import uuid

import pytest

from app.core.security import create_access_token
from app.models.curriculum import Course, Lesson, Level, Unit
from app.models.user import User, UserRole


@pytest.fixture
def test_lesson(db):
    suffix = uuid.uuid4().hex[:8]
    level = Level(name=f"N5-{suffix}", is_published=True)
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
def reviewer_token_headers(db):
    reviewer = User(
        email="question-reviewer@example.test",
        password_hash="not-used",
        role=UserRole.REVIEWER,
        is_active=True,
    )
    db.add(reviewer)
    db.commit()
    return {"Authorization": f"Bearer {create_access_token(reviewer.id)}"}


def _question_payload(lesson_id: str, *, text: str = "What is cat in Japanese?"):
    return {
        "lesson_id": lesson_id,
        "question_type": "MULTIPLE_CHOICE",
        "skill": "VOCABULARY",
        "difficulty": 1,
        "prompt_json": {
            "text": text,
            "options": [{"id": "opt1", "text": "Neko"}, {"id": "opt2", "text": "Inu"}],
        },
        "answer_key_json": {"correct_option_id": "opt1"},
        "explanation_json": {"text": "猫 is read neko."},
    }


def test_explicit_review_workflow_and_separation_of_duty(
    client,
    admin_token_headers,
    reviewer_token_headers,
    learner_token_headers,
    test_lesson,
):
    response = client.post(
        "/api/v1/admin/questions",
        json=_question_payload(test_lesson.id),
        headers=admin_token_headers,
    )
    assert response.status_code == 201
    question_id = response.json()["id"]
    assert response.json()["status"] == "DRAFT"

    response = client.post(
        f"/api/v1/admin/questions/{question_id}/submit-review",
        headers=admin_token_headers,
    )
    assert response.status_code == 409

    response = client.post(
        f"/api/v1/admin/questions/{question_id}/auto-validate",
        headers=admin_token_headers,
    )
    assert response.status_code == 200
    assert response.json()["status"] == "AUTO_VALIDATED"

    response = client.post(
        f"/api/v1/admin/questions/{question_id}/submit-review",
        headers=admin_token_headers,
    )
    assert response.status_code == 200
    assert response.json()["status"] == "IN_REVIEW"

    response = client.post(
        f"/api/v1/admin/questions/{question_id}/approve",
        json={"status_given": "APPROVED"},
        headers=admin_token_headers,
    )
    assert response.status_code == 403
    assert response.json()["error"]["code"] == "SEPARATION_OF_DUTY"

    response = client.post(
        f"/api/v1/admin/questions/{question_id}/approve",
        json={"notes": "Verified Japanese and answer."},
        headers=reviewer_token_headers,
    )
    assert response.status_code == 200
    assert response.json()["status"] == "APPROVED"

    response = client.post(
        f"/api/v1/admin/questions/{question_id}/publish",
        headers=reviewer_token_headers,
    )
    assert response.status_code == 200
    assert response.json()["status"] == "PUBLISHED"
    assert response.json()["published_at"] is not None

    history = client.get(
        f"/api/v1/admin/questions/{question_id}/history",
        headers=reviewer_token_headers,
    )
    assert history.status_code == 200
    assert len(history.json()) == 1
    assert history.json()[0]["question_type"] == "MULTIPLE_CHOICE"

    forbidden = client.get("/api/v1/admin/questions", headers=learner_token_headers)
    assert forbidden.status_code == 403


def test_question_filter_pagination_duplicate_and_archive(
    client,
    admin_token_headers,
    reviewer_token_headers,
    test_lesson,
):
    first = client.post(
        "/api/v1/admin/questions",
        json=_question_payload(test_lesson.id),
        headers=admin_token_headers,
    )
    assert first.status_code == 201
    question_id = first.json()["id"]

    duplicate = client.post(
        "/api/v1/admin/questions",
        json=_question_payload(test_lesson.id),
        headers=admin_token_headers,
    )
    assert duplicate.status_code == 409
    assert duplicate.json()["error"]["code"] == "DUPLICATE_QUESTION"

    second = client.post(
        "/api/v1/admin/questions",
        json=_question_payload(test_lesson.id, text="What is dog in Japanese?"),
        headers=admin_token_headers,
    )
    assert second.status_code == 201

    page = client.get(
        f"/api/v1/admin/questions?lesson_id={test_lesson.id}&status=DRAFT&page=1&page_size=1",
        headers=reviewer_token_headers,
    )
    assert page.status_code == 200
    assert page.json()["total"] == 2
    assert page.json()["pages"] == 2
    assert len(page.json()["items"]) == 1

    archived = client.post(
        f"/api/v1/admin/questions/{question_id}/archive",
        headers=admin_token_headers,
    )
    assert archived.status_code == 200
    assert archived.json()["status"] == "ARCHIVED"
    repeated = client.post(
        f"/api/v1/admin/questions/{question_id}/archive",
        headers=admin_token_headers,
    )
    assert repeated.status_code == 200


def test_invalid_question_contract_and_review_action_are_rejected(
    client,
    admin_token_headers,
    reviewer_token_headers,
    test_lesson,
):
    invalid = _question_payload(test_lesson.id)
    invalid["answer_key_json"] = {"correct_option_id": "missing"}
    response = client.post("/api/v1/admin/questions", json=invalid, headers=admin_token_headers)
    assert response.status_code == 400
    assert response.json()["error"]["code"] == "INVALID_ANSWER_KEY"

    created = client.post(
        "/api/v1/admin/questions",
        json=_question_payload(test_lesson.id),
        headers=admin_token_headers,
    )
    question_id = created.json()["id"]
    client.post(f"/api/v1/admin/questions/{question_id}/auto-validate", headers=admin_token_headers)
    client.post(f"/api/v1/admin/questions/{question_id}/submit-review", headers=admin_token_headers)

    missing_notes = client.post(
        f"/api/v1/admin/questions/{question_id}/reject",
        json={},
        headers=reviewer_token_headers,
    )
    assert missing_notes.status_code == 400
    mismatch = client.post(
        f"/api/v1/admin/questions/{question_id}/reject",
        json={"status_given": "APPROVED", "notes": "Wrong answer."},
        headers=reviewer_token_headers,
    )
    assert mismatch.status_code == 422
