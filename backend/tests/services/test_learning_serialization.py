from datetime import datetime, timedelta, timezone

from app.models.learning import (
    LearningSession,
    LearningSessionQuestion,
    SessionMode,
    SessionSource,
    SessionStatus,
)
from app.models.question import QuestionRevision, QuestionType, SkillType
from app.services.learning import sanitize_prompt, serialize_session_questions


def _session(mode=SessionMode.PRACTICE, status=SessionStatus.ACTIVE, answered=False):
    revision = QuestionRevision(
        id="revision-1",
        question_id="question-1",
        version_number=1,
        lesson_id="lesson-1",
        question_type=QuestionType.MULTIPLE_CHOICE,
        skill=SkillType.READING,
        difficulty=1,
        prompt_json={
            "text": "Choose",
            "correct_option_id": "a",
            "options": [{"id": "a", "text": "猫"}, {"id": "b", "text": "犬"}],
        },
        answer_key_json={"correct_option_id": "a"},
        explanation_json={"text": "Because"},
    )
    session_question = LearningSessionQuestion(
        id="session-question-1",
        question_id="question-1",
        question_revision_id="revision-1",
        order_number=1,
        is_answered=answered,
        user_answer_json={"selected_option_id": "a"} if answered else None,
        is_correct=True if answered else None,
        score=100 if answered else 0,
        feedback_notes="Correct" if answered else None,
        question_revision=revision,
    )
    now = datetime.now(timezone.utc)
    return LearningSession(
        id="session-1",
        user_id="user-1",
        lesson_id="lesson-1",
        mode=mode,
        source=SessionSource.LESSON,
        status=status,
        total_questions=1,
        answered_questions=int(answered),
        correct_answers=int(answered),
        final_score=100 if status == SessionStatus.COMPLETED else 0,
        started_at=now,
        expires_at=now + timedelta(hours=1),
        session_questions=[session_question],
    )


def test_prompt_sanitizer_recursively_removes_answer_material():
    sanitized = sanitize_prompt(
        {"text": "x", "answer_key_json": {"secret": 1}, "nested": {"is_correct": True, "safe": "yes"}}
    )
    assert sanitized == {"text": "x", "nested": {"safe": "yes"}}


def test_delivery_is_stable_and_never_contains_answer_key():
    session = _session()
    first = serialize_session_questions(session)[0].model_dump(exclude_none=True)
    second = serialize_session_questions(session)[0].model_dump(exclude_none=True)
    assert first == second
    assert "correct_option_id" not in first["question"]["prompt_json"]
    assert "correct_answer_json" not in first
    assert "is_correct" not in first


def test_active_exam_masks_result_but_completed_exam_reveals_it():
    active = serialize_session_questions(_session(mode=SessionMode.EXAM, answered=True))[0].model_dump(
        exclude_none=True
    )
    assert active["is_answered"] is True
    assert "is_correct" not in active
    assert "correct_answer_json" not in active

    completed = serialize_session_questions(
        _session(mode=SessionMode.EXAM, status=SessionStatus.COMPLETED, answered=True)
    )[0].model_dump(exclude_none=True)
    assert completed["is_correct"] is True
    assert completed["correct_answer_json"] == {"correct_option_id": "a"}
