import uuid
from datetime import datetime, timedelta, timezone

from fastapi.testclient import TestClient
from sqlalchemy.orm import Session

from app.models.curriculum import Course, Lesson, Level, Unit
from app.models.question import Question, QuestionRevision, QuestionStatus
from app.models.simulation import (
    JlptSimulation,
    JlptSimulationQuestion,
    JlptSimulationSection,
    UserSimulationAttemptSection,
)


# Helper function to create mock simulation data
def create_mock_simulation_data(db: Session):
    level = Level(id=str(uuid.uuid4()), name=f"N5 Mock Level {uuid.uuid4()}")
    course = Course(id=str(uuid.uuid4()), level_id=level.id, title="Mock Course")
    unit = Unit(id=str(uuid.uuid4()), course_id=course.id, title="Mock Unit")
    lesson = Lesson(id=str(uuid.uuid4()), unit_id=unit.id, title="Mock Lesson")
    db.add_all([level, course, unit, lesson])
    db.flush()

    q = Question(
        id=str(uuid.uuid4()),
        lesson_id=lesson.id,
        question_type="MULTIPLE_CHOICE",
        skill="VOCABULARY",
        status=QuestionStatus.PUBLISHED,
        prompt_json='{"text": "Sim Question"}',
        answer_key_json='{"correct_answer": "A"}',
        version_number=1,
    )
    db.add(q)
    db.flush()

    q_rev = QuestionRevision(
        id=str(uuid.uuid4()),
        question_id=q.id,
        version_number=1,
        lesson_id=lesson.id,
        question_type="MULTIPLE_CHOICE",
        skill="VOCABULARY",
        difficulty=1,
        prompt_json='{"text": "Sim Question"}',
        answer_key_json='{"correct_answer": "A"}',
    )
    db.add(q_rev)
    db.flush()

    sim = JlptSimulation(id=str(uuid.uuid4()), title="N5 Mock", level="N5", passing_score=80, is_published=True)
    db.add(sim)

    sec = JlptSimulationSection(
        id=str(uuid.uuid4()),
        simulation_id=sim.id,
        title="Vocab",
        section_type="VOCABULARY_KANJI",
        duration_minutes=25,
        passing_score=19,
    )
    db.add(sec)
    db.flush()

    sq = JlptSimulationQuestion(id=str(uuid.uuid4()), section_id=sec.id, question_id=q.id, order_number=1)
    db.add(sq)
    db.commit()
    return sim, sec, q, sq


def test_learner_simulation_flow(client: TestClient, db: Session, learner_token_headers: dict):
    sim, sec, q, sq = create_mock_simulation_data(db)

    # 1. Get simulations
    res = client.get("/api/v1/jlpt-simulations", headers=learner_token_headers)
    assert res.status_code == 200
    assert len(res.json()) >= 1

    # 2. Start attempt
    res = client.post(f"/api/v1/jlpt-simulations/{sim.id}/attempts", headers=learner_token_headers)
    assert res.status_code == 200
    attempt_id = res.json()["id"]
    assert res.json()["status"] == "STARTED"

    # 3. Start section
    res = client.post(f"/api/v1/jlpt-simulation-attempts/{attempt_id}/start-section", headers=learner_token_headers)
    assert res.status_code == 200
    assert res.json()["status"] == "IN_PROGRESS"

    # 4. Submit correct answer
    ans_res = client.post(
        f"/api/v1/jlpt-simulation-attempts/{attempt_id}/answers",
        json={"question_id": q.id, "answer_data": {"choice": "A"}},
        headers=learner_token_headers,
    )
    assert ans_res.status_code == 200

    # 5. Complete Section
    res = client.post(f"/api/v1/jlpt-simulation-attempts/{attempt_id}/complete-section", headers=learner_token_headers)
    assert res.status_code == 200

    # 6. Complete Simulation
    res = client.post(f"/api/v1/jlpt-simulation-attempts/{attempt_id}/complete", headers=learner_token_headers)
    assert res.status_code == 200
    result = res.json()
    assert result["total_score"] >= 0
    assert len(result["section_scores"]) == 1


def test_simulation_timer_expired(client: TestClient, db: Session, learner_token_headers: dict):
    sim, sec, q, sq = create_mock_simulation_data(db)

    # 1. Start attempt & section
    res = client.post(f"/api/v1/jlpt-simulations/{sim.id}/attempts", headers=learner_token_headers)
    attempt_id = res.json()["id"]
    client.post(f"/api/v1/jlpt-simulation-attempts/{attempt_id}/start-section", headers=learner_token_headers)

    # 2. Manually manipulate DB to make it expired (started 30 mins ago for a 25 mins section)
    db.commit()  # End current transaction to see changes made by FastAPI's SessionLocal
    attempt_sec = (
        db.query(UserSimulationAttemptSection).filter(UserSimulationAttemptSection.attempt_id == attempt_id).first()
    )
    attempt_sec.started_at = datetime.now(timezone.utc) - timedelta(minutes=30)
    db.commit()

    # 3. Submit answer should fail
    ans_res = client.post(
        f"/api/v1/jlpt-simulation-attempts/{attempt_id}/answers",
        json={"question_id": q.id, "answer_data": {"choice": "A"}},
        headers=learner_token_headers,
    )
    assert ans_res.status_code == 400
    assert "Time expired" in ans_res.json()["error"]["message"]
