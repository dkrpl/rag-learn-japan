from __future__ import annotations

import json

from fastapi import APIRouter, Depends, File, Form, HTTPException, Query, UploadFile, status
from sqlalchemy.orm import Session

from app.api.deps import RoleChecker, get_current_user
from app.api.v1.frontend import _can_dispatch_ai_worker
from app.db.session import get_db
from app.models.ai_jobs import GenerationJob, JobStatus, JobType
from app.models.curriculum import Lesson
from app.models.material import MaterialDocument
from app.models.user import User, UserRole
from app.schemas.ai_jobs import GenerationJobResponse
from app.schemas.material import MaterialDocumentResponse, MaterialQuestionJobCreate
from app.services.pdf_material import PdfMaterialError, extract_pdf_material, store_pdf_material
from app.tasks.ai_tasks import generate_questions_task

admin_checker = RoleChecker([UserRole.CONTENT_EDITOR, UserRole.ADMINISTRATOR])
router = APIRouter(dependencies=[Depends(admin_checker)])


def _material_response(material: MaterialDocument) -> MaterialDocumentResponse:
    return MaterialDocumentResponse(
        id=material.id,
        lesson_id=material.lesson_id,
        title=material.title,
        original_filename=material.original_filename,
        content_type=material.content_type,
        file_size_bytes=material.file_size_bytes,
        checksum=material.checksum,
        file_url=f"/api/v1/app/materials/{material.id}/file",
        page_count=material.page_count,
        extracted_text_preview=material.extracted_text[:500],
        created_by_id=material.created_by_id,
        created_at=material.created_at,
        updated_at=material.updated_at,
    )


def _get_lesson(db: Session, lesson_id: str) -> Lesson:
    lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first()
    if lesson is None:
        raise HTTPException(status_code=404, detail="Lesson not found")
    return lesson


def _get_material(db: Session, material_id: str) -> MaterialDocument:
    material = db.query(MaterialDocument).filter(MaterialDocument.id == material_id).first()
    if material is None:
        raise HTTPException(status_code=404, detail="Material document not found")
    return material


@router.post(
    "/pdf",
    response_model=MaterialDocumentResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Upload a PDF source material for a lesson",
)
async def upload_pdf_material(
    file: UploadFile = File(...),
    lesson_id: str = Form(...),
    title: str | None = Form(default=None, min_length=1, max_length=255),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    _get_lesson(db, lesson_id)
    try:
        extracted = await extract_pdf_material(file)
    except PdfMaterialError as exc:
        raise HTTPException(status_code=422, detail=str(exc)) from exc

    material = MaterialDocument(
        lesson_id=lesson_id,
        title=title or extracted.original_filename,
        original_filename=extracted.original_filename,
        content_type=extracted.content_type,
        file_size_bytes=extracted.file_size_bytes,
        checksum=extracted.checksum,
        storage_key=store_pdf_material(extracted.data, extracted.checksum),
        page_count=extracted.page_count,
        extracted_text=extracted.text,
        created_by_id=current_user.id,
    )
    db.add(material)
    db.commit()
    db.refresh(material)
    return _material_response(material)


@router.get("", response_model=list[MaterialDocumentResponse], summary="List uploaded PDF source materials")
def list_materials(
    lesson_id: str | None = Query(default=None),
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    db: Session = Depends(get_db),
):
    query = db.query(MaterialDocument)
    if lesson_id:
        query = query.filter(MaterialDocument.lesson_id == lesson_id)
    materials = (
        query.order_by(MaterialDocument.created_at.desc(), MaterialDocument.id)
        .offset(offset)
        .limit(limit)
        .all()
    )
    return [_material_response(material) for material in materials]


@router.get("/{material_id}", response_model=MaterialDocumentResponse, summary="Get one uploaded source material")
def get_material(material_id: str, db: Session = Depends(get_db)):
    return _material_response(_get_material(db, material_id))


@router.post(
    "/{material_id}/question-jobs",
    response_model=GenerationJobResponse,
    status_code=status.HTTP_202_ACCEPTED,
    summary="Generate questions from an uploaded PDF material",
)
def create_material_question_job(
    material_id: str,
    payload: MaterialQuestionJobCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    material = _get_material(db, material_id)
    _get_lesson(db, material.lesson_id)

    job_payload = {
        "lesson_id": material.lesson_id,
        "material_id": material.id,
        "material_title": material.title,
        "question_type": payload.question_type.value,
        "skill": payload.skill.value,
        "count": payload.question_count,
        "difficulty": payload.difficulty,
        "additional_notes": payload.additional_notes,
        "source_material": material.extracted_text,
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
