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
        "role": "ADMIN" # Forcing role
    }
    
    response = client.post("/api/v1/auth/register", json=payload)
    # The API should ignore 'role' and register as LEARNER
    assert response.status_code == 201
    data = response.json()
    assert data["role"] == "learner"

@pytest.mark.asyncio
async def test_answer_leakage(client, learner_token_headers, db):
    # 1. Create a mock level, course, unit, lesson and question
    import uuid

    from app.models.curriculum import Course, Lesson, Level, Unit
    from app.models.question import Question, QuestionType, SkillType
    
    level = Level(name=f"N5_{uuid.uuid4()}", is_published=True)
    db.add(level)
    db.commit()
    db.refresh(level)
    
    course = Course(level_id=level.id, title="Test Course", description="Desc", is_published=True)
    db.add(course)
    db.commit()
    db.refresh(course)
    
    unit = Unit(course_id=course.id, title="Test Unit", description="Desc", sequence=1, is_published=True)
    db.add(unit)
    db.commit()
    db.refresh(unit)
    
    lesson = Lesson(unit_id=unit.id, title="Test Lesson", sequence=1, is_published=True)
    db.add(lesson)
    db.commit()
    db.refresh(lesson)
    
    question = Question(
        lesson_id=lesson.id,
        question_type=QuestionType.MULTIPLE_CHOICE,
        skill=SkillType.VOCABULARY,
        prompt_json={"text": "Test Q?"},
        answer_key_json={"correct": "A"},
        explanation_json={"text": "Because A"},
        status=QuestionStatus.PUBLISHED
    )
    db.add(question)
    db.commit()
    db.refresh(question)
    
    from app.models.question import QuestionRevision
    rev = QuestionRevision(
        question_id=question.id,
        version_number=1,
        lesson_id=question.lesson_id,
        reading_id=question.reading_id,
        audio_asset_id=question.audio_asset_id,
        question_type=question.question_type,
        skill=question.skill,
        difficulty=question.difficulty,
        prompt_json=question.prompt_json,
        answer_key_json=question.answer_key_json,
        explanation_json=question.explanation_json
    )
    db.add(rev)
    db.commit()
    
    # 2. Start session
    payload = {"lesson_id": lesson.id, "mode": "PRACTICE"}
    response = client.post("/api/v1/learning-sessions/start", json=payload, headers=learner_token_headers)
    assert response.status_code == 200
    data = response.json()
    
    session_id = data["id"]
    
    # Fetch questions
    q_response = client.get(f"/api/v1/learning-sessions/{session_id}/questions", headers=learner_token_headers)
    assert q_response.status_code == 200
    questions = q_response.json()
    
    for q in questions:
        # Crucial security check: learners should never see the answer_key_json
        assert "answer_key_json" not in q
        assert "explanation_json" not in q # Explanation only visible after answer/completion

@pytest.mark.asyncio
async def test_idor_prevent_access_other_user(client, learner_token_headers, admin_token_headers):
    # A learner trying to fetch admin's user info via some user endpoint 
    # Actually, NIHONGO-LEARN uses `get_current_user` mostly, so IDOR is naturally protected,
    # but let's test if a learner can call an admin endpoint to get other users
    response = client.get("/api/v1/admin/users", headers=learner_token_headers)
    assert response.status_code == 403 # Forbidden
