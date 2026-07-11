"""Deterministic scorers for all ten MVP question types."""

from __future__ import annotations

import unicodedata
from typing import Any

from app.models.question import QuestionType

JsonObject = dict[str, Any]


class ScoringError(ValueError):
    """Raised when a submitted answer does not match the public contract."""


def _required(mapping: JsonObject, *keys: str) -> Any:
    for key in keys:
        if key in mapping:
            return mapping[key]
    raise ScoringError(f"Missing required field: {keys[0]}")


def _non_empty_string(value: Any, field: str) -> str:
    if not isinstance(value, str) or not value.strip():
        raise ScoringError(f"{field} must be a non-empty string")
    return value


def _boolean(value: Any, field: str) -> bool:
    if not isinstance(value, bool):
        raise ScoringError(f"{field} must be a boolean")
    return value


def _normalize_reading(value: str) -> str:
    return "".join(unicodedata.normalize("NFKC", value).casefold().split())


def _normalize_pairs(value: Any, field: str) -> set[tuple[str, str]]:
    if not isinstance(value, list) or not value:
        raise ScoringError(f"{field} must be a non-empty array")
    result: set[tuple[str, str]] = set()
    left_ids: set[str] = set()
    for item in value:
        if not isinstance(item, dict):
            raise ScoringError(f"{field} entries must be objects")
        left = _non_empty_string(item.get("left_id"), f"{field}.left_id")
        right = _non_empty_string(item.get("right_id"), f"{field}.right_id")
        if left in left_ids:
            raise ScoringError(f"{field} contains a duplicate left_id")
        left_ids.add(left)
        result.add((left, right))
    return result


def _normalize_blank_answers(value: Any, field: str) -> dict[str, str]:
    if isinstance(value, dict):
        if not value:
            raise ScoringError(f"{field} must not be empty")
        return {
            _non_empty_string(blank_id, f"{field}.blank_id"): _non_empty_string(option_id, f"{field}.option_id")
            for blank_id, option_id in value.items()
        }
    if not isinstance(value, list) or not value:
        raise ScoringError(f"{field} must be an object or non-empty array")
    result: dict[str, str] = {}
    for item in value:
        if not isinstance(item, dict):
            raise ScoringError(f"{field} entries must be objects")
        blank_id = _non_empty_string(item.get("blank_id"), f"{field}.blank_id")
        option_id = _non_empty_string(item.get("option_id", item.get("selected_option_id")), f"{field}.option_id")
        if blank_id in result:
            raise ScoringError(f"{field} contains a duplicate blank_id")
        result[blank_id] = option_id
    return result


def _score_single_choice(answer_key: JsonObject, user_answer: JsonObject) -> bool:
    expected = _non_empty_string(_required(answer_key, "correct_option_id"), "correct_option_id")
    actual = _non_empty_string(_required(user_answer, "selected_option_id"), "selected_option_id")
    return actual == expected


def evaluate_answer(
    question_type: QuestionType,
    answer_key: JsonObject,
    user_answer: JsonObject,
) -> tuple[bool, int, str]:
    """Validate and score one answer.

    Invalid shapes raise :class:`ScoringError`; a valid-but-wrong answer returns
    ``(False, 0, "Incorrect")``.  No fuzzy or AI grading is used.
    """

    if not isinstance(answer_key, dict) or not answer_key:
        raise ScoringError("Question answer key is invalid")
    if not isinstance(user_answer, dict) or not user_answer:
        raise ScoringError("answer_json must be a non-empty object")

    if question_type in {
        QuestionType.MULTIPLE_CHOICE,
        QuestionType.LISTENING_MULTIPLE_CHOICE,
        QuestionType.LISTENING_WITH_IMAGE,
    }:
        is_correct = _score_single_choice(answer_key, user_answer)

    elif question_type in {QuestionType.TRUE_FALSE, QuestionType.LISTENING_TRUE_FALSE}:
        expected = _boolean(_required(answer_key, "value", "is_true"), "value")
        actual = _boolean(_required(user_answer, "value", "is_true"), "value")
        is_correct = actual is expected

    elif question_type == QuestionType.MATCHING:
        expected = _normalize_pairs(_required(answer_key, "pairs"), "pairs")
        actual = _normalize_pairs(_required(user_answer, "pairs"), "pairs")
        is_correct = actual == expected

    elif question_type == QuestionType.ORDERING:
        expected = _required(answer_key, "ordered_ids")
        actual = _required(user_answer, "ordered_ids")
        if not isinstance(expected, list) or not expected or not all(isinstance(item, str) for item in expected):
            raise ScoringError("Question answer key has invalid ordered_ids")
        if not isinstance(actual, list) or not actual or not all(isinstance(item, str) for item in actual):
            raise ScoringError("ordered_ids must be a non-empty string array")
        if len(actual) != len(set(actual)):
            raise ScoringError("ordered_ids must not contain duplicates")
        is_correct = actual == expected

    elif question_type == QuestionType.CLOZE_MULTIPLE_CHOICE:
        if "correct_option_id" in answer_key:
            is_correct = _score_single_choice(answer_key, user_answer)
        else:
            expected = _normalize_blank_answers(_required(answer_key, "answers"), "answers")
            actual = _normalize_blank_answers(_required(user_answer, "answers"), "answers")
            is_correct = actual == expected

    elif question_type == QuestionType.KANJI_READING:
        if "correct_option_id" in answer_key:
            is_correct = _score_single_choice(answer_key, user_answer)
        else:
            accepted = _required(answer_key, "accepted_readings")
            if not isinstance(accepted, list) or not accepted or not all(isinstance(item, str) for item in accepted):
                raise ScoringError("Question answer key has invalid accepted_readings")
            actual = _non_empty_string(_required(user_answer, "reading"), "reading")
            normalized_accepted = {_normalize_reading(item) for item in accepted}
            is_correct = _normalize_reading(actual) in normalized_accepted

    elif question_type == QuestionType.READING_COMPREHENSION:
        if "correct_option_ids" in answer_key:
            expected = answer_key["correct_option_ids"]
            actual = _required(user_answer, "selected_option_ids")
            if not isinstance(expected, list) or not expected or not all(isinstance(item, str) for item in expected):
                raise ScoringError("Question answer key has invalid correct_option_ids")
            if not isinstance(actual, list) or not actual or not all(isinstance(item, str) for item in actual):
                raise ScoringError("selected_option_ids must be a non-empty string array")
            if len(actual) != len(set(actual)):
                raise ScoringError("selected_option_ids must not contain duplicates")
            is_correct = set(actual) == set(expected)
        else:
            is_correct = _score_single_choice(answer_key, user_answer)

    else:  # pragma: no cover - enum exhaustiveness guard
        raise ScoringError(f"Unsupported question type: {question_type}")

    return is_correct, 100 if is_correct else 0, "Correct" if is_correct else "Incorrect"
