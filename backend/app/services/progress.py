"""Material progress, XP, streak, and dashboard rules for the PDF quiz MVP."""

from __future__ import annotations

from datetime import datetime, timezone
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

from sqlalchemy import case, func
from sqlalchemy.orm import Session

from app.models.learning import LearningSession, LearningSessionQuestion, SessionStatus
from app.models.progress import MaterialProgressStatus, UserMaterialProgress, XPTransaction
from app.models.user import User

DEFAULT_BASE_EXP = 100
DIFFICULTY_MULTIPLIERS = {
    1: 1.0,
    2: 1.25,
    3: 1.5,
    4: 1.5,
    5: 1.5,
}


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


def _material_progress(db: Session, *, user_id: str, material_id: str) -> UserMaterialProgress:
    progress = (
        db.query(UserMaterialProgress)
        .filter(UserMaterialProgress.user_id == user_id, UserMaterialProgress.material_id == material_id)
        .with_for_update()
        .first()
    )
    if progress is None:
        progress = UserMaterialProgress(
            user_id=user_id,
            material_id=material_id,
            status=MaterialProgressStatus.IN_PROGRESS,
            attempts_count=0,
            best_score=0,
            last_score=0,
        )
        db.add(progress)
        db.flush()
    return progress


def calculate_earned_exp(*, score: int, passing_score: int, difficulty: int, base_exp: int = DEFAULT_BASE_EXP) -> int:
    if score < passing_score:
        return 0
    multiplier = DIFFICULTY_MULTIPLIERS.get(difficulty, 1.0)
    return round(base_exp * multiplier * (score / 100))


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

    earned_exp = 0
    if session.material_id:
        material_progress = _material_progress(db, user_id=user.id, material_id=session.material_id)
        was_completed = material_progress.status == MaterialProgressStatus.COMPLETED
        material_progress.attempts_count += 1
        material_progress.last_score = session.final_score
        material_progress.best_score = max(material_progress.best_score, session.final_score)

        session.is_passed = session.final_score >= session.passing_score
        if session.is_passed:
            material_progress.status = MaterialProgressStatus.COMPLETED
            already_rewarded = (
                db.query(XPTransaction.id)
                .filter(
                    XPTransaction.user_id == user.id,
                    XPTransaction.material_id == session.material_id,
                    XPTransaction.reason == "MATERIAL_QUIZ_PASSED",
                )
                .first()
            )
            if not was_completed and not already_rewarded:
                earned_exp = calculate_earned_exp(
                    score=session.final_score,
                    passing_score=session.passing_score,
                    difficulty=session.difficulty,
                )
        elif material_progress.status != MaterialProgressStatus.COMPLETED:
            material_progress.status = MaterialProgressStatus.IN_PROGRESS

    session.earned_exp = earned_exp
    if earned_exp > 0:
        db.add(
            XPTransaction(
                user_id=user.id,
                material_id=session.material_id,
                amount=earned_exp,
                reason="MATERIAL_QUIZ_PASSED",
                session_id=session.id,
            )
        )
    session.progress_processed_at = now
    db.flush()


def dashboard_overview(db: Session, *, user: User) -> dict:
    total_xp = (
        db.query(func.coalesce(func.sum(XPTransaction.amount), 0)).filter(XPTransaction.user_id == user.id).scalar()
    )
    materials_completed = (
        db.query(UserMaterialProgress)
        .filter(
            UserMaterialProgress.user_id == user.id,
            UserMaterialProgress.status == MaterialProgressStatus.COMPLETED,
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
        "materials_completed": materials_completed,
        "answered_questions": int(answered or 0),
        "correct_answers": int(correct or 0),
        "accuracy_percentage": round((int(correct) / int(answered)) * 100) if answered else 0,
    }
