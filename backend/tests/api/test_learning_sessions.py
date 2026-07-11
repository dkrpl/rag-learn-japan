from datetime import datetime, timedelta, timezone

import pytest

from app.core.security import create_access_token
from app.models.curriculum import Course, Lesson, Level, Unit
from app.models.learning import LearningSession, SessionStatus
from app.models.progress import XPTransaction
from app.models.question import Question, QuestionRevision, QuestionStatus, QuestionType, SkillType
from app.models.user import User, UserRole


@pytest.fixture
def test_lesson(db):
    level = Level(name="N5-learning", is_published=True)
    db.add(level)
    db.flush()
    course = Course(level_id=level.id, title="Course", is_published=True)
    db.add(course)
    db.flush()
    unit = Unit(course_id=course.id, title="Unit", is_published=True)
    db.add(unit)
    db.flush()
    lesson = Lesson(unit_id=unit.id, title="Lesson", is_published=True)
    db.add(lesson)
    db.commit()
    return lesson


@pytest.fixture
def other_learner_headers(db):
    user = User(
        email="other-learner@example.test",
        password_hash="not-used",
        role=UserRole.LEARNER,
        is_active=True,
    )
    db.add(user)
    db.commit()
    return {"Authorization": f"Bearer {create_access_token(user.id)}"}


def _published_question(db, lesson, *, prompt_text="What is dog in Japanese?"):
    question = Question(
        lesson_id=lesson.id,
        question_type=QuestionType.MULTIPLE_CHOICE,
        skill=SkillType.VOCABULARY,
        difficulty=1,
        prompt_json={
            "text": prompt_text,
            "options": [{"id": "opt1", "text": "Inu"}, {"id": "opt2", "text": "Neko"}],
        },
        answer_key_json={"correct_option_id": "opt1"},
        explanation_json={"text": "犬 means dog."},
        status=QuestionStatus.PUBLISHED,
        version_number=1,
        is_ai_generated=False,
        published_at=datetime.now(timezone.utc),
    )
    db.add(question)
    db.flush()
    revision = QuestionRevision(
        question_id=question.id,
        version_number=1,
        lesson_id=lesson.id,
        question_type=question.question_type,
        skill=question.skill,
        difficulty=question.difficulty,
        prompt_json=question.prompt_json,
        answer_key_json=question.answer_key_json,
        explanation_json=question.explanation_json,
    )
    db.add(revision)
    db.commit()
    return question


def _start(client, headers, lesson_id, *, mode="PRACTICE"):
    return client.post(
        "/api/v1/learning-sessions",
        json={"lesson_id": lesson_id, "mode": mode, "question_count": 1},
        headers=headers,
    )


def test_practice_session_is_owned_safe_atomic_and_idempotent(
    client,
    db,
    learner_token_headers,
    other_learner_headers,
    test_lesson,
):
    question = _published_question(db, test_lesson)
    started = _start(client, learner_token_headers, test_lesson.id)
    assert started.status_code == 201
    session = started.json()
    session_id = session["id"]
    assert session["status"] == "ACTIVE"
    assert session["source"] == "LESSON"
    assert session["expires_at"] is not None

    duplicate = _start(client, learner_token_headers, test_lesson.id)
    assert duplicate.status_code == 409
    assert duplicate.json()["error"]["code"] == "ACTIVE_SESSION_EXISTS"

    forbidden = client.get(f"/api/v1/learning-sessions/{session_id}", headers=other_learner_headers)
    assert forbidden.status_code == 404

    delivered = client.get(
        f"/api/v1/learning-sessions/{session_id}/questions",
        headers=learner_token_headers,
    )
    assert delivered.status_code == 200
    session_question = delivered.json()[0]
    assert session_question["question"]["id"] == question.id
    assert "answer_key_json" not in session_question["question"]
    assert "explanation_json" not in session_question["question"]
    assert "status" not in session_question["question"]
    assert "is_correct" not in session_question

    answered = client.post(
        f"/api/v1/learning-sessions/{session_id}/answers",
        json={
            "session_question_id": session_question["id"],
            "answer_json": {"selected_option_id": "opt1"},
            "response_time_ms": 750,
        },
        headers=learner_token_headers,
    )
    assert answered.status_code == 200
    assert answered.json()["is_correct"] is True
    assert answered.json()["correct_answer_json"] == {"correct_option_id": "opt1"}
    assert answered.json()["explanation_json"] == {"text": "犬 means dog."}

    repeated_answer = client.post(
        f"/api/v1/learning-sessions/{session_id}/answers",
        json={
            "session_question_id": session_question["id"],
            "answer_json": {"selected_option_id": "opt1"},
        },
        headers=learner_token_headers,
    )
    assert repeated_answer.status_code == 409
    assert repeated_answer.json()["error"]["code"] == "ANSWER_ALREADY_SUBMITTED"

    completed = client.post(
        f"/api/v1/learning-sessions/{session_id}/complete",
        headers=learner_token_headers,
    )
    assert completed.status_code == 200
    assert completed.json()["status"] == "COMPLETED"
    assert completed.json()["final_score"] == 100

    retry = client.post(
        f"/api/v1/learning-sessions/{session_id}/complete",
        headers=learner_token_headers,
    )
    assert retry.status_code == 200
    db.expire_all()
    assert db.query(XPTransaction).filter(XPTransaction.session_id == session_id).count() == 1


def test_exam_masks_feedback_until_completion(client, db, learner_token_headers, test_lesson):
    _published_question(db, test_lesson)
    started = _start(client, learner_token_headers, test_lesson.id, mode="EXAM")
    assert started.status_code == 201
    session_id = started.json()["id"]
    question = client.get(
        f"/api/v1/learning-sessions/{session_id}/questions",
        headers=learner_token_headers,
    ).json()[0]

    answered = client.post(
        f"/api/v1/learning-sessions/{session_id}/answers",
        json={
            "session_question_id": question["id"],
            "answer_json": {"selected_option_id": "opt1"},
        },
        headers=learner_token_headers,
    )
    assert answered.status_code == 200
    assert "is_correct" not in answered.json()
    assert "score" not in answered.json()
    assert "correct_answer_json" not in answered.json()

    active_delivery = client.get(
        f"/api/v1/learning-sessions/{session_id}/questions",
        headers=learner_token_headers,
    ).json()[0]
    assert active_delivery["is_answered"] is True
    assert "is_correct" not in active_delivery

    completed = client.post(
        f"/api/v1/learning-sessions/{session_id}/complete",
        headers=learner_token_headers,
    )
    assert completed.status_code == 200
    result = client.get(
        f"/api/v1/learning-sessions/{session_id}/questions",
        headers=learner_token_headers,
    ).json()[0]
    assert result["is_correct"] is True
    assert result["correct_answer_json"] == {"correct_option_id": "opt1"}


def test_incomplete_expired_and_cancelled_session_rules(client, db, learner_token_headers, test_lesson):
    _published_question(db, test_lesson)
    started = _start(client, learner_token_headers, test_lesson.id)
    session_id = started.json()["id"]
    session_question = client.get(
        f"/api/v1/learning-sessions/{session_id}/questions",
        headers=learner_token_headers,
    ).json()[0]

    incomplete = client.post(
        f"/api/v1/learning-sessions/{session_id}/complete",
        headers=learner_token_headers,
    )
    assert incomplete.status_code == 409
    assert incomplete.json()["error"]["code"] == "SESSION_INCOMPLETE"

    db.expire_all()
    stored = db.query(LearningSession).filter(LearningSession.id == session_id).one()
    stored.expires_at = datetime.now(timezone.utc) - timedelta(seconds=1)
    db.commit()
    expired = client.post(
        f"/api/v1/learning-sessions/{session_id}/answers",
        json={
            "session_question_id": session_question["id"],
            "answer_json": {"selected_option_id": "opt1"},
        },
        headers=learner_token_headers,
    )
    assert expired.status_code == 409
    db.expire_all()
    assert db.query(LearningSession).filter(LearningSession.id == session_id).one().status == SessionStatus.EXPIRED

    replacement = _start(client, learner_token_headers, test_lesson.id)
    assert replacement.status_code == 201
    replacement_id = replacement.json()["id"]
    first_cancel = client.post(
        f"/api/v1/learning-sessions/{replacement_id}/cancel",
        headers=learner_token_headers,
    )
    second_cancel = client.post(
        f"/api/v1/learning-sessions/{replacement_id}/cancel",
        headers=learner_token_headers,
    )
    assert first_cancel.json()["status"] == "CANCELLED"
    assert second_cancel.json()["status"] == "CANCELLED"
