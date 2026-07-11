#!/bin/sh
set -eu

if [ "${RUN_MIGRATIONS:-0}" = "1" ]; then
  python - <<'PY'
import os
import sys
import time

from sqlalchemy import create_engine, text

database_url = os.getenv("DATABASE_URL")
retries = int(os.getenv("DB_CONNECT_RETRIES", "60"))
delay = float(os.getenv("DB_CONNECT_RETRY_DELAY_SECONDS", "2"))

if not database_url:
    print("DATABASE_URL is not set", flush=True)
    sys.exit(1)

connect_args = {}
if database_url.startswith("mysql"):
    connect_args["connect_timeout"] = int(os.getenv("DB_CONNECT_TIMEOUT_SECONDS", "5"))

last_error = None
for attempt in range(1, retries + 1):
    try:
        engine = create_engine(database_url, pool_pre_ping=True, connect_args=connect_args)
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))
        print("Database is reachable", flush=True)
        break
    except Exception as exc:
        last_error = exc
        print(f"Waiting for database ({attempt}/{retries}): {exc}", flush=True)
        time.sleep(delay)
else:
    print(f"Database did not become reachable: {last_error}", flush=True)
    sys.exit(1)
PY

  alembic upgrade head
fi

exec "$@"
