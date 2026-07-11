"""Idempotent progress, mastery, SRS, mistake, XP, and streak engine."""

from __future__ import annotations

import math
from datetime import datetime, timedelta, timezone
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

from sqlalchemy import case, func
from sqlalchemy.orm import Session

from app.models.learning import LearningSession, LearningSessionQuestion, SessionStatus
from app.models.progress import (
    LessonStatus,
    ReviewSchedule,
    UserLessonProgress,
    UserMastery,
    UserMistake,
    XPTransaction,
)
from app.models.question import SkillType
from app.models.user import User

XP_PER_CORRECT = 10
XP_LESSON_COMPLETE_BONUS = 50
LESSON_PASSING_SCORE = 80
SRS_INTERVALS = (1, 3, 7, 14, 30)


def _local_date(instant: datetime, timezone_name: str | None):
    if instant.tzinfo is None:
        instant = instant.replace(tzinfo=timezone.utc)
    try:
        local_timezone = ZoneInfo(timezone_name or "UTC")
    except (ZoneInfoNotFoundError, ValueError):
        local_timezone = timezone.utc
    return instant.astimezone(local_timezone).date()


def update_streak(db: Session, user: User, *, now: datetime | None = None) -> None:
    """Update a locked user once per local calendar date."""

    now = now or datetime.now(timezone.utc)
    today = _local_date(now, user.timezone)
    if user.last_activity_date == today:
        return
    if user.last_activity_date is None:
        user.current_streak = 1
    elif (today - user.last_activity_date).days == 1:
        user.current_streak = (user.current_streak or 0) + 1
    else:
        user.current_streak = 1
    user.longest_streak = max(user.longest_streak or 0, user.current_streak or 0)
    user.last_activity_date = today
    db.add(user)


def next_srs_interval(current_interval: int, is_correct: bool) -> int:
    if not is_correct:
        return SRS_INTERVALS[0]
    for interval in SRS_INTERVALS:
        if interval > (current_interval or 0):
            return interval
    return SRS_INTERVALS[-1]


def _lesson_progress(db: Session, *, user_id: str, lesson_id: str) -> UserLessonProgress:
    progress = (
        db.query(UserLessonProgress)
        .filter(UserLessonProgress.user_id == user_id, UserLessonProgress.lesson_id == lesson_id)
        .with_for_update()
        .first()
    )
    if progress is None:
        progress = UserLessonProgress(
            user_id=user_id,
            lesson_id=lesson_id,
            status=LessonStatus.IN_PROGRESS,
            attempts_count=0,
            best_score=0,
            last_score=0,
        )
        db.add(progress)
        db.flush()
    return progress


def _mastery(db: Session, *, user_id: str, skill: SkillType) -> UserMastery:
    mastery = (
        db.query(UserMastery)
        .filter(UserMastery.user_id == user_id, UserMastery.skill == skill)
        .with_for_update()
        .first()
    )
    if mastery is None:
        mastery = UserMastery(user_id=user_id, skill=skill, mastery_level=0)
        db.add(mastery)
        db.flush()
    return mastery


def _mistake(db: Session, *, user_id: str, question_id: str) -> UserMistake | None:
    return (
        db.query(UserMistake)
        .filter(UserMistake.user_id == user_id, UserMistake.question_id == question_id)
        .with_for_update()
        .first()
    )


def _review_schedule(db: Session, *, user_id: str, question_id: str, now: datetime) -> ReviewSchedule:
    schedule = (
        db.query(ReviewSchedule)
        .filter(ReviewSchedule.user_id == user_id, ReviewSchedule.question_id == question_id)
        .with_for_update()
        .first()
    )
    if schedule is None:
        schedule = ReviewSchedule(
            user_id=user_id,
            question_id=question_id,
            next_review_date=now,
            interval_days=0,
            consecutive_correct=0,
        )
        db.add(schedule)
        db.flush()
    return schedule


def record_session_completion(
    db: Session,
    *,
    session: LearningSession,
    user: User,
    now: datetime | None = None,
) -> None:
    """Apply all completion side effects in the caller's transaction.

    ``learning_sessions.progress_processed_at`` and the unique XP session ledger
    make retries safe.  The caller must hold a row lock on the learning session.
    """

    if session.status != SessionStatus.COMPLETED:
        raise ValueError("Progress can only be recorded for a completed session")
    if session.progress_processed_at is not None:
        return
    existing_marker = db.query(XPTransaction.id).filter(XPTransaction.session_id == session.id).first()
    if existing_marker:
        session.progress_processed_at = now or datetime.now(timezone.utc)
        return

    now = now or datetime.now(timezone.utc)
    locked_user = db.query(User).filter(User.id == user.id).populate_existing().with_for_update().one()
    update_streak(db, locked_user, now=now)

    total_xp = 0
    if session.lesson_id:
        lesson_progress = _lesson_progress(db, user_id=user.id, lesson_id=session.lesson_id)
        was_completed = lesson_progress.status == LessonStatus.COMPLETED
        lesson_progress.attempts_count += 1
        lesson_progress.last_score = session.final_score
        lesson_progress.best_score = max(lesson_progress.best_score, session.final_score)
        if session.final_score >= LESSON_PASSING_SCORE:
            lesson_progress.status = LessonStatus.COMPLETED
            if not was_completed:
                total_xp += XP_LESSON_COMPLETE_BONUS
        elif not was_completed:
            lesson_progress.status = LessonStatus.IN_PROGRESS

    for session_question in session.session_questions:
        if not session_question.is_answered:
            continue
        revision = session_question.question_revision
        mastery = _mastery(db, user_id=user.id, skill=revision.skill)
        difficulty = max(1, min(5, revision.difficulty or 1))
        if session_question.is_correct:
            mastery.mastery_level = min(100, mastery.mastery_level + 2 + difficulty)
            total_xp += XP_PER_CORRECT
        else:
            mastery.mastery_level = max(0, mastery.mastery_level - (1 + math.ceil(difficulty / 2)))

        mistake = _mistake(db, user_id=user.id, question_id=session_question.question_id)
        if session_question.is_correct:
            if mistake:
                mistake.is_resolved = True
                mistake.last_succeeded_at = now
        elif mistake:
            mistake.mistake_count += 1
            mistake.is_resolved = False
            mistake.last_failed_at = now
            mistake.question_revision_id = session_question.question_revision_id
        else:
            db.add(
                UserMistake(
                    user_id=user.id,
                    question_id=session_question.question_id,
                    question_revision_id=session_question.question_revision_id,
                    mistake_count=1,
                    is_resolved=False,
                    last_failed_at=now,
                )
            )

        schedule = _review_schedule(
            db,
            user_id=user.id,
            question_id=session_question.question_id,
            now=now,
        )
        schedule.interval_days = next_srs_interval(schedule.interval_days, bool(session_question.is_correct))
        schedule.consecutive_correct = schedule.consecutive_correct + 1 if session_question.is_correct else 0
        schedule.last_reviewed_at = now
        schedule.next_review_date = now + timedelta(days=schedule.interval_days)

    db.add(
        XPTransaction(
            user_id=user.id,
            amount=total_xp,
            reason="LEARNING_SESSION_COMPLETED",
            session_id=session.id,
        )
    )
    session.progress_processed_at = now
    db.flush()


def dashboard_overview(db: Session, *, user: User, now: datetime | None = None) -> dict:
    now = now or datetime.now(timezone.utc)
    total_xp = (
        db.query(func.coalesce(func.sum(XPTransaction.amount), 0)).filter(XPTransaction.user_id == user.id).scalar()
    )
    lessons_completed = (
        db.query(UserLessonProgress)
        .filter(
            UserLessonProgress.user_id == user.id,
            UserLessonProgress.status == LessonStatus.COMPLETED,
        )
        .count()
    )
    answered, correct = (
        db.query(
            func.count(LearningSessionQuestion.id),
            func.coalesce(func.sum(case((LearningSessionQuestion.is_correct.is_(True), 1), else_=0)), 0),
        )
        .join(LearningSession, LearningSessionQuestion.session_id == LearningSession.id)
        .filter(
            LearningSession.user_id == user.id,
            LearningSession.status == SessionStatus.COMPLETED,
            LearningSessionQuestion.is_answered.is_(True),
        )
        .one()
    )
    reviews_due = (
        db.query(ReviewSchedule)
        .filter(
            ReviewSchedule.user_id == user.id,
            ReviewSchedule.next_review_date <= now,
        )
        .count()
    )
    unresolved_mistakes = (
        db.query(UserMistake)
        .filter(
            UserMistake.user_id == user.id,
            UserMistake.is_resolved.is_(False),
        )
        .count()
    )
    return {
        "total_xp": int(total_xp or 0),
        "current_streak": user.current_streak or 0,
        "longest_streak": user.longest_streak or 0,
        "lessons_completed": lessons_completed,
        "answered_questions": int(answered or 0),
        "correct_answers": int(correct or 0),
        "accuracy_percentage": round((int(correct) / int(answered)) * 100) if answered else 0,
        "reviews_due": reviews_due,
        "unresolved_mistakes": unresolved_mistakes,
    }


def recommendations(db: Session, *, user: User, now: datetime | None = None) -> list[dict]:
    now = now or datetime.now(timezone.utc)
    due_count = (
        db.query(ReviewSchedule)
        .filter(
            ReviewSchedule.user_id == user.id,
            ReviewSchedule.next_review_date <= now,
        )
        .count()
    )
    mistake_count = (
        db.query(UserMistake)
        .filter(
            UserMistake.user_id == user.id,
            UserMistake.is_resolved.is_(False),
        )
        .count()
    )
    weakest = (
        db.query(UserMastery)
        .filter(UserMastery.user_id == user.id)
        .order_by(UserMastery.mastery_level.asc(), UserMastery.skill.asc())
        .first()
    )
    result: list[dict] = []
    if due_count:
        result.append({"kind": "REVIEW", "reason": "Spaced-repetition items are due", "question_count": due_count})
    if mistake_count:
        result.append(
            {"kind": "MISTAKE", "reason": "Unresolved mistakes need practice", "question_count": mistake_count}
        )
    if weakest:
        result.append(
            {
                "kind": "SKILL",
                "reason": f"Lowest current mastery ({weakest.mastery_level}%)",
                "skill": weakest.skill,
                "question_count": 0,
            }
        )
    return result


def readiness_prediction(db: Session, *, user: User) -> dict:
    overview = dashboard_overview(db, user=user)
    mastery_average = db.query(func.avg(UserMastery.mastery_level)).filter(UserMastery.user_id == user.id).scalar()
    mastery = round(float(mastery_average or 0))
    accuracy = overview["accuracy_percentage"]
    readiness = round((mastery * 0.6) + (accuracy * 0.4))
    return {
        "target_level": user.target_level or "N5",
        "readiness_percentage": max(0, min(100, readiness)),
        "accuracy_percentage": accuracy,
        "mastery_percentage": mastery,
        "disclaimer": "This estimate supports study planning and does not guarantee JLPT results.",
    }
