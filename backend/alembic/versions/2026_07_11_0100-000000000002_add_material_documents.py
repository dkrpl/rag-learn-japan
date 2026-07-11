"""add material documents

Revision ID: 000000000002
Revises: 000000000001
Create Date: 2026-07-11 01:00:00.000000

"""

from collections.abc import Sequence

from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, Text, inspect

from alembic import op

# revision identifiers, used by Alembic.
revision: str = "000000000002"
down_revision: str | None = "000000000001"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    bind = op.get_bind()
    if "material_documents" in inspect(bind).get_table_names():
        return

    op.create_table(
        "material_documents",
        Column("lesson_id", String(36), ForeignKey("lessons.id", ondelete="CASCADE"), nullable=False),
        Column("title", String(255), nullable=False),
        Column("original_filename", String(255), nullable=False),
        Column("content_type", String(100), nullable=False),
        Column("file_size_bytes", Integer, nullable=False),
        Column("checksum", String(64), nullable=False),
        Column("page_count", Integer, nullable=False),
        Column("extracted_text", Text, nullable=False),
        Column("created_by_id", String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True),
        Column("id", String(36), primary_key=True),
        Column("created_at", DateTime(timezone=True), nullable=False),
        Column("updated_at", DateTime(timezone=True), nullable=False),
    )
    op.create_index("ix_material_documents_lesson_id", "material_documents", ["lesson_id"])
    op.create_index("ix_material_documents_checksum", "material_documents", ["checksum"])
    op.create_index("ix_material_documents_id", "material_documents", ["id"])


def downgrade() -> None:
    bind = op.get_bind()
    if "material_documents" in inspect(bind).get_table_names():
        op.drop_table("material_documents")
