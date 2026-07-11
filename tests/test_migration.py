import os
import subprocess
import sys

import pytest


@pytest.mark.no_db_reset
def test_alembic_upgrade_head_on_dedicated_mysql_database():
    database_url = os.getenv("TEST_DATABASE_URL")
    if not database_url or not database_url.startswith("mysql"):
        pytest.skip("Set TEST_DATABASE_URL to a disposable MySQL database for migration validation")

    environment = os.environ.copy()
    environment["DATABASE_URL"] = database_url
    result = subprocess.run(
        [sys.executable, "-m", "alembic", "upgrade", "head"],
        capture_output=True,
        check=False,
        env=environment,
        text=True,
    )
    assert result.returncode == 0, result.stderr or result.stdout
