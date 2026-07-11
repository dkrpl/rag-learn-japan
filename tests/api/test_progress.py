from datetime import datetime, timedelta, timezone

import pytest

from app.models.curriculum import Course, Lesson, Level, Unit
from app.models.progress import ReviewSchedule, UserMistake, XPTransaction
from app.models.question import Question, QuestionRevision, QuestionStatus, QuestionType, SkillType


@pytest.fixture
def progress_lesson(db):
    level = Level(name="N5-progress", is_published=True)
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


def _published_question(db, lesson, *, skill=SkillType.VOCABULARY):
    question = Question(
        lesson_id=lesson.id,
        question_type=QuestionType.MULTIPLE_CHOICE,
        skill=skill,
        difficulty=2,
        prompt_json={
            "text": "What is cat?",
            "options": [{"id": "a", "text": "Neko"}, {"id": "b", "text": "Inu"}],
        },
        answer_key_json={"correct_option_id": "a"},
        explanation_json={"text": "猫 means cat."},
        status=QuestionStatus.PUBLISHED,
        version_number=1,
        is_ai_generated=False,
        published_at=datetime.now(timezone.utc),
    )
    db.add(question)
    db.flush()
    db.add(
        QuestionRevision(
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
    )
    db.commit()
    return question


def _complete_one_question(client, headers, lesson_id, *, option_id):
    started = client.post(
        "/api/v1/learning-sessions",
        json={"lesson_id": lesson_id, "mode": "PRACTICE", "question_count": 1},
        headers=headers,
    )
    assert started.status_code == 201, started.text
    session_id = started.json()["id"]
    session_question = client.get(
        f"/api/v1/learning-sessions/{session_id}/questions",
        headers=headers,
    ).json()[0]
    answered = client.post(
        f"/api/v1/learning-sessions/{session_id}/answers",
        json={
            "session_question_id": session_question["id"],
            "answer_json": {"selected_option_id": option_id},
        },
        headers=headers,
    )
    assert answered.status_code == 200
    completed = client.post(f"/api/v1/learning-sessions/{session_id}/complete", headers=headers)
    assert completed.status_code == 200
    return session_id


def test_completion_updates_dashboard_mastery_srs_xp_and_lesson_progress_once(
    client,
    db,
    learner_token_headers,
    progress_lesson,
):
    question = _published_question(db, progress_lesson)
    session_id = _complete_one_question(
        client,
        learner_token_headers,
        progress_lesson.id,
        option_id="a",
    )

    overview = client.get("/api/v1/progress/overview", headers=learner_token_headers)
    assert overview.status_code == 200
    assert overview.json()["total_xp"] == 60
    assert overview.json()["lessons_completed"] == 1
    assert overview.json()["answered_questions"] == 1
    assert overview.json()["correct_answers"] == 1
    assert overview.json()["accuracy_percentage"] == 100
    assert overview.json()["current_streak"] == 1

    mastery = client.get("/api/v1/progress/mastery", headers=learner_token_headers).json()
    assert len(mastery) == 1
    assert mastery[0]["skill"] == "VOCABULARY"
    assert mastery[0]["mastery_level"] == 4

    lessons = client.get("/api/v1/progress/lessons", headers=learner_token_headers).json()
    assert lessons[0]["lesson_id"] == progress_lesson.id
    assert lessons[0]["status"] == "COMPLETED"
    assert lessons[0]["attempts_count"] == 1

    activity = client.get("/api/v1/progress/activity", headers=learner_token_headers).json()
    assert activity["total"] == 1
    assert activity["items"][0]["amount"] == 60

    due = client.get("/api/v1/reviews/due", headers=learner_token_headers).json()
    assert due["total"] == 0
    db.expire_all()
    schedule = db.query(ReviewSchedule).filter(ReviewSchedule.question_id == question.id).one()
    assert schedule.interval_days == 1
    assert schedule.consecutive_correct == 1

    retry = client.post(
        f"/api/v1/learning-sessions/{session_id}/complete",
        headers=learner_token_headers,
    )
    assert retry.status_code == 200
    db.expire_all()
    assert db.query(XPTransaction).filter(XPTransaction.session_id == session_id).count() == 1

    readiness = client.get("/api/v1/progress/readiness", headers=learner_token_headers)
    assert readiness.status_code == 200
    assert 0 <= readiness.json()["readiness_percentage"] <= 100
    recommendations = client.get("/api/v1/progress/recommendations", headers=learner_token_headers)
    assert recommendations.status_code == 200
    assert recommendations.json()[0]["kind"] == "SKILL"


def test_mistake_and_review_sessions_close_the_learning_loop(
    client,
    db,
    learner_token_headers,
    progress_lesson,
):
    question = _published_question(db, progress_lesson, skill=SkillType.GRAMMAR)
    _complete_one_question(client, learner_token_headers, progress_lesson.id, option_id="b")

    mistakes = client.get("/api/v1/progress/mistakes", headers=learner_token_headers)
    assert mistakes.status_code == 200
    mistake_page = mistakes.json()
    assert mistake_page["total"] == 1
    assert mistake_page["items"][0]["question_id"] == question.id
    assert isinstance(mistake_page["items"][0]["prompt_json"], dict)
    assert "answer_key_json" not in mistake_page["items"][0]["prompt_json"]

    mistake_session = client.post("/api/v1/reviews/mistake-sessions", headers=learner_token_headers)
    assert mistake_session.status_code == 201
    assert mistake_session.json()["source"] == "MISTAKE"
    client.post(
        f"/api/v1/learning-sessions/{mistake_session.json()['id']}/cancel",
        headers=learner_token_headers,
    )

    db.expire_all()
    schedule = db.query(ReviewSchedule).filter(ReviewSchedule.question_id == question.id).one()
    assert schedule.interval_days == 1
    schedule.next_review_date = datetime.now(timezone.utc) - timedelta(minutes=1)
    db.commit()

    due = client.get("/api/v1/reviews/due", headers=learner_token_headers)
    assert due.status_code == 200
    assert due.json()["total"] == 1
    assert due.json()["items"][0]["question_id"] == question.id

    review_session = client.post("/api/v1/reviews/sessions", headers=learner_token_headers)
    assert review_session.status_code == 201
    assert review_session.json()["source"] == "REVIEW"
    review_id = review_session.json()["id"]
    session_question = client.get(
        f"/api/v1/learning-sessions/{review_id}/questions",
        headers=learner_token_headers,
    ).json()[0]
    client.post(
        f"/api/v1/learning-sessions/{review_id}/answers",
        json={
            "session_question_id": session_question["id"],
            "answer_json": {"selected_option_id": "a"},
        },
        headers=learner_token_headers,
    )
    completed = client.post(
        f"/api/v1/learning-sessions/{review_id}/complete",
        headers=learner_token_headers,
    )
    assert completed.status_code == 200

    resolved = client.get("/api/v1/progress/mistakes", headers=learner_token_headers).json()
    assert resolved["total"] == 0
    db.expire_all()
    mistake = db.query(UserMistake).filter(UserMistake.question_id == question.id).one()
    assert mistake.is_resolved is True
    schedule = db.query(ReviewSchedule).filter(ReviewSchedule.question_id == question.id).one()
    assert schedule.interval_days == 3
    assert schedule.consecutive_correct == 1
