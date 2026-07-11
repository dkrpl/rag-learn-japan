"""Question-bank API contracts.

Admin and learner contracts are deliberately separate.  Do not inherit learner
responses from an admin model because that makes answer-key regressions too easy.
"""

from __future__ import annotations

from datetime import datetime
from typing import Any

from pydantic import BaseModel, ConfigDict, Field

from app.models.question import QuestionStatus, QuestionType, SkillType

JsonObject = dict[str, Any]


class QuestionCreate(BaseModel):
    lesson_id: str = Field(min_length=1, max_length=36)
    reading_id: str | None = Field(default=None, max_length=36)
    audio_asset_id: str | None = Field(default=None, max_length=36)
    question_type: QuestionType
    skill: SkillType
    difficulty: int = Field(default=1, ge=1, le=5)
    prompt_json: JsonObject
    answer_key_json: JsonObject
    explanation_json: JsonObject | None = None

    model_config = ConfigDict(extra="forbid")


class QuestionUpdate(BaseModel):
    lesson_id: str | None = Field(default=None, min_length=1, max_length=36)
    reading_id: str | None = Field(default=None, max_length=36)
    audio_asset_id: str | None = Field(default=None, max_length=36)
    question_type: QuestionType | None = None
    skill: SkillType | None = None
    difficulty: int | None = Field(default=None, ge=1, le=5)
    prompt_json: JsonObject | None = None
    answer_key_json: JsonObject | None = None
    explanation_json: JsonObject | None = None

    model_config = ConfigDict(extra="forbid")


class QuestionResponseLearner(BaseModel):
    """Safe delivery shape: no status, explanation, review, or answer key."""

    id: str
    lesson_id: str
    reading_id: str | None = None
    audio_asset_id: str | None = None
    question_type: QuestionType
    skill: SkillType
    difficulty: int
    prompt_json: JsonObject

    model_config = ConfigDict(from_attributes=True, extra="forbid")


class QuestionResponseAdmin(BaseModel):
    id: str
    lesson_id: str
    reading_id: str | None = None
    audio_asset_id: str | None = None
    question_type: QuestionType
    skill: SkillType
    difficulty: int
    prompt_json: JsonObject
    answer_key_json: JsonObject
    explanation_json: JsonObject | None = None
    status: QuestionStatus
    is_ai_generated: bool
    version_number: int
    created_by: str | None = None
    reviewed_by: str | None = None
    published_at: datetime | None = None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


class QuestionPage(BaseModel):
    items: list[QuestionResponseAdmin]
    page: int
    page_size: int
    total: int
    pages: int


class QuestionReviewCreate(BaseModel):
    notes: str | None = Field(default=None, max_length=4000)
    # Compatibility input only. The endpoint action, never this field, decides
    # the transition. If supplied, it must match the endpoint action.
    status_given: QuestionStatus | None = None

    model_config = ConfigDict(extra="forbid")


class QuestionRevisionResponse(BaseModel):
    id: str
    question_id: str
    version_number: int
    lesson_id: str
    reading_id: str | None = None
    audio_asset_id: str | None = None
    question_type: QuestionType
    skill: SkillType
    difficulty: int
    prompt_json: JsonObject
    answer_key_json: JsonObject
    explanation_json: JsonObject | None = None
    created_by: str | None = None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


class QuestionReviewResponse(BaseModel):
    id: str
    question_id: str
    reviewer_id: str | None = None
    status_given: QuestionStatus
    notes: str | None = None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
