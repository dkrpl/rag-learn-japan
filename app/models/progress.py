"""Progress, mastery, mistake-book, XP, and SRS persistence."""

from __future__ import annotations

import enum
from datetime import datetime, timezone

from sqlalchemy import (
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
from app.models.question import SkillType


class LessonStatus(str, enum.Enum):
    NOT_STARTED = "NOT_STARTED"
    IN_PROGRESS = "IN_PROGRESS"
    COMPLETED = "COMPLETED"


class UserLessonProgress(CustomBase):
    __tablename__ = "user_lesson_progress"
    __table_args__ = (
        UniqueConstraint("user_id", "lesson_id", name="uq_user_lesson_progress"),
        CheckConstraint("attempts_count >= 0", name="ck_lesson_progress_attempts"),
        CheckConstraint("best_score BETWEEN 0 AND 100", name="ck_lesson_progress_best_score"),
        CheckConstraint("last_score BETWEEN 0 AND 100", name="ck_lesson_progress_last_score"),
        Index("ix_lesson_progress_user_status", "user_id", "status"),
    )

    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    lesson_id = Column(String(36), ForeignKey("lessons.id", ondelete="CASCADE"), nullable=False)
    status = Column(Enum(LessonStatus), default=LessonStatus.NOT_STARTED, nullable=False)
    attempts_count = Column(Integer, default=0, nullable=False)
    best_score = Column(Integer, default=0, nullable=False)
    last_score = Column(Integer, default=0, nullable=False)


class UserMastery(CustomBase):
    __tablename__ = "user_masteries"
    __table_args__ = (
        UniqueConstraint("user_id", "skill", name="uq_user_mastery_skill"),
        CheckConstraint("mastery_level BETWEEN 0 AND 100", name="ck_user_mastery_level"),
        Index("ix_user_masteries_user_level", "user_id", "mastery_level"),
    )

    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    skill = Column(Enum(SkillType), nullable=False)
    mastery_level = Column(Integer, default=0, nullable=False)


class UserMistake(CustomBase):
    __tablename__ = "user_mistakes"
    __table_args__ = (
        UniqueConstraint("user_id", "question_id", name="uq_user_mistake_question"),
        CheckConstraint("mistake_count > 0", name="ck_user_mistake_count"),
        Index("ix_user_mistakes_user_resolved", "user_id", "is_resolved", "last_failed_at"),
    )

    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    question_id = Column(String(36), ForeignKey("questions.id", ondelete="CASCADE"), nullable=False)
    question_revision_id = Column(String(36), ForeignKey("question_revisions.id", ondelete="SET NULL"), nullable=True)
    mistake_count = Column(Integer, default=1, nullable=False)
    is_resolved = Column(Boolean, default=False, nullable=False)
    last_failed_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), nullable=False)
    last_succeeded_at = Column(DateTime(timezone=True), nullable=True)

    question = relationship("Question")
    question_revision = relationship("QuestionRevision")


class XPTransaction(CustomBase):
    __tablename__ = "xp_transactions"
    __table_args__ = (
        UniqueConstraint("session_id", name="uq_xp_transaction_session"),
        CheckConstraint("amount >= 0", name="ck_xp_transaction_amount"),
        Index("ix_xp_transactions_user_created", "user_id", "created_at"),
    )

    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    amount = Column(Integer, nullable=False)
    reason = Column(String(255), nullable=False)
    session_id = Column(String(36), ForeignKey("learning_sessions.id", ondelete="SET NULL"), nullable=True)


class ReviewSchedule(CustomBase):
    __tablename__ = "review_schedules"
    __table_args__ = (
        UniqueConstraint("user_id", "question_id", name="uq_review_schedule_question"),
        CheckConstraint("interval_days >= 0", name="ck_review_schedule_interval"),
        CheckConstraint("consecutive_correct >= 0", name="ck_review_schedule_streak"),
        Index("ix_review_schedules_user_due", "user_id", "next_review_date"),
    )

    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    question_id = Column(String(36), ForeignKey("questions.id", ondelete="CASCADE"), nullable=False)
    next_review_date = Column(DateTime(timezone=True), nullable=False)
    interval_days = Column(Integer, default=0, nullable=False)
    consecutive_correct = Column(Integer, default=0, nullable=False)
    last_reviewed_at = Column(DateTime(timezone=True), nullable=True)

    question = relationship("Question")
