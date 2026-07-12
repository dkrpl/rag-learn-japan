"""drop deprecated non-MVP features

Revision ID: 000000000004
Revises: 000000000003
Create Date: 2026-07-12 01:00:00.000000

"""

from collections.abc import Sequence

from sqlalchemy import inspect, text

from alembic import op

# revision identifiers, used by Alembic.
revision: str = "000000000004"
down_revision: str | None = "000000000003"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


DROP_TABLES = [
    "user_simulation_attempt_questions",
    "user_simulation_attempt_sections",
    "user_simulation_attempts",
    "jlpt_simulation_questions",
    "jlpt_simulation_sections",
    "jlpt_simulations",
    "review_schedules",
    "user_mistakes",
    "user_masteries",
    "question_reviews",
    "lesson_vocabularies",
    "lesson_kanjis",
    "lesson_grammar_points",
    "example_sentences",
    "readings",
    "vocabularies",
    "kanjis",
    "grammar_points",
    "audio_assets",
    "background_jobs",
]


def _tables() -> set[str]:
    return set(inspect(op.get_bind()).get_table_names())


def _columns(table_name: str) -> set[str]:
    if table_name not in _tables():
        return set()
    return {column["name"] for column in inspect(op.get_bind()).get_columns(table_name)}


def _drop_fk_for_column(table_name: str, column_name: str) -> None:
    bind = op.get_bind()
    for fk in inspect(bind).get_foreign_keys(table_name):
        if column_name in fk.get("constrained_columns", []):
            name = fk.get("name")
            if name:
                op.drop_constraint(name, table_name, type_="foreignkey")


def _drop_column_if_exists(table_name: str, column_name: str) -> None:
    if column_name not in _columns(table_name):
        return
    _drop_fk_for_column(table_name, column_name)
    op.drop_column(table_name, column_name)


def upgrade() -> None:
    bind = op.get_bind()
    if bind.dialect.name == "mysql":
        bind.execute(text("SET FOREIGN_KEY_CHECKS=0"))
    try:
        for table_name in DROP_TABLES:
            if table_name in _tables():
                op.drop_table(table_name)

        _drop_column_if_exists("questions", "reading_id")
        _drop_column_if_exists("questions", "audio_asset_id")
        _drop_column_if_exists("questions", "reviewed_by")
        _drop_column_if_exists("question_revisions", "reading_id")
        _drop_column_if_exists("question_revisions", "audio_asset_id")

        if "questions" in _tables():
            bind.execute(text("UPDATE questions SET question_type='MULTIPLE_CHOICE', skill='READING'"))
            bind.execute(text("UPDATE questions SET status='AUTO_VALIDATED' WHERE status NOT IN ('AUTO_VALIDATED','PUBLISHED','ARCHIVED')"))
        if "question_revisions" in _tables():
            bind.execute(text("UPDATE question_revisions SET question_type='MULTIPLE_CHOICE', skill='READING'"))
        if "learning_sessions" in _tables() and "source" in _columns("learning_sessions"):
            bind.execute(text("UPDATE learning_sessions SET source='LESSON' WHERE source IN ('REVIEW','MISTAKE')"))
        if "generation_jobs" in _tables() and "job_type" in _columns("generation_jobs"):
            bind.execute(
                text(
                    "UPDATE generation_jobs SET job_type='QUESTION_GENERATION' "
                    "WHERE job_type IN ('TTS_GENERATION','ADAPTIVE_EVALUATION_GENERATION')"
                )
            )
        if "users" in _tables() and "role" in _columns("users"):
            bind.execute(text("UPDATE users SET role='content_editor' WHERE role='reviewer'"))
    finally:
        if bind.dialect.name == "mysql":
            bind.execute(text("SET FOREIGN_KEY_CHECKS=1"))


def downgrade() -> None:
    # Deprecated features are intentionally not recreated. The previous schema can
    # be restored from backup if a rollback to the old product scope is required.
    pass
