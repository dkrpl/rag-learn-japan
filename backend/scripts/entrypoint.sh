#!/bin/sh
set -eu

if [ "${RUN_MIGRATIONS:-0}" = "1" ]; then
  python - <<'PY'
import os
import subprocess
import sys
import time
from urllib.parse import quote_plus

from sqlalchemy import create_engine, text
from sqlalchemy.engine import make_url


def normalize_database_url(value):
    if value.startswith("mysql://"):
        return value.replace("mysql://", "mysql+pymysql://", 1)
    return value


def resolve_database_url():
    database_url = os.getenv("DATABASE_URL", "")
    if database_url:
        return normalize_database_url(database_url)

    mysql_url = os.getenv("MYSQL_URL", "")
    if mysql_url:
        return normalize_database_url(mysql_url)

    host = os.getenv("MYSQLHOST", "")
    port = os.getenv("MYSQLPORT", "3306")
    user = os.getenv("MYSQLUSER", "")
    password = os.getenv("MYSQLPASSWORD", "")
    database = os.getenv("MYSQLDATABASE", "")
    if all((host, port, user, database)):
        return (
            f"mysql+pymysql://{quote_plus(user)}:{quote_plus(password)}"
            f"@{host}:{port}/{quote_plus(database)}"
        )
    return ""


database_url = resolve_database_url()
retries = int(os.getenv("DB_CONNECT_RETRIES", "60"))
delay = float(os.getenv("DB_CONNECT_RETRY_DELAY_SECONDS", "2"))

if not database_url:
    print("DATABASE_URL, MYSQL_URL, or MYSQLHOST/MYSQL* variables are not set", flush=True)
    sys.exit(1)

connect_args = {}
if database_url.startswith("mysql"):
    connect_args["connect_timeout"] = int(os.getenv("DB_CONNECT_TIMEOUT_SECONDS", "5"))

url = make_url(database_url)
target = f"{url.get_backend_name()}://{url.username or '<user>'}@{url.host or '<host>'}:{url.port or '<port>'}/{url.database or '<database>'}"
print(f"Database target: {target}", flush=True)
os.environ["DATABASE_URL"] = database_url

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

subprocess.run(["alembic", "upgrade", "head"], check=True, env=os.environ)

if os.getenv("RUN_SEED_DUMMY", "0") == "1":
    subprocess.run([sys.executable, "scripts/seed_dummy_data.py"], check=True, env=os.environ)
PY
fi

exec "$@"
