"""initial current schema

Revision ID: 000000000001
Revises: 69e963bb7b7b
Create Date: 2026-07-11 00:00:00.000000

"""

from collections.abc import Sequence

from alembic import op
from app.db.base import Base

# revision identifiers, used by Alembic.
revision: str = "000000000001"
down_revision: str | None = "69e963bb7b7b"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    bind = op.get_bind()
    Base.metadata.create_all(bind=bind)


def downgrade() -> None:
    bind = op.get_bind()
    Base.metadata.drop_all(bind=bind)
