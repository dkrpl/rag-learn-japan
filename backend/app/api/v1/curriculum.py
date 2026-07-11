from __future__ import annotations

from typing import Any

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session, selectinload

from app.api.deps import get_current_user
from app.db.session import get_db
from app.models.content import ExampleSentence
from app.models.curriculum import Course, Lesson, Level, Unit
from app.schemas.content import ExampleSentenceResponse, ReadingResponse, VocabularyResponse
from app.schemas.curriculum import (
    CourseResponse,
    LessonContentResponse,
    LessonDetailResponse,
    LessonResponse,
    LevelResponse,
    UnitResponse,
)

router = APIRouter(dependencies=[Depends(get_current_user)])


def _not_found() -> None:
    # A single response avoids disclosing whether a draft/archived resource exists.
    raise HTTPException(status_code=404, detail="Published curriculum resource not found")


def _published_level_query(db: Session):
    return db.query(Level).filter(Level.is_published.is_(True), Level.is_archived.is_(False))


def _published_course_query(db: Session):
    return (
        db.query(Course)
        .join(Level, Course.level_id == Level.id)
        .filter(
            Course.is_published.is_(True),
            Course.is_archived.is_(False),
            Level.is_published.is_(True),
            Level.is_archived.is_(False),
        )
    )


def _published_unit_query(db: Session):
    return (
        db.query(Unit)
        .join(Course, Unit.course_id == Course.id)
        .join(Level, Course.level_id == Level.id)
        .filter(
            Unit.is_published.is_(True),
            Unit.is_archived.is_(False),
            Course.is_published.is_(True),
            Course.is_archived.is_(False),
            Level.is_published.is_(True),
            Level.is_archived.is_(False),
        )
    )


def _published_lesson_query(db: Session):
    return (
        db.query(Lesson)
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
    )


def _is_visible(resource: Any) -> bool:
    return bool(resource.is_published and not resource.is_archived)


def _visible_audio_or_none(resource: Any) -> Any | None:
    audio = getattr(resource, "audio", None)
    return audio if audio is not None and _is_visible(audio) else None


def _public_model(schema: type[Any], resource: Any) -> Any:
    values = {column.name: getattr(resource, column.name) for column in resource.__table__.columns}
    if hasattr(resource, "audio"):
        values["audio"] = _visible_audio_or_none(resource)
    return schema.model_validate(values)


def _lesson_content(lesson: Lesson) -> LessonContentResponse:
    sections = [section for section in lesson.sections if _is_visible(section)]
    vocabularies = [
        _public_model(VocabularyResponse, vocabulary) for vocabulary in lesson.vocabularies if _is_visible(vocabulary)
    ]
    kanjis = [kanji for kanji in lesson.kanjis if _is_visible(kanji)]
    grammar_points = [grammar for grammar in lesson.grammar_points if _is_visible(grammar)]
    readings = [_public_model(ReadingResponse, reading) for reading in lesson.readings if _is_visible(reading)]

    # Example sentences are reusable and linked through vocabulary/grammar.
    # Deduplicate when one sentence is linked to both types of material.
    examples_by_id: dict[str, ExampleSentence] = {}
    for vocabulary in lesson.vocabularies:
        if not _is_visible(vocabulary):
            continue
        for sentence in vocabulary.example_sentences:
            if _is_visible(sentence):
                examples_by_id[sentence.id] = sentence
    for grammar in lesson.grammar_points:
        if not _is_visible(grammar):
            continue
        for sentence in grammar.example_sentences:
            if _is_visible(sentence):
                examples_by_id[sentence.id] = sentence
    example_sentences = [
        _public_model(ExampleSentenceResponse, sentence)
        for sentence in sorted(examples_by_id.values(), key=lambda item: (item.created_at, item.id))
    ]

    return LessonContentResponse(
        lesson=LessonResponse.model_validate(lesson),
        sections=sections,
        vocabularies=vocabularies,
        kanjis=kanjis,
        grammar_points=grammar_points,
        example_sentences=example_sentences,
        readings=readings,
    )


def _get_published_lesson(db: Session, lesson_id: str) -> Lesson:
    lesson = (
        _published_lesson_query(db)
        .options(
            selectinload(Lesson.sections),
            selectinload(Lesson.vocabularies),
            selectinload(Lesson.kanjis),
            selectinload(Lesson.grammar_points),
            selectinload(Lesson.readings),
        )
        .filter(Lesson.id == lesson_id)
        .first()
    )
    if lesson is None:
        _not_found()
    return lesson


@router.get("/levels", response_model=list[LevelResponse])
def list_published_levels(
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    db: Session = Depends(get_db),
):
    return _published_level_query(db).order_by(Level.sequence, Level.id).offset(offset).limit(limit).all()


@router.get("/levels/{level_id}", response_model=LevelResponse)
def get_published_level(level_id: str, db: Session = Depends(get_db)):
    level = _published_level_query(db).filter(Level.id == level_id).first()
    if level is None:
        _not_found()
    return level


@router.get("/levels/{level_id}/courses", response_model=list[CourseResponse])
def list_published_courses(
    level_id: str,
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    db: Session = Depends(get_db),
):
    if _published_level_query(db).filter(Level.id == level_id).first() is None:
        _not_found()
    return (
        _published_course_query(db)
        .filter(Course.level_id == level_id)
        .order_by(Course.sequence, Course.id)
        .offset(offset)
        .limit(limit)
        .all()
    )


@router.get("/courses/{course_id}", response_model=CourseResponse)
def get_published_course(course_id: str, db: Session = Depends(get_db)):
    course = _published_course_query(db).filter(Course.id == course_id).first()
    if course is None:
        _not_found()
    return course


@router.get("/courses/{course_id}/units", response_model=list[UnitResponse])
def list_published_units(
    course_id: str,
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    db: Session = Depends(get_db),
):
    if _published_course_query(db).filter(Course.id == course_id).first() is None:
        _not_found()
    return (
        _published_unit_query(db)
        .filter(Unit.course_id == course_id)
        .order_by(Unit.sequence, Unit.id)
        .offset(offset)
        .limit(limit)
        .all()
    )


@router.get("/units/{unit_id}", response_model=UnitResponse)
def get_published_unit(unit_id: str, db: Session = Depends(get_db)):
    unit = _published_unit_query(db).filter(Unit.id == unit_id).first()
    if unit is None:
        _not_found()
    return unit


@router.get("/units/{unit_id}/lessons", response_model=list[LessonResponse])
def list_published_lessons(
    unit_id: str,
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    db: Session = Depends(get_db),
):
    if _published_unit_query(db).filter(Unit.id == unit_id).first() is None:
        _not_found()
    return (
        _published_lesson_query(db)
        .filter(Lesson.unit_id == unit_id)
        .order_by(Lesson.sequence, Lesson.id)
        .offset(offset)
        .limit(limit)
        .all()
    )


@router.get("/lessons/{lesson_id}", response_model=LessonDetailResponse)
def get_published_lesson(lesson_id: str, db: Session = Depends(get_db)):
    content = _lesson_content(_get_published_lesson(db, lesson_id))
    return LessonDetailResponse(**content.lesson.model_dump(), **content.model_dump(exclude={"lesson"}))


@router.get("/lessons/{lesson_id}/content", response_model=LessonContentResponse)
def get_published_lesson_content(lesson_id: str, db: Session = Depends(get_db)):
    return _lesson_content(_get_published_lesson(db, lesson_id))
