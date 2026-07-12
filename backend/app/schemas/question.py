"""Question API contracts for AI-generated PDF quizzes."""

from __future__ import annotations

from typing import Any

from pydantic import BaseModel, ConfigDict

from app.models.question import QuestionType, SkillType

JsonObject = dict[str, Any]


class QuestionResponseLearner(BaseModel):
    """Safe delivery shape: no explanation or answer key before answer submission."""

    id: str
    lesson_id: str
    question_type: QuestionType
    skill: SkillType
    difficulty: int
    prompt_json: JsonObject

    model_config = ConfigDict(from_attributes=True, extra="forbid")
