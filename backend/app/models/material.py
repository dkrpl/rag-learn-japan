from datetime import datetime, timezone

from sqlalchemy import Boolean, CheckConstraint, Column, DateTime, ForeignKey, Index, Integer, String, Text

from app.db.base_class import CustomBase


class MaterialDocument(CustomBase):
    """Admin-uploaded PDF source material used to generate learner quizzes."""

    __tablename__ = "material_documents"
    __table_args__ = (
        CheckConstraint("sequence >= 0", name="ck_material_documents_sequence_non_negative"),
        CheckConstraint("passing_score >= 0 AND passing_score <= 100", name="ck_material_documents_passing_score"),
        Index(
            "ix_material_documents_visibility_sequence",
            "is_published",
            "is_archived",
            "level",
            "sequence",
        ),
    )

    # Legacy compatibility only. New MVP flow is material-first and does not
    # require course/unit/lesson hierarchy.
    lesson_id = Column(String(36), nullable=True, index=True)
    title = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    level = Column(String(16), default="N5", server_default="N5", nullable=False)
    category = Column(String(100), nullable=True)
    sequence = Column(Integer, default=0, server_default="0", nullable=False)
    passing_score = Column(Integer, default=70, server_default="70", nullable=False)
    original_filename = Column(String(255), nullable=False)
    content_type = Column(String(100), default="application/pdf", nullable=False)
    file_size_bytes = Column(Integer, nullable=False)
    checksum = Column(String(64), nullable=False, index=True)
    storage_key = Column(String(512), nullable=True)
    page_count = Column(Integer, nullable=False, default=0)
    extracted_text = Column(Text, nullable=False)
    is_published = Column(Boolean, default=True, nullable=False)
    is_archived = Column(Boolean, default=False, server_default="0", nullable=False)
    published_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), nullable=True)
    archived_at = Column(DateTime(timezone=True), nullable=True)
    created_by_id = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
