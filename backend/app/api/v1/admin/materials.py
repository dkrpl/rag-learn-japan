from __future__ import annotations

import csv
import json
from datetime import datetime, timezone
from io import StringIO

from fastapi import APIRouter, Depends, File, Form, HTTPException, Query, UploadFile, status
from fastapi.responses import Response
from sqlalchemy import func
from sqlalchemy.orm import Session

from app.api.deps import RoleChecker, get_current_user
from app.db.session import get_db
from app.models.ai_jobs import AuditLog
from app.models.learning import LearningSession, SessionStatus
from app.models.material import MaterialDocument
from app.models.progress import MaterialProgressStatus, UserMaterialProgress
from app.models.user import User, UserRole
from app.schemas.material import (
    MaterialAnalyticsAttempt,
    MaterialAnalyticsBucket,
    MaterialAnalyticsResponse,
    MaterialDocumentResponse,
    MaterialPreviewResponse,
    MaterialUpdateRequest,
)
from app.services.pdf_material import PdfMaterialError, extract_pdf_material, store_pdf_material

admin_checker = RoleChecker([UserRole.CONTENT_EDITOR, UserRole.ADMINISTRATOR])
router = APIRouter(dependencies=[Depends(admin_checker)])


def _audit_material(db: Session, *, actor: User | None, action: str, material: MaterialDocument, details: dict | None = None) -> None:
    db.add(
        AuditLog(
            user_id=actor.id if actor else None,
            action=action,
            entity_name="MaterialDocument",
            entity_id=material.id,
            details=json.dumps(details or {}, ensure_ascii=False, separators=(",", ":"), sort_keys=True),
        )
    )


def _material_response(material: MaterialDocument) -> MaterialDocumentResponse:
    return MaterialDocumentResponse(
        id=material.id,
        lesson_id=material.lesson_id,
        title=material.title,
        description=material.description,
        level=material.level,
        category=material.category,
        sequence=material.sequence,
        passing_score=material.passing_score,
        original_filename=material.original_filename,
        content_type=material.content_type,
        file_size_bytes=material.file_size_bytes,
        checksum=material.checksum,
        file_url=f"/api/v1/app/materials/{material.id}/file",
        page_count=material.page_count,
        extracted_text_preview=material.extracted_text[:500],
        extracted_text_char_count=len(material.extracted_text or ""),
        is_published=material.is_published,
        is_archived=material.is_archived,
        created_by_id=material.created_by_id,
        created_at=material.created_at,
        updated_at=material.updated_at,
    )


def _get_material(db: Session, material_id: str, *, include_archived: bool = True) -> MaterialDocument:
    query = db.query(MaterialDocument).filter(MaterialDocument.id == material_id)
    if not include_archived:
        query = query.filter(MaterialDocument.is_archived.is_(False))
    material = query.first()
    if material is None:
        raise HTTPException(status_code=404, detail="Material document not found")
    return material


@router.post(
    "/pdf",
    response_model=MaterialDocumentResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Upload a PDF source material",
)
async def upload_pdf_material(
    file: UploadFile = File(...),
    title: str | None = Form(default=None, min_length=1, max_length=255),
    description: str | None = Form(default=None, max_length=4000),
    level: str = Form(default="N5", min_length=1, max_length=16),
    category: str | None = Form(default=None, max_length=100),
    sequence: int = Form(default=0, ge=0),
    passing_score: int = Form(default=70, ge=0, le=100),
    is_published: bool = Form(default=True),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    try:
        extracted = await extract_pdf_material(file)
    except PdfMaterialError as exc:
        raise HTTPException(status_code=422, detail=str(exc)) from exc

    now = datetime.now(timezone.utc)
    material = MaterialDocument(
        title=title or extracted.original_filename,
        description=description,
        level=level,
        category=category,
        sequence=sequence,
        passing_score=passing_score,
        original_filename=extracted.original_filename,
        content_type=extracted.content_type,
        file_size_bytes=extracted.file_size_bytes,
        checksum=extracted.checksum,
        storage_key=store_pdf_material(extracted.data, extracted.checksum),
        page_count=extracted.page_count,
        extracted_text=extracted.text,
        is_published=is_published,
        published_at=now if is_published else None,
        created_by_id=current_user.id,
    )
    db.add(material)
    db.flush()
    _audit_material(
        db,
        actor=current_user,
        action="material.upload",
        material=material,
        details={"title": material.title, "is_published": material.is_published},
    )
    db.commit()
    db.refresh(material)
    return _material_response(material)


@router.get("", response_model=list[MaterialDocumentResponse], summary="List uploaded PDF source materials")
def list_materials(
    level: str | None = Query(default=None),
    category: str | None = Query(default=None),
    include_archived: bool = Query(default=False),
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    db: Session = Depends(get_db),
):
    query = db.query(MaterialDocument)
    if not include_archived:
        query = query.filter(MaterialDocument.is_archived.is_(False))
    if level:
        query = query.filter(MaterialDocument.level == level)
    if category:
        query = query.filter(MaterialDocument.category == category)
    materials = (
        query.order_by(MaterialDocument.sequence.asc(), MaterialDocument.created_at.desc(), MaterialDocument.id)
        .offset(offset)
        .limit(limit)
        .all()
    )
    return [_material_response(material) for material in materials]


@router.get("/{material_id}", response_model=MaterialDocumentResponse, summary="Get one uploaded source material")
def get_material(material_id: str, db: Session = Depends(get_db)):
    return _material_response(_get_material(db, material_id))


@router.patch("/{material_id}", response_model=MaterialDocumentResponse, summary="Edit material metadata")
def update_material(
    material_id: str,
    payload: MaterialUpdateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    material = _get_material(db, material_id, include_archived=False)
    update_data = payload.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(material, field, value)
    _audit_material(db, actor=current_user, action="material.update", material=material, details=update_data)
    db.commit()
    db.refresh(material)
    return _material_response(material)


@router.get(
    "/{material_id}/preview",
    response_model=MaterialPreviewResponse,
    summary="Preview extracted PDF text before it is used by AI",
)
def preview_material(material_id: str, db: Session = Depends(get_db)):
    material = _get_material(db, material_id)
    return MaterialPreviewResponse(
        id=material.id,
        title=material.title,
        page_count=material.page_count,
        extracted_text=material.extracted_text,
        extracted_text_char_count=len(material.extracted_text or ""),
        is_published=material.is_published,
    )


@router.get(
    "/{material_id}/analytics",
    response_model=MaterialAnalyticsResponse,
    summary="Get production analytics for one PDF material",
)
def material_analytics(material_id: str, db: Session = Depends(get_db)):
    material = _get_material(db, material_id)
    completed_query = db.query(LearningSession).filter(
        LearningSession.material_id == material.id,
        LearningSession.status == SessionStatus.COMPLETED,
    )
    total_attempts = completed_query.count()
    passed_attempts = completed_query.filter(LearningSession.is_passed.is_(True)).count()
    failed_attempts = max(total_attempts - passed_attempts, 0)
    average_score = int(round(completed_query.with_entities(func.coalesce(func.avg(LearningSession.final_score), 0)).scalar() or 0))
    completed_learners = (
        db.query(UserMaterialProgress.user_id)
        .filter(
            UserMaterialProgress.material_id == material.id,
            UserMaterialProgress.status == MaterialProgressStatus.COMPLETED,
        )
        .distinct()
        .count()
    )
    difficulty_row = (
        completed_query.with_entities(LearningSession.difficulty, func.count(LearningSession.id).label("count"))
        .group_by(LearningSession.difficulty)
        .order_by(func.count(LearningSession.id).desc(), LearningSession.difficulty.asc())
        .first()
    )
    difficulty_counts = (
        completed_query.with_entities(LearningSession.difficulty, func.count(LearningSession.id).label("count"))
        .group_by(LearningSession.difficulty)
        .order_by(LearningSession.difficulty.asc())
        .all()
    )
    difficulty_labels = {1: "easy", 2: "medium", 3: "hard", 4: "hard+", 5: "expert"}
    difficulty_breakdown = [
        MaterialAnalyticsBucket(
            label=difficulty_labels.get(int(difficulty), str(difficulty)),
            count=int(count),
            percentage=round((int(count) / total_attempts) * 100) if total_attempts else 0,
        )
        for difficulty, count in difficulty_counts
    ]

    score_ranges = [
        ("0-49", 0, 49),
        ("50-69", 50, 69),
        ("70-84", 70, 84),
        ("85-100", 85, 100),
    ]
    score_buckets = []
    for label, minimum, maximum in score_ranges:
        count = completed_query.filter(
            LearningSession.final_score >= minimum,
            LearningSession.final_score <= maximum,
        ).count()
        score_buckets.append(
            MaterialAnalyticsBucket(
                label=label,
                count=count,
                percentage=round((count / total_attempts) * 100) if total_attempts else 0,
            )
        )

    recent_rows = (
        db.query(LearningSession, User.name, User.email)
        .join(User, LearningSession.user_id == User.id)
        .filter(
            LearningSession.material_id == material.id,
            LearningSession.status == SessionStatus.COMPLETED,
        )
        .order_by(LearningSession.completed_at.desc(), LearningSession.id.desc())
        .limit(8)
        .all()
    )
    recent_attempts = [
        MaterialAnalyticsAttempt(
            session_id=session.id,
            learner_name=name or email,
            final_score=session.final_score,
            is_passed=session.is_passed,
            difficulty=session.difficulty,
            earned_exp=session.earned_exp,
            completed_at=session.completed_at,
        )
        for session, name, email in recent_rows
    ]

    return MaterialAnalyticsResponse(
        material_id=material.id,
        title=material.title,
        total_attempts=total_attempts,
        completed_learners=completed_learners,
        average_score=average_score,
        pass_rate=round((passed_attempts / total_attempts) * 100) if total_attempts else 0,
        most_used_difficulty=difficulty_row[0] if difficulty_row else None,
        failed_attempts=failed_attempts,
        passed_attempts=passed_attempts,
        difficulty_breakdown=difficulty_breakdown,
        score_buckets=score_buckets,
        recent_attempts=recent_attempts,
    )


@router.get(
    "/{material_id}/analytics.csv",
    response_class=Response,
    summary="Export production analytics for one PDF material as CSV",
)
def material_analytics_csv(material_id: str, db: Session = Depends(get_db)):
    analytics = material_analytics(material_id=material_id, db=db)
    output = StringIO()
    writer = csv.writer(output)
    writer.writerow(["metric", "value"])
    writer.writerow(["title", analytics.title])
    writer.writerow(["total_attempts", analytics.total_attempts])
    writer.writerow(["completed_learners", analytics.completed_learners])
    writer.writerow(["average_score", analytics.average_score])
    writer.writerow(["pass_rate", analytics.pass_rate])
    writer.writerow(["most_used_difficulty", analytics.most_used_difficulty or ""])
    writer.writerow(["passed_attempts", analytics.passed_attempts])
    writer.writerow(["failed_attempts", analytics.failed_attempts])
    writer.writerow([])
    writer.writerow(["difficulty", "count", "percentage"])
    for item in analytics.difficulty_breakdown:
        writer.writerow([item.label, item.count, item.percentage])
    writer.writerow([])
    writer.writerow(["score_bucket", "count", "percentage"])
    for item in analytics.score_buckets:
        writer.writerow([item.label, item.count, item.percentage])
    writer.writerow([])
    writer.writerow(["session_id", "learner", "score", "passed", "difficulty", "earned_exp", "completed_at"])
    for item in analytics.recent_attempts:
        writer.writerow(
            [
                item.session_id,
                item.learner_name or "",
                item.final_score,
                item.is_passed,
                item.difficulty,
                item.earned_exp,
                item.completed_at.isoformat() if item.completed_at else "",
            ]
        )
    return Response(
        output.getvalue(),
        media_type="text/csv; charset=utf-8",
        headers={"Content-Disposition": f'attachment; filename="material-{material_id}-analytics.csv"'},
    )


@router.post("/{material_id}/publish", response_model=MaterialDocumentResponse, summary="Publish a PDF material")
def publish_material(
    material_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    material = _get_material(db, material_id, include_archived=False)
    material.is_published = True
    material.published_at = datetime.now(timezone.utc)
    _audit_material(db, actor=current_user, action="material.publish", material=material)
    db.commit()
    db.refresh(material)
    return _material_response(material)


@router.post("/{material_id}/unpublish", response_model=MaterialDocumentResponse, summary="Unpublish a PDF material")
def unpublish_material(
    material_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    material = _get_material(db, material_id, include_archived=False)
    material.is_published = False
    material.published_at = None
    _audit_material(db, actor=current_user, action="material.unpublish", material=material)
    db.commit()
    db.refresh(material)
    return _material_response(material)


@router.delete("/{material_id}", response_model=MaterialDocumentResponse, summary="Archive a PDF material")
def archive_material(
    material_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    material = _get_material(db, material_id, include_archived=False)
    material.is_archived = True
    material.is_published = False
    material.archived_at = datetime.now(timezone.utc)
    material.published_at = None
    _audit_material(db, actor=current_user, action="material.archive", material=material)
    db.commit()
    db.refresh(material)
    return _material_response(material)
