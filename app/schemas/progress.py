"""Progress, mistake-book, activity, recommendation, and SRS contracts."""

from __future__ import annotations

from datetime import datetime
from typing import Any

from pydantic import BaseModel, ConfigDict

from app.models.progress import LessonStatus
from app.models.question import QuestionType, SkillType


class DashboardOverviewResponse(BaseModel):
    total_xp: int
    current_streak: int
    longest_streak: int
    lessons_completed: int
    answered_questions: int
    correct_answers: int
    accuracy_percentage: int
    reviews_due: int
    unresolved_mistakes: int


class MasteryResponse(BaseModel):
    skill: SkillType
    mastery_level: int
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


class LessonProgressResponse(BaseModel):
    lesson_id: str
    status: LessonStatus
    attempts_count: int
    best_score: int
    last_score: int
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


class MistakeResponse(BaseModel):
    question_id: str
    question_type: QuestionType
    skill: SkillType
    mistake_count: int
    last_failed_at: datetime
    prompt_json: dict[str, Any]
    explanation_json: dict[str, Any] | None = None


class MistakePage(BaseModel):
    items: list[MistakeResponse]
    page: int
    page_size: int
    total: int
    pages: int


class ReviewDueResponse(BaseModel):
    question_id: str
    question_type: QuestionType
    skill: SkillType
    next_review_date: datetime
    interval_days: int


class ReviewDuePage(BaseModel):
    items: list[ReviewDueResponse]
    page: int
    page_size: int
    total: int
    pages: int


class ReviewSummaryResponse(BaseModel):
    due_now: int
    due_next_24_hours: int
    scheduled_total: int


class XPActivityResponse(BaseModel):
    id: str
    amount: int
    reason: str
    session_id: str | None = None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


class XPActivityPage(BaseModel):
    items: list[XPActivityResponse]
    page: int
    page_size: int
    total: int
    pages: int


class RecommendationResponse(BaseModel):
    kind: str
    reason: str
    skill: SkillType | None = None
    lesson_id: str | None = None
    question_count: int = 0


class ReadinessResponse(BaseModel):
    target_level: str
    readiness_percentage: int
    accuracy_percentage: int
    mastery_percentage: int
    disclaimer: str
