"""Learning-session persistence and immutable question references."""

from __future__ import annotations

import enum
from datetime import datetime, timezone

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


class SessionMode(str, enum.Enum):
    PRACTICE = "PRACTICE"
    EXAM = "EXAM"


class SessionStatus(str, enum.Enum):
    ACTIVE = "ACTIVE"
    COMPLETED = "COMPLETED"
    CANCELLED = "CANCELLED"
    EXPIRED = "EXPIRED"


class SessionSource(str, enum.Enum):
    LESSON = "LESSON"
    REVIEW = "REVIEW"
    MISTAKE = "MISTAKE"


class LearningSession(CustomBase):
    __tablename__ = "learning_sessions"
    __table_args__ = (
        CheckConstraint("total_questions >= 0", name="ck_learning_sessions_total"),
        CheckConstraint("answered_questions >= 0", name="ck_learning_sessions_answered"),
        CheckConstraint("correct_answers >= 0", name="ck_learning_sessions_correct"),
        CheckConstraint("final_score BETWEEN 0 AND 100", name="ck_learning_sessions_score"),
        Index("ix_learning_sessions_user_status", "user_id", "status", "started_at"),
    )

    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    lesson_id = Column(String(36), ForeignKey("lessons.id", ondelete="CASCADE"), nullable=True)

    mode = Column(Enum(SessionMode), default=SessionMode.PRACTICE, nullable=False)
    source = Column(Enum(SessionSource), default=SessionSource.LESSON, nullable=False)
    status = Column(Enum(SessionStatus), default=SessionStatus.ACTIVE, nullable=False)

    total_questions = Column(Integer, default=0, nullable=False)
    answered_questions = Column(Integer, default=0, nullable=False)
    correct_answers = Column(Integer, default=0, nullable=False)
    final_score = Column(Integer, default=0, nullable=False)

    started_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), nullable=False)
    expires_at = Column(DateTime(timezone=True), nullable=False)
    completed_at = Column(DateTime(timezone=True), nullable=True)
    progress_processed_at = Column(DateTime(timezone=True), nullable=True)

    session_questions = relationship(
        "LearningSessionQuestion",
        back_populates="session",
        cascade="all, delete-orphan",
        order_by="LearningSessionQuestion.order_number",
    )


class LearningSessionQuestion(CustomBase):
    __tablename__ = "learning_session_questions"
    __table_args__ = (
        UniqueConstraint("session_id", "question_id", name="uq_session_question"),
        UniqueConstraint("session_id", "order_number", name="uq_session_question_order"),
        CheckConstraint("order_number > 0", name="ck_session_question_order"),
        CheckConstraint("score BETWEEN 0 AND 100", name="ck_session_question_score"),
        CheckConstraint("response_time_ms >= 0", name="ck_session_question_response_time"),
        Index("ix_session_questions_session_answered", "session_id", "is_answered"),
    )

    session_id = Column(String(36), ForeignKey("learning_sessions.id", ondelete="CASCADE"), nullable=False)
    question_id = Column(String(36), ForeignKey("questions.id", ondelete="RESTRICT"), nullable=False)
    question_revision_id = Column(String(36), ForeignKey("question_revisions.id", ondelete="RESTRICT"), nullable=False)

    order_number = Column(Integer, nullable=False)
    is_answered = Column(Boolean, default=False, nullable=False)
    user_answer_json = Column(JSON, nullable=True)
    is_correct = Column(Boolean, nullable=True)
    score = Column(Integer, default=0, nullable=False)
    response_time_ms = Column(Integer, default=0, nullable=False)
    feedback_notes = Column(Text, nullable=True)

    session = relationship("LearningSession", back_populates="session_questions")
    question = relationship("Question")
    question_revision = relationship("QuestionRevision")
