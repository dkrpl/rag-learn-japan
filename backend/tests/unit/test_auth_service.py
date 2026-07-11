from collections.abc import Generator

import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy.pool import StaticPool

from app.core import security
from app.db.base_class import Base
from app.models.ai_jobs import AuditLog
from app.models.auth import EmailVerificationToken, PasswordResetToken, RefreshToken
from app.models.user import User, UserRole
from app.services.auth_service import (
    AuthService,
    InvalidCredentialsError,
    InvalidOneTimeTokenError,
    InvalidRefreshTokenError,
    LastAdministratorError,
    LoginRateLimiter,
)


@pytest.fixture()
def db() -> Generator[Session, None, None]:
    engine = create_engine(
        "sqlite+pysqlite:///:memory:",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    Base.metadata.create_all(
        engine,
        tables=[
            User.__table__,
            AuditLog.__table__,
            RefreshToken.__table__,
            PasswordResetToken.__table__,
            EmailVerificationToken.__table__,
        ],
    )
    local_session = sessionmaker(bind=engine, expire_on_commit=False)
    session = local_session()
    LoginRateLimiter._redis_disabled = True
    LoginRateLimiter._local_attempts.clear()
    try:
        yield session
    finally:
        session.close()
        Base.metadata.drop_all(
            engine,
            tables=[
                EmailVerificationToken.__table__,
                PasswordResetToken.__table__,
                RefreshToken.__table__,
                AuditLog.__table__,
                User.__table__,
            ],
        )
        engine.dispose()


def create_user(db: Session, *, email: str, role: UserRole = UserRole.LEARNER) -> User:
    user = User(
        email=email,
        password_hash=security.get_password_hash("Password123"),
        role=role,
        timezone="UTC",
        target_level="N5",
        is_active=True,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


def test_register_normalizes_email_and_never_mass_assigns_role(db: Session) -> None:
    user = AuthService(db).register(
        email="  LEARNER@Example.com ",
        password="Password123",
        profile={"name": "Learner", "role": UserRole.ADMINISTRATOR},
    )

    assert user.email == "learner@example.com"
    assert user.role == UserRole.LEARNER
    assert security.verify_password("Password123", user.password_hash)


def test_login_rotation_reuse_and_session_revocation(db: Session) -> None:
    user = create_user(db, email="rotation@example.com")
    service = AuthService(db)

    first = service.login(
        email=user.email,
        password="Password123",
        ip_address="127.0.0.1",
        device_info="pytest",
    )
    first_refresh_payload = security.decode_token(first.refresh_token, expected_type="refresh")
    assert service.session_is_active(user_id=user.id, session_id=first_refresh_payload["jti"])

    second = service.refresh(
        raw_token=first.refresh_token,
        ip_address="127.0.0.1",
        device_info="pytest",
    )
    second_refresh_payload = security.decode_token(second.refresh_token, expected_type="refresh")
    assert first_refresh_payload["family_id"] == second_refresh_payload["family_id"]
    assert not service.session_is_active(user_id=user.id, session_id=first_refresh_payload["jti"])
    assert service.session_is_active(user_id=user.id, session_id=second_refresh_payload["jti"])

    with pytest.raises(InvalidRefreshTokenError):
        service.refresh(
            raw_token=first.refresh_token,
            ip_address="127.0.0.1",
            device_info="pytest",
        )

    assert not service.session_is_active(user_id=user.id, session_id=second_refresh_payload["jti"])


def test_login_uses_same_public_error_for_unknown_and_inactive_users(db: Session) -> None:
    user = create_user(db, email="inactive@example.com")
    user.is_active = False
    db.commit()
    service = AuthService(db)

    with pytest.raises(InvalidCredentialsError) as unknown_error:
        service.login(
            email="unknown@example.com",
            password="Password123",
            ip_address="127.0.0.1",
            device_info="pytest",
        )
    with pytest.raises(InvalidCredentialsError) as inactive_error:
        service.login(
            email=user.email,
            password="Password123",
            ip_address="127.0.0.2",
            device_info="pytest",
        )

    assert unknown_error.value.detail == inactive_error.value.detail


def test_deactivating_last_administrator_is_rejected(db: Session) -> None:
    administrator = create_user(db, email="admin@example.com", role=UserRole.ADMINISTRATOR)

    with pytest.raises(LastAdministratorError):
        AuthService(db).set_user_status(
            actor=administrator,
            user_id=administrator.id,
            is_active=False,
        )

    db.refresh(administrator)
    assert administrator.is_active is True


def test_admin_status_change_is_audited_and_revokes_sessions(db: Session) -> None:
    administrator = create_user(db, email="admin@example.com", role=UserRole.ADMINISTRATOR)
    learner = create_user(db, email="learner@example.com")
    service = AuthService(db)
    tokens = service.login(
        email=learner.email,
        password="Password123",
        ip_address="127.0.0.1",
        device_info="pytest",
    )
    session_id = security.decode_token(tokens.refresh_token, expected_type="refresh")["jti"]

    updated = service.set_user_status(actor=administrator, user_id=learner.id, is_active=False)

    assert updated.is_active is False
    assert not service.session_is_active(user_id=learner.id, session_id=session_id)
    audit = db.query(AuditLog).filter(AuditLog.entity_id == learner.id).one()
    assert audit.action == "UPDATE_USER_STATUS"


def test_password_reset_is_single_use_and_revokes_sessions(db: Session) -> None:
    user = create_user(db, email="reset@example.com")
    service = AuthService(db)
    service.login(
        email=user.email,
        password="Password123",
        ip_address="127.0.0.1",
        device_info="pytest",
    )
    delivery = service.request_password_reset(email=user.email)
    assert delivery is not None

    service.reset_password(raw_token=delivery.token, new_password="NewPassword456")

    assert service.list_sessions(user_id=user.id) == []
    assert security.verify_password("NewPassword456", user.password_hash)
    with pytest.raises(InvalidOneTimeTokenError):
        service.reset_password(raw_token=delivery.token, new_password="AnotherPassword789")


def test_email_verification_is_single_use_and_enumeration_safe(db: Session) -> None:
    user = create_user(db, email="verify@example.com")
    service = AuthService(db)

    assert service.request_email_verification(email="unknown@example.com") is None
    delivery = service.request_email_verification(email=user.email)
    assert delivery is not None

    service.verify_email(raw_token=delivery.token)
    db.refresh(user)

    assert user.is_email_verified is True
    assert service.request_email_verification(email=user.email) is None
    with pytest.raises(InvalidOneTimeTokenError):
        service.verify_email(raw_token=delivery.token)
