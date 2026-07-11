"""Business rules shared by curriculum/content admin routers.

Keeping lifecycle and integrity rules here prevents alternate endpoints and
imports from bypassing the same publication constraints.
"""

from __future__ import annotations

from datetime import datetime, timezone
from typing import Any, Iterable, TypeVar

from sqlalchemy import and_
from sqlalchemy.orm import Session, object_session

from app.models.content import (
    AudioAsset,
    ExampleSentence,
    GrammarPoint,
    Kanji,
    Reading,
    Vocabulary,
    lesson_grammar_points,
    lesson_kanjis,
    lesson_vocabularies,
)
from app.models.curriculum import Course, Lesson, LessonSection, Level, Unit
from app.schemas.content import ContentImportRequest
from app.services.storage_service import AudioStorageError, get_audio_storage

Publishable = (
    Level
    | Course
    | Unit
    | Lesson
    | LessonSection
    | AudioAsset
    | Vocabulary
    | Kanji
    | GrammarPoint
    | ExampleSentence
    | Reading
)
ContentModel = AudioAsset | Vocabulary | Kanji | GrammarPoint | ExampleSentence | Reading
ModelT = TypeVar("ModelT")


class DomainError(Exception):
    status_code = 400


class ResourceNotFoundError(DomainError):
    status_code = 404


class DomainConflictError(DomainError):
    status_code = 409


class PublicationValidationError(DomainError):
    status_code = 422


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


def get_or_raise(db: Session, model: type[ModelT], resource_id: str, *, include_archived: bool = True) -> ModelT:
    query = db.query(model).filter(model.id == resource_id)
    if not include_archived and hasattr(model, "is_archived"):
        query = query.filter(model.is_archived.is_(False))
    resource = query.first()
    if resource is None:
        raise ResourceNotFoundError(f"{model.__name__} not found")
    return resource


def validate_active_reference(
    db: Session,
    model: type[ModelT],
    resource_id: str | None,
    field_name: str,
) -> ModelT | None:
    if resource_id is None:
        return None
    resource = get_or_raise(db, model, resource_id, include_archived=False)
    if getattr(resource, "is_archived", False):
        raise DomainConflictError(f"{field_name} refers to an archived {model.__name__}")
    return resource


def validate_content_references(db: Session, model: type[Any], values: dict[str, Any]) -> None:
    if "level_id" in values:
        validate_active_reference(db, Level, values.get("level_id"), "level_id")
    if "audio_id" in values:
        validate_active_reference(db, AudioAsset, values.get("audio_id"), "audio_id")
    if model is Course and "level_id" in values:
        validate_active_reference(db, Level, values.get("level_id"), "level_id")
    if model is Unit and "course_id" in values:
        validate_active_reference(db, Course, values.get("course_id"), "course_id")
    if model is Lesson and "unit_id" in values:
        validate_active_reference(db, Unit, values.get("unit_id"), "unit_id")
    if model is LessonSection and "lesson_id" in values:
        validate_active_reference(db, Lesson, values.get("lesson_id"), "lesson_id")
    if model is Reading and "lesson_id" in values:
        validate_active_reference(db, Lesson, values.get("lesson_id"), "lesson_id")
    if model is ExampleSentence:
        if "vocabulary_id" in values:
            validate_active_reference(db, Vocabulary, values.get("vocabulary_id"), "vocabulary_id")
        if "grammar_point_id" in values:
            validate_active_reference(db, GrammarPoint, values.get("grammar_point_id"), "grammar_point_id")


def _published(resource: Publishable | None) -> bool:
    return bool(resource and resource.is_published and not resource.is_archived)


def _lesson_has_published_content(lesson: Lesson) -> bool:
    session = object_session(lesson)
    if session is not None and lesson.id:
        section_exists = (
            session.query(LessonSection.id)
            .filter(
                LessonSection.lesson_id == lesson.id,
                LessonSection.is_published.is_(True),
                LessonSection.is_archived.is_(False),
            )
            .first()
            is not None
        )
        reading_exists = (
            session.query(Reading.id)
            .filter(
                Reading.lesson_id == lesson.id,
                Reading.is_published.is_(True),
                Reading.is_archived.is_(False),
            )
            .first()
            is not None
        )
        vocabulary_exists = (
            session.query(Vocabulary.id)
            .join(lesson_vocabularies, lesson_vocabularies.c.vocabulary_id == Vocabulary.id)
            .filter(
                lesson_vocabularies.c.lesson_id == lesson.id,
                Vocabulary.is_published.is_(True),
                Vocabulary.is_archived.is_(False),
            )
            .first()
            is not None
        )
        kanji_exists = (
            session.query(Kanji.id)
            .join(lesson_kanjis, lesson_kanjis.c.kanji_id == Kanji.id)
            .filter(
                lesson_kanjis.c.lesson_id == lesson.id,
                Kanji.is_published.is_(True),
                Kanji.is_archived.is_(False),
            )
            .first()
            is not None
        )
        grammar_exists = (
            session.query(GrammarPoint.id)
            .join(lesson_grammar_points, lesson_grammar_points.c.grammar_point_id == GrammarPoint.id)
            .filter(
                lesson_grammar_points.c.lesson_id == lesson.id,
                GrammarPoint.is_published.is_(True),
                GrammarPoint.is_archived.is_(False),
            )
            .first()
            is not None
        )
        return any((section_exists, reading_exists, vocabulary_exists, kanji_exists, grammar_exists))

    collections: Iterable[Iterable[Publishable]] = (
        lesson.sections,
        lesson.vocabularies,
        lesson.kanjis,
        lesson.grammar_points,
        lesson.readings,
    )
    return any(_published(item) for collection in collections for item in collection)


def validate_publish(resource: Publishable) -> None:
    if resource.is_archived:
        raise DomainConflictError("archived resources must be restored before publication")

    if isinstance(resource, Course) and not _published(resource.level):
        raise PublicationValidationError("course parent level must be published")
    if isinstance(resource, Unit) and not (_published(resource.course) and _published(resource.course.level)):
        raise PublicationValidationError("unit parent course and level must be published")
    if isinstance(resource, Lesson):
        if not (
            _published(resource.unit)
            and _published(resource.unit.course)
            and _published(resource.unit.course.level)
        ):
            raise PublicationValidationError("lesson parent unit, course, and level must be published")
        if not resource.learning_objective or not resource.learning_objective.strip():
            raise PublicationValidationError("lesson requires a learning objective before publication")
        if not _lesson_has_published_content(resource):
            raise PublicationValidationError("lesson requires at least one published content item before publication")
    if isinstance(resource, LessonSection):
        if resource.lesson.is_archived:
            raise PublicationValidationError("section parent lesson is archived")
        if not resource.content or not resource.content.strip():
            raise PublicationValidationError("lesson section requires non-empty content before publication")
    if isinstance(resource, AudioAsset):
        if not resource.checksum or resource.file_size_bytes <= 0 or resource.duration_seconds <= 0:
            raise PublicationValidationError("audio requires checksum, size, and duration metadata before publication")
        if not resource.transcript or not resource.transcript.strip():
            raise PublicationValidationError("audio requires a transcript before publication")
        try:
            storage = get_audio_storage(resource.storage_backend)
            if resource.storage_backend == "local":
                path = storage.resolve_asset(resource.storage_key, resource.file_path)
                if not path.is_file():
                    raise PublicationValidationError("audio binary is missing from local storage")
            else:
                storage.assert_exists(resource.storage_key)
        except AudioStorageError as exc:
            raise PublicationValidationError(str(exc)) from exc
    if isinstance(resource, Vocabulary):
        if not resource.word.strip() or not resource.kana.strip() or not resource.meaning.strip():
            raise PublicationValidationError("vocabulary word, kana, and meaning are required")
        if resource.audio and not _published(resource.audio):
            raise PublicationValidationError("linked vocabulary audio must be published")
    if isinstance(resource, Kanji):
        if not resource.character.strip() or not resource.meaning.strip():
            raise PublicationValidationError("kanji character and meaning are required")
    if isinstance(resource, GrammarPoint):
        if not resource.title.strip() or not resource.structure.strip() or not resource.meaning.strip():
            raise PublicationValidationError("grammar title, structure, and meaning are required")
    if isinstance(resource, ExampleSentence):
        if not resource.japanese.strip() or not resource.indonesian.strip():
            raise PublicationValidationError("example sentence and translation are required")
        if resource.audio and not _published(resource.audio):
            raise PublicationValidationError("linked example-sentence audio must be published")
    if isinstance(resource, Reading):
        if not resource.title.strip() or not resource.content.strip():
            raise PublicationValidationError("reading title and Japanese content are required")
        if resource.audio and not _published(resource.audio):
            raise PublicationValidationError("linked reading audio must be published")


def publish(resource: Publishable) -> Publishable:
    validate_publish(resource)
    resource.is_published = True
    resource.published_at = resource.published_at or utcnow()
    resource.archived_at = None
    return resource


def _cascade_unpublish(resource: Publishable) -> None:
    resource.is_published = False
    resource.published_at = None
    if isinstance(resource, Level):
        for course in resource.courses:
            _cascade_unpublish(course)
    elif isinstance(resource, Course):
        for unit in resource.units:
            _cascade_unpublish(unit)
    elif isinstance(resource, Unit):
        for lesson in resource.lessons:
            _cascade_unpublish(lesson)
    elif isinstance(resource, Lesson):
        for section in resource.sections:
            _cascade_unpublish(section)


def unpublish(resource: Publishable) -> Publishable:
    _cascade_unpublish(resource)
    return resource


def archive(resource: Publishable) -> Publishable:
    _cascade_unpublish(resource)
    resource.is_archived = True
    resource.archived_at = utcnow()
    if isinstance(resource, Level):
        for course in resource.courses:
            archive(course)
    elif isinstance(resource, Course):
        for unit in resource.units:
            archive(unit)
    elif isinstance(resource, Unit):
        for lesson in resource.lessons:
            archive(lesson)
    elif isinstance(resource, Lesson):
        for section in resource.sections:
            archive(section)
    return resource


def restore(resource: Publishable) -> Publishable:
    resource.is_archived = False
    resource.archived_at = None
    # Restores are intentionally draft. Descendants remain archived until an
    # editor restores them explicitly, avoiding accidental bulk publication.
    resource.is_published = False
    resource.published_at = None
    return resource


def apply_lifecycle_from_input(resource: Publishable, requested_publish: bool | None) -> None:
    if requested_publish is True:
        publish(resource)
    elif requested_publish is False and resource.is_published:
        unpublish(resource)


IMPORT_MODELS: tuple[tuple[str, type[Any], tuple[str, ...]], ...] = (
    ("vocabularies", Vocabulary, ("word", "kana")),
    ("kanjis", Kanji, ("character",)),
    ("grammar_points", GrammarPoint, ("title", "structure")),
    ("example_sentences", ExampleSentence, ("japanese", "indonesian")),
    ("readings", Reading, ("lesson_id", "title")),
)


def _find_by_natural_key(
    db: Session,
    model: type[Any],
    values: dict[str, Any],
    key_fields: tuple[str, ...],
) -> Any | None:
    filters = [getattr(model, field) == values.get(field) for field in key_fields]
    return db.query(model).filter(and_(*filters)).first()


def import_content(db: Session, payload: ContentImportRequest) -> dict[str, Any]:
    created = {name: 0 for name, _, _ in IMPORT_MODELS}
    updated = {name: 0 for name, _, _ in IMPORT_MODELS}
    unchanged = {name: 0 for name, _, _ in IMPORT_MODELS}

    for collection_name, model, natural_key in IMPORT_MODELS:
        for schema in getattr(payload, collection_name):
            values = schema.model_dump(exclude={"is_published"})
            requested_publish = schema.is_published
            validate_content_references(db, model, values)
            resource = _find_by_natural_key(db, model, values, natural_key)
            if resource is None:
                resource = model(**values)
                db.add(resource)
                db.flush()
                apply_lifecycle_from_input(resource, requested_publish)
                created[collection_name] += 1
                continue

            changed = False
            for field, value in values.items():
                if getattr(resource, field) != value:
                    setattr(resource, field, value)
                    changed = True
            previous_state = resource.is_published
            apply_lifecycle_from_input(resource, requested_publish)
            changed = changed or previous_state != resource.is_published
            if changed:
                updated[collection_name] += 1
            else:
                unchanged[collection_name] += 1

    db.flush()
    result = {"created": created, "updated": updated, "unchanged": unchanged, "dry_run": payload.dry_run}
    if payload.dry_run:
        db.rollback()
    else:
        db.commit()
    return result
