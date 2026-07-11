import pytest

from app.models.question import QuestionType, SkillType
from app.services.question_workflow import QuestionWorkflowError, validate_question_payload

OPTIONS = [{"id": "a", "text": "A"}, {"id": "b", "text": "B"}]


@pytest.mark.parametrize(
    ("question_type", "skill", "prompt", "answer_key", "audio_id"),
    [
        (
            QuestionType.MULTIPLE_CHOICE,
            SkillType.VOCABULARY,
            {"text": "Choose", "options": OPTIONS},
            {"correct_option_id": "a"},
            None,
        ),
        (
            QuestionType.CLOZE_MULTIPLE_CHOICE,
            SkillType.GRAMMAR,
            {"text": "Fill", "blanks": [{"id": "x", "options": OPTIONS}]},
            {"answers": {"x": "b"}},
            None,
        ),
        (QuestionType.TRUE_FALSE, SkillType.GRAMMAR, {"text": "True?"}, {"value": True}, None),
        (
            QuestionType.MATCHING,
            SkillType.VOCABULARY,
            {
                "text": "Match",
                "left_items": [{"id": "l1", "text": "猫"}, {"id": "l2", "text": "犬"}],
                "right_items": [{"id": "r1", "text": "cat"}, {"id": "r2", "text": "dog"}],
            },
            {"pairs": [{"left_id": "l1", "right_id": "r1"}, {"left_id": "l2", "right_id": "r2"}]},
            None,
        ),
        (
            QuestionType.ORDERING,
            SkillType.GRAMMAR,
            {"text": "Order", "items": OPTIONS},
            {"ordered_ids": ["b", "a"]},
            None,
        ),
        (
            QuestionType.KANJI_READING,
            SkillType.VOCABULARY,
            {"text": "学生"},
            {"accepted_readings": ["がくせい"]},
            None,
        ),
        (
            QuestionType.READING_COMPREHENSION,
            SkillType.READING,
            {"text": "Read", "options": OPTIONS},
            {"correct_option_ids": ["a"]},
            None,
        ),
        (
            QuestionType.LISTENING_MULTIPLE_CHOICE,
            SkillType.LISTENING,
            {"text": "Listen", "options": OPTIONS},
            {"correct_option_id": "a"},
            "audio-1",
        ),
        (
            QuestionType.LISTENING_TRUE_FALSE,
            SkillType.LISTENING,
            {"text": "Listen"},
            {"value": False},
            "audio-1",
        ),
        (
            QuestionType.LISTENING_WITH_IMAGE,
            SkillType.LISTENING,
            {
                "text": "Choose image",
                "options": [
                    {"id": "a", "image_url": "https://example.test/a.png"},
                    {"id": "b", "image_url": "https://example.test/b.png"},
                ],
            },
            {"correct_option_id": "b"},
            "audio-1",
        ),
    ],
)
def test_all_canonical_question_contracts_validate(question_type, skill, prompt, answer_key, audio_id):
    validate_question_payload(
        question_type=question_type,
        skill=skill,
        difficulty=3,
        prompt_json=prompt,
        answer_key_json=answer_key,
        explanation_json={"text": "Explanation"},
        audio_asset_id=audio_id,
        require_explanation=True,
    )


def test_duplicate_option_text_is_rejected():
    with pytest.raises(QuestionWorkflowError, match="duplicate display"):
        validate_question_payload(
            question_type=QuestionType.MULTIPLE_CHOICE,
            skill=SkillType.VOCABULARY,
            difficulty=1,
            prompt_json={
                "text": "Choose",
                "options": [{"id": "a", "text": "猫"}, {"id": "b", "text": " 猫 "}],
            },
            answer_key_json={"correct_option_id": "a"},
            explanation_json={"text": "x"},
            audio_asset_id=None,
            require_explanation=True,
        )


def test_listening_requires_audio_and_listening_skill():
    with pytest.raises(QuestionWorkflowError, match="LISTENING skill"):
        validate_question_payload(
            question_type=QuestionType.LISTENING_TRUE_FALSE,
            skill=SkillType.GRAMMAR,
            difficulty=1,
            prompt_json={"text": "Listen"},
            answer_key_json={"value": True},
            explanation_json={"text": "x"},
            audio_asset_id="audio-1",
            require_explanation=True,
        )


def test_explanation_is_required_at_workflow_gate():
    with pytest.raises(QuestionWorkflowError, match="explanation_json"):
        validate_question_payload(
            question_type=QuestionType.TRUE_FALSE,
            skill=SkillType.GRAMMAR,
            difficulty=1,
            prompt_json={"text": "True?"},
            answer_key_json={"value": True},
            explanation_json=None,
            audio_asset_id=None,
            require_explanation=True,
        )
