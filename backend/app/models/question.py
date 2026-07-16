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
    UniqueConstraint,
)
from sqlalchemy.orm import relationship

from app.db.base_class import CustomBase


class QuestionType(str, enum.Enum):
    """Canonical MVP question type: AI-generated reading multiple choice."""

    MULTIPLE_CHOICE = "MULTIPLE_CHOICE"


class SkillType(str, enum.Enum):
    READING = "READING"


class QuestionStatus(str, enum.Enum):
    AUTO_VALIDATED = "AUTO_VALIDATED"
    PUBLISHED = "PUBLISHED"
    ARCHIVED = "ARCHIVED"


class Question(CustomBase):
    __tablename__ = "questions"
    __table_args__ = (
        CheckConstraint("difficulty BETWEEN 1 AND 5", name="ck_questions_difficulty"),
        Index("ix_questions_material_selection", "material_id", "status", "skill", "difficulty"),
        Index("ix_questions_status_updated", "status", "updated_at"),
    )

    material_id = Column(String(36), ForeignKey("material_documents.id", ondelete="CASCADE"), nullable=True, index=True)
    # Legacy compatibility only. New MVP flow uses material_id.
    lesson_id = Column(String(36), nullable=True)
    question_type = Column(Enum(QuestionType), nullable=False)
    skill = Column(Enum(SkillType), nullable=False)
    difficulty = Column(Integer, default=1, nullable=False)

    prompt_json = Column(JSON, nullable=False)
    answer_key_json = Column(JSON, nullable=False)
    explanation_json = Column(JSON, nullable=True)

    status = Column(Enum(QuestionStatus), default=QuestionStatus.AUTO_VALIDATED, nullable=False)
    is_ai_generated = Column(Boolean, default=False, nullable=False)
    version_number = Column(Integer, default=1, nullable=False)
    published_at = Column(DateTime(timezone=True), nullable=True)

    created_by = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)

    revisions = relationship(
        "QuestionRevision",
        back_populates="question",
        cascade="all, delete-orphan",
        order_by="QuestionRevision.version_number",
    )

class QuestionRevision(CustomBase):
    """Immutable question snapshot used by learning attempts."""

    __tablename__ = "question_revisions"
    __table_args__ = (
        UniqueConstraint("question_id", "version_number", name="uq_question_revision_version"),
        Index("ix_question_revisions_question", "question_id", "version_number"),
    )

    question_id = Column(String(36), ForeignKey("questions.id", ondelete="CASCADE"), nullable=False)
    version_number = Column(Integer, nullable=False)

    material_id = Column(String(36), nullable=True)
    lesson_id = Column(String(36), nullable=True)
    question_type = Column(Enum(QuestionType), nullable=False)
    skill = Column(Enum(SkillType), nullable=False)
    difficulty = Column(Integer, nullable=False)
    prompt_json = Column(JSON, nullable=False)
    answer_key_json = Column(JSON, nullable=False)
    explanation_json = Column(JSON, nullable=True)

    created_by = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)

    question = relationship("Question", back_populates="revisions")
