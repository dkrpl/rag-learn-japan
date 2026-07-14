"""Small frontend-facing API facade.

The project still keeps richer admin/internal endpoints for back-office and
tests, but this router is the contract a course frontend should start from.
"""

from __future__ import annotations

import json
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, Query, status
from fastapi.responses import FileResponse
from pydantic import BaseModel, ConfigDict, Field
from sqlalchemy import func
from sqlalchemy.orm import Session, selectinload

from app.api.deps import get_current_user
from app.core.config import settings
from app.db.session import get_db
from app.models.ai_jobs import GenerationJob, JobStatus, JobType
from app.models.curriculum import Course, Lesson, Level, Unit
from app.models.learning import LearningSession, SessionMode
from app.models.material import MaterialDocument
from app.models.progress import LessonStatus, UserLessonProgress, XPTransaction
from app.models.question import QuestionStatus
from app.models.user import User
from app.schemas.ai_jobs import GenerationJobResponse
from app.schemas.curriculum import LessonContentResponse, LessonResponse
from app.schemas.learning import (
    LearningSessionResponse,
    SessionQuestionResponse,
    SubmitAnswerRequest,
    SubmitAnswerResponse,
)
from app.schemas.user import UserResponse
from app.services import learning as learning_service
from app.services.pdf_material import PdfMaterialError, material_storage_path
from app.services.progress import dashboard_overview
from app.tasks.ai_tasks import generate_questions_task

router = APIRouter()


class AppLessonSummary(BaseModel):
    id: str
    title: str
    summary: str | None = None
    estimated_minutes: int
    sequence: int
    status: str = "locked"
    is_locked: bool = True
    passing_score: int = 70
    best_score: int = 0
    last_score: int = 0
    attempts_count: int = 0

    model_config = ConfigDict(from_attributes=True)


class AppUnitSummary(BaseModel):
    id: str
    title: str
    sequence: int
    lessons: list[AppLessonSummary] = Field(default_factory=list)

    model_config = ConfigDict(from_attributes=True)


class AppCourseSummary(BaseModel):
    id: str
    title: str
    description: str | None = None
    image_url: str | None = None
    units: list[AppUnitSummary] = Field(default_factory=list)

    model_config = ConfigDict(from_attributes=True)


class AppCatalogResponse(BaseModel):
    courses: list[AppCourseSummary]


class AppMaterialSummary(BaseModel):
    id: str
    lesson_id: str
    title: str
    original_filename: str
    file_url: str
    page_count: int
    extracted_text_preview: str
    extracted_text_char_count: int
    is_published: bool


class MaterialAiQuestionJobCreate(BaseModel):
    question_count: int = Field(default=10, ge=1, le=30)
    difficulty: int = Field(default=1, ge=1, le=5)
    prompt: str | None = Field(default=None, max_length=4000)

    model_config = ConfigDict(extra="forbid")


class StartJobSessionRequest(BaseModel):
    mode: SessionMode = SessionMode.PRACTICE

    model_config = ConfigDict(extra="forbid")


class RegenerateJobRequest(BaseModel):
    prompt: str | None = Field(default=None, max_length=4000)

    model_config = ConfigDict(extra="forbid")


class LeaderboardEntry(BaseModel):
    rank: int
    user_id: str
    name: str | None = None
    total_xp: int


class AttemptHistoryItem(BaseModel):
    id: str
    lesson_id: str | None = None
    lesson_title: str | None = None
    status: str
    mode: str
    total_questions: int
    answered_questions: int
    correct_answers: int
    final_score: int
    xp_earned: int
    started_at: datetime
    completed_at: datetime | None = None


class LessonProgressDetail(BaseModel):
    lesson_id: str
    status: str
    attempts_count: int
    best_score: int
    last_score: int
    last_attempt_at: datetime | None = None
    is_completed: bool


class AppDashboardResponse(BaseModel):
    total_xp: int
    current_streak: int
    longest_streak: int
    lessons_completed: int
    answered_questions: int
    correct_answers: int
    accuracy_percentage: int
    course_progress_percentage: int
    leaderboard_rank: int | None = None
    ai_generations_remaining_today: int


def _raise_learning_error(exc: learning_service.LearningServiceError) -> None:
    raise HTTPException(
        status_code=exc.status_code,
        detail={"code": exc.code, "message": exc.message},
    ) from exc


def _is_visible(resource: Any) -> bool:
    return bool(resource.is_published and not resource.is_archived)


def _progress_map(db: Session, user_id: str) -> dict[str, UserLessonProgress]:
    rows = db.query(UserLessonProgress).filter(UserLessonProgress.user_id == user_id).all()
    return {row.lesson_id: row for row in rows}


def _lesson_state(lesson: Lesson, *, is_unlocked: bool, progress: UserLessonProgress | None) -> str:
    if progress and progress.status == LessonStatus.COMPLETED:
        return "completed"
    return "unlocked" if is_unlocked else "locked"


def _lesson_summary(
    lesson: Lesson,
    *,
    is_unlocked: bool,
    progress: UserLessonProgress | None,
) -> AppLessonSummary:
    state = _lesson_state(lesson, is_unlocked=is_unlocked, progress=progress)
    return AppLessonSummary(
        id=lesson.id,
        title=lesson.title,
        summary=lesson.summary,
        estimated_minutes=lesson.estimated_minutes,
        sequence=lesson.sequence,
        status=state,
        is_locked=state == "locked",
        passing_score=lesson.passing_score,
        best_score=progress.best_score if progress else 0,
        last_score=progress.last_score if progress else 0,
        attempts_count=progress.attempts_count if progress else 0,
    )


def _visible_course_lessons(course: Course) -> list[Lesson]:
    lessons: list[Lesson] = []
    visible_units = (item for item in course.units if _is_visible(item))
    for unit in sorted(visible_units, key=lambda item: (item.sequence, item.id)):
        visible_lessons = (item for item in unit.lessons if _is_visible(item))
        lessons.extend(sorted(visible_lessons, key=lambda item: (item.sequence, item.id)))
    return lessons


def _unlocked_lesson_ids(course: Course, progress_by_lesson: dict[str, UserLessonProgress]) -> set[str]:
    unlocked: set[str] = set()
    previous_completed = True
    for lesson in _visible_course_lessons(course):
        progress = progress_by_lesson.get(lesson.id)
        is_completed = bool(progress and progress.status == LessonStatus.COMPLETED)
        if previous_completed or is_completed:
            unlocked.add(lesson.id)
        previous_completed = is_completed
    return unlocked


def _course_progress_percentage(db: Session, user_id: str) -> int:
    visible_lessons = (
        db.query(Lesson.id)
        .join(Unit, Lesson.unit_id == Unit.id)
        .join(Course, Unit.course_id == Course.id)
        .join(Level, Course.level_id == Level.id)
        .filter(
            Lesson.is_published.is_(True),
            Lesson.is_archived.is_(False),
            Unit.is_published.is_(True),
            Unit.is_archived.is_(False),
            Course.is_published.is_(True),
            Course.is_archived.is_(False),
            Level.is_published.is_(True),
            Level.is_archived.is_(False),
        )
        .count()
    )
    if not visible_lessons:
        return 0
    completed = (
        db.query(UserLessonProgress)
        .join(Lesson, UserLessonProgress.lesson_id == Lesson.id)
        .join(Unit, Lesson.unit_id == Unit.id)
        .join(Course, Unit.course_id == Course.id)
        .join(Level, Course.level_id == Level.id)
        .filter(
            UserLessonProgress.user_id == user_id,
            UserLessonProgress.status == LessonStatus.COMPLETED,
            Lesson.is_published.is_(True),
            Lesson.is_archived.is_(False),
            Unit.is_published.is_(True),
            Unit.is_archived.is_(False),
            Course.is_published.is_(True),
            Course.is_archived.is_(False),
            Level.is_published.is_(True),
            Level.is_archived.is_(False),
        )
        .count()
    )
    return round((completed / visible_lessons) * 100)


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
    remaining = _ai_generations_remaining_today(db, user_id)
    if remaining <= 0:
        raise HTTPException(
            status_code=429,
            detail="Batas generate soal harian tercapai. Coba lagi besok.",
        )


def _lesson_content(lesson: Lesson) -> LessonContentResponse:
    sections = [section for section in lesson.sections if _is_visible(section)]
    return LessonContentResponse(lesson=LessonResponse.model_validate(lesson), sections=sections)


def _published_lessons_options():
    return (selectinload(Lesson.sections),)


def _get_published_lesson(db: Session, lesson_id: str) -> Lesson:
    lesson = (
        db.query(Lesson)
        .join(Unit, Lesson.unit_id == Unit.id)
        .join(Course, Unit.course_id == Course.id)
        .join(Level, Course.level_id == Level.id)
        .options(*_published_lessons_options())
        .filter(
            Lesson.id == lesson_id,
            Lesson.is_published.is_(True),
            Lesson.is_archived.is_(False),
            Unit.is_published.is_(True),
            Unit.is_archived.is_(False),
            Course.is_published.is_(True),
            Course.is_archived.is_(False),
            Level.is_published.is_(True),
            Level.is_archived.is_(False),
        )
        .first()
    )
    if lesson is None:
        raise HTTPException(status_code=404, detail="Published lesson not found")
    return lesson


def _ensure_lesson_unlocked(db: Session, lesson: Lesson, user: User) -> None:
    course = (
        db.query(Course)
        .join(Unit, Unit.course_id == Course.id)
        .options(selectinload(Course.units).selectinload(Unit.lessons))
        .filter(Unit.id == lesson.unit_id)
        .first()
    )
    if course is None:
        raise HTTPException(status_code=404, detail="Course not found")
    progress_by_lesson = _progress_map(db, user.id)
    if lesson.id not in _unlocked_lesson_ids(course, progress_by_lesson):
        raise HTTPException(status_code=423, detail="Lesson is locked")


def _can_dispatch_ai_worker() -> tuple[bool, str | None]:
    try:
        import redis

        client = redis.Redis.from_url(
            settings.REDIS_URL,
            socket_connect_timeout=0.25,
            socket_timeout=0.25,
        )
        client.ping()
        return True, None
    except Exception as exc:
        return False, f"AI worker broker is unavailable: {exc}"


def _material_summary(material: MaterialDocument) -> AppMaterialSummary:
    return AppMaterialSummary(
        id=material.id,
        lesson_id=material.lesson_id,
        title=material.title,
        original_filename=material.original_filename,
        file_url=f"/api/v1/app/materials/{material.id}/file",
        page_count=material.page_count,
        extracted_text_preview=material.extracted_text[:500],
        extracted_text_char_count=len(material.extracted_text or ""),
        is_published=material.is_published,
    )


def _get_visible_material(db: Session, material_id: str) -> MaterialDocument:
    material = (
        db.query(MaterialDocument)
        .join(Lesson, MaterialDocument.lesson_id == Lesson.id)
        .join(Unit, Lesson.unit_id == Unit.id)
        .join(Course, Unit.course_id == Course.id)
        .join(Level, Course.level_id == Level.id)
        .filter(
            MaterialDocument.id == material_id,
            MaterialDocument.is_published.is_(True),
            Lesson.is_published.is_(True),
            Lesson.is_archived.is_(False),
            Unit.is_published.is_(True),
            Unit.is_archived.is_(False),
            Course.is_published.is_(True),
            Course.is_archived.is_(False),
            Level.is_published.is_(True),
            Level.is_archived.is_(False),
        )
        .first()
    )
    if material is None:
        raise HTTPException(status_code=404, detail="Material not found")
    return material


def _question_ids_from_job(job: GenerationJob) -> list[str]:
    if not job.raw_response:
        return []
    try:
        payload = json.loads(job.raw_response)
    except json.JSONDecodeError:
        return []
    ids = payload.get("created_question_ids") if isinstance(payload, dict) else None
    return [str(question_id) for question_id in ids] if isinstance(ids, list) else []


def _dispatch_ai_job(job: GenerationJob, db: Session) -> GenerationJob:
    broker_ready, broker_error = _can_dispatch_ai_worker()
    if not broker_ready:
        job.status = JobStatus.FAILED
        job.error_message = broker_error
        db.commit()
        db.refresh(job)
        return job

    try:
        generate_questions_task.delay(job.id)
    except Exception as exc:
        job.status = JobStatus.FAILED
        job.error_message = f"AI worker dispatch failed: {exc}"
        db.commit()
        db.refresh(job)
    return job


def _create_question_generation_job(
    *,
    db: Session,
    user: User,
    lesson: Lesson,
    material: MaterialDocument,
    question_count: int,
    difficulty: int,
    prompt: str | None,
    regenerate_of_job_id: str | None = None,
) -> GenerationJob:
    _ensure_generation_quota(db, user.id)
    job_payload = {
        "lesson_id": material.lesson_id,
        "material_id": material.id,
        "material_title": material.title,
        "question_type": "MULTIPLE_CHOICE",
        "skill": "READING",
        "count": question_count,
        "difficulty": difficulty,
        "additional_notes": prompt,
        "source_material": material.extracted_text,
        "private_to_user": True,
    }
    if regenerate_of_job_id:
        job_payload["regenerate_of_job_id"] = regenerate_of_job_id
    job = GenerationJob(
        job_type=JobType.QUESTION_GENERATION,
        status=JobStatus.PENDING,
        prompt_json=json.dumps(job_payload, ensure_ascii=False, separators=(",", ":"), sort_keys=True),
        target_id=lesson.id,
        created_by=user.id,
    )
    db.add(job)
    db.commit()
    db.refresh(job)
    return _dispatch_ai_job(job, db)


@router.get("/me", response_model=UserResponse, summary="Get the signed-in user")
def get_me(current_user: User = Depends(get_current_user)):
    return current_user


@router.get("/catalog", response_model=AppCatalogResponse, summary="Get published course catalog")
def get_catalog(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    level = (
        db.query(Level)
        .options(
            selectinload(Level.courses).selectinload(Course.units).selectinload(Unit.lessons),
        )
        .filter(Level.is_published.is_(True), Level.is_archived.is_(False))
        .order_by(Level.sequence.asc(), Level.id.asc())
        .first()
    )
    if level is None:
        raise HTTPException(status_code=404, detail="Published catalog is empty")

    courses: list[AppCourseSummary] = []
    progress_by_lesson = _progress_map(db, current_user.id)
    visible_courses = (item for item in level.courses if _is_visible(item))
    for course in sorted(visible_courses, key=lambda item: (item.sequence, item.id)):
        units: list[AppUnitSummary] = []
        unlocked_ids = _unlocked_lesson_ids(course, progress_by_lesson)
        visible_units = (item for item in course.units if _is_visible(item))
        for unit in sorted(visible_units, key=lambda item: (item.sequence, item.id)):
            lessons = [
                _lesson_summary(
                    lesson,
                    is_unlocked=lesson.id in unlocked_ids,
                    progress=progress_by_lesson.get(lesson.id),
                )
                for lesson in sorted(
                    (item for item in unit.lessons if _is_visible(item)),
                    key=lambda item: (item.sequence, item.id),
                )
            ]
            units.append(AppUnitSummary(id=unit.id, title=unit.title, sequence=unit.sequence, lessons=lessons))
        courses.append(
            AppCourseSummary(
                id=course.id,
                title=course.title,
                description=course.description,
                image_url=course.image_url,
                units=units,
            )
        )
    return AppCatalogResponse(courses=courses)


@router.get("/lessons/{lesson_id}", response_model=LessonContentResponse, summary="Get one lesson with content")
def get_lesson(lesson_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    lesson = _get_published_lesson(db, lesson_id)
    _ensure_lesson_unlocked(db, lesson, current_user)
    return _lesson_content(lesson)


@router.get(
    "/lessons/{lesson_id}/materials",
    response_model=list[AppMaterialSummary],
    summary="Get PDFs uploaded by admin for a lesson",
)
def get_lesson_materials(lesson_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    lesson = _get_published_lesson(db, lesson_id)
    _ensure_lesson_unlocked(db, lesson, current_user)
    materials = (
        db.query(MaterialDocument)
        .filter(MaterialDocument.lesson_id == lesson_id, MaterialDocument.is_published.is_(True))
        .order_by(MaterialDocument.created_at.desc(), MaterialDocument.id)
        .all()
    )
    return [_material_summary(material) for material in materials]


@router.get(
    "/materials/{material_id}/file",
    response_class=FileResponse,
    summary="Stream an admin-uploaded PDF for the lesson viewer",
)
def get_material_file(material_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    material = _get_visible_material(db, material_id)
    lesson = _get_published_lesson(db, material.lesson_id)
    _ensure_lesson_unlocked(db, lesson, current_user)
    if not material.storage_key:
        raise HTTPException(status_code=404, detail="PDF file is not available")
    try:
        path = material_storage_path(material.storage_key)
    except PdfMaterialError as exc:
        raise HTTPException(status_code=404, detail="PDF file is not available") from exc
    if not path.exists() or not path.is_file():
        raise HTTPException(status_code=404, detail="PDF file is not available")
    return FileResponse(
        Path(path),
        media_type="application/pdf",
        filename=material.original_filename,
    )


@router.get(
    "/sessions/{session_id}",
    response_model=LearningSessionResponse,
    summary="Get an owned practice session",
)
def get_session(session_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    try:
        return learning_service.get_owned_session(db, session_id=session_id, user_id=current_user.id)
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.get(
    "/sessions/{session_id}/questions",
    response_model=list[SessionQuestionResponse],
    response_model_exclude_none=True,
    summary="Get learner-safe session questions",
)
def get_session_questions(
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
    "/sessions/{session_id}/answers",
    response_model=SubmitAnswerResponse,
    response_model_exclude_none=True,
    summary="Submit an answer",
)
def submit_session_answer(
    session_id: str,
    payload: SubmitAnswerRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    try:
        return learning_service.submit_answer(db, session_id=session_id, user=current_user, payload=payload)
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.post(
    "/sessions/{session_id}/complete",
    response_model=LearningSessionResponse,
    summary="Complete a fully answered session",
)
def complete_session(session_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    try:
        return learning_service.complete_session(db, session_id=session_id, user=current_user)
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.get("/dashboard", response_model=AppDashboardResponse, summary="Get learner MVP dashboard")
def get_dashboard(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    overview = dashboard_overview(db, user=current_user)
    return AppDashboardResponse(
        total_xp=overview["total_xp"],
        current_streak=overview["current_streak"],
        longest_streak=overview["longest_streak"],
        lessons_completed=overview["lessons_completed"],
        answered_questions=overview["answered_questions"],
        correct_answers=overview["correct_answers"],
        accuracy_percentage=overview["accuracy_percentage"],
        course_progress_percentage=_course_progress_percentage(db, current_user.id),
        leaderboard_rank=_leaderboard_rank(db, current_user.id),
        ai_generations_remaining_today=_ai_generations_remaining_today(db, current_user.id),
    )


@router.get("/attempts", response_model=list[AttemptHistoryItem], summary="Get learner attempt history")
def get_attempt_history(
    lesson_id: str | None = Query(default=None),
    limit: int = Query(default=20, ge=1, le=100),
    offset: int = Query(default=0, ge=0),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    query = (
        db.query(
            LearningSession,
            Lesson.title.label("lesson_title"),
            func.coalesce(XPTransaction.amount, 0).label("xp_earned"),
        )
        .outerjoin(Lesson, LearningSession.lesson_id == Lesson.id)
        .outerjoin(XPTransaction, XPTransaction.session_id == LearningSession.id)
        .filter(LearningSession.user_id == current_user.id)
    )
    if lesson_id:
        query = query.filter(LearningSession.lesson_id == lesson_id)
    rows = (
        query.order_by(LearningSession.started_at.desc(), LearningSession.id.desc())
        .offset(offset)
        .limit(limit)
        .all()
    )
    return [
        AttemptHistoryItem(
            id=session.id,
            lesson_id=session.lesson_id,
            lesson_title=lesson_title,
            status=session.status.value,
            mode=session.mode.value,
            total_questions=session.total_questions,
            answered_questions=session.answered_questions,
            correct_answers=session.correct_answers,
            final_score=session.final_score,
            xp_earned=int(xp_earned or 0),
            started_at=session.started_at,
            completed_at=session.completed_at,
        )
        for session, lesson_title, xp_earned in rows
    ]


@router.get(
    "/lessons/{lesson_id}/progress",
    response_model=LessonProgressDetail,
    summary="Get detailed progress for one lesson",
)
def get_lesson_progress(
    lesson_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    lesson = _get_published_lesson(db, lesson_id)
    _ensure_lesson_unlocked(db, lesson, current_user)
    progress = (
        db.query(UserLessonProgress)
        .filter(UserLessonProgress.user_id == current_user.id, UserLessonProgress.lesson_id == lesson_id)
        .first()
    )
    last_attempt_at = (
        db.query(func.max(LearningSession.completed_at))
        .filter(
            LearningSession.user_id == current_user.id,
            LearningSession.lesson_id == lesson_id,
            LearningSession.completed_at.is_not(None),
        )
        .scalar()
    )
    if progress is None:
        return LessonProgressDetail(
            lesson_id=lesson_id,
            status=LessonStatus.NOT_STARTED.value,
            attempts_count=0,
            best_score=0,
            last_score=0,
            last_attempt_at=last_attempt_at,
            is_completed=False,
        )
    return LessonProgressDetail(
        lesson_id=lesson_id,
        status=progress.status.value,
        attempts_count=progress.attempts_count,
        best_score=progress.best_score,
        last_score=progress.last_score,
        last_attempt_at=last_attempt_at,
        is_completed=progress.status == LessonStatus.COMPLETED,
    )


@router.post(
    "/materials/{material_id}/ai-question-jobs",
    response_model=GenerationJobResponse,
    status_code=status.HTTP_202_ACCEPTED,
    summary="Generate questions from an admin-uploaded PDF",
)
def create_material_ai_question_job(
    material_id: str,
    payload: MaterialAiQuestionJobCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    material = _get_visible_material(db, material_id)
    lesson = _get_published_lesson(db, material.lesson_id)
    _ensure_lesson_unlocked(db, lesson, current_user)
    return _create_question_generation_job(
        db=db,
        user=current_user,
        lesson=lesson,
        material=material,
        question_count=payload.question_count,
        difficulty=payload.difficulty,
        prompt=payload.prompt,
    )


@router.get(
    "/ai-question-jobs/{job_id}",
    response_model=GenerationJobResponse,
    summary="Get an owned AI question job",
)
def get_ai_question_job(job_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    job = (
        db.query(GenerationJob)
        .filter(
            GenerationJob.id == job_id,
            GenerationJob.created_by == current_user.id,
            GenerationJob.job_type == JobType.QUESTION_GENERATION,
        )
        .first()
    )
    if job is None:
        raise HTTPException(status_code=404, detail="AI question job not found")
    return job


@router.post(
    "/ai-question-jobs/{job_id}/regenerate",
    response_model=GenerationJobResponse,
    status_code=status.HTTP_202_ACCEPTED,
    summary="Regenerate questions from the same PDF material",
)
def regenerate_ai_question_job(
    job_id: str,
    payload: RegenerateJobRequest | None = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    job = (
        db.query(GenerationJob)
        .filter(
            GenerationJob.id == job_id,
            GenerationJob.created_by == current_user.id,
            GenerationJob.job_type == JobType.QUESTION_GENERATION,
        )
        .first()
    )
    if job is None:
        raise HTTPException(status_code=404, detail="AI question job not found")
    if not job.can_retry:
        raise HTTPException(status_code=409, detail="AI question job is still running")
    try:
        config = json.loads(job.prompt_json)
    except json.JSONDecodeError as exc:
        raise HTTPException(status_code=409, detail="AI question job payload is invalid") from exc
    if not isinstance(config, dict) or not config.get("material_id"):
        raise HTTPException(status_code=409, detail="AI question job is not linked to a PDF material")

    material = _get_visible_material(db, str(config["material_id"]))
    lesson = _get_published_lesson(db, material.lesson_id)
    _ensure_lesson_unlocked(db, lesson, current_user)
    return _create_question_generation_job(
        db=db,
        user=current_user,
        lesson=lesson,
        material=material,
        question_count=int(config.get("count") or 10),
        difficulty=int(config.get("difficulty") or 1),
        prompt=(payload.prompt if payload and payload.prompt is not None else config.get("additional_notes")),
        regenerate_of_job_id=job.id,
    )


@router.post(
    "/ai-question-jobs/{job_id}/sessions",
    response_model=LearningSessionResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Start a session from questions created by an AI job",
)
def start_ai_job_session(
    job_id: str,
    payload: StartJobSessionRequest | None = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    job = (
        db.query(GenerationJob)
        .filter(
            GenerationJob.id == job_id,
            GenerationJob.created_by == current_user.id,
            GenerationJob.job_type == JobType.QUESTION_GENERATION,
        )
        .first()
    )
    if job is None:
        raise HTTPException(status_code=404, detail="AI question job not found")
    if job.status != JobStatus.COMPLETED:
        raise HTTPException(status_code=409, detail="AI question job is not completed")
    try:
        job_config = json.loads(job.prompt_json)
    except json.JSONDecodeError as exc:
        raise HTTPException(status_code=409, detail="AI question job payload is invalid") from exc
    if not isinstance(job_config, dict) or not job_config.get("material_id"):
        raise HTTPException(status_code=409, detail="AI question job is not linked to a PDF material")
    _get_visible_material(db, str(job_config["material_id"]))
    question_ids = _question_ids_from_job(job)
    try:
        return learning_service.start_question_session(
            db,
            user=current_user,
            question_ids=question_ids,
            lesson_id=job.target_id or "",
            limit=len(question_ids),
            mode=(payload or StartJobSessionRequest()).mode,
            owner_user_id=current_user.id,
            allowed_statuses={QuestionStatus.AUTO_VALIDATED, QuestionStatus.PUBLISHED},
        )
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


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
