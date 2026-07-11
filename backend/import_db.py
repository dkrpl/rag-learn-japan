"""Reset/import the local database and seed demo data.

This script intentionally reads DATABASE_URL from .env/environment. It refuses
non-local MySQL hosts by default so production databases are not dropped by
accident.

Usage:
    python import_db.py --yes
    python import_db.py --yes --allow-non-local
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path

from sqlalchemy import create_engine, text
from sqlalchemy.engine import make_url

PROJECT_ROOT = Path(__file__).resolve().parent


def _masked_url(url) -> str:
    if url.password:
        return str(url).replace(url.password, "***")
    return str(url)


def _confirm(yes: bool, database_name: str, masked_url: str) -> None:
    if yes:
        return
    print(f"Target database: {database_name}")
    print(f"URL: {masked_url}")
    answer = input("Type RESET to drop and recreate this database: ")
    if answer != "RESET":
        raise SystemExit("Cancelled.")


def _ensure_safe_target(url, allow_non_local: bool) -> None:
    if url.get_backend_name() != "mysql":
        return
    host = url.host or ""
    if allow_non_local:
        return
    if host not in {"localhost", "127.0.0.1", "::1"}:
        raise SystemExit(
            "Refusing to reset a non-local MySQL host. Re-run with --allow-non-local only if this is intentional."
        )


def _reset_mysql_database(url) -> None:
    database_name = url.database
    if not database_name:
        raise SystemExit("DATABASE_URL must include a database name.")

    admin_url = url.set(database=None)
    engine = create_engine(admin_url, pool_pre_ping=True)
    with engine.begin() as conn:
        conn.execute(text(f"DROP DATABASE IF EXISTS `{database_name}`"))
        conn.execute(text(f"CREATE DATABASE `{database_name}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"))


def _reset_sqlite_database(url) -> None:
    database = url.database
    if database and database not in {":memory:"}:
        db_path = Path(database)
        if not db_path.is_absolute():
            db_path = PROJECT_ROOT / db_path
        db_path.unlink(missing_ok=True)


def _run(command: list[str], env: dict[str, str]) -> None:
    result = subprocess.run(command, cwd=PROJECT_ROOT, env=env, text=True, check=False)
    if result.returncode != 0:
        raise SystemExit(result.returncode)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--yes", action="store_true", help="Skip interactive confirmation.")
    parser.add_argument("--allow-non-local", action="store_true", help="Allow resetting a non-local MySQL host.")
    args = parser.parse_args()

    from app.core.config import settings

    url = make_url(settings.DATABASE_URL)
    _ensure_safe_target(url, args.allow_non_local)
    _confirm(args.yes, url.database or "<memory>", _masked_url(url))

    if url.get_backend_name() == "mysql":
        _reset_mysql_database(url)
    elif url.get_backend_name() == "sqlite":
        _reset_sqlite_database(url)
    else:
        raise SystemExit(f"Unsupported database backend: {url.get_backend_name()}")

    env = os.environ.copy()
    env["DATABASE_URL"] = settings.DATABASE_URL
    _run([sys.executable, "-m", "alembic", "upgrade", "head"], env)
    _run([sys.executable, "scripts/seed_dummy_data.py"], env)
    print("Database import/reset complete.")


if __name__ == "__main__":
    main()
