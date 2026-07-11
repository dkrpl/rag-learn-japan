"""Question-bank persistence models.

The JSON columns intentionally remain native JSON.  Learner-facing serialization is
handled by dedicated schemas/services so answer keys never leave the trusted side.
"""

from __future__ import annotations

import enum

from sqlalchemy import (
    JSON,
    Boolean,
    CheckConstraint,
    Column,
    DateTime,
    Enum,
    ForeignKey,
    Index,
    Integer,
    String,
    Text,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship

from app.db.base_class import CustomBase


class QuestionType(str, enum.Enum):
    """The ten canonical MVP question types from the PRD."""

    MULTIPLE_CHOICE = "MULTIPLE_CHOICE"
    CLOZE_MULTIPLE_CHOICE = "CLOZE_MULTIPLE_CHOICE"
    TRUE_FALSE = "TRUE_FALSE"
    MATCHING = "MATCHING"
    ORDERING = "ORDERING"
    KANJI_READING = "KANJI_READING"
    READING_COMPREHENSION = "READING_COMPREHENSION"
    LISTENING_MULTIPLE_CHOICE = "LISTENING_MULTIPLE_CHOICE"
    LISTENING_TRUE_FALSE = "LISTENING_TRUE_FALSE"
    LISTENING_WITH_IMAGE = "LISTENING_WITH_IMAGE"

    # Source-compatibility aliases. Values persisted to the database are canonical.
    CLOZE = "CLOZE_MULTIPLE_CHOICE"
    READING = "READING_COMPREHENSION"
    LISTENING = "LISTENING_MULTIPLE_CHOICE"


class SkillType(str, enum.Enum):
    VOCABULARY = "VOCABULARY"
    GRAMMAR = "GRAMMAR"
    READING = "READING"
    LISTENING = "LISTENING"


class QuestionStatus(str, enum.Enum):
    DRAFT = "DRAFT"
    AUTO_VALIDATED = "AUTO_VALIDATED"
    IN_REVIEW = "IN_REVIEW"
    NEEDS_REVISION = "NEEDS_REVISION"
    APPROVED = "APPROVED"
    PUBLISHED = "PUBLISHED"
    REJECTED = "REJECTED"
    ARCHIVED = "ARCHIVED"


class Question(CustomBase):
    __tablename__ = "questions"
    __table_args__ = (
        CheckConstraint("difficulty BETWEEN 1 AND 5", name="ck_questions_difficulty"),
        Index("ix_questions_selection", "lesson_id", "status", "skill", "difficulty"),
        Index("ix_questions_status_updated", "status", "updated_at"),
    )

    lesson_id = Column(String(36), ForeignKey("lessons.id", ondelete="CASCADE"), nullable=False)
    reading_id = Column(String(36), ForeignKey("readings.id", ondelete="SET NULL"), nullable=True)
    audio_asset_id = Column(String(36), ForeignKey("audio_assets.id", ondelete="SET NULL"), nullable=True)

    question_type = Column(Enum(QuestionType), nullable=False)
    skill = Column(Enum(SkillType), nullable=False)
    difficulty = Column(Integer, default=1, nullable=False)

    prompt_json = Column(JSON, nullable=False)
    answer_key_json = Column(JSON, nullable=False)
    explanation_json = Column(JSON, nullable=True)

    status = Column(Enum(QuestionStatus), default=QuestionStatus.DRAFT, nullable=False)
    is_ai_generated = Column(Boolean, default=False, nullable=False)
    version_number = Column(Integer, default=1, nullable=False)
    published_at = Column(DateTime(timezone=True), nullable=True)

    created_by = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    reviewed_by = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)

    reviews = relationship(
        "QuestionReview",
        back_populates="question",
        cascade="all, delete-orphan",
        order_by="QuestionReview.created_at",
    )
    revisions = relationship(
        "QuestionRevision",
        back_populates="question",
        cascade="all, delete-orphan",
        order_by="QuestionRevision.version_number",
    )


class QuestionReview(CustomBase):
    __tablename__ = "question_reviews"
    __table_args__ = (Index("ix_question_reviews_question_created", "question_id", "created_at"),)

    question_id = Column(String(36), ForeignKey("questions.id", ondelete="CASCADE"), nullable=False)
    reviewer_id = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    status_given = Column(Enum(QuestionStatus), nullable=False)
    notes = Column(Text, nullable=True)

    question = relationship("Question", back_populates="reviews")


class QuestionRevision(CustomBase):
    """Immutable question snapshot used by learning and simulation attempts."""

    __tablename__ = "question_revisions"
    __table_args__ = (
        UniqueConstraint("question_id", "version_number", name="uq_question_revision_version"),
        Index("ix_question_revisions_question", "question_id", "version_number"),
    )

    question_id = Column(String(36), ForeignKey("questions.id", ondelete="CASCADE"), nullable=False)
    version_number = Column(Integer, nullable=False)

    lesson_id = Column(String(36), nullable=False)
    reading_id = Column(String(36), nullable=True)
    audio_asset_id = Column(String(36), nullable=True)
    question_type = Column(Enum(QuestionType), nullable=False)
    skill = Column(Enum(SkillType), nullable=False)
    difficulty = Column(Integer, nullable=False)
    prompt_json = Column(JSON, nullable=False)
    answer_key_json = Column(JSON, nullable=False)
    explanation_json = Column(JSON, nullable=True)

    created_by = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)

    question = relationship("Question", back_populates="revisions")
