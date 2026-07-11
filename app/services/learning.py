"""Atomic learning-session selection, delivery, answering, and completion."""

from __future__ import annotations

import copy
import hashlib
import random
from datetime import datetime, timedelta, timezone
from typing import Iterable

from sqlalchemy.orm import Session

from app.models.curriculum import Course, Lesson, Level, Unit
from app.models.learning import (
    LearningSession,
    LearningSessionQuestion,
    SessionMode,
    SessionSource,
    SessionStatus,
)
from app.models.question import Question, QuestionRevision, QuestionStatus, SkillType
from app.models.user import User
from app.schemas.learning import (
    LearningSessionCreate,
    SessionQuestionResponse,
    SubmitAnswerRequest,
    SubmitAnswerResponse,
)
from app.schemas.question import QuestionResponseLearner
from app.services.question_workflow import snapshot_question
from app.services.scoring import ScoringError, evaluate_answer

PRACTICE_TTL = timedelta(hours=24)
EXAM_TTL = timedelta(hours=2)
MAX_SELECTION_POOL = 500


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
        # A single 404 response prevents leaking whether another user's UUID exists.
        raise LearningServiceError("Learning session not found", status_code=404, code="SESSION_NOT_FOUND")
    expired = _expire_if_needed(session)
    if expired and persist_expiry:
        db.commit()
        db.refresh(session)
    return session


def _published_lesson(db: Session, lesson_id: str) -> Lesson:
    lesson = (
        db.query(Lesson)
        .join(Unit, Lesson.unit_id == Unit.id)
        .join(Course, Unit.course_id == Course.id)
        .join(Level, Course.level_id == Level.id)
        .filter(
            Lesson.id == lesson_id,
            Lesson.is_published.is_(True),
            Unit.is_published.is_(True),
            Course.is_published.is_(True),
            Level.is_published.is_(True),
        )
        .first()
    )
    if not lesson:
        raise LearningServiceError("Published lesson not found", status_code=404, code="LESSON_NOT_FOUND")
    return lesson


def _recent_question_ids(db: Session, user_id: str, *, limit: int = 100) -> set[str]:
    rows = (
        db.query(LearningSessionQuestion.question_id)
        .join(LearningSession, LearningSessionQuestion.session_id == LearningSession.id)
        .filter(LearningSession.user_id == user_id)
        .order_by(LearningSessionQuestion.created_at.desc())
        .limit(limit)
        .all()
    )
    return {row[0] for row in rows}


def _select_lesson_questions(
    db: Session,
    *,
    user_id: str,
    lesson_id: str,
    count: int,
    skill: SkillType | None,
    difficulty: int | None,
) -> list[Question]:
    query = db.query(Question).filter(
        Question.lesson_id == lesson_id,
        Question.status == QuestionStatus.PUBLISHED,
    )
    if skill:
        query = query.filter(Question.skill == skill)
    if difficulty is not None:
        query = query.filter(Question.difficulty == difficulty)
    candidates = query.order_by(Question.updated_at.asc(), Question.id.asc()).limit(MAX_SELECTION_POOL).all()
    if not candidates:
        raise LearningServiceError(
            "No published questions match this session request",
            status_code=409,
            code="NO_PUBLISHED_QUESTIONS",
        )
    recent = _recent_question_ids(db, user_id)
    unseen = [question for question in candidates if question.id not in recent]
    seen = [question for question in candidates if question.id in recent]
    rng = random.SystemRandom()
    rng.shuffle(unseen)
    rng.shuffle(seen)
    return (unseen + seen)[:count]


def _assert_no_duplicate_active_session(
    db: Session,
    *,
    user_id: str,
    source: SessionSource,
    lesson_id: str | None,
) -> None:
    query = db.query(LearningSession).filter(
        LearningSession.user_id == user_id,
        LearningSession.source == source,
        LearningSession.status == SessionStatus.ACTIVE,
    )
    if lesson_id is None:
        query = query.filter(LearningSession.lesson_id.is_(None))
    else:
        query = query.filter(LearningSession.lesson_id == lesson_id)
    for existing in query.with_for_update().all():
        if _expire_if_needed(existing):
            continue
        raise LearningServiceError(
            "An active session already exists for this source",
            status_code=409,
            code="ACTIVE_SESSION_EXISTS",
        )


def _create_session(
    db: Session,
    *,
    user: User,
    questions: Iterable[Question],
    lesson_id: str | None,
    mode: SessionMode,
    source: SessionSource,
) -> LearningSession:
    selected = list(dict.fromkeys(questions))
    if not selected:
        raise LearningServiceError("No eligible questions are available", status_code=409, code="NO_QUESTIONS")
    now = datetime.now(timezone.utc)
    ttl = EXAM_TTL if mode == SessionMode.EXAM else PRACTICE_TTL
    session = LearningSession(
        user_id=user.id,
        lesson_id=lesson_id,
        mode=mode,
        source=source,
        status=SessionStatus.ACTIVE,
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
        revision = snapshot_question(db, question, actor_id=question.reviewed_by or question.created_by)
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


def start_lesson_session(db: Session, payload: LearningSessionCreate, user: User) -> LearningSession:
    _published_lesson(db, payload.lesson_id)
    try:
        _assert_no_duplicate_active_session(
            db,
            user_id=user.id,
            source=SessionSource.LESSON,
            lesson_id=payload.lesson_id,
        )
        questions = _select_lesson_questions(
            db,
            user_id=user.id,
            lesson_id=payload.lesson_id,
            count=payload.question_count,
            skill=payload.skill,
            difficulty=payload.difficulty,
        )
        return _create_session(
            db,
            user=user,
            questions=questions,
            lesson_id=payload.lesson_id,
            mode=payload.mode,
            source=SessionSource.LESSON,
        )
    except Exception:
        db.rollback()
        raise


def start_targeted_session(
    db: Session,
    *,
    user: User,
    question_ids: list[str],
    source: SessionSource,
    limit: int = 10,
) -> LearningSession:
    if source not in {SessionSource.REVIEW, SessionSource.MISTAKE}:
        raise LearningServiceError("Invalid targeted session source", code="INVALID_SESSION_SOURCE")
    unique_ids = list(dict.fromkeys(question_ids))[:limit]
    if not unique_ids:
        raise LearningServiceError("No eligible questions are available", status_code=409, code="NO_QUESTIONS")
    questions = db.query(Question).filter(
        Question.id.in_(unique_ids),
        Question.status == QuestionStatus.PUBLISHED,
    ).all()
    by_id = {question.id: question for question in questions}
    ordered = [by_id[question_id] for question_id in unique_ids if question_id in by_id]
    if not ordered:
        raise LearningServiceError(
            "No eligible published questions are available", status_code=409, code="NO_QUESTIONS"
        )
    try:
        _assert_no_duplicate_active_session(db, user_id=user.id, source=source, lesson_id=None)
        return _create_session(
            db,
            user=user,
            questions=ordered,
            lesson_id=None,
            mode=SessionMode.PRACTICE,
            source=source,
        )
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
    """Return a defensive learner-safe copy of a stored prompt."""

    return _strip_prompt_secrets(copy.deepcopy(prompt_json))


def _shuffle_list(items: list, *, seed: str) -> list:
    result = list(items)
    digest = hashlib.sha256(seed.encode("utf-8")).digest()
    random.Random(int.from_bytes(digest[:8], "big")).shuffle(result)
    return result


def _randomized_prompt(prompt_json: dict, *, session_question_id: str) -> dict:
    prompt = sanitize_prompt(prompt_json)
    for field in ("options", "left_items", "right_items", "pairs_left", "pairs_right", "items"):
        if isinstance(prompt.get(field), list):
            prompt[field] = _shuffle_list(prompt[field], seed=f"{session_question_id}:{field}")
    if isinstance(prompt.get("blanks"), list):
        for blank in prompt["blanks"]:
            if isinstance(blank, dict) and isinstance(blank.get("options"), list):
                blank["options"] = _shuffle_list(
                    blank["options"], seed=f"{session_question_id}:blank:{blank.get('id', '')}"
                )
    return prompt


def serialize_session_questions(session: LearningSession) -> list[SessionQuestionResponse]:
    reveal_exam = session.mode == SessionMode.EXAM and session.status == SessionStatus.COMPLETED
    responses: list[SessionQuestionResponse] = []
    for session_question in sorted(session.session_questions, key=lambda item: item.order_number):
        revision: QuestionRevision = session_question.question_revision
        question = QuestionResponseLearner(
            id=session_question.question_id,
            lesson_id=revision.lesson_id,
            reading_id=revision.reading_id,
            audio_asset_id=revision.audio_asset_id,
            question_type=revision.question_type,
            skill=revision.skill,
            difficulty=revision.difficulty,
            prompt_json=_randomized_prompt(revision.prompt_json, session_question_id=session_question.id),
        )
        reveal_result = session_question.is_answered and (
            session.mode == SessionMode.PRACTICE or reveal_exam
        )
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
        raise LearningServiceError("Learning session has expired", status_code=409, code="SESSION_EXPIRED")
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
    session_question.feedback_notes = feedback
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
        feedback_notes=feedback,
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
        raise LearningServiceError("Learning session has expired", status_code=409, code="SESSION_EXPIRED")
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


def cancel_session(db: Session, *, session_id: str, user: User) -> LearningSession:
    session = get_owned_session(
        db,
        session_id=session_id,
        user_id=user.id,
        lock=True,
        persist_expiry=False,
    )
    if session.status in {SessionStatus.CANCELLED, SessionStatus.EXPIRED}:
        if session.status == SessionStatus.EXPIRED:
            db.commit()
        return session
    if session.status == SessionStatus.COMPLETED:
        raise LearningServiceError("A completed session cannot be cancelled", status_code=409)
    session.status = SessionStatus.CANCELLED
    session.completed_at = datetime.now(timezone.utc)
    db.commit()
    db.refresh(session)
    return session
