"""Frontend-facing material-first API facade."""

from __future__ import annotations

from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, Query, status
from fastapi.responses import FileResponse
from pydantic import BaseModel, ConfigDict, Field
from sqlalchemy import func
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.core.config import settings
from app.db.session import get_db
from app.models.ai_jobs import GenerationJob, JobType
from app.models.learning import LearningSession, SessionMode, SessionStatus
from app.models.material import MaterialDocument
from app.models.progress import MaterialProgressStatus, UserMaterialProgress, XPTransaction
from app.models.user import User
from app.schemas.learning import SessionQuestionResponse, SubmitAnswerRequest
from app.schemas.user import UserResponse
from app.services import learning as learning_service
from app.services.material_quiz import generate_questions_for_material, normalize_difficulty
from app.services.pdf_material import PdfMaterialError, material_storage_path
from app.services.progress import dashboard_overview

router = APIRouter()


class AppMaterialSummary(BaseModel):
    id: str
    title: str
    description: str | None = None
    level: str
    category: str | None = None
    sequence: int
    passing_score: int
    page_count: int
    file_url: str
    status: str
    is_locked: bool
    best_score: int
    last_score: int
    attempts_count: int
    extracted_text_preview: str | None = None


class AppMaterialDetail(AppMaterialSummary):
    original_filename: str
    extracted_text_char_count: int
    created_at: datetime
    updated_at: datetime


class GenerateQuizRequest(BaseModel):
    difficulty: str | int = Field(default="medium")
    question_count: int = Field(default=10, ge=1, le=30)

    model_config = ConfigDict(extra="forbid")


class GenerateQuizResponse(BaseModel):
    session_id: str
    material_id: str
    status: str
    difficulty: int
    passing_score: int
    total_questions: int
    ai_generation_id: str


class QuizSessionStatusResponse(BaseModel):
    id: str
    material_id: str | None
    status: str
    is_ready: bool
    answered_questions: int
    total_questions: int
    final_score: int
    passing_score: int
    is_passed: bool
    earned_exp: int


class SubmitQuizAnswerItem(BaseModel):
    session_question_id: str = Field(min_length=1, max_length=36)
    answer_json: dict[str, Any]
    response_time_ms: int = Field(default=0, ge=0, le=86_400_000)


class SubmitQuizRequest(BaseModel):
    answers: list[SubmitQuizAnswerItem] = Field(min_length=1)

    model_config = ConfigDict(extra="forbid")


class QuizResultResponse(BaseModel):
    session_id: str
    material_id: str | None
    score: int
    passing_score: int
    is_passed: bool
    earned_exp: int
    correct_answers: int
    total_questions: int
    completed_at: datetime | None
    message: str


class LeaderboardEntry(BaseModel):
    rank: int
    user_id: str
    name: str | None = None
    total_xp: int


class AttemptHistoryItem(BaseModel):
    id: str
    material_id: str | None = None
    material_title: str | None = None
    status: str
    difficulty: int
    total_questions: int
    answered_questions: int
    correct_answers: int
    final_score: int
    passing_score: int
    is_passed: bool
    earned_exp: int
    started_at: datetime
    completed_at: datetime | None = None


class AppDashboardResponse(BaseModel):
    total_xp: int
    current_streak: int
    longest_streak: int
    materials_completed: int
    answered_questions: int
    correct_answers: int
    accuracy_percentage: int
    material_progress_percentage: int
    leaderboard_rank: int | None = None
    ai_generations_remaining_today: int


def _raise_learning_error(exc: learning_service.LearningServiceError) -> None:
    raise HTTPException(
        status_code=exc.status_code,
        detail={"code": exc.code, "message": exc.message},
    ) from exc


def _progress_map(db: Session, user_id: str) -> dict[str, UserMaterialProgress]:
    rows = db.query(UserMaterialProgress).filter(UserMaterialProgress.user_id == user_id).all()
    return {row.material_id: row for row in rows}


def _published_materials_query(db: Session):
    return db.query(MaterialDocument).filter(
        MaterialDocument.is_published.is_(True),
        MaterialDocument.is_archived.is_(False),
    )


def _published_materials(db: Session) -> list[MaterialDocument]:
    return (
        _published_materials_query(db)
        .order_by(MaterialDocument.sequence.asc(), MaterialDocument.created_at.asc(), MaterialDocument.id.asc())
        .all()
    )


def _unlocked_material_ids(db: Session, user_id: str) -> set[str]:
    unlocked: set[str] = set()
    progress_by_material = _progress_map(db, user_id)
    previous_completed = True
    for material in _published_materials(db):
        progress = progress_by_material.get(material.id)
        is_completed = bool(progress and progress.status == MaterialProgressStatus.COMPLETED)
        if previous_completed or is_completed:
            unlocked.add(material.id)
        previous_completed = is_completed
    return unlocked


def _material_state(material: MaterialDocument, *, is_unlocked: bool, progress: UserMaterialProgress | None) -> str:
    if progress and progress.status == MaterialProgressStatus.COMPLETED:
        return "completed"
    return "unlocked" if is_unlocked else "locked"


def _material_summary(
    material: MaterialDocument,
    *,
    is_unlocked: bool,
    progress: UserMaterialProgress | None,
    include_preview: bool = False,
) -> AppMaterialSummary:
    state = _material_state(material, is_unlocked=is_unlocked, progress=progress)
    return AppMaterialSummary(
        id=material.id,
        title=material.title,
        description=material.description,
        level=material.level,
        category=material.category,
        sequence=material.sequence,
        passing_score=material.passing_score,
        page_count=material.page_count,
        file_url=f"/api/v1/app/materials/{material.id}/file",
        status=state,
        is_locked=state == "locked",
        best_score=progress.best_score if progress else 0,
        last_score=progress.last_score if progress else 0,
        attempts_count=progress.attempts_count if progress else 0,
        extracted_text_preview=material.extracted_text[:500] if include_preview else None,
    )


def _material_detail(
    material: MaterialDocument,
    *,
    is_unlocked: bool,
    progress: UserMaterialProgress | None,
) -> AppMaterialDetail:
    summary = _material_summary(material, is_unlocked=is_unlocked, progress=progress, include_preview=True)
    return AppMaterialDetail(
        **summary.model_dump(),
        original_filename=material.original_filename,
        extracted_text_char_count=len(material.extracted_text or ""),
        created_at=material.created_at,
        updated_at=material.updated_at,
    )


def _get_visible_material(db: Session, material_id: str) -> MaterialDocument:
    material = (
        _published_materials_query(db)
        .filter(MaterialDocument.id == material_id)
        .first()
    )
    if material is None:
        raise HTTPException(status_code=404, detail="Material not found")
    return material


def _ensure_material_unlocked(db: Session, material: MaterialDocument, user: User) -> None:
    if material.id not in _unlocked_material_ids(db, user.id):
        raise HTTPException(status_code=423, detail="Material is locked. Complete the previous material first.")


def _generation_window_start(now: datetime | None = None) -> datetime:
    now = now or datetime.now(timezone.utc)
    return now.replace(hour=0, minute=0, second=0, microsecond=0)


def _daily_generation_count(db: Session, user_id: str) -> int:
    return (
        db.query(GenerationJob)
        .filter(
            GenerationJob.created_by == user_id,
            GenerationJob.job_type == JobType.QUESTION_GENERATION,
            GenerationJob.created_at >= _generation_window_start(),
        )
        .count()
    )


def _ai_generations_remaining_today(db: Session, user_id: str) -> int:
    return max(settings.AI_DAILY_GENERATION_LIMIT - _daily_generation_count(db, user_id), 0)


def _ensure_generation_quota(db: Session, user_id: str) -> None:
    if _ai_generations_remaining_today(db, user_id) <= 0:
        raise HTTPException(status_code=429, detail="Batas generate soal harian tercapai. Coba lagi besok.")


def _material_progress_percentage(db: Session, user_id: str) -> int:
    total = _published_materials_query(db).count()
    if not total:
        return 0
    completed = (
        db.query(UserMaterialProgress)
        .join(MaterialDocument, UserMaterialProgress.material_id == MaterialDocument.id)
        .filter(
            UserMaterialProgress.user_id == user_id,
            UserMaterialProgress.status == MaterialProgressStatus.COMPLETED,
            MaterialDocument.is_published.is_(True),
            MaterialDocument.is_archived.is_(False),
        )
        .count()
    )
    return round((completed / total) * 100)


def _leaderboard_rank(db: Session, user_id: str) -> int | None:
    rows = (
        db.query(User.id, func.coalesce(func.sum(XPTransaction.amount), 0).label("total_xp"))
        .join(XPTransaction, XPTransaction.user_id == User.id)
        .filter(User.is_active.is_(True))
        .group_by(User.id)
        .order_by(func.coalesce(func.sum(XPTransaction.amount), 0).desc(), User.created_at.asc())
        .all()
    )
    for index, row in enumerate(rows, start=1):
        if row.id == user_id:
            return index
    return None


def _quiz_status(session: LearningSession) -> QuizSessionStatusResponse:
    return QuizSessionStatusResponse(
        id=session.id,
        material_id=session.material_id,
        status=session.status.value,
        is_ready=session.status in {SessionStatus.ACTIVE, SessionStatus.COMPLETED},
        answered_questions=session.answered_questions,
        total_questions=session.total_questions,
        final_score=session.final_score,
        passing_score=session.passing_score,
        is_passed=session.is_passed,
        earned_exp=session.earned_exp,
    )


def _quiz_result(session: LearningSession) -> QuizResultResponse:
    is_completed = session.status == SessionStatus.COMPLETED
    passed = bool(session.is_passed and is_completed)
    return QuizResultResponse(
        session_id=session.id,
        material_id=session.material_id,
        score=session.final_score if is_completed else 0,
        passing_score=session.passing_score,
        is_passed=passed,
        earned_exp=session.earned_exp if is_completed else 0,
        correct_answers=session.correct_answers if is_completed else 0,
        total_questions=session.total_questions,
        completed_at=session.completed_at,
        message=(
            "Selamat, materi berikutnya sudah terbuka."
            if passed
            else "Nilai belum cukup. Kamu harus mengulang materi ini untuk membuka materi berikutnya."
        ),
    )


@router.get("/me", response_model=UserResponse, summary="Get the signed-in user")
def get_me(current_user: User = Depends(get_current_user)):
    return current_user


@router.get("/dashboard", response_model=AppDashboardResponse, summary="Get learner dashboard")
def get_dashboard(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    overview = dashboard_overview(db, user=current_user)
    return AppDashboardResponse(
        total_xp=overview["total_xp"],
        current_streak=overview["current_streak"],
        longest_streak=overview["longest_streak"],
        materials_completed=overview["materials_completed"],
        answered_questions=overview["answered_questions"],
        correct_answers=overview["correct_answers"],
        accuracy_percentage=overview["accuracy_percentage"],
        material_progress_percentage=_material_progress_percentage(db, current_user.id),
        leaderboard_rank=_leaderboard_rank(db, current_user.id),
        ai_generations_remaining_today=_ai_generations_remaining_today(db, current_user.id),
    )


@router.get("/materials", response_model=list[AppMaterialSummary], summary="Get published materials")
def list_materials(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    progress_by_material = _progress_map(db, current_user.id)
    unlocked_ids = _unlocked_material_ids(db, current_user.id)
    return [
        _material_summary(
            material,
            is_unlocked=material.id in unlocked_ids,
            progress=progress_by_material.get(material.id),
        )
        for material in _published_materials(db)
    ]


@router.get("/materials/{material_id}", response_model=AppMaterialDetail, summary="Get one material")
def get_material(material_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    material = _get_visible_material(db, material_id)
    _ensure_material_unlocked(db, material, current_user)
    return _material_detail(
        material,
        is_unlocked=True,
        progress=_progress_map(db, current_user.id).get(material.id),
    )


@router.get(
    "/materials/{material_id}/file",
    response_class=FileResponse,
    summary="Stream an admin-uploaded PDF",
)
def get_material_file(material_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    material = _get_visible_material(db, material_id)
    _ensure_material_unlocked(db, material, current_user)
    if not material.storage_key:
        raise HTTPException(status_code=404, detail="PDF file is not available")
    try:
        path = material_storage_path(material.storage_key)
    except PdfMaterialError as exc:
        raise HTTPException(status_code=404, detail="PDF file is not available") from exc
    if not path.exists() or not path.is_file():
        raise HTTPException(status_code=404, detail="PDF file is not available")
    return FileResponse(Path(path), media_type="application/pdf", filename=material.original_filename)


@router.post(
    "/materials/{material_id}/generate-quiz",
    response_model=GenerateQuizResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Generate a quiz from a PDF material",
)
def generate_material_quiz(
    material_id: str,
    payload: GenerateQuizRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    material = _get_visible_material(db, material_id)
    _ensure_material_unlocked(db, material, current_user)
    _ensure_generation_quota(db, current_user.id)
    try:
        difficulty = normalize_difficulty(payload.difficulty)
        job, questions = generate_questions_for_material(
            db,
            user=current_user,
            material=material,
            count=payload.question_count,
            difficulty=difficulty,
        )
        session = learning_service.start_material_session(
            db,
            user=current_user,
            material=material,
            questions=questions,
            difficulty=difficulty,
            mode=SessionMode.PRACTICE,
        )
    except ValueError as exc:
        db.rollback()
        raise HTTPException(status_code=422, detail=str(exc)) from exc
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)
    except Exception as exc:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to generate quiz: {exc}") from exc
    return GenerateQuizResponse(
        session_id=session.id,
        material_id=material.id,
        status=session.status.value,
        difficulty=session.difficulty,
        passing_score=session.passing_score,
        total_questions=session.total_questions,
        ai_generation_id=job.id,
    )


@router.get(
    "/quiz-sessions/{session_id}/status",
    response_model=QuizSessionStatusResponse,
    summary="Get quiz session status",
)
def get_quiz_session_status(
    session_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        return _quiz_status(learning_service.get_owned_session(db, session_id=session_id, user_id=current_user.id))
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.get(
    "/quiz-sessions/{session_id}/questions",
    response_model=list[SessionQuestionResponse],
    response_model_exclude_none=True,
    summary="Get learner-safe quiz questions",
)
def get_quiz_session_questions(
    session_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        session = learning_service.get_owned_session(db, session_id=session_id, user_id=current_user.id)
        return learning_service.serialize_session_questions(session)
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.post(
    "/quiz-sessions/{session_id}/submit",
    response_model=QuizResultResponse,
    summary="Submit quiz answers and calculate result",
)
def submit_quiz_session(
    session_id: str,
    payload: SubmitQuizRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        for item in payload.answers:
            learning_service.submit_answer(
                db,
                session_id=session_id,
                user=current_user,
                payload=SubmitAnswerRequest(
                    session_question_id=item.session_question_id,
                    answer_json=item.answer_json,
                    response_time_ms=item.response_time_ms,
                ),
            )
        session = learning_service.complete_session(db, session_id=session_id, user=current_user)
        return _quiz_result(session)
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.get(
    "/quiz-sessions/{session_id}/result",
    response_model=QuizResultResponse,
    summary="Get quiz result",
)
def get_quiz_session_result(
    session_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        session = learning_service.get_owned_session(db, session_id=session_id, user_id=current_user.id)
        return _quiz_result(session)
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.get("/attempts", response_model=list[AttemptHistoryItem], summary="Get learner attempt history")
def get_attempt_history(
    material_id: str | None = Query(default=None),
    limit: int = Query(default=20, ge=1, le=100),
    offset: int = Query(default=0, ge=0),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = (
        db.query(LearningSession, MaterialDocument.title.label("material_title"))
        .outerjoin(MaterialDocument, LearningSession.material_id == MaterialDocument.id)
        .filter(LearningSession.user_id == current_user.id)
    )
    if material_id:
        query = query.filter(LearningSession.material_id == material_id)
    rows = (
        query.order_by(LearningSession.started_at.desc(), LearningSession.id.desc())
        .offset(offset)
        .limit(limit)
        .all()
    )
    return [
        AttemptHistoryItem(
            id=session.id,
            material_id=session.material_id,
            material_title=material_title,
            status=session.status.value,
            difficulty=session.difficulty,
            total_questions=session.total_questions,
            answered_questions=session.answered_questions,
            correct_answers=session.correct_answers,
            final_score=session.final_score,
            passing_score=session.passing_score,
            is_passed=session.is_passed,
            earned_exp=session.earned_exp,
            started_at=session.started_at,
            completed_at=session.completed_at,
        )
        for session, material_title in rows
    ]


@router.get("/leaderboard", response_model=list[LeaderboardEntry], summary="Get XP leaderboard")
def get_leaderboard(
    limit: int = Query(default=20, ge=1, le=100),
    period: str = Query(default="all", pattern="^(all|weekly|monthly)$"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = (
        db.query(User.id, User.name, func.coalesce(func.sum(XPTransaction.amount), 0).label("total_xp"))
        .join(XPTransaction, XPTransaction.user_id == User.id)
        .filter(User.is_active.is_(True))
    )
    now = datetime.now(timezone.utc)
    if period == "weekly":
        query = query.filter(XPTransaction.created_at >= now - timedelta(days=7))
    elif period == "monthly":
        query = query.filter(XPTransaction.created_at >= now - timedelta(days=30))
    rows = (
        query.group_by(User.id, User.name)
        .order_by(func.coalesce(func.sum(XPTransaction.amount), 0).desc(), User.created_at.asc())
        .limit(limit)
        .all()
    )
    return [
        LeaderboardEntry(rank=index, user_id=row.id, name=row.name, total_xp=int(row.total_xp or 0))
        for index, row in enumerate(rows, start=1)
    ]
