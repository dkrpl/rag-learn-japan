import pytest

from app.models.question import QuestionType
from app.services.scoring import ScoringError, evaluate_answer


def test_multiple_choice_scorer_is_deterministic():
    answer_key = {"correct_option_id": "a"}
    assert evaluate_answer(QuestionType.MULTIPLE_CHOICE, answer_key, {"selected_option_id": "a"}) == (
        True,
        100,
        "Correct",
    )
    assert evaluate_answer(QuestionType.MULTIPLE_CHOICE, answer_key, {"selected_option_id": "b"}) == (
        False,
        0,
        "Incorrect",
    )


def test_invalid_answer_shape_is_not_silently_scored_as_wrong():
    with pytest.raises(ScoringError, match="selected_option_id"):
        evaluate_answer(
            QuestionType.MULTIPLE_CHOICE,
            {"correct_option_id": "a"},
            {"choice": "a"},
        )
