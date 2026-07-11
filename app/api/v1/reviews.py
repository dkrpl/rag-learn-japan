"""Spaced-repetition and mistake-practice session endpoints."""

from __future__ import annotations

import math
from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.db.session import get_db
from app.models.learning import SessionSource
from app.models.progress import ReviewSchedule, UserMistake
from app.models.question import Question, QuestionStatus
from app.models.user import User
from app.schemas.learning import LearningSessionResponse
from app.schemas.progress import ReviewDuePage, ReviewDueResponse, ReviewSummaryResponse
from app.services import learning as learning_service

router = APIRouter()


def _raise_learning_error(exc: learning_service.LearningServiceError) -> None:
    raise HTTPException(
        status_code=exc.status_code,
        detail={"code": exc.code, "message": exc.message},
    ) from exc


def _due_query(db: Session, *, user_id: str, now: datetime):
    return (
        db.query(ReviewSchedule)
        .join(Question, ReviewSchedule.question_id == Question.id)
        .filter(
            ReviewSchedule.user_id == user_id,
            ReviewSchedule.next_review_date <= now,
            Question.status == QuestionStatus.PUBLISHED,
        )
    )


@router.get(
    "/due",
    response_model=ReviewDuePage,
    operation_id="listDueReviews",
    summary="Paginate due SRS items that are still published",
)
def list_due_reviews(
    page: int = Query(default=1, ge=1),
    page_size: int = Query(default=20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    now = datetime.now(timezone.utc)
    query = _due_query(db, user_id=current_user.id, now=now)
    total = query.count()
    schedules = (
        query.order_by(ReviewSchedule.next_review_date.asc(), ReviewSchedule.id.asc())
        .offset((page - 1) * page_size)
        .limit(page_size)
        .all()
    )
    return ReviewDuePage(
        items=[
            ReviewDueResponse(
                question_id=schedule.question_id,
                question_type=schedule.question.question_type,
                skill=schedule.question.skill,
                next_review_date=schedule.next_review_date,
                interval_days=schedule.interval_days,
            )
            for schedule in schedules
        ],
        page=page,
        page_size=page_size,
        total=total,
        pages=math.ceil(total / page_size) if total else 0,
    )


@router.get(
    "/summary",
    response_model=ReviewSummaryResponse,
    operation_id="getReviewSummary",
    summary="Get current and near-term SRS counts",
)
def get_review_summary(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    now = datetime.now(timezone.utc)
    total = (
        db.query(ReviewSchedule)
        .join(Question, ReviewSchedule.question_id == Question.id)
        .filter(ReviewSchedule.user_id == current_user.id, Question.status == QuestionStatus.PUBLISHED)
        .count()
    )
    due_now = _due_query(db, user_id=current_user.id, now=now).count()
    due_24_hours = _due_query(db, user_id=current_user.id, now=now + timedelta(hours=24)).count()
    return ReviewSummaryResponse(
        due_now=due_now,
        due_next_24_hours=due_24_hours,
        scheduled_total=total,
    )


@router.post(
    "/sessions",
    response_model=LearningSessionResponse,
    status_code=status.HTTP_201_CREATED,
    operation_id="createReviewSession",
    summary="Start a practice session from due SRS items",
)
def create_review_session(
    question_count: int = Query(default=10, ge=1, le=50),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    schedules = (
        _due_query(db, user_id=current_user.id, now=datetime.now(timezone.utc))
        .order_by(ReviewSchedule.next_review_date.asc(), ReviewSchedule.id.asc())
        .limit(question_count)
        .all()
    )
    try:
        return learning_service.start_targeted_session(
            db,
            user=current_user,
            question_ids=[schedule.question_id for schedule in schedules],
            source=SessionSource.REVIEW,
            limit=question_count,
        )
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.post(
    "/mistake-sessions",
    response_model=LearningSessionResponse,
    status_code=status.HTTP_201_CREATED,
    operation_id="createMistakeSession",
    summary="Start a practice session from unresolved published mistakes",
)
def create_mistake_session(
    question_count: int = Query(default=10, ge=1, le=50),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    mistakes = (
        db.query(UserMistake)
        .join(Question, UserMistake.question_id == Question.id)
        .filter(
            UserMistake.user_id == current_user.id,
            UserMistake.is_resolved.is_(False),
            Question.status == QuestionStatus.PUBLISHED,
        )
        .order_by(UserMistake.last_failed_at.desc(), UserMistake.id.asc())
        .limit(question_count)
        .all()
    )
    try:
        return learning_service.start_targeted_session(
            db,
            user=current_user,
            question_ids=[mistake.question_id for mistake in mistakes],
            source=SessionSource.MISTAKE,
            limit=question_count,
        )
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)
