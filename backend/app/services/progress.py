"""Course progress, XP, streak, and dashboard rules for the PDF quiz MVP."""

from __future__ import annotations

from datetime import datetime, timezone
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

from sqlalchemy import case, func
from sqlalchemy.orm import Session

from app.models.learning import LearningSession, LearningSessionQuestion, SessionStatus
from app.models.progress import LessonStatus, UserLessonProgress, XPTransaction
from app.models.user import User

XP_PER_CORRECT = 10
XP_LESSON_COMPLETE_BONUS = 50
LESSON_PASSING_SCORE = 70


def _local_date(instant: datetime, timezone_name: str | None):
    if instant.tzinfo is None:
        instant = instant.replace(tzinfo=timezone.utc)
    try:
        local_timezone = ZoneInfo(timezone_name or "UTC")
    except (ZoneInfoNotFoundError, ValueError):
        local_timezone = timezone.utc
    return instant.astimezone(local_timezone).date()


def update_streak(user: User, *, now: datetime | None = None) -> None:
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


def record_session_completion(
    db: Session,
    *,
    session: LearningSession,
    user: User,
    now: datetime | None = None,
) -> None:
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
    update_streak(locked_user, now=now)

    total_xp = 0
    if session.lesson_id:
        lesson_progress = _lesson_progress(db, user_id=user.id, lesson_id=session.lesson_id)
        already_completed = lesson_progress.status == LessonStatus.COMPLETED
        lesson_progress.attempts_count += 1
        lesson_progress.last_score = session.final_score
        lesson_progress.best_score = max(lesson_progress.best_score, session.final_score)
        if session.final_score >= LESSON_PASSING_SCORE:
            lesson_progress.status = LessonStatus.COMPLETED
            if not already_completed:
                total_xp = XP_LESSON_COMPLETE_BONUS + (session.correct_answers * XP_PER_CORRECT)
        elif not already_completed:
            lesson_progress.status = LessonStatus.IN_PROGRESS

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


def dashboard_overview(db: Session, *, user: User) -> dict:
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
    return {
        "total_xp": int(total_xp or 0),
        "current_streak": user.current_streak or 0,
        "longest_streak": user.longest_streak or 0,
        "lessons_completed": lessons_completed,
        "answered_questions": int(answered or 0),
        "correct_answers": int(correct or 0),
        "accuracy_percentage": round((int(correct) / int(answered)) * 100) if answered else 0,
    }
