from sqlalchemy import Column, ForeignKey, Integer, String, Text

from app.db.base_class import CustomBase


class MaterialDocument(CustomBase):
    """Admin-uploaded source material used to generate lesson questions."""

    __tablename__ = "material_documents"

    lesson_id = Column(String(36), ForeignKey("lessons.id", ondelete="CASCADE"), nullable=False, index=True)
    title = Column(String(255), nullable=False)
    original_filename = Column(String(255), nullable=False)
    content_type = Column(String(100), default="application/pdf", nullable=False)
    file_size_bytes = Column(Integer, nullable=False)
    checksum = Column(String(64), nullable=False, index=True)
    storage_key = Column(String(512), nullable=True)
    page_count = Column(Integer, nullable=False, default=0)
    extracted_text = Column(Text, nullable=False)
    created_by_id = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
