"""legacy Railway migration anchor

Revision ID: 69e963bb7b7b
Revises:
Create Date: 2026-07-11 00:00:00.000000

This no-op revision keeps existing deployments that already recorded the old
pre-squash migration id in alembic_version upgradeable without resetting data.
"""

from collections.abc import Sequence

# revision identifiers, used by Alembic.
revision: str = "69e963bb7b7b"
down_revision: str | None = None
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
