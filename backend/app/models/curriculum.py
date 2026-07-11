from datetime import datetime, timezone

from sqlalchemy import (
    Boolean,
    CheckConstraint,
    Column,
    DateTime,
    ForeignKey,
    Index,
    Integer,
    String,
    Text,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship

from app.db.base_class import CustomBase


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


class PublicationMixin:
    """Shared, soft-delete-safe lifecycle for curriculum resources."""

    is_published = Column(Boolean, default=False, server_default="0", nullable=False)
    is_archived = Column(Boolean, default=False, server_default="0", nullable=False)
    published_at = Column(DateTime(timezone=True), nullable=True)
    archived_at = Column(DateTime(timezone=True), nullable=True)


class Level(PublicationMixin, CustomBase):
    """Proficiency level, for example JLPT N5 or N4."""

    __tablename__ = "levels"
    __table_args__ = (
        CheckConstraint("sequence >= 0", name="ck_levels_sequence_non_negative"),
        Index("ix_levels_visibility_sequence", "is_published", "is_archived", "sequence"),
    )

    code = Column(String(16), unique=True, index=True, nullable=True)
    name = Column(String(50), unique=True, index=True, nullable=False)
    description = Column(Text, nullable=True)
    sequence = Column(Integer, default=0, server_default="0", nullable=False)

    courses = relationship(
        "Course",
        back_populates="level",
        cascade="all, delete-orphan",
        order_by="Course.sequence",
    )


class Course(PublicationMixin, CustomBase):
    """A course within a proficiency level."""

    __tablename__ = "courses"
    __table_args__ = (
        UniqueConstraint("level_id", "title", name="uq_courses_level_title"),
        CheckConstraint("sequence >= 0", name="ck_courses_sequence_non_negative"),
        Index("ix_courses_parent_visibility_sequence", "level_id", "is_published", "is_archived", "sequence"),
    )

    level_id = Column(String(36), ForeignKey("levels.id", ondelete="CASCADE"), nullable=False)
    title = Column(String(255), nullable=False)
    slug = Column(String(255), unique=True, index=True, nullable=True)
    description = Column(Text, nullable=True)
    image_url = Column(String(512), nullable=True)
    sequence = Column(Integer, default=0, server_default="0", nullable=False)

    level = relationship("Level", back_populates="courses")
    units = relationship(
        "Unit",
        back_populates="course",
        cascade="all, delete-orphan",
        order_by="Unit.sequence",
    )


class Unit(PublicationMixin, CustomBase):
    """A module within a course."""

    __tablename__ = "units"
    __table_args__ = (
        UniqueConstraint("course_id", "title", name="uq_units_course_title"),
        CheckConstraint("sequence >= 0", name="ck_units_sequence_non_negative"),
        Index("ix_units_parent_visibility_sequence", "course_id", "is_published", "is_archived", "sequence"),
    )

    course_id = Column(String(36), ForeignKey("courses.id", ondelete="CASCADE"), nullable=False)
    title = Column(String(255), nullable=False)
    slug = Column(String(255), unique=True, index=True, nullable=True)
    description = Column(Text, nullable=True)
    sequence = Column(Integer, default=0, server_default="0", nullable=False)

    course = relationship("Course", back_populates="units")
    lessons = relationship(
        "Lesson",
        back_populates="unit",
        cascade="all, delete-orphan",
        order_by="Lesson.sequence",
    )


class Lesson(PublicationMixin, CustomBase):
    """An ordered learning lesson and its linked learning material."""

    __tablename__ = "lessons"
    __table_args__ = (
        UniqueConstraint("unit_id", "title", name="uq_lessons_unit_title"),
        CheckConstraint("sequence >= 0", name="ck_lessons_sequence_non_negative"),
        CheckConstraint("estimated_minutes > 0", name="ck_lessons_estimated_minutes_positive"),
        CheckConstraint("passing_score >= 0 AND passing_score <= 100", name="ck_lessons_passing_score_range"),
        Index("ix_lessons_parent_visibility_sequence", "unit_id", "is_published", "is_archived", "sequence"),
    )

    unit_id = Column(String(36), ForeignKey("units.id", ondelete="CASCADE"), nullable=False)
    title = Column(String(255), nullable=False)
    slug = Column(String(255), unique=True, index=True, nullable=True)
    summary = Column(Text, nullable=True)
    learning_objective = Column(Text, nullable=True)
    estimated_minutes = Column(Integer, default=15, server_default="15", nullable=False)
    passing_score = Column(Integer, default=70, server_default="70", nullable=False)
    sequence = Column(Integer, default=0, server_default="0", nullable=False)

    unit = relationship("Unit", back_populates="lessons")
    sections = relationship(
        "LessonSection",
        back_populates="lesson",
        cascade="all, delete-orphan",
        order_by="LessonSection.sequence",
    )

    # Association ordering is deliberately stored on the join rows so one
    # material can appear at a different position in different lessons.
    vocabularies = relationship(
        "Vocabulary",
        secondary="lesson_vocabularies",
        back_populates="lessons",
        order_by="lesson_vocabularies.c.sequence",
    )
    kanjis = relationship(
        "Kanji",
        secondary="lesson_kanjis",
        back_populates="lessons",
        order_by="lesson_kanjis.c.sequence",
    )
    grammar_points = relationship(
        "GrammarPoint",
        secondary="lesson_grammar_points",
        back_populates="lessons",
        order_by="lesson_grammar_points.c.sequence",
    )
    readings = relationship("Reading", back_populates="lesson", order_by="Reading.sequence")


class LessonSection(PublicationMixin, CustomBase):
    """A structured text section inside a lesson."""

    __tablename__ = "lesson_sections"
    __table_args__ = (
        UniqueConstraint("lesson_id", "sequence", name="uq_lesson_sections_lesson_sequence"),
        CheckConstraint("sequence >= 0", name="ck_lesson_sections_sequence_non_negative"),
        Index(
            "ix_lesson_sections_parent_visibility_sequence",
            "lesson_id",
            "is_published",
            "is_archived",
            "sequence",
        ),
    )

    lesson_id = Column(String(36), ForeignKey("lessons.id", ondelete="CASCADE"), nullable=False)
    section_type = Column(String(32), default="article", server_default="article", nullable=False)
    title = Column(String(255), nullable=False)
    content = Column(Text, nullable=True)
    sequence = Column(Integer, default=0, server_default="0", nullable=False)

    lesson = relationship("Lesson", back_populates="sections")
