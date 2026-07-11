"""Seed local demo data for the full MVP API surface.

Usage:
    python scripts/seed_dummy_data.py
"""

from __future__ import annotations

import sys
from datetime import datetime, timezone
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from app.core import security  # noqa: E402
from app.db.session import SessionLocal  # noqa: E402
from app.models.content import AudioAsset  # noqa: E402
from app.models.curriculum import Lesson  # noqa: E402
from app.models.question import Question, QuestionRevision, QuestionStatus, QuestionType, SkillType  # noqa: E402
from app.models.simulation import JlptSimulation, JlptSimulationQuestion, JlptSimulationSection  # noqa: E402
from app.models.user import User, UserRole  # noqa: E402
from scripts.seed_n5_content import seed_n5  # noqa: E402

DEMO_PASSWORD = "Password123"


def _upsert_user(*, email: str, role: UserRole, name: str) -> None:
    db = SessionLocal()
    try:
        user = db.query(User).filter(User.email == email).first()
        values = {
            "password_hash": security.get_password_hash(DEMO_PASSWORD),
            "name": name,
            "role": role,
            "is_active": True,
            "email_verified_at": datetime.now(timezone.utc),
            "timezone": "Asia/Jakarta",
            "target_level": "N5",
        }
        if user is None:
            db.add(User(email=email, **values))
        else:
            for field, value in values.items():
                setattr(user, field, value)
        db.commit()
    finally:
        db.close()


def _question_payloads(audio_asset_id: str | None) -> list[dict]:
    return [
        {
            "question_type": QuestionType.MULTIPLE_CHOICE,
            "skill": SkillType.VOCABULARY,
            "prompt_json": {
                "text": "Apa arti kata こんにちは?",
                "options": [{"id": "a", "text": "Halo"}, {"id": "b", "text": "Selamat tidur"}],
            },
            "answer_key_json": {"correct_option_id": "a"},
            "explanation_json": {"text": "こんにちは digunakan untuk menyapa pada siang hari."},
        },
        {
            "question_type": QuestionType.TRUE_FALSE,
            "skill": SkillType.GRAMMAR,
            "prompt_json": {"text": "Partikel は dapat menandai topik kalimat."},
            "answer_key_json": {"value": True},
            "explanation_json": {"text": "は sering dipakai sebagai topic marker."},
        },
        {
            "question_type": QuestionType.READING_COMPREHENSION,
            "skill": SkillType.READING,
            "prompt_json": {
                "text": "たなかさんは がくせいです。 Siapa Tanaka-san?",
                "options": [{"id": "a", "text": "Guru"}, {"id": "b", "text": "Siswa"}],
            },
            "answer_key_json": {"correct_option_ids": ["b"]},
            "explanation_json": {"text": "がくせい berarti siswa."},
        },
        {
            "question_type": QuestionType.LISTENING_MULTIPLE_CHOICE,
            "skill": SkillType.LISTENING,
            "audio_asset_id": audio_asset_id,
            "prompt_json": {
                "text": "Dengarkan audio. Pilih sapaan yang terdengar.",
                "options": [{"id": "a", "text": "こんにちは"}, {"id": "b", "text": "ありがとう"}],
            },
            "answer_key_json": {"correct_option_id": "a"},
            "explanation_json": {"text": "Fixture audio dipakai untuk memvalidasi alur listening."},
        },
    ]


def _upsert_questions_and_simulation() -> dict[str, int]:
    db = SessionLocal()
    try:
        lesson = db.query(Lesson).order_by(Lesson.created_at.asc()).first()
        if lesson is None:
            raise RuntimeError("No lesson found after N5 seed")

        audio = (
            db.query(AudioAsset)
            .filter(AudioAsset.is_published.is_(True))
            .order_by(AudioAsset.created_at.asc())
            .first()
        )
        questions: list[Question] = []
        for index, payload in enumerate(_question_payloads(audio.id if audio else None), start=1):
            if payload["skill"] == SkillType.LISTENING and not payload.get("audio_asset_id"):
                continue
            prompt_text = payload["prompt_json"]["text"]
            question = (
                db.query(Question)
                .filter(Question.lesson_id == lesson.id, Question.prompt_json["text"].as_string() == prompt_text)
                .first()
            )
            values = {
                "lesson_id": lesson.id,
                "reading_id": None,
                "audio_asset_id": payload.get("audio_asset_id"),
                "question_type": payload["question_type"],
                "skill": payload["skill"],
                "difficulty": 1,
                "prompt_json": payload["prompt_json"],
                "answer_key_json": payload["answer_key_json"],
                "explanation_json": payload["explanation_json"],
                "status": QuestionStatus.PUBLISHED,
                "is_ai_generated": False,
                "version_number": 1,
                "published_at": datetime.now(timezone.utc),
            }
            if question is None:
                question = Question(**values)
                db.add(question)
            else:
                for field, value in values.items():
                    setattr(question, field, value)
            db.flush()

            revision = (
                db.query(QuestionRevision)
                .filter(QuestionRevision.question_id == question.id, QuestionRevision.version_number == 1)
                .first()
            )
            revision_values = {
                "question_id": question.id,
                "version_number": 1,
                "lesson_id": question.lesson_id,
                "reading_id": question.reading_id,
                "audio_asset_id": question.audio_asset_id,
                "question_type": question.question_type,
                "skill": question.skill,
                "difficulty": question.difficulty,
                "prompt_json": question.prompt_json,
                "answer_key_json": question.answer_key_json,
                "explanation_json": question.explanation_json,
            }
            if revision is None:
                db.add(QuestionRevision(**revision_values))
            else:
                for field, value in revision_values.items():
                    setattr(revision, field, value)
            questions.append(question)

        simulation = db.query(JlptSimulation).filter(JlptSimulation.title == "Demo JLPT N5").first()
        if simulation is None:
            simulation = JlptSimulation(
                title="Demo JLPT N5",
                description="Dummy simulation for local testing.",
                level="N5",
            )
            db.add(simulation)
        simulation.passing_score = 80
        simulation.is_published = True
        simulation.is_archived = False
        simulation.published_at = datetime.now(timezone.utc)
        db.flush()

        section = (
            db.query(JlptSimulationSection)
            .filter(JlptSimulationSection.simulation_id == simulation.id, JlptSimulationSection.sequence == 1)
            .first()
        )
        if section is None:
            section = JlptSimulationSection(
                simulation_id=simulation.id,
                title="Vocabulary, Grammar, Reading, Listening",
                section_type="MIXED",
                sequence=1,
                duration_minutes=25,
                passing_score=19,
            )
            db.add(section)
        db.flush()

        db.query(JlptSimulationQuestion).filter(JlptSimulationQuestion.section_id == section.id).delete()
        for order, question in enumerate(questions, start=1):
            db.add(JlptSimulationQuestion(section_id=section.id, question_id=question.id, order_number=order))

        db.commit()
        return {"questions": len(questions), "simulations": 1}
    finally:
        db.close()


def seed_dummy_data() -> dict[str, int]:
    seed_n5(dry_run=False)
    _upsert_user(email="admin@example.com", role=UserRole.ADMINISTRATOR, name="Demo Admin")
    _upsert_user(email="learner@example.com", role=UserRole.LEARNER, name="Demo Learner")
    counts = _upsert_questions_and_simulation()
    return {"users": 2, **counts}


def main() -> None:
    counts = seed_dummy_data()
    print(f"Dummy data ready: {counts}")
    print("Demo accounts: admin@example.com / Password123, learner@example.com / Password123")


if __name__ == "__main__":
    main()
