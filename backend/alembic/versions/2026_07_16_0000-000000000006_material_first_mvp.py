"""material first MVP schema

Revision ID: 000000000006
Revises: 000000000005
Create Date: 2026-07-16 00:00:00.000000

"""

from collections.abc import Sequence

import sqlalchemy as sa
from sqlalchemy import inspect, text

from alembic import op

# revision identifiers, used by Alembic.
revision: str = "000000000006"
down_revision: str | None = "000000000005"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def _tables() -> set[str]:
    return set(inspect(op.get_bind()).get_table_names())


def _columns(table_name: str) -> set[str]:
    if table_name not in _tables():
        return set()
    return {column["name"] for column in inspect(op.get_bind()).get_columns(table_name)}


def _indexes(table_name: str) -> set[str]:
    if table_name not in _tables():
        return set()
    return {index["name"] for index in inspect(op.get_bind()).get_indexes(table_name)}


def _add_column_if_missing(table_name: str, column: sa.Column) -> None:
    if column.name not in _columns(table_name):
        op.add_column(table_name, column)


def _drop_fk_for_column(table_name: str, column_name: str) -> None:
    if table_name not in _tables():
        return
    for fk in inspect(op.get_bind()).get_foreign_keys(table_name):
        if column_name in fk.get("constrained_columns", []):
            name = fk.get("name")
            if name:
                op.drop_constraint(name, table_name, type_="foreignkey")


def _has_fk_for_column(table_name: str, column_name: str) -> bool:
    if table_name not in _tables():
        return False
    for fk in inspect(op.get_bind()).get_foreign_keys(table_name):
        if column_name in fk.get("constrained_columns", []):
            return True
    return False


def _drop_table_if_exists(table_name: str) -> None:
    if table_name in _tables():
        op.drop_table(table_name)


def _normalize_material_documents() -> None:
    bind = op.get_bind()
    _add_column_if_missing("material_documents", sa.Column("description", sa.Text(), nullable=True))
    _add_column_if_missing(
        "material_documents",
        sa.Column("level", sa.String(length=16), nullable=False, server_default="N5"),
    )
    _add_column_if_missing("material_documents", sa.Column("category", sa.String(length=100), nullable=True))
    _add_column_if_missing(
        "material_documents",
        sa.Column("sequence", sa.Integer(), nullable=False, server_default="0"),
    )
    _add_column_if_missing(
        "material_documents",
        sa.Column("passing_score", sa.Integer(), nullable=False, server_default="70"),
    )
    _add_column_if_missing(
        "material_documents",
        sa.Column("is_archived", sa.Boolean(), nullable=False, server_default=sa.false()),
    )
    _add_column_if_missing("material_documents", sa.Column("archived_at", sa.DateTime(timezone=True), nullable=True))

    if "lesson_id" in _columns("material_documents"):
        _drop_fk_for_column("material_documents", "lesson_id")
        if bind.dialect.name != "sqlite":
            op.alter_column(
                "material_documents",
                "lesson_id",
                existing_type=sa.String(length=36),
                nullable=True,
            )

    if "ix_material_documents_visibility_sequence" not in _indexes("material_documents"):
        op.create_index(
            "ix_material_documents_visibility_sequence",
            "material_documents",
            ["is_published", "is_archived", "level", "sequence"],
        )

    bind.execute(text("UPDATE material_documents SET level='N5' WHERE level IS NULL OR level=''"))
    bind.execute(text("UPDATE material_documents SET sequence=0 WHERE sequence IS NULL"))
    bind.execute(text("UPDATE material_documents SET passing_score=70 WHERE passing_score IS NULL"))


def _normalize_questions() -> None:
    _add_column_if_missing("questions", sa.Column("material_id", sa.String(length=36), nullable=True))
    _add_column_if_missing("question_revisions", sa.Column("material_id", sa.String(length=36), nullable=True))

    if "lesson_id" in _columns("questions"):
        _drop_fk_for_column("questions", "lesson_id")
        if op.get_bind().dialect.name != "sqlite":
            op.alter_column("questions", "lesson_id", existing_type=sa.String(length=36), nullable=True)
    if "lesson_id" in _columns("question_revisions") and op.get_bind().dialect.name != "sqlite":
        op.alter_column("question_revisions", "lesson_id", existing_type=sa.String(length=36), nullable=True)

    if "ix_questions_material_selection" not in _indexes("questions"):
        op.create_index(
            "ix_questions_material_selection",
            "questions",
            ["material_id", "status", "skill", "difficulty"],
        )
    if op.get_bind().dialect.name != "sqlite" and not _has_fk_for_column("questions", "material_id"):
        op.create_foreign_key(
            "fk_questions_material_id",
            "questions",
            "material_documents",
            ["material_id"],
            ["id"],
            ondelete="CASCADE",
        )

    bind = op.get_bind()
    if (
        bind.dialect.name == "mysql"
        and {"lesson_id", "material_id"}.issubset(_columns("questions"))
        and "lesson_id" in _columns("material_documents")
    ):
        bind.execute(
            text(
                """
                UPDATE questions q
                JOIN material_documents m ON m.lesson_id = q.lesson_id
                SET q.material_id = m.id
                WHERE q.material_id IS NULL
                """
            )
        )
    if bind.dialect.name == "mysql" and {"material_id", "question_id"}.issubset(_columns("question_revisions")):
        bind.execute(
            text(
                """
                UPDATE question_revisions qr
                JOIN questions q ON q.id = qr.question_id
                SET qr.material_id = q.material_id
                WHERE qr.material_id IS NULL
                """
            )
        )


def _normalize_learning_sessions() -> None:
    bind = op.get_bind()
    _add_column_if_missing("learning_sessions", sa.Column("material_id", sa.String(length=36), nullable=True))
    _add_column_if_missing(
        "learning_sessions",
        sa.Column("difficulty", sa.Integer(), nullable=False, server_default="1"),
    )
    _add_column_if_missing(
        "learning_sessions",
        sa.Column("passing_score", sa.Integer(), nullable=False, server_default="70"),
    )
    _add_column_if_missing(
        "learning_sessions",
        sa.Column("is_passed", sa.Boolean(), nullable=False, server_default=sa.false()),
    )
    _add_column_if_missing(
        "learning_sessions",
        sa.Column("earned_exp", sa.Integer(), nullable=False, server_default="0"),
    )

    if "lesson_id" in _columns("learning_sessions"):
        _drop_fk_for_column("learning_sessions", "lesson_id")
        if bind.dialect.name != "sqlite":
            op.alter_column("learning_sessions", "lesson_id", existing_type=sa.String(length=36), nullable=True)
    if bind.dialect.name != "sqlite" and not _has_fk_for_column("learning_sessions", "material_id"):
        op.create_foreign_key(
            "fk_learning_sessions_material_id",
            "learning_sessions",
            "material_documents",
            ["material_id"],
            ["id"],
            ondelete="CASCADE",
        )

    if (
        bind.dialect.name == "mysql"
        and {"lesson_id", "material_id"}.issubset(_columns("learning_sessions"))
        and "lesson_id" in _columns("material_documents")
    ):
        bind.execute(
            text(
                """
                UPDATE learning_sessions s
                JOIN material_documents m ON m.lesson_id = s.lesson_id
                SET s.material_id = m.id
                WHERE s.material_id IS NULL
                """
            )
        )
    if "source" in _columns("learning_sessions"):
        if bind.dialect.name != "sqlite":
            op.alter_column(
                "learning_sessions",
                "source",
                existing_type=sa.String(length=32),
                type_=sa.String(length=32),
                nullable=False,
            )
        bind.execute(text("UPDATE learning_sessions SET source='MATERIAL' WHERE material_id IS NOT NULL"))


def _create_user_material_progress() -> None:
    if "user_material_progress" in _tables():
        return
    op.create_table(
        "user_material_progress",
        sa.Column("user_id", sa.String(length=36), nullable=False),
        sa.Column("material_id", sa.String(length=36), nullable=False),
        sa.Column(
            "status",
            sa.Enum("NOT_STARTED", "IN_PROGRESS", "COMPLETED", name="materialprogressstatus"),
            nullable=False,
        ),
        sa.Column("attempts_count", sa.Integer(), nullable=False),
        sa.Column("best_score", sa.Integer(), nullable=False),
        sa.Column("last_score", sa.Integer(), nullable=False),
        sa.Column("id", sa.String(length=36), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.CheckConstraint("attempts_count >= 0", name="ck_material_progress_attempts"),
        sa.CheckConstraint("best_score BETWEEN 0 AND 100", name="ck_material_progress_best_score"),
        sa.CheckConstraint("last_score BETWEEN 0 AND 100", name="ck_material_progress_last_score"),
        sa.ForeignKeyConstraint(["material_id"], ["material_documents.id"], ondelete="CASCADE"),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("user_id", "material_id", name="uq_user_material_progress"),
    )
    op.create_index("ix_user_material_progress_id", "user_material_progress", ["id"])
    op.create_index("ix_material_progress_user_status", "user_material_progress", ["user_id", "status"])


def _migrate_progress_rows() -> None:
    bind = op.get_bind()
    if (
        bind.dialect.name != "mysql"
        or "user_lesson_progress" not in _tables()
        or "lesson_id" not in _columns("material_documents")
    ):
        return
    bind.execute(
        text(
            """
            INSERT INTO user_material_progress
                (id, user_id, material_id, status, attempts_count, best_score, last_score, created_at, updated_at)
            SELECT
                ulp.id, ulp.user_id, m.id, ulp.status, ulp.attempts_count, ulp.best_score, ulp.last_score,
                ulp.created_at, ulp.updated_at
            FROM user_lesson_progress ulp
            JOIN material_documents m ON m.lesson_id = ulp.lesson_id
            LEFT JOIN user_material_progress ump ON ump.user_id = ulp.user_id AND ump.material_id = m.id
            WHERE ump.id IS NULL
            """
        )
    )


def upgrade() -> None:
    bind = op.get_bind()
    if bind.dialect.name == "mysql":
        bind.execute(text("SET FOREIGN_KEY_CHECKS=0"))
    try:
        _normalize_material_documents()
        _normalize_questions()
        _normalize_learning_sessions()
        _create_user_material_progress()
        _migrate_progress_rows()

        for table_name in [
            "user_lesson_progress",
            "lesson_sections",
            "lessons",
            "units",
            "courses",
            "levels",
        ]:
            _drop_table_if_exists(table_name)
    finally:
        if bind.dialect.name == "mysql":
            bind.execute(text("SET FOREIGN_KEY_CHECKS=1"))


def downgrade() -> None:
    # The old course-first schema is intentionally not recreated. Restore from a
    # database backup if the product scope must roll back.
    pass
