"""initial current schema

Revision ID: 000000000001
Revises: 69e963bb7b7b
Create Date: 2026-07-11 00:00:00.000000

"""

from collections.abc import Sequence

from sqlalchemy import String, inspect, text

from alembic import op
from app.db.base import Base

# revision identifiers, used by Alembic.
revision: str = "000000000001"
down_revision: str | None = "69e963bb7b7b"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def _normalize_mysql_uuid_columns(bind) -> None:
    """Align legacy MySQL UUID columns before creating new foreign keys.

    Some Railway databases were created from an older migration chain whose
    string id columns used different length/collation metadata. MySQL requires
    referencing and referenced string columns to match for foreign keys.
    """

    if bind.dialect.name != "mysql":
        return

    inspector = inspect(bind)
    existing_tables = set(inspector.get_table_names())
    if not existing_tables:
        return

    bind.execute(text("SET FOREIGN_KEY_CHECKS=0"))
    try:
        for table in Base.metadata.sorted_tables:
            if table.name not in existing_tables:
                continue
            existing_columns = {column["name"] for column in inspector.get_columns(table.name)}
            for column in table.columns:
                if column.name not in existing_columns:
                    continue
                if not isinstance(column.type, String) or column.type.length != 36:
                    continue

                nullable = "NULL" if column.nullable else "NOT NULL"
                bind.execute(
                    text(
                        f"ALTER TABLE `{table.name}` "
                        f"MODIFY `{column.name}` VARCHAR(36) "
                        f"CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci {nullable}"
                    )
                )
    finally:
        bind.execute(text("SET FOREIGN_KEY_CHECKS=1"))


def upgrade() -> None:
    bind = op.get_bind()
    _normalize_mysql_uuid_columns(bind)
    Base.metadata.create_all(bind=bind)


def downgrade() -> None:
    bind = op.get_bind()
    Base.metadata.drop_all(bind=bind)
