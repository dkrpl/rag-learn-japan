"""Create a MySQL backup using mysqldump.

This script intentionally shells out to `mysqldump` because it is the most
portable way to preserve schema, indexes, constraints, and data for Railway MySQL.

Required:
  DATABASE_URL or MYSQL_URL

Optional:
  BACKUP_DIR=backups
"""

from __future__ import annotations

import os
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import urlparse


def main() -> int:
    raw_url = os.getenv("DATABASE_URL") or os.getenv("MYSQL_URL")
    if not raw_url:
        raise RuntimeError("DATABASE_URL or MYSQL_URL is required")
    parsed = urlparse(raw_url.replace("mysql+pymysql://", "mysql://", 1))
    if parsed.scheme != "mysql":
        raise RuntimeError("Only MySQL backup is supported by this script")

    backup_dir = Path(os.getenv("BACKUP_DIR", "backups"))
    backup_dir.mkdir(parents=True, exist_ok=True)
    filename = backup_dir / f"nihongo-learn-{datetime.now(timezone.utc).strftime('%Y%m%d-%H%M%S')}.sql"
    database = parsed.path.lstrip("/")

    command = [
        "mysqldump",
        f"--host={parsed.hostname}",
        f"--port={parsed.port or 3306}",
        f"--user={parsed.username}",
        f"--password={parsed.password or ''}",
        "--single-transaction",
        "--routines",
        "--triggers",
        database,
    ]
    with filename.open("wb") as output:
        subprocess.run(command, check=True, stdout=output)
    print(f"Backup written to {filename}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
