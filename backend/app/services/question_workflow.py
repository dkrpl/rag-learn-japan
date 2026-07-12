"""Question validation and immutable snapshots for AI PDF quizzes."""

from __future__ import annotations

import copy
from typing import Any

from sqlalchemy.orm import Session

from app.models.question import Question, QuestionRevision, QuestionType, SkillType

JsonObject = dict[str, Any]


class QuestionWorkflowError(RuntimeError):
    def __init__(self, message: str, *, status_code: int = 400, code: str = "QUESTION_WORKFLOW_ERROR") -> None:
        super().__init__(message)
        self.message = message
        self.status_code = status_code
        self.code = code


def _require_text(prompt: JsonObject) -> None:
    value = prompt.get("text", prompt.get("question"))
    if not isinstance(value, str) or not value.strip():
        raise QuestionWorkflowError("prompt_json must contain non-empty text or question", code="INVALID_PROMPT")


def _item_ids(items: Any, field: str, *, min_items: int = 2) -> set[str]:
    if not isinstance(items, list) or len(items) < min_items:
        raise QuestionWorkflowError(f"{field} must contain at least {min_items} items", code="INVALID_OPTIONS")
    ids: set[str] = set()
    labels: set[str] = set()
    for item in items:
        if not isinstance(item, dict):
            raise QuestionWorkflowError(f"{field} entries must be objects", code="INVALID_OPTIONS")
        item_id = item.get("id")
        text = item.get("text")
        if not isinstance(item_id, str) or not item_id.strip():
            raise QuestionWorkflowError(f"{field} entries require a stable string id", code="INVALID_OPTIONS")
        if not isinstance(text, str) or not text.strip():
            raise QuestionWorkflowError(f"{field} entries require text", code="INVALID_OPTIONS")
        if item_id in ids:
            raise QuestionWorkflowError(f"{field} contains duplicate ids", code="DUPLICATE_OPTION")
        normalized_text = " ".join(text.casefold().split())
        if normalized_text in labels:
            raise QuestionWorkflowError(f"{field} contains duplicate display values", code="DUPLICATE_OPTION")
        ids.add(item_id)
        labels.add(normalized_text)
    return ids


def validate_question_payload(
    *,
    question_type: QuestionType,
    skill: SkillType,
    difficulty: int,
    prompt_json: JsonObject,
    answer_key_json: JsonObject,
    explanation_json: JsonObject | None,
    require_explanation: bool,
) -> None:
    if question_type != QuestionType.MULTIPLE_CHOICE:
        raise QuestionWorkflowError("Only MULTIPLE_CHOICE questions are supported", code="INVALID_QUESTION_TYPE")
    if skill != SkillType.READING:
        raise QuestionWorkflowError("Only READING skill is supported", code="INVALID_SKILL")
    if not 1 <= difficulty <= 5:
        raise QuestionWorkflowError("difficulty must be between 1 and 5", code="INVALID_DIFFICULTY")
    if not isinstance(prompt_json, dict) or not prompt_json:
        raise QuestionWorkflowError("prompt_json must be a non-empty object", code="INVALID_PROMPT")
    if not isinstance(answer_key_json, dict) or not answer_key_json:
        raise QuestionWorkflowError("answer_key_json must be a non-empty object", code="INVALID_ANSWER_KEY")
    if require_explanation and (not isinstance(explanation_json, dict) or not explanation_json):
        raise QuestionWorkflowError("explanation_json is required", code="MISSING_EXPLANATION")

    _require_text(prompt_json)
    option_ids = _item_ids(prompt_json.get("options"), "prompt_json.options")
    correct = answer_key_json.get("correct_option_id")
    if not isinstance(correct, str) or correct not in option_ids:
        raise QuestionWorkflowError("correct_option_id must reference an option", code="INVALID_ANSWER_KEY")


def snapshot_question(db: Session, question: Question, *, actor_id: str | None) -> QuestionRevision:
    existing = (
        db.query(QuestionRevision)
        .filter(
            QuestionRevision.question_id == question.id,
            QuestionRevision.version_number == question.version_number,
        )
        .first()
    )
    if existing:
        return existing
    revision = QuestionRevision(
        question_id=question.id,
        version_number=question.version_number,
        lesson_id=question.lesson_id,
        question_type=question.question_type,
        skill=question.skill,
        difficulty=question.difficulty,
        prompt_json=copy.deepcopy(question.prompt_json),
        answer_key_json=copy.deepcopy(question.answer_key_json),
        explanation_json=copy.deepcopy(question.explanation_json),
        created_by=actor_id,
    )
    db.add(revision)
    db.flush()
    return revision
