from datetime import datetime, timezone

from sqlalchemy import Boolean, CheckConstraint, Column, DateTime, ForeignKey, Index, Integer, JSON, String
from sqlalchemy.orm import relationship

from app.db.base_class import CustomBase


class JlptSimulation(CustomBase):
    __tablename__ = "jlpt_simulations"
    __table_args__ = (
        CheckConstraint("passing_score >= 0 AND passing_score <= 180", name="ck_simulation_passing_score"),
        Index("ix_jlpt_simulations_level_published", "level", "is_published", "is_archived"),
    )

    title = Column(String(255), nullable=False)
    description = Column(String(500), nullable=True)
    level = Column(String(10), nullable=False)
    passing_score = Column(Integer, nullable=False, default=80)
    is_published = Column(Boolean, default=False, nullable=False)
    is_archived = Column(Boolean, default=False, nullable=False)
    published_at = Column(DateTime(timezone=True), nullable=True)

    sections = relationship(
        "JlptSimulationSection",
        back_populates="simulation",
        cascade="all, delete-orphan",
        order_by="JlptSimulationSection.sequence",
    )
    attempts = relationship("UserSimulationAttempt", back_populates="simulation")


class JlptSimulationSection(CustomBase):
    __tablename__ = "jlpt_simulation_sections"
    __table_args__ = (
        CheckConstraint("duration_minutes > 0", name="ck_simulation_section_duration"),
        CheckConstraint("passing_score >= 0", name="ck_simulation_section_passing_score"),
        Index("uq_simulation_section_sequence", "simulation_id", "sequence", unique=True),
    )

    simulation_id = Column(String(36), ForeignKey("jlpt_simulations.id", ondelete="CASCADE"), nullable=False)
    title = Column(String(255), nullable=False)
    section_type = Column(String(50), nullable=False)
    sequence = Column(Integer, nullable=False, default=1)
    duration_minutes = Column(Integer, nullable=False)
    passing_score = Column(Integer, nullable=False, default=19)

    simulation = relationship("JlptSimulation", back_populates="sections")
    questions = relationship(
        "JlptSimulationQuestion",
        back_populates="section",
        cascade="all, delete-orphan",
        order_by="JlptSimulationQuestion.order_number",
    )


class JlptSimulationQuestion(CustomBase):
    __tablename__ = "jlpt_simulation_questions"
    __table_args__ = (
        Index("uq_simulation_question_order", "section_id", "order_number", unique=True),
        Index("uq_simulation_question", "section_id", "question_id", unique=True),
    )

    section_id = Column(String(36), ForeignKey("jlpt_simulation_sections.id", ondelete="CASCADE"), nullable=False)
    question_id = Column(String(36), ForeignKey("questions.id", ondelete="RESTRICT"), nullable=False)
    order_number = Column(Integer, nullable=False)

    section = relationship("JlptSimulationSection", back_populates="questions")


class UserSimulationAttemptSection(CustomBase):
    __tablename__ = "user_simulation_attempt_sections"
    __table_args__ = (
        CheckConstraint(
            "status IN ('NOT_STARTED','IN_PROGRESS','COMPLETED','EXPIRED')",
            name="ck_attempt_section_status",
        ),
        Index("uq_attempt_section", "attempt_id", "section_id", unique=True),
    )

    attempt_id = Column(String(36), ForeignKey("user_simulation_attempts.id", ondelete="CASCADE"), nullable=False)
    section_id = Column(String(36), ForeignKey("jlpt_simulation_sections.id", ondelete="RESTRICT"), nullable=False)
    status = Column(String(50), default="NOT_STARTED", nullable=False)
    started_at = Column(DateTime(timezone=True), nullable=True)
    completed_at = Column(DateTime(timezone=True), nullable=True)
    score = Column(Integer, default=0, nullable=False)
    correct_count = Column(Integer, default=0, nullable=False)
    question_count = Column(Integer, default=0, nullable=False)
    is_passed = Column(Boolean, default=False, nullable=False)

    attempt = relationship("UserSimulationAttempt", back_populates="attempt_sections")
    section = relationship("JlptSimulationSection")
    attempt_questions = relationship(
        "UserSimulationAttemptQuestion",
        back_populates="attempt_section",
        cascade="all, delete-orphan",
        order_by="UserSimulationAttemptQuestion.order_number",
    )


class UserSimulationAttemptQuestion(CustomBase):
    __tablename__ = "user_simulation_attempt_questions"
    __table_args__ = (
        Index("uq_attempt_question", "attempt_section_id", "question_id", unique=True),
        Index("uq_attempt_question_order", "attempt_section_id", "order_number", unique=True),
    )

    attempt_id = Column(String(36), ForeignKey("user_simulation_attempts.id", ondelete="CASCADE"), nullable=False)
    attempt_section_id = Column(
        String(36),
        ForeignKey("user_simulation_attempt_sections.id", ondelete="CASCADE"),
        nullable=False,
    )
    question_id = Column(String(36), ForeignKey("questions.id", ondelete="RESTRICT"), nullable=False)
    question_revision_id = Column(String(36), ForeignKey("question_revisions.id", ondelete="RESTRICT"), nullable=False)
    order_number = Column(Integer, nullable=False)
    is_answered = Column(Boolean, default=False, nullable=False)
    is_correct = Column(Boolean, default=False, nullable=False)
    score = Column(Integer, default=0, nullable=False)
    answer_data_json = Column(JSON, nullable=True)
    response_time_ms = Column(Integer, nullable=True)

    attempt = relationship("UserSimulationAttempt", back_populates="attempt_questions")
    attempt_section = relationship("UserSimulationAttemptSection", back_populates="attempt_questions")
    question_revision = relationship("QuestionRevision")


class UserSimulationAttempt(CustomBase):
    __tablename__ = "user_simulation_attempts"
    __table_args__ = (
        CheckConstraint(
            "status IN ('STARTED','IN_PROGRESS','COMPLETED','EXPIRED','CANCELLED')",
            name="ck_simulation_attempt_status",
        ),
        Index("ix_simulation_attempt_user_status", "user_id", "status"),
        Index("ix_simulation_attempt_simulation", "simulation_id", "created_at"),
    )

    user_id = Column(String(36), ForeignKey("users.id", ondelete="RESTRICT"), nullable=False)
    simulation_id = Column(String(36), ForeignKey("jlpt_simulations.id", ondelete="RESTRICT"), nullable=False)
    status = Column(String(50), default="STARTED", nullable=False)
    started_at = Column(DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))
    completed_at = Column(DateTime(timezone=True), nullable=True)
    cancelled_at = Column(DateTime(timezone=True), nullable=True)
    total_score = Column(Integer, default=0, nullable=False)
    correct_count = Column(Integer, default=0, nullable=False)
    question_count = Column(Integer, default=0, nullable=False)
    is_passed = Column(Boolean, default=False, nullable=False)

    user = relationship("User")
    simulation = relationship("JlptSimulation", back_populates="attempts")
    attempt_sections = relationship(
        "UserSimulationAttemptSection",
        back_populates="attempt",
        cascade="all, delete-orphan",
    )
    attempt_questions = relationship(
        "UserSimulationAttemptQuestion",
        back_populates="attempt",
        cascade="all, delete-orphan",
    )
