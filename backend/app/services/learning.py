"""Material quiz selection, delivery, answering, and completion."""

from __future__ import annotations

import copy
import hashlib
import random
from datetime import datetime, timedelta, timezone
from typing import Iterable

from sqlalchemy.orm import Session

from app.models.learning import (
    LearningSession,
    LearningSessionQuestion,
    SessionMode,
    SessionSource,
    SessionStatus,
)
from app.models.material import MaterialDocument
from app.models.question import Question, QuestionRevision, QuestionStatus
from app.models.user import User
from app.schemas.learning import SessionQuestionResponse, SubmitAnswerRequest, SubmitAnswerResponse
from app.schemas.question import QuestionResponseLearner
from app.services.question_workflow import snapshot_question
from app.services.scoring import ScoringError, evaluate_answer

PRACTICE_TTL = timedelta(hours=24)
EXAM_TTL = timedelta(hours=2)


class LearningServiceError(RuntimeError):
    def __init__(self, message: str, *, status_code: int = 400, code: str = "LEARNING_ERROR") -> None:
        super().__init__(message)
        self.message = message
        self.status_code = status_code
        self.code = code


def _aware_utc(value: datetime) -> datetime:
    return value.replace(tzinfo=timezone.utc) if value.tzinfo is None else value.astimezone(timezone.utc)


def _expire_if_needed(session: LearningSession, *, now: datetime | None = None) -> bool:
    if session.status != SessionStatus.ACTIVE:
        return False
    now = now or datetime.now(timezone.utc)
    if _aware_utc(session.expires_at) > now:
        return False
    session.status = SessionStatus.EXPIRED
    session.completed_at = now
    return True


def get_owned_session(
    db: Session,
    *,
    session_id: str,
    user_id: str,
    lock: bool = False,
    persist_expiry: bool = True,
) -> LearningSession:
    query = db.query(LearningSession).filter(
        LearningSession.id == session_id,
        LearningSession.user_id == user_id,
    )
    if lock:
        query = query.with_for_update()
    session = query.first()
    if not session:
        raise LearningServiceError("Quiz session not found", status_code=404, code="SESSION_NOT_FOUND")
    expired = _expire_if_needed(session)
    if expired and persist_expiry:
        db.commit()
        db.refresh(session)
    return session


def get_published_material(db: Session, material_id: str) -> MaterialDocument:
    material = (
        db.query(MaterialDocument)
        .filter(
            MaterialDocument.id == material_id,
            MaterialDocument.is_published.is_(True),
            MaterialDocument.is_archived.is_(False),
        )
        .first()
    )
    if not material:
        raise LearningServiceError("Material not found", status_code=404, code="MATERIAL_NOT_FOUND")
    return material


def _assert_no_duplicate_active_session(db: Session, *, user_id: str, material_id: str) -> None:
    query = db.query(LearningSession).filter(
        LearningSession.user_id == user_id,
        LearningSession.material_id == material_id,
        LearningSession.source == SessionSource.MATERIAL,
        LearningSession.status == SessionStatus.ACTIVE,
    )
    for existing in query.with_for_update().all():
        if _expire_if_needed(existing):
            continue
        raise LearningServiceError(
            "An active quiz session already exists for this material",
            status_code=409,
            code="ACTIVE_SESSION_EXISTS",
        )


def _create_session(
    db: Session,
    *,
    user: User,
    material: MaterialDocument,
    questions: Iterable[Question],
    difficulty: int,
    mode: SessionMode,
) -> LearningSession:
    selected = list(dict.fromkeys(questions))
    if not selected:
        raise LearningServiceError("No eligible questions are available", status_code=409, code="NO_QUESTIONS")
    now = datetime.now(timezone.utc)
    ttl = EXAM_TTL if mode == SessionMode.EXAM else PRACTICE_TTL
    session = LearningSession(
        user_id=user.id,
        material_id=material.id,
        lesson_id=material.lesson_id,
        mode=mode,
        source=SessionSource.MATERIAL,
        status=SessionStatus.ACTIVE,
        difficulty=difficulty,
        passing_score=material.passing_score,
        is_passed=False,
        earned_exp=0,
        total_questions=len(selected),
        answered_questions=0,
        correct_answers=0,
        final_score=0,
        started_at=now,
        expires_at=now + ttl,
    )
    db.add(session)
    db.flush()
    for order_number, question in enumerate(selected, start=1):
        revision = snapshot_question(db, question, actor_id=question.created_by)
        db.add(
            LearningSessionQuestion(
                session_id=session.id,
                question_id=question.id,
                question_revision_id=revision.id,
                order_number=order_number,
                is_answered=False,
                is_correct=None,
                score=0,
            )
        )
    db.commit()
    db.refresh(session)
    return session


def start_material_session(
    db: Session,
    *,
    user: User,
    material: MaterialDocument,
    questions: list[Question],
    difficulty: int,
    mode: SessionMode = SessionMode.PRACTICE,
) -> LearningSession:
    try:
        _assert_no_duplicate_active_session(db, user_id=user.id, material_id=material.id)
        return _create_session(db, user=user, material=material, questions=questions, difficulty=difficulty, mode=mode)
    except Exception:
        db.rollback()
        raise


_SECRET_PROMPT_KEYS = {
    "answer_key",
    "answer_key_json",
    "correct_answer",
    "correct_option_id",
    "correct_option_ids",
    "is_correct",
    "explanation",
    "explanation_json",
}


def _strip_prompt_secrets(value):
    if isinstance(value, dict):
        return {key: _strip_prompt_secrets(item) for key, item in value.items() if key not in _SECRET_PROMPT_KEYS}
    if isinstance(value, list):
        return [_strip_prompt_secrets(item) for item in value]
    return value


def sanitize_prompt(prompt_json: dict) -> dict:
    return _strip_prompt_secrets(copy.deepcopy(prompt_json))


def _explanation_text(explanation_json: dict | None) -> str | None:
    if not isinstance(explanation_json, dict):
        return None
    value = explanation_json.get("text") or explanation_json.get("explanation")
    if isinstance(value, str) and value.strip():
        return value.strip()
    return None


def _shuffle_list(items: list, *, seed: str) -> list:
    result = list(items)
    digest = hashlib.sha256(seed.encode("utf-8")).digest()
    random.Random(int.from_bytes(digest[:8], "big")).shuffle(result)
    return result


def _randomized_prompt(prompt_json: dict, *, session_question_id: str) -> dict:
    prompt = sanitize_prompt(prompt_json)
    if isinstance(prompt.get("options"), list):
        prompt["options"] = _shuffle_list(prompt["options"], seed=f"{session_question_id}:options")
    return prompt


def serialize_session_questions(session: LearningSession) -> list[SessionQuestionResponse]:
    reveal_exam = session.mode == SessionMode.EXAM and session.status == SessionStatus.COMPLETED
    responses: list[SessionQuestionResponse] = []
    for session_question in sorted(session.session_questions, key=lambda item: item.order_number):
        revision: QuestionRevision = session_question.question_revision
        question = QuestionResponseLearner(
            id=session_question.question_id,
            material_id=revision.material_id,
            lesson_id=revision.lesson_id,
            question_type=revision.question_type,
            skill=revision.skill,
            difficulty=revision.difficulty,
            prompt_json=_randomized_prompt(revision.prompt_json, session_question_id=session_question.id),
        )
        reveal_result = session_question.is_answered and (session.mode == SessionMode.PRACTICE or reveal_exam)
        responses.append(
            SessionQuestionResponse(
                id=session_question.id,
                order_number=session_question.order_number,
                is_answered=session_question.is_answered,
                question=question,
                user_answer_json=session_question.user_answer_json if reveal_result else None,
                is_correct=session_question.is_correct if reveal_result else None,
                score=session_question.score if reveal_result else None,
                correct_answer_json=revision.answer_key_json if reveal_result else None,
                explanation_json=revision.explanation_json if reveal_result else None,
                feedback_notes=session_question.feedback_notes if reveal_result else None,
            )
        )
    return responses


def submit_answer(
    db: Session,
    *,
    session_id: str,
    user: User,
    payload: SubmitAnswerRequest,
    session_question_id: str | None = None,
    question_id: str | None = None,
) -> SubmitAnswerResponse:
    session = get_owned_session(
        db,
        session_id=session_id,
        user_id=user.id,
        lock=True,
        persist_expiry=False,
    )
    if session.status == SessionStatus.EXPIRED:
        db.commit()
        raise LearningServiceError("Quiz session has expired", status_code=409, code="SESSION_EXPIRED")
    if session.status != SessionStatus.ACTIVE:
        raise LearningServiceError("Answers are accepted only for ACTIVE sessions", status_code=409)
    target_id = session_question_id or payload.session_question_id
    query = db.query(LearningSessionQuestion).filter(LearningSessionQuestion.session_id == session.id)
    if target_id:
        query = query.filter(LearningSessionQuestion.id == target_id)
    elif question_id:
        query = query.filter(LearningSessionQuestion.question_id == question_id)
    else:
        raise LearningServiceError("session_question_id is required", status_code=422, code="MISSING_SESSION_QUESTION")
    session_question = query.with_for_update().first()
    if not session_question:
        raise LearningServiceError(
            "Question is not part of this session", status_code=404, code="QUESTION_NOT_IN_SESSION"
        )
    if session_question.is_answered:
        raise LearningServiceError("Question already answered", status_code=409, code="ANSWER_ALREADY_SUBMITTED")
    revision = session_question.question_revision
    try:
        is_correct, score, feedback = evaluate_answer(
            question_type=revision.question_type,
            answer_key=revision.answer_key_json,
            user_answer=payload.answer_json,
        )
    except ScoringError as exc:
        raise LearningServiceError(str(exc), status_code=422, code="INVALID_ANSWER") from exc
    session_question.user_answer_json = copy.deepcopy(payload.answer_json)
    session_question.is_answered = True
    session_question.is_correct = is_correct
    session_question.score = score
    session_question.response_time_ms = payload.response_time_ms
    explanation = _explanation_text(revision.explanation_json)
    session_question.feedback_notes = f"{feedback}. {explanation}" if explanation else feedback
    session.answered_questions += 1
    if is_correct:
        session.correct_answers += 1
    try:
        db.commit()
        db.refresh(session_question)
    except Exception:
        db.rollback()
        raise
    if session.mode == SessionMode.EXAM:
        return SubmitAnswerResponse(
            session_question_id=session_question.id,
            feedback_notes="Answer recorded. Results are available after completion.",
        )
    return SubmitAnswerResponse(
        session_question_id=session_question.id,
        is_correct=is_correct,
        score=score,
        correct_answer_json=revision.answer_key_json,
        explanation_json=revision.explanation_json,
        feedback_notes=session_question.feedback_notes,
    )


def complete_session(db: Session, *, session_id: str, user: User) -> LearningSession:
    from app.services.progress import record_session_completion

    session = get_owned_session(
        db,
        session_id=session_id,
        user_id=user.id,
        lock=True,
        persist_expiry=False,
    )
    if session.status == SessionStatus.COMPLETED:
        if session.progress_processed_at is None:
            record_session_completion(db, session=session, user=user)
            db.commit()
            db.refresh(session)
        return session
    if session.status == SessionStatus.EXPIRED:
        db.commit()
        raise LearningServiceError("Quiz session has expired", status_code=409, code="SESSION_EXPIRED")
    if session.status != SessionStatus.ACTIVE:
        raise LearningServiceError("Only ACTIVE sessions can be completed", status_code=409)
    if session.answered_questions != session.total_questions:
        raise LearningServiceError(
            "All session questions must be answered before completion",
            status_code=409,
            code="SESSION_INCOMPLETE",
        )
    session.final_score = (
        round((session.correct_answers / session.total_questions) * 100) if session.total_questions else 0
    )
    session.status = SessionStatus.COMPLETED
    session.completed_at = datetime.now(timezone.utc)
    try:
        record_session_completion(db, session=session, user=user)
        db.commit()
        db.refresh(session)
        return session
    except Exception:
        db.rollback()
        raise
