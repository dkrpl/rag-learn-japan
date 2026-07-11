"""Learner-safe learning-session API contracts."""

from __future__ import annotations

from datetime import datetime
from typing import Any

from pydantic import BaseModel, ConfigDict, Field

from app.models.learning import SessionMode, SessionSource, SessionStatus
from app.models.question import SkillType
from app.schemas.question import QuestionResponseLearner

JsonObject = dict[str, Any]


class LearningSessionCreate(BaseModel):
    lesson_id: str = Field(min_length=1, max_length=36)
    mode: SessionMode = SessionMode.PRACTICE
    question_count: int = Field(default=10, ge=1, le=50)
    skill: SkillType | None = None
    difficulty: int | None = Field(default=None, ge=1, le=5)

    model_config = ConfigDict(extra="forbid")


class SubmitAnswerRequest(BaseModel):
    session_question_id: str | None = Field(default=None, max_length=36)
    answer_json: JsonObject
    response_time_ms: int = Field(default=0, ge=0, le=86_400_000)

    model_config = ConfigDict(extra="forbid")


class SubmitAnswerResponse(BaseModel):
    accepted: bool = True
    session_question_id: str
    is_correct: bool | None = None
    score: int | None = None
    correct_answer_json: JsonObject | None = None
    explanation_json: JsonObject | None = None
    feedback_notes: str | None = None


class SessionQuestionResponse(BaseModel):
    id: str
    order_number: int
    is_answered: bool
    question: QuestionResponseLearner
    user_answer_json: JsonObject | None = None
    is_correct: bool | None = None
    score: int | None = None
    correct_answer_json: JsonObject | None = None
    explanation_json: JsonObject | None = None
    feedback_notes: str | None = None


class LearningSessionResponse(BaseModel):
    id: str
    user_id: str
    lesson_id: str | None = None
    mode: SessionMode
    source: SessionSource
    status: SessionStatus
    total_questions: int
    answered_questions: int
    correct_answers: int
    final_score: int
    started_at: datetime
    expires_at: datetime
    completed_at: datetime | None = None

    model_config = ConfigDict(from_attributes=True)
