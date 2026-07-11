import pytest

from app.models.question import QuestionType
from app.services.scoring import ScoringError, evaluate_answer


@pytest.mark.parametrize(
    ("question_type", "answer_key", "correct", "wrong"),
    [
        (
            QuestionType.MULTIPLE_CHOICE,
            {"correct_option_id": "a"},
            {"selected_option_id": "a"},
            {"selected_option_id": "b"},
        ),
        (
            QuestionType.CLOZE_MULTIPLE_CHOICE,
            {"answers": {"blank-1": "a", "blank-2": "c"}},
            {"answers": {"blank-2": "c", "blank-1": "a"}},
            {"answers": {"blank-1": "b", "blank-2": "c"}},
        ),
        (QuestionType.TRUE_FALSE, {"value": True}, {"value": True}, {"value": False}),
        (
            QuestionType.MATCHING,
            {"pairs": [{"left_id": "l1", "right_id": "r1"}, {"left_id": "l2", "right_id": "r2"}]},
            {"pairs": [{"left_id": "l2", "right_id": "r2"}, {"left_id": "l1", "right_id": "r1"}]},
            {"pairs": [{"left_id": "l1", "right_id": "r2"}, {"left_id": "l2", "right_id": "r1"}]},
        ),
        (
            QuestionType.ORDERING,
            {"ordered_ids": ["a", "b", "c"]},
            {"ordered_ids": ["a", "b", "c"]},
            {"ordered_ids": ["b", "a", "c"]},
        ),
        (
            QuestionType.KANJI_READING,
            {"accepted_readings": ["がくせい", "ガクセイ"]},
            {"reading": "  ガクセイ "},
            {"reading": "せんせい"},
        ),
        (
            QuestionType.READING_COMPREHENSION,
            {"correct_option_ids": ["a", "c"]},
            {"selected_option_ids": ["c", "a"]},
            {"selected_option_ids": ["a", "b"]},
        ),
        (
            QuestionType.LISTENING_MULTIPLE_CHOICE,
            {"correct_option_id": "a"},
            {"selected_option_id": "a"},
            {"selected_option_id": "b"},
        ),
        (QuestionType.LISTENING_TRUE_FALSE, {"value": False}, {"value": False}, {"value": True}),
        (
            QuestionType.LISTENING_WITH_IMAGE,
            {"correct_option_id": "img-a"},
            {"selected_option_id": "img-a"},
            {"selected_option_id": "img-b"},
        ),
    ],
)
def test_all_canonical_scorers_are_deterministic(question_type, answer_key, correct, wrong):
    assert evaluate_answer(question_type, answer_key, correct) == (True, 100, "Correct")
    assert evaluate_answer(question_type, answer_key, wrong) == (False, 0, "Incorrect")


def test_invalid_answer_shape_is_not_silently_scored_as_wrong():
    with pytest.raises(ScoringError, match="selected_option_id"):
        evaluate_answer(
            QuestionType.MULTIPLE_CHOICE,
            {"correct_option_id": "a"},
            {"choice": "a"},
        )


def test_duplicate_matching_left_id_is_rejected():
    with pytest.raises(ScoringError, match="duplicate left_id"):
        evaluate_answer(
            QuestionType.MATCHING,
            {"pairs": [{"left_id": "l1", "right_id": "r1"}]},
            {
                "pairs": [
                    {"left_id": "l1", "right_id": "r1"},
                    {"left_id": "l1", "right_id": "r2"},
                ]
            },
        )
