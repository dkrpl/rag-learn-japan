import uuid

import pytest

from app.models.question import QuestionStatus


@pytest.mark.asyncio
async def test_rate_limit_login(client, db):
    # Try logging in 6 times with wrong password
    email = f"rate_limit_{uuid.uuid4()}@example.com"
    payload = {"email": email, "password": "wrongpassword"}

    # Five attempts are rejected with the canonical authentication status.
    for _ in range(5):
        response = client.post("/api/v1/auth/login", json=payload)
        assert response.status_code == 401

    # The 6th attempt should trigger 429 Too Many Requests
    response = client.post("/api/v1/auth/login", json=payload)
    assert response.status_code == 429
    assert "Too many login attempts" in response.json()["error"]["message"]


@pytest.mark.asyncio
async def test_mass_assignment_registration(client):
    # Try to register as an admin using mass assignment
    unique_email = f"hacker_{uuid.uuid4()}@example.com"
    payload = {
        "email": unique_email,
        "password": "Password123!",
        "name": "Hacker",
        "role": "ADMIN",  # Forcing role
    }

    response = client.post("/api/v1/auth/register", json=payload)
    # The API should ignore 'role' and register as LEARNER
    assert response.status_code == 201
    data = response.json()
    assert data["role"] == "learner"


@pytest.mark.asyncio
async def test_answer_leakage(client, learner_token_headers, db):
    # Learners should never receive answer keys before submission.
    from datetime import datetime, timedelta, timezone

    from app.models.learning import LearningSession, LearningSessionQuestion, SessionMode, SessionSource, SessionStatus
    from app.models.material import MaterialDocument
    from app.models.question import Question, QuestionRevision, QuestionType, SkillType
    from app.models.user import User

    learner = db.query(User).filter(User.email == "learner_test_fixture@example.com").one()
    material = MaterialDocument(
        title="Security PDF",
        original_filename="security.pdf",
        content_type="application/pdf",
        file_size_bytes=100,
        checksum=uuid.uuid4().hex + uuid.uuid4().hex,
        page_count=1,
        extracted_text="Security material",
        is_published=True,
        published_at=datetime.now(timezone.utc),
    )
    db.add(material)
    db.flush()
    question = Question(
        material_id=material.id,
        question_type=QuestionType.MULTIPLE_CHOICE,
        skill=SkillType.READING,
        prompt_json={"text": "Test Q?", "options": [{"id": "a", "text": "A"}, {"id": "b", "text": "B"}]},
        answer_key_json={"correct_option_id": "a"},
        explanation_json={"text": "Because A"},
        status=QuestionStatus.PUBLISHED,
        created_by=learner.id,
    )
    db.add(question)
    db.commit()
    db.refresh(question)

    rev = QuestionRevision(
        question_id=question.id,
        version_number=1,
        material_id=material.id,
        question_type=question.question_type,
        skill=question.skill,
        difficulty=question.difficulty,
        prompt_json=question.prompt_json,
        answer_key_json=question.answer_key_json,
        explanation_json=question.explanation_json,
    )
    db.add(rev)
    now = datetime.now(timezone.utc)
    session = LearningSession(
        user_id=learner.id,
        material_id=material.id,
        mode=SessionMode.PRACTICE,
        source=SessionSource.MATERIAL,
        status=SessionStatus.ACTIVE,
        total_questions=1,
        answered_questions=0,
        correct_answers=0,
        final_score=0,
        difficulty=1,
        passing_score=70,
        started_at=now,
        expires_at=now + timedelta(hours=1),
    )
    db.add(session)
    db.flush()
    db.add(
        LearningSessionQuestion(
            session_id=session.id,
            question_id=question.id,
            question_revision_id=rev.id,
            order_number=1,
        )
    )
    db.commit()

    q_response = client.get(f"/api/v1/app/quiz-sessions/{session.id}/questions", headers=learner_token_headers)
    assert q_response.status_code == 200
    questions = q_response.json()

    for q in questions:
        # Crucial security check: learners should never see the answer_key_json
        assert "answer_key_json" not in q["question"]
        assert "explanation_json" not in q["question"]  # Explanation only visible after answer/completion


@pytest.mark.asyncio
async def test_idor_prevent_access_other_user(client, learner_token_headers, admin_token_headers):
    # A learner trying to fetch admin's user info via some user endpoint
    # Actually, NIHONGO-LEARN uses `get_current_user` mostly, so IDOR is naturally protected,
    # but let's test if a learner can call an admin endpoint to get other users
    response = client.get("/api/v1/admin/users", headers=learner_token_headers)
    assert response.status_code == 403  # Forbidden
