"""Learner-owned learning-session endpoints."""

from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.db.session import get_db
from app.models.ai_jobs import GenerationJob, JobStatus, JobType
from app.models.user import User
from app.schemas.ai_jobs import GenerationJobResponse
from app.schemas.learning import (
    AdaptiveEvaluationCreate,
    LearningSessionCreate,
    LearningSessionResponse,
    SessionQuestionResponse,
    SubmitAnswerRequest,
    SubmitAnswerResponse,
)
from app.services import learning as learning_service
from app.tasks.ai_tasks import generate_adaptive_evaluation_task

router = APIRouter()


def _raise_learning_error(exc: learning_service.LearningServiceError) -> None:
    raise HTTPException(
        status_code=exc.status_code,
        detail={"code": exc.code, "message": exc.message},
    ) from exc


def _start(payload: LearningSessionCreate, db: Session, current_user: User):
    try:
        return learning_service.start_lesson_session(db, payload, current_user)
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.post(
    "",
    response_model=LearningSessionResponse,
    status_code=status.HTTP_201_CREATED,
    operation_id="createLearningSession",
    summary="Start a lesson practice or exam session",
)
def create_learning_session(
    payload: LearningSessionCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return _start(payload, db, current_user)


@router.post(
    "/start",
    response_model=LearningSessionResponse,
    include_in_schema=False,
)
def start_learning_session_compatibility(
    payload: LearningSessionCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Compatibility alias for pre-contract clients; use POST /learning-sessions."""

    return _start(payload, db, current_user)


@router.post(
    "/adaptive",
    response_model=GenerationJobResponse,
    status_code=status.HTTP_202_ACCEPTED,
    operation_id="createAdaptiveEvaluation",
    summary="Trigger RAG-based personalized evaluation",
)
def create_adaptive_evaluation(
    payload: AdaptiveEvaluationCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    # Buat job baru untuk RAG
    job = GenerationJob(
        job_type=JobType.ADAPTIVE_EVALUATION_GENERATION,
        status=JobStatus.PENDING,
        prompt_json=payload.model_dump_json(),
        target_id=payload.lesson_id,  # Target is the lesson to evaluate
        created_by=current_user.id,
    )
    db.add(job)
    db.commit()
    db.refresh(job)

    # Dispatch Celery task
    generate_adaptive_evaluation_task.delay(job.id)

    return job


@router.get(
    "/{session_id}",
    response_model=LearningSessionResponse,
    operation_id="getLearningSession",
    summary="Get an owned learning session",
)
def get_learning_session(
    session_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        return learning_service.get_owned_session(
            db,
            session_id=session_id,
            user_id=current_user.id,
        )
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.get(
    "/{session_id}/questions",
    response_model=list[SessionQuestionResponse],
    response_model_exclude_none=True,
    operation_id="getLearningSessionQuestions",
    summary="Deliver randomized learner-safe session questions",
)
def get_learning_session_questions(
    session_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        session = learning_service.get_owned_session(
            db,
            session_id=session_id,
            user_id=current_user.id,
        )
        return learning_service.serialize_session_questions(session)
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.post(
    "/{session_id}/answers",
    response_model=SubmitAnswerResponse,
    response_model_exclude_none=True,
    operation_id="submitLearningSessionAnswer",
    summary="Submit one deterministic answer by session-question ID",
)
def submit_learning_session_answer(
    session_id: str,
    payload: SubmitAnswerRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        return learning_service.submit_answer(
            db,
            session_id=session_id,
            user=current_user,
            payload=payload,
        )
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.post(
    "/{session_id}/questions/{question_id}/submit-answer",
    response_model=SubmitAnswerResponse,
    response_model_exclude_none=True,
    include_in_schema=False,
)
def submit_learning_session_answer_compatibility(
    session_id: str,
    question_id: str,
    payload: SubmitAnswerRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Compatibility alias; canonical clients submit a session_question_id."""

    try:
        return learning_service.submit_answer(
            db,
            session_id=session_id,
            user=current_user,
            payload=payload,
            question_id=question_id,
        )
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.post(
    "/{session_id}/complete",
    response_model=LearningSessionResponse,
    operation_id="completeLearningSession",
    summary="Atomically complete a fully answered session",
)
def complete_learning_session(
    session_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        return learning_service.complete_session(db, session_id=session_id, user=current_user)
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.post(
    "/{session_id}/cancel",
    response_model=LearningSessionResponse,
    operation_id="cancelLearningSession",
    summary="Idempotently cancel an active session",
)
def cancel_learning_session(
    session_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        return learning_service.cancel_session(db, session_id=session_id, user=current_user)
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)
