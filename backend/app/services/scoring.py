"""Deterministic multiple-choice scorer for AI PDF quizzes."""

from __future__ import annotations

from typing import Any

from app.models.question import QuestionType

JsonObject = dict[str, Any]


class ScoringError(ValueError):
    """Raised when a submitted answer does not match the public contract."""


def _non_empty_string(value: Any, field: str) -> str:
    if not isinstance(value, str) or not value.strip():
        raise ScoringError(f"{field} must be a non-empty string")
    return value


def evaluate_answer(
    question_type: QuestionType,
    answer_key: JsonObject,
    user_answer: JsonObject,
) -> tuple[bool, int, str]:
    if question_type != QuestionType.MULTIPLE_CHOICE:
        raise ScoringError(f"Unsupported question type: {question_type}")
    if not isinstance(answer_key, dict) or not answer_key:
        raise ScoringError("Question answer key is invalid")
    if not isinstance(user_answer, dict) or not user_answer:
        raise ScoringError("answer_json must be a non-empty object")

    expected = _non_empty_string(answer_key.get("correct_option_id"), "correct_option_id")
    actual = _non_empty_string(user_answer.get("selected_option_id"), "selected_option_id")
    is_correct = actual == expected
    return is_correct, 100 if is_correct else 0, "Correct" if is_correct else "Incorrect"
