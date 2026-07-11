import enum
from datetime import datetime, timezone

from sqlalchemy import Column, DateTime, Enum, ForeignKey, Integer, String, Text

from app.db.base_class import CustomBase


class JobStatus(str, enum.Enum):
    PENDING = "PENDING"
    PROCESSING = "PROCESSING"
    COMPLETED = "COMPLETED"
    FAILED = "FAILED"
    CANCELLED = "CANCELLED"


class JobType(str, enum.Enum):
    QUESTION_GENERATION = "QUESTION_GENERATION"
    TTS_GENERATION = "TTS_GENERATION"


class GenerationJob(CustomBase):
    __tablename__ = "generation_jobs"

    job_type = Column(Enum(JobType), nullable=False)
    status = Column(Enum(JobStatus), default=JobStatus.PENDING, nullable=False)

    celery_task_id = Column(String(255), nullable=True, index=True)
    target_id = Column(String(36), nullable=True)  # ID target terkait, misal ID question untuk TTS

    prompt_json = Column(Text, nullable=False)  # Payload configuration
    raw_response = Column(Text, nullable=True)  # Raw AI response

    error_message = Column(Text, nullable=True)
    tokens_used = Column(Integer, default=0)

    created_by = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    started_at = Column(DateTime(timezone=True), nullable=True)
    completed_at = Column(DateTime(timezone=True), nullable=True)


class AuditLog(CustomBase):
    __tablename__ = "audit_logs"

    user_id = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    action = Column(String(255), nullable=False)
    entity_name = Column(String(100), nullable=False)
    entity_id = Column(String(36), nullable=False)
    details = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
