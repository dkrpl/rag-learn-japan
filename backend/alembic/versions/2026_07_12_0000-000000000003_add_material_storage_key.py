"""add material storage key

Revision ID: 000000000003
Revises: 000000000002
Create Date: 2026-07-12 00:00:00.000000

"""

from collections.abc import Sequence

import sqlalchemy as sa
from sqlalchemy import inspect

from alembic import op

# revision identifiers, used by Alembic.
revision: str = "000000000003"
down_revision: str | None = "000000000002"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    bind = op.get_bind()
    columns = {column["name"] for column in inspect(bind).get_columns("material_documents")}
    if "storage_key" not in columns:
        op.add_column("material_documents", sa.Column("storage_key", sa.String(length=512), nullable=True))


def downgrade() -> None:
    bind = op.get_bind()
    columns = {column["name"] for column in inspect(bind).get_columns("material_documents")}
    if "storage_key" in columns:
        op.drop_column("material_documents", "storage_key")
