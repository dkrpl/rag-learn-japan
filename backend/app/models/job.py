import enum
import uuid

from sqlalchemy import JSON, Column, DateTime, Enum, ForeignKey, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base_class import Base


class JobType(str, enum.Enum):
    AI_QUESTION_GENERATION = "AI_QUESTION_GENERATION"
    TTS_AUDIO_GENERATION = "TTS_AUDIO_GENERATION"


class JobStatus(str, enum.Enum):
    PENDING = "PENDING"
    IN_PROGRESS = "IN_PROGRESS"
    COMPLETED = "COMPLETED"
    FAILED = "FAILED"
    CANCELLED = "CANCELLED"


class BackgroundJob(Base):
    __tablename__ = "background_jobs"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    job_type = Column(Enum(JobType), nullable=False)
    status = Column(Enum(JobStatus), default=JobStatus.PENDING, nullable=False)
    target_id = Column(String(36), nullable=True)  # e.g. question_id for TTS
    celery_task_id = Column(String(255), nullable=True)

    # meta_data can store token/cost, provider usage, latency, failure reason, partial results
    meta_data = Column(JSON, nullable=True)

    created_by_id = Column(String(36), ForeignKey("users.id"), nullable=False)

    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), onupdate=func.now(), nullable=True)
    completed_at = Column(DateTime(timezone=True), nullable=True)

    created_by = relationship("User", foreign_keys=[created_by_id])
