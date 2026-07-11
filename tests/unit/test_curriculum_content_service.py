import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import Session

import app.db.base  # noqa: F401 - registers all model metadata
from app.db.base_class import Base
from app.models.content import Vocabulary
from app.models.curriculum import Course, Lesson, LessonSection, Level, Unit
from app.schemas.content import ContentImportRequest, VocabularyCreate
from app.services.curriculum_content_service import (
    PublicationValidationError,
    archive,
    import_content,
    publish,
    restore,
)


@pytest.fixture
def db():
    engine = create_engine("sqlite+pysqlite:///:memory:")
    Base.metadata.create_all(engine)
    with Session(engine) as session:
        yield session
    Base.metadata.drop_all(engine)


def curriculum_tree(db: Session):
    level = Level(code="N5", name="JLPT N5")
    db.add(level)
    db.flush()
    publish(level)
    course = Course(level_id=level.id, title="N5 Core")
    db.add(course)
    db.flush()
    publish(course)
    unit = Unit(course_id=course.id, title="Unit 1")
    db.add(unit)
    db.flush()
    publish(unit)
    lesson = Lesson(unit_id=unit.id, title="Lesson 1", learning_objective="Mampu memberi salam")
    db.add(lesson)
    db.flush()
    return level, course, unit, lesson


def test_lesson_publication_requires_objective_and_published_content(db):
    _, _, _, lesson = curriculum_tree(db)

    with pytest.raises(PublicationValidationError, match="published content"):
        publish(lesson)

    section = LessonSection(lesson_id=lesson.id, title="Salam", content="こんにちは")
    db.add(section)
    db.flush()
    publish(section)
    publish(lesson)

    assert lesson.is_published is True
    assert lesson.published_at is not None


def test_parent_archive_cascades_but_restore_does_not_republish(db):
    level, course, unit, lesson = curriculum_tree(db)
    section = LessonSection(lesson_id=lesson.id, title="Salam", content="こんにちは")
    db.add(section)
    db.flush()
    publish(section)
    publish(lesson)

    archive(level)

    assert all(resource.is_archived for resource in (level, course, unit, lesson, section))
    assert not any(resource.is_published for resource in (level, course, unit, lesson, section))

    restore(level)
    assert level.is_archived is False
    assert level.is_published is False
    assert course.is_archived is True


def test_json_import_is_idempotent_and_preserves_unicode(db):
    payload = ContentImportRequest(
        vocabularies=[
            VocabularyCreate(
                word="日本語",
                kana="にほんご",
                romaji="nihongo",
                meaning="Bahasa Jepang",
            )
        ]
    )

    first = import_content(db, payload)
    second = import_content(db, payload)

    assert first["created"]["vocabularies"] == 1
    assert second["unchanged"]["vocabularies"] == 1
    assert db.query(Vocabulary).filter(Vocabulary.word == "日本語").count() == 1


def test_import_dry_run_rolls_back_new_content(db):
    payload = ContentImportRequest(
        vocabularies=[VocabularyCreate(word="猫", kana="ねこ", meaning="Kucing")],
        dry_run=True,
    )

    result = import_content(db, payload)

    assert result["dry_run"] is True
    assert result["created"]["vocabularies"] == 1
    assert db.query(Vocabulary).count() == 0
