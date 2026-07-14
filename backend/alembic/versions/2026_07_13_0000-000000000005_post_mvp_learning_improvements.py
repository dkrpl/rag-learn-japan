"""post MVP learning improvements

Revision ID: 000000000005
Revises: 000000000004
Create Date: 2026-07-13 00:00:00.000000

"""

from collections.abc import Sequence

import sqlalchemy as sa
from sqlalchemy import inspect, text

from alembic import op

# revision identifiers, used by Alembic.
revision: str = "000000000005"
down_revision: str | None = "000000000004"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def _has_column(table_name: str, column_name: str) -> bool:
    bind = op.get_bind()
    if table_name not in inspect(bind).get_table_names():
        return False
    return column_name in {column["name"] for column in inspect(bind).get_columns(table_name)}


def upgrade() -> None:
    bind = op.get_bind()
    if not _has_column("material_documents", "is_published"):
        op.add_column(
            "material_documents",
            sa.Column("is_published", sa.Boolean(), nullable=False, server_default=sa.true()),
        )
        op.create_index(
            "ix_material_documents_lesson_published",
            "material_documents",
            ["lesson_id", "is_published", "created_at"],
        )
    if not _has_column("material_documents", "published_at"):
        op.add_column("material_documents", sa.Column("published_at", sa.DateTime(timezone=True), nullable=True))
        bind.execute(text("UPDATE material_documents SET published_at = created_at WHERE published_at IS NULL"))


def downgrade() -> None:
    bind = op.get_bind()
    indexes = {index["name"] for index in inspect(bind).get_indexes("material_documents")}
    if "ix_material_documents_lesson_published" in indexes:
        op.drop_index("ix_material_documents_lesson_published", table_name="material_documents")
    if _has_column("material_documents", "published_at"):
        op.drop_column("material_documents", "published_at")
    if _has_column("material_documents", "is_published"):
        op.drop_column("material_documents", "is_published")
