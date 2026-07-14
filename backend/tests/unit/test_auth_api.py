from collections.abc import Generator

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy.pool import StaticPool

from app.core import security
from app.db.base_class import Base
from app.db.session import get_db
from app.main import create_app
from app.models.ai_jobs import AuditLog
from app.models.auth import EmailVerificationToken, PasswordResetToken, RefreshToken
from app.models.user import User, UserRole
from app.services.auth_service import LoginRateLimiter

AUTH_TABLES = [
    User.__table__,
    AuditLog.__table__,
    RefreshToken.__table__,
    PasswordResetToken.__table__,
    EmailVerificationToken.__table__,
]


@pytest.fixture()
def api() -> Generator[tuple[TestClient, sessionmaker], None, None]:
    engine = create_engine(
        "sqlite+pysqlite:///:memory:",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    Base.metadata.create_all(engine, tables=AUTH_TABLES)
    testing_session = sessionmaker(bind=engine, expire_on_commit=False)
    app = create_app()

    def override_get_db() -> Generator[Session, None, None]:
        db = testing_session()
        try:
            yield db
        finally:
            db.close()

    app.dependency_overrides[get_db] = override_get_db
    LoginRateLimiter._redis_disabled = True
    LoginRateLimiter._local_attempts.clear()
    with TestClient(app) as client:
        yield client, testing_session
    app.dependency_overrides.clear()
    Base.metadata.drop_all(engine, tables=list(reversed(AUTH_TABLES)))
    engine.dispose()


def register_and_login(client: TestClient, email: str = "learner@example.com") -> dict:
    register_response = client.post(
        "/api/v1/auth/register",
        json={
            "email": email,
            "password": "Password123",
            "name": "Learner",
            "role": "administrator",
        },
    )
    assert register_response.status_code == 201, register_response.text
    assert register_response.json()["role"] == "learner"

    login_response = client.post(
        "/api/v1/auth/login",
        json={"email": email, "password": "Password123", "device_name": "pytest"},
    )
    assert login_response.status_code == 200, login_response.text
    return login_response.json()


def test_refresh_rotation_reuse_and_refresh_as_access(api: tuple[TestClient, sessionmaker]) -> None:
    client, _ = api
    first = register_and_login(client)

    refresh_as_access = client.get(
        "/api/v1/app/me",
        headers={"Authorization": f"Bearer {first['refresh_token']}"},
    )
    assert refresh_as_access.status_code == 401

    refresh_response = client.post(
        "/api/v1/auth/refresh",
        json={"refresh_token": first["refresh_token"]},
    )
    assert refresh_response.status_code == 200, refresh_response.text
    second = refresh_response.json()
    assert second["refresh_token"] != first["refresh_token"]

    reuse_response = client.post(
        "/api/v1/auth/refresh",
        json={"refresh_token": first["refresh_token"]},
    )
    assert reuse_response.status_code == 401

    family_revoked_response = client.post(
        "/api/v1/auth/refresh",
        json={"refresh_token": second["refresh_token"]},
    )
    assert family_revoked_response.status_code == 401


def test_admin_user_management_and_last_admin_guard(api: tuple[TestClient, sessionmaker]) -> None:
    client, testing_session = api
    with testing_session() as db:
        administrator = User(
            email="admin@example.com",
            password_hash=security.get_password_hash("Password123"),
            role=UserRole.ADMINISTRATOR,
            timezone="UTC",
            target_level="N5",
            is_active=True,
        )
        learner = User(
            email="managed@example.com",
            password_hash=security.get_password_hash("Password123"),
            role=UserRole.LEARNER,
            timezone="UTC",
            target_level="N5",
            is_active=True,
        )
        db.add_all([administrator, learner])
        db.commit()
        administrator_id = administrator.id
        learner_id = learner.id

    headers = {"Authorization": f"Bearer {security.create_access_token(administrator_id)}"}
    list_response = client.get("/api/v1/admin/users", headers=headers)
    assert list_response.status_code == 200, list_response.text
    assert list_response.json()["total"] == 2

    role_response = client.patch(
        f"/api/v1/admin/users/{learner_id}/role",
        headers=headers,
        json={"role": "content_editor"},
    )
    assert role_response.status_code == 200, role_response.text
    assert role_response.json()["role"] == "content_editor"

    last_admin_response = client.patch(
        f"/api/v1/admin/users/{administrator_id}/status",
        headers=headers,
        json={"is_active": False},
    )
    assert last_admin_response.status_code == 409
