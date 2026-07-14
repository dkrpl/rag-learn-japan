import enum
import json
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


class GenerationJob(CustomBase):
    __tablename__ = "generation_jobs"

    job_type = Column(Enum(JobType), nullable=False)
    status = Column(Enum(JobStatus), default=JobStatus.PENDING, nullable=False)

    celery_task_id = Column(String(255), nullable=True, index=True)
    target_id = Column(String(36), nullable=True)

    prompt_json = Column(Text, nullable=False)  # Payload configuration
    raw_response = Column(Text, nullable=True)  # Raw AI response

    error_message = Column(Text, nullable=True)
    tokens_used = Column(Integer, default=0)

    created_by = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    started_at = Column(DateTime(timezone=True), nullable=True)
    completed_at = Column(DateTime(timezone=True), nullable=True)

    @property
    def created_question_count(self) -> int:
        if not self.raw_response:
            return 0
        try:
            payload = json.loads(self.raw_response)
        except json.JSONDecodeError:
            return 0
        ids = payload.get("created_question_ids") if isinstance(payload, dict) else None
        return len(ids) if isinstance(ids, list) else 0

    @property
    def can_retry(self) -> bool:
        return self.status in {JobStatus.COMPLETED, JobStatus.FAILED, JobStatus.CANCELLED}

    @property
    def status_label(self) -> str:
        labels = {
            JobStatus.PENDING: "Menunggu antrean",
            JobStatus.PROCESSING: "Sedang membuat soal",
            JobStatus.COMPLETED: "Selesai",
            JobStatus.FAILED: "Gagal",
            JobStatus.CANCELLED: "Dibatalkan",
        }
        return labels[self.status]

    @property
    def status_message(self) -> str:
        if self.status == JobStatus.FAILED:
            return self.error_message or "AI gagal membuat soal. Silakan coba lagi."
        if self.status == JobStatus.COMPLETED:
            count = self.created_question_count
            return f"{count} soal berhasil dibuat." if count else "Job selesai."
        if self.status == JobStatus.PROCESSING:
            return "AI sedang membaca materi PDF dan membuat soal."
        if self.status == JobStatus.CANCELLED:
            return "Job dibatalkan."
        return "Job masuk antrean dan akan segera diproses."


class AuditLog(CustomBase):
    __tablename__ = "audit_logs"

    user_id = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    action = Column(String(255), nullable=False)
    entity_name = Column(String(100), nullable=False)
    entity_id = Column(String(36), nullable=False)
    details = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
