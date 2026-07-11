import os
from pathlib import Path

import pytest

TEST_ROOT = Path(__file__).resolve().parents[1] / ".pytest_tmp"
TEST_ROOT.mkdir(exist_ok=True)
default_sqlite = TEST_ROOT / "api.sqlite3"
if default_sqlite.exists():
    default_sqlite.unlink()

# Environment must be set before importing the application because settings and
# the SQLAlchemy engine are initialized at import time.
os.environ["ENVIRONMENT"] = "test"
os.environ["DATABASE_URL"] = os.getenv("TEST_DATABASE_URL", f"sqlite:///{default_sqlite.as_posix()}")
os.environ["SECRET_KEY"] = "pytest-secret-key-with-at-least-thirty-two-characters"
os.environ["REDIS_URL"] = os.getenv("TEST_REDIS_URL", "redis://127.0.0.1:6379/15")
os.environ["READINESS_CHECK_REDIS"] = "false"
os.environ["CORS_ORIGINS"] = '["http://testserver"]'
os.environ["ALLOWED_HOSTS"] = '["testserver","localhost","127.0.0.1"]'
os.environ["ENABLE_METRICS"] = "false"
os.environ["AI_PROVIDER"] = "disabled"
os.environ["TTS_PROVIDER"] = "disabled"
os.environ["AUDIO_STORAGE_PATH"] = str(TEST_ROOT / "audio")

from fastapi.testclient import TestClient  # noqa: E402
from sqlalchemy import event  # noqa: E402

from app.core.security import create_access_token  # noqa: E402
from app.db.base import Base  # noqa: E402
from app.db.session import SessionLocal, engine  # noqa: E402
from app.main import app  # noqa: E402
from app.models.user import User, UserRole  # noqa: E402

if engine.dialect.name == "sqlite":

    @event.listens_for(engine, "connect")
    def enable_sqlite_foreign_keys(dbapi_connection, _):
        cursor = dbapi_connection.cursor()
        cursor.execute("PRAGMA foreign_keys=ON")
        cursor.close()


@pytest.fixture(scope="function", autouse=True)
def reset_database(request):
    if request.node.get_closest_marker("no_db_reset"):
        yield
        return
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)
    yield


@pytest.fixture(scope="function")
def client():
    with TestClient(app) as test_client:
        yield test_client


@pytest.fixture(scope="function")
def db():
    session = SessionLocal()
    try:
        yield session
    finally:
        session.rollback()
        session.close()


@pytest.fixture(scope="function")
def admin_token_headers(db):
    user = User(
        email="admin_test_fixture@example.com",
        password_hash="not-used-by-token-tests",
        name="Admin User",
        role=UserRole.ADMINISTRATOR,
        is_active=True,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    token = create_access_token(user.id)
    return {"Authorization": f"Bearer {token}"}


@pytest.fixture(scope="function")
def learner_token_headers(db):
    user = User(
        email="learner_test_fixture@example.com",
        password_hash="not-used-by-token-tests",
        name="Learner User",
        role=UserRole.LEARNER,
        is_active=True,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    token = create_access_token(user.id)
    return {"Authorization": f"Bearer {token}"}
