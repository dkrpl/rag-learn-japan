"""Small frontend-facing API facade.

The project still keeps richer admin/internal endpoints for back-office and
tests, but this router is the contract a course frontend should start from.
"""

from __future__ import annotations

import json
from typing import Any

from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel, ConfigDict, Field
from sqlalchemy import func
from sqlalchemy.orm import Session, selectinload

from app.api.deps import get_current_user
from app.core.config import settings
from app.db.session import get_db
from app.models.ai_jobs import GenerationJob, JobStatus, JobType
from app.models.curriculum import Course, Lesson, Level, Unit
from app.models.learning import SessionMode
from app.models.material import MaterialDocument
from app.models.progress import XPTransaction
from app.models.user import User
from app.schemas.ai_jobs import GenerationJobResponse
from app.schemas.curriculum import LessonContentResponse
from app.schemas.learning import (
    LearningSessionCreate,
    LearningSessionResponse,
    SessionQuestionResponse,
    SubmitAnswerRequest,
    SubmitAnswerResponse,
)
from app.schemas.progress import DashboardOverviewResponse
from app.schemas.user import UserResponse
from app.services import learning as learning_service
from app.services.progress import dashboard_overview
from app.tasks.ai_tasks import generate_questions_task

router = APIRouter()


class AppLessonSummary(BaseModel):
    id: str
    title: str
    summary: str | None = None
    estimated_minutes: int
    sequence: int

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
    level_id: str
    level_name: str
    courses: list[AppCourseSummary]


class AiQuestionJobCreate(BaseModel):
    question_count: int = Field(default=5, ge=1, le=20)
    skill: str | None = Field(default=None, max_length=32)
    difficulty: int | None = Field(default=None, ge=1, le=5)
    prompt: str | None = Field(default=None, max_length=4000)

    model_config = ConfigDict(extra="forbid")


class AppMaterialSummary(BaseModel):
    id: str
    lesson_id: str
    title: str
    original_filename: str
    page_count: int
    extracted_text_preview: str


class MaterialAiQuestionJobCreate(BaseModel):
    question_count: int = Field(default=10, ge=1, le=30)
    skill: str = Field(default="READING", max_length=32)
    difficulty: int = Field(default=1, ge=1, le=5)
    prompt: str | None = Field(default=None, max_length=4000)

    model_config = ConfigDict(extra="forbid")


class StartJobSessionRequest(BaseModel):
    mode: SessionMode = SessionMode.PRACTICE

    model_config = ConfigDict(extra="forbid")


class LeaderboardEntry(BaseModel):
    rank: int
    user_id: str
    name: str | None = None
    total_xp: int


def _raise_learning_error(exc: learning_service.LearningServiceError) -> None:
    raise HTTPException(
        status_code=exc.status_code,
        detail={"code": exc.code, "message": exc.message},
    ) from exc


def _is_visible(resource: Any) -> bool:
    return bool(resource.is_published and not resource.is_archived)


def _lesson_content(lesson: Lesson) -> LessonContentResponse:
    from app.api.v1.curriculum import _lesson_content as build_lesson_content

    return build_lesson_content(lesson)


def _published_lessons_options():
    return (
        selectinload(Lesson.sections),
        selectinload(Lesson.vocabularies),
        selectinload(Lesson.kanjis),
        selectinload(Lesson.grammar_points),
        selectinload(Lesson.readings),
    )


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
        page_count=material.page_count,
        extracted_text_preview=material.extracted_text[:500],
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
    visible_courses = (item for item in level.courses if _is_visible(item))
    for course in sorted(visible_courses, key=lambda item: (item.sequence, item.id)):
        units: list[AppUnitSummary] = []
        visible_units = (item for item in course.units if _is_visible(item))
        for unit in sorted(visible_units, key=lambda item: (item.sequence, item.id)):
            lessons = [
                AppLessonSummary.model_validate(lesson)
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
    return AppCatalogResponse(level_id=level.id, level_name=level.name, courses=courses)


@router.get("/lessons/{lesson_id}", response_model=LessonContentResponse, summary="Get one lesson with content")
def get_lesson(lesson_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    return _lesson_content(_get_published_lesson(db, lesson_id))


@router.get(
    "/lessons/{lesson_id}/materials",
    response_model=list[AppMaterialSummary],
    summary="Get PDFs uploaded by admin for a lesson",
)
def get_lesson_materials(lesson_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    _get_published_lesson(db, lesson_id)
    materials = (
        db.query(MaterialDocument)
        .filter(MaterialDocument.lesson_id == lesson_id)
        .order_by(MaterialDocument.created_at.desc(), MaterialDocument.id)
        .all()
    )
    return [_material_summary(material) for material in materials]


@router.post(
    "/lessons/{lesson_id}/sessions",
    response_model=LearningSessionResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Start practice for a lesson",
)
def start_lesson_session(
    lesson_id: str,
    payload: LearningSessionCreate | None = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    request = (payload or LearningSessionCreate(lesson_id=lesson_id)).model_copy(update={"lesson_id": lesson_id})
    try:
        return learning_service.start_lesson_session(db, request, current_user)
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


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


@router.get("/dashboard", response_model=DashboardOverviewResponse, summary="Get learner dashboard")
def get_dashboard(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    return dashboard_overview(db, user=current_user)


@router.post(
    "/lessons/{lesson_id}/ai-question-jobs",
    response_model=GenerationJobResponse,
    status_code=status.HTTP_202_ACCEPTED,
    summary="Generate more questions for a lesson with AI",
)
def create_ai_question_job(
    lesson_id: str,
    payload: AiQuestionJobCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    _get_published_lesson(db, lesson_id)
    job_payload = {
        "lesson_id": lesson_id,
        "question_type": "MULTIPLE_CHOICE",
        "skill": payload.skill or "VOCABULARY",
        "count": payload.question_count,
        "difficulty": payload.difficulty or 1,
        "additional_notes": payload.prompt,
    }
    job = GenerationJob(
        job_type=JobType.QUESTION_GENERATION,
        status=JobStatus.PENDING,
        prompt_json=json.dumps(job_payload, separators=(",", ":"), sort_keys=True),
        target_id=lesson_id,
        created_by=current_user.id,
    )
    db.add(job)
    db.commit()
    db.refresh(job)

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
    job_payload = {
        "lesson_id": material.lesson_id,
        "material_id": material.id,
        "material_title": material.title,
        "question_type": "MULTIPLE_CHOICE",
        "skill": payload.skill,
        "count": payload.question_count,
        "difficulty": payload.difficulty,
        "additional_notes": payload.prompt,
        "source_material": material.extracted_text,
        "auto_publish": True,
    }
    job = GenerationJob(
        job_type=JobType.QUESTION_GENERATION,
        status=JobStatus.PENDING,
        prompt_json=json.dumps(job_payload, ensure_ascii=False, separators=(",", ":"), sort_keys=True),
        target_id=material.lesson_id,
        created_by=current_user.id,
    )
    db.add(job)
    db.commit()
    db.refresh(job)

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
    question_ids = _question_ids_from_job(job)
    try:
        return learning_service.start_question_session(
            db,
            user=current_user,
            question_ids=question_ids,
            lesson_id=job.target_id or "",
            limit=len(question_ids),
            mode=(payload or StartJobSessionRequest()).mode,
        )
    except learning_service.LearningServiceError as exc:
        _raise_learning_error(exc)


@router.get("/leaderboard", response_model=list[LeaderboardEntry], summary="Get XP leaderboard")
def get_leaderboard(
    limit: int = Query(default=20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    rows = (
        db.query(User.id, User.name, func.coalesce(func.sum(XPTransaction.amount), 0).label("total_xp"))
        .join(XPTransaction, XPTransaction.user_id == User.id)
        .filter(User.is_active.is_(True))
        .group_by(User.id, User.name)
        .order_by(func.coalesce(func.sum(XPTransaction.amount), 0).desc(), User.created_at.asc())
        .limit(limit)
        .all()
    )
    return [
        LeaderboardEntry(rank=index, user_id=row.id, name=row.name, total_xp=int(row.total_xp or 0))
        for index, row in enumerate(rows, start=1)
    ]
