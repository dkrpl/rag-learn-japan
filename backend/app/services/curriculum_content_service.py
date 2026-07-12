"""Lifecycle rules for the simplified Course -> Unit -> Lesson MVP."""

from __future__ import annotations

from datetime import datetime, timezone
from typing import Any

from sqlalchemy.orm import Session

from app.models.curriculum import Course, Lesson, LessonSection, Level, Unit
from app.models.material import MaterialDocument

LifecycleModel = Level | Course | Unit | Lesson | LessonSection


class DomainError(RuntimeError):
    def __init__(self, message: str, *, status_code: int = 400) -> None:
        super().__init__(message)
        self.status_code = status_code


class PublicationValidationError(DomainError):
    def __init__(self, message: str) -> None:
        super().__init__(message, status_code=422)


def get_or_raise(db: Session, model: type[Any], resource_id: str, *, include_archived: bool = True) -> Any:
    query = db.query(model).filter(model.id == resource_id)
    if not include_archived and hasattr(model, "is_archived"):
        query = query.filter(model.is_archived.is_(False))
    resource = query.first()
    if resource is None:
        raise DomainError(f"{model.__name__} not found", status_code=404)
    return resource


def _has_published_section(lesson: Lesson) -> bool:
    return any(
        section.is_published and not section.is_archived and (section.content or "").strip()
        for section in lesson.sections
    )


def _has_pdf_material(db: Session, lesson: Lesson) -> bool:
    return db.query(MaterialDocument.id).filter(MaterialDocument.lesson_id == lesson.id).first() is not None


def ensure_publishable(resource: LifecycleModel, db: Session | None = None) -> None:
    if getattr(resource, "is_archived", False):
        raise PublicationValidationError("archived resources cannot be published")
    if isinstance(resource, Course):
        level = getattr(resource, "level", None)
        if level and (not level.is_published or level.is_archived):
            raise PublicationValidationError("course parent level must be published")
    if isinstance(resource, Unit):
        course = getattr(resource, "course", None)
        if course and (not course.is_published or course.is_archived):
            raise PublicationValidationError("unit parent course must be published")
    if isinstance(resource, Lesson):
        unit = getattr(resource, "unit", None)
        if unit and (not unit.is_published or unit.is_archived):
            raise PublicationValidationError("lesson parent unit must be published")
        if not (resource.learning_objective or "").strip():
            raise PublicationValidationError("lesson requires a learning objective before publication")
        has_material = db is not None and _has_pdf_material(db, resource)
        if not _has_published_section(resource) and not has_material:
            raise PublicationValidationError("lesson requires published content or PDF material before publication")
    if isinstance(resource, LessonSection):
        if not (resource.content or "").strip():
            raise PublicationValidationError("lesson section requires non-empty content before publication")


def publish(resource: LifecycleModel, *, db: Session | None = None) -> None:
    ensure_publishable(resource, db=db)
    resource.is_published = True
    resource.published_at = datetime.now(timezone.utc)


def unpublish(resource: LifecycleModel) -> None:
    resource.is_published = False
    resource.published_at = None


def archive(resource: LifecycleModel) -> None:
    resource.is_archived = True
    resource.archived_at = datetime.now(timezone.utc)
    resource.is_published = False
    resource.published_at = None


def restore(resource: LifecycleModel) -> None:
    resource.is_archived = False
    resource.archived_at = None


def apply_lifecycle_from_input(
    resource: LifecycleModel,
    requested_publish: bool | None,
    db: Session | None = None,
) -> None:
    if requested_publish is True:
        publish(resource, db=db)
    elif requested_publish is False:
        unpublish(resource)
