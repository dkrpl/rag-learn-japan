from __future__ import annotations

from datetime import datetime, timezone

from fastapi import APIRouter, Depends, File, Form, HTTPException, Query, UploadFile, status
from sqlalchemy.orm import Session

from app.api.deps import RoleChecker, get_current_user
from app.db.session import get_db
from app.models.material import MaterialDocument
from app.models.user import User, UserRole
from app.schemas.material import MaterialDocumentResponse, MaterialPreviewResponse, MaterialUpdateRequest
from app.services.pdf_material import PdfMaterialError, extract_pdf_material, store_pdf_material

admin_checker = RoleChecker([UserRole.CONTENT_EDITOR, UserRole.ADMINISTRATOR])
router = APIRouter(dependencies=[Depends(admin_checker)])


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
def update_material(material_id: str, payload: MaterialUpdateRequest, db: Session = Depends(get_db)):
    material = _get_material(db, material_id, include_archived=False)
    update_data = payload.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(material, field, value)
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


@router.post("/{material_id}/publish", response_model=MaterialDocumentResponse, summary="Publish a PDF material")
def publish_material(material_id: str, db: Session = Depends(get_db)):
    material = _get_material(db, material_id, include_archived=False)
    material.is_published = True
    material.published_at = datetime.now(timezone.utc)
    db.commit()
    db.refresh(material)
    return _material_response(material)


@router.post("/{material_id}/unpublish", response_model=MaterialDocumentResponse, summary="Unpublish a PDF material")
def unpublish_material(material_id: str, db: Session = Depends(get_db)):
    material = _get_material(db, material_id, include_archived=False)
    material.is_published = False
    material.published_at = None
    db.commit()
    db.refresh(material)
    return _material_response(material)


@router.delete("/{material_id}", response_model=MaterialDocumentResponse, summary="Archive a PDF material")
def archive_material(material_id: str, db: Session = Depends(get_db)):
    material = _get_material(db, material_id, include_archived=False)
    material.is_archived = True
    material.is_published = False
    material.archived_at = datetime.now(timezone.utc)
    material.published_at = None
    db.commit()
    db.refresh(material)
    return _material_response(material)
