"""Question generation helpers for material-first quiz sessions."""

from __future__ import annotations

import json
import re
from datetime import datetime, timezone
from typing import Any

from sqlalchemy.orm import Session

from app.core.config import settings
from app.models.ai_jobs import GenerationJob, JobStatus, JobType
from app.models.material import MaterialDocument
from app.models.question import Question, QuestionStatus, QuestionType, SkillType
from app.models.user import User
from app.services.ai_provider import get_ai_provider
from app.services.question_workflow import QuestionWorkflowError, snapshot_question, validate_question_payload

DIFFICULTY_LABELS = {
    "easy": 1,
    "medium": 2,
    "hard": 3,
}


class MaterialQuizGenerationError(ValueError):
    """Raised when AI output cannot be turned into safe learner questions."""


def normalize_difficulty(value: int | str) -> int:
    if isinstance(value, str):
        normalized = value.strip().lower()
        if normalized in DIFFICULTY_LABELS:
            return DIFFICULTY_LABELS[normalized]
        if normalized.isdigit():
            value = int(normalized)
        else:
            raise ValueError("difficulty must be easy, medium, hard, or 1-5")
    if not 1 <= int(value) <= 5:
        raise ValueError("difficulty must be between 1 and 5")
    return int(value)


def difficulty_label(value: int) -> str:
    if value <= 1:
        return "easy"
    if value == 2:
        return "medium"
    return "hard"


def _sentences(text: str) -> list[str]:
    chunks = re.split(r"(?<=[.!?。！？])\s+|\n+", text)
    cleaned = [" ".join(chunk.split()) for chunk in chunks if len(" ".join(chunk.split())) >= 20]
    return cleaned or [" ".join(text.split())[:240] or "Materi PDF belum memiliki teks yang cukup."]


def _fallback_questions(material: MaterialDocument, *, count: int, difficulty: int) -> list[dict[str, Any]]:
    sentences = _sentences(material.extracted_text)
    questions: list[dict[str, Any]] = []
    for index in range(count):
        source = sentences[index % len(sentences)]
        excerpt = source[:180]
        questions.append(
            {
                "question_type": QuestionType.MULTIPLE_CHOICE.value,
                "skill": SkillType.READING.value,
                "difficulty": difficulty,
                "prompt_json": {
                    "text": f"Apa informasi yang paling sesuai dengan kutipan {index + 1} dari materi '{material.title}'?",
                    "options": [
                        {"id": "a", "text": excerpt},
                        {"id": "b", "text": "Pernyataan ini tidak terdapat pada materi."},
                        {"id": "c", "text": "Materi membahas topik yang tidak berkaitan."},
                        {"id": "d", "text": "Semua pilihan jawaban salah."},
                    ],
                },
                "answer_key_json": {"correct_option_id": "a"},
                "explanation_json": {"text": f"Jawaban diambil dari kutipan materi: {excerpt}"},
            }
        )
    return questions


def _generation_prompt(material: MaterialDocument, *, count: int, difficulty: int) -> str:
    return f"""
Kamu adalah pembuat soal evaluasi pemahaman Bahasa Jepang.

Buat {count} soal pilihan ganda berdasarkan PDF berikut.
Difficulty: {difficulty_label(difficulty)}.

Aturan:
- Gunakan hanya informasi dari materi.
- Jangan bocorkan jawaban di prompt.
- Setiap soal wajib memiliki 4 opsi: a, b, c, d.
- Kembalikan HANYA JSON array.

Format item:
{{
  "question_type": "MULTIPLE_CHOICE",
  "skill": "READING",
  "difficulty": {difficulty},
  "prompt_json": {{
    "text": "pertanyaan",
    "options": [
      {{"id": "a", "text": "opsi A"}},
      {{"id": "b", "text": "opsi B"}},
      {{"id": "c", "text": "opsi C"}},
      {{"id": "d", "text": "opsi D"}}
    ]
  }},
  "answer_key_json": {{"correct_option_id": "a"}},
  "explanation_json": {{"text": "penjelasan singkat dari materi"}}
}}

MATERI:
{material.extracted_text}
""".strip()


def _coerce_questions(
    raw_content: str,
    material: MaterialDocument,
    *,
    count: int,
    difficulty: int,
    allow_fallback: bool,
) -> list[dict[str, Any]]:
    try:
        parsed = json.loads(raw_content)
    except json.JSONDecodeError:
        if allow_fallback:
            return _fallback_questions(material, count=count, difficulty=difficulty)
        raise MaterialQuizGenerationError("AI returned invalid JSON. Please try generating again.")
    if not isinstance(parsed, list):
        if allow_fallback:
            return _fallback_questions(material, count=count, difficulty=difficulty)
        raise MaterialQuizGenerationError("AI response must be a JSON array of questions.")
    return [item for item in parsed if isinstance(item, dict)][:count]


def _string_value(value: Any) -> str:
    return value.strip() if isinstance(value, str) else ""


def _material_tokens(material: MaterialDocument) -> set[str]:
    text = f"{material.title} {material.extracted_text}".lower()
    return {token for token in re.findall(r"[\w\u3040-\u30ff\u4e00-\u9fff]+", text) if len(token) >= 3}


def _validate_ai_question_safety(item: dict[str, Any], material: MaterialDocument, *, index: int) -> None:
    prompt_json = item.get("prompt_json") or item.get("prompt")
    answer_key_json = item.get("answer_key_json") or item.get("answer_key")
    explanation_json = item.get("explanation_json") or item.get("explanation")
    if isinstance(explanation_json, str):
        explanation_json = {"text": explanation_json}
        item["explanation_json"] = explanation_json

    if not isinstance(prompt_json, dict):
        raise MaterialQuizGenerationError(f"Question {index} prompt_json is invalid.")
    question_text = _string_value(prompt_json.get("text") or prompt_json.get("question"))
    if not question_text:
        raise MaterialQuizGenerationError(f"Question {index} prompt text is empty.")

    options = prompt_json.get("options")
    if not isinstance(options, list) or len(options) != 4:
        raise MaterialQuizGenerationError(f"Question {index} must have exactly 4 options.")
    option_ids: list[str] = []
    option_texts: list[str] = []
    for option in options:
        if not isinstance(option, dict):
            raise MaterialQuizGenerationError(f"Question {index} contains an invalid option.")
        option_id = _string_value(option.get("id")).lower()
        option_text = _string_value(option.get("text"))
        if option_id not in {"a", "b", "c", "d"} or not option_text:
            raise MaterialQuizGenerationError(f"Question {index} options must use ids a, b, c, d with text.")
        option_ids.append(option_id)
        option_texts.append(" ".join(option_text.lower().split()))
    if sorted(option_ids) != ["a", "b", "c", "d"]:
        raise MaterialQuizGenerationError(f"Question {index} options must include a, b, c, and d.")
    if len(set(option_texts)) != len(option_texts):
        raise MaterialQuizGenerationError(f"Question {index} contains duplicate option text.")

    if not isinstance(answer_key_json, dict):
        raise MaterialQuizGenerationError(f"Question {index} answer_key_json is invalid.")
    correct_option = _string_value(answer_key_json.get("correct_option_id")).lower()
    if correct_option not in option_ids:
        raise MaterialQuizGenerationError(f"Question {index} correct option is not present in options.")
    answer_key_json["correct_option_id"] = correct_option

    explanation_text = ""
    if isinstance(explanation_json, dict):
        explanation_text = _string_value(explanation_json.get("text") or explanation_json.get("explanation"))
    if not explanation_text:
        raise MaterialQuizGenerationError(f"Question {index} explanation is required.")

    material_tokens = _material_tokens(material)
    combined = f"{question_text} {' '.join(option_texts)} {explanation_text}".lower()
    generated_tokens = {token for token in re.findall(r"[\w\u3040-\u30ff\u4e00-\u9fff]+", combined) if len(token) >= 3}
    if material_tokens and generated_tokens and material_tokens.isdisjoint(generated_tokens):
        raise MaterialQuizGenerationError(f"Question {index} does not appear grounded in the PDF material.")


def create_generation_job(
    db: Session,
    *,
    user: User,
    material: MaterialDocument,
    count: int,
    difficulty: int,
) -> GenerationJob:
    payload = {
        "material_id": material.id,
        "material_title": material.title,
        "question_type": QuestionType.MULTIPLE_CHOICE.value,
        "skill": SkillType.READING.value,
        "count": count,
        "difficulty": difficulty,
        "difficulty_label": difficulty_label(difficulty),
        "source_material": material.extracted_text,
    }
    job = GenerationJob(
        job_type=JobType.QUESTION_GENERATION,
        status=JobStatus.PROCESSING,
        prompt_json=json.dumps(payload, ensure_ascii=False, separators=(",", ":"), sort_keys=True),
        target_id=material.id,
        created_by=user.id,
        started_at=datetime.now(timezone.utc),
    )
    db.add(job)
    db.flush()
    return job


def generate_questions_for_material(
    db: Session,
    *,
    user: User,
    material: MaterialDocument,
    count: int,
    difficulty: int,
) -> tuple[GenerationJob, list[Question]]:
    job = create_generation_job(db, user=user, material=material, count=count, difficulty=difficulty)
    tokens_used = 0
    try:
        raw_ai_response: str
        if settings.AI_PROVIDER == "disabled":
            questions_data = _fallback_questions(material, count=count, difficulty=difficulty)
            raw_ai_response = json.dumps(questions_data, ensure_ascii=False)
        else:
            content, metadata = get_ai_provider().generate_questions(
                _generation_prompt(material, count=count, difficulty=difficulty)
            )
            tokens_used = int(metadata.get("tokens_used", 0) or 0)
            raw_ai_response = content
            questions_data = _coerce_questions(
                content,
                material,
                count=count,
                difficulty=difficulty,
                allow_fallback=False,
            )

        created: list[Question] = []
        seen_question_texts: set[str] = set()
        for index, item in enumerate(questions_data[:count], start=1):
            _validate_ai_question_safety(item, material, index=index)
            prompt_json = item.get("prompt_json") or item.get("prompt")
            question_text = " ".join(
                str(prompt_json.get("text") or prompt_json.get("question") or "").lower().split()
            )
            if question_text in seen_question_texts:
                raise MaterialQuizGenerationError(f"Question {index} duplicates another generated prompt.")
            seen_question_texts.add(question_text)
            answer_key_json = item.get("answer_key_json") or item.get("answer_key")
            explanation_json = item.get("explanation_json") or item.get("explanation")
            if isinstance(explanation_json, str):
                explanation_json = {"text": explanation_json}
            question_type = QuestionType(item.get("question_type") or QuestionType.MULTIPLE_CHOICE.value)
            skill = SkillType(item.get("skill") or SkillType.READING.value)
            question_difficulty = normalize_difficulty(item.get("difficulty") or difficulty)
            validate_question_payload(
                question_type=question_type,
                skill=skill,
                difficulty=question_difficulty,
                prompt_json=prompt_json,
                answer_key_json=answer_key_json,
                explanation_json=explanation_json,
                require_explanation=True,
            )
            question = Question(
                material_id=material.id,
                lesson_id=material.lesson_id,
                question_type=question_type,
                skill=skill,
                difficulty=question_difficulty,
                prompt_json=prompt_json,
                answer_key_json=answer_key_json,
                explanation_json=explanation_json,
                status=QuestionStatus.AUTO_VALIDATED,
                is_ai_generated=True,
                created_by=user.id,
            )
            db.add(question)
            db.flush()
            snapshot_question(db, question, actor_id=user.id)
            created.append(question)

        if not created:
            raise ValueError("No valid questions were generated")
        job.status = JobStatus.COMPLETED
        job.raw_response = json.dumps(
            {"created_question_ids": [question.id for question in created], "raw_ai_response": raw_ai_response},
            ensure_ascii=False,
            separators=(",", ":"),
        )
        job.tokens_used = tokens_used
        job.completed_at = datetime.now(timezone.utc)
        job.error_message = None
        db.flush()
        return job, created
    except (QuestionWorkflowError, ValueError, RuntimeError, MaterialQuizGenerationError) as exc:
        job.status = JobStatus.FAILED
        job.error_message = str(exc)
        job.completed_at = datetime.now(timezone.utc)
        db.flush()
        raise
