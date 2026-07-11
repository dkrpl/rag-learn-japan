"""Learner progress, mastery, mistakes, XP activity, and recommendations."""

from __future__ import annotations

import math

from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.db.session import get_db
from app.models.progress import UserLessonProgress, UserMastery, UserMistake, XPTransaction
from app.models.user import User
from app.schemas.progress import (
    DashboardOverviewResponse,
    LessonProgressResponse,
    MasteryResponse,
    MistakePage,
    MistakeResponse,
    ReadinessResponse,
    RecommendationResponse,
    XPActivityPage,
)
from app.services.learning import sanitize_prompt
from app.services.progress import dashboard_overview, readiness_prediction, recommendations

router = APIRouter()


@router.get(
    "/overview",
    response_model=DashboardOverviewResponse,
    operation_id="getProgressOverview",
    summary="Get aggregates computed from completed learning activity",
)
def get_progress_overview(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return dashboard_overview(db, user=current_user)


@router.get(
    "/mastery",
    response_model=list[MasteryResponse],
    operation_id="listSkillMastery",
    summary="List mastery by skill",
)
def list_skill_mastery(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return (
        db.query(UserMastery)
        .filter(UserMastery.user_id == current_user.id)
        .order_by(UserMastery.skill.asc())
        .all()
    )


@router.get(
    "/lessons",
    response_model=list[LessonProgressResponse],
    operation_id="listLessonProgress",
    summary="List learner lesson progress",
)
def list_lesson_progress(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return (
        db.query(UserLessonProgress)
        .filter(UserLessonProgress.user_id == current_user.id)
        .order_by(UserLessonProgress.updated_at.desc())
        .all()
    )


@router.get(
    "/mistakes",
    response_model=MistakePage,
    operation_id="listMistakeBook",
    summary="Paginate unresolved mistake-book entries",
)
def list_mistakes(
    page: int = Query(default=1, ge=1),
    page_size: int = Query(default=20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = db.query(UserMistake).filter(
        UserMistake.user_id == current_user.id,
        UserMistake.is_resolved.is_(False),
    )
    total = query.count()
    rows = (
        query.order_by(UserMistake.last_failed_at.desc(), UserMistake.id.desc())
        .offset((page - 1) * page_size)
        .limit(page_size)
        .all()
    )
    items: list[MistakeResponse] = []
    for mistake in rows:
        revision = mistake.question_revision
        question = mistake.question
        items.append(
            MistakeResponse(
                question_id=mistake.question_id,
                question_type=revision.question_type if revision else question.question_type,
                skill=revision.skill if revision else question.skill,
                mistake_count=mistake.mistake_count,
                last_failed_at=mistake.last_failed_at,
                prompt_json=sanitize_prompt(revision.prompt_json if revision else question.prompt_json),
                explanation_json=(revision.explanation_json if revision else question.explanation_json),
            )
        )
    return MistakePage(
        items=items,
        page=page,
        page_size=page_size,
        total=total,
        pages=math.ceil(total / page_size) if total else 0,
    )


@router.get(
    "/activity",
    response_model=XPActivityPage,
    operation_id="listXpActivity",
    summary="Paginate the immutable XP ledger",
)
def list_xp_activity(
    page: int = Query(default=1, ge=1),
    page_size: int = Query(default=20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = db.query(XPTransaction).filter(XPTransaction.user_id == current_user.id)
    total = query.count()
    items = (
        query.order_by(XPTransaction.created_at.desc(), XPTransaction.id.desc())
        .offset((page - 1) * page_size)
        .limit(page_size)
        .all()
    )
    return XPActivityPage(
        items=items,
        page=page,
        page_size=page_size,
        total=total,
        pages=math.ceil(total / page_size) if total else 0,
    )


@router.get(
    "/recommendations",
    response_model=list[RecommendationResponse],
    operation_id="getLearningRecommendations",
    summary="Get deterministic next-study recommendations",
)
def get_learning_recommendations(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return recommendations(db, user=current_user)


@router.get(
    "/readiness",
    response_model=ReadinessResponse,
    operation_id="getJlptReadinessEstimate",
    summary="Get a transparent early readiness estimate",
)
def get_readiness_estimate(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return readiness_prediction(db, user=current_user)
