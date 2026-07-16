"""Production readiness fields and constraints.

Revision ID: 000000000007
Revises: 000000000006
Create Date: 2026-07-16
"""

from __future__ import annotations

import sqlalchemy as sa
from alembic import op
from sqlalchemy import inspect

revision = "000000000007"
down_revision = "000000000006"
branch_labels = None
depends_on = None


def _has_column(table_name: str, column_name: str) -> bool:
    bind = op.get_bind()
    inspector = inspect(bind)
    return column_name in {column["name"] for column in inspector.get_columns(table_name)}


def _constraint_names(table_name: str) -> set[str]:
    bind = op.get_bind()
    inspector = inspect(bind)
    names: set[str] = set()
    for constraint in inspector.get_unique_constraints(table_name):
        if constraint.get("name"):
            names.add(str(constraint["name"]))
    return names


def upgrade() -> None:
    if not _has_column("xp_transactions", "material_id"):
        op.add_column("xp_transactions", sa.Column("material_id", sa.String(length=36), nullable=True))
        op.create_foreign_key(
            "fk_xp_transactions_material_id_material_documents",
            "xp_transactions",
            "material_documents",
            ["material_id"],
            ["id"],
            ondelete="CASCADE",
        )

    if "uq_xp_transaction_material_reward" not in _constraint_names("xp_transactions"):
        op.create_unique_constraint(
            "uq_xp_transaction_material_reward",
            "xp_transactions",
            ["user_id", "material_id", "reason"],
        )


def downgrade() -> None:
    constraints = _constraint_names("xp_transactions")
    if "uq_xp_transaction_material_reward" in constraints:
        op.drop_constraint("uq_xp_transaction_material_reward", "xp_transactions", type_="unique")
    if _has_column("xp_transactions", "material_id"):
        op.drop_constraint("fk_xp_transactions_material_id_material_documents", "xp_transactions", type_="foreignkey")
        op.drop_column("xp_transactions", "material_id")
