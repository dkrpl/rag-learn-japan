import hashlib
import json
import threading
import uuid
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from functools import lru_cache

from sqlalchemy import func
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.core import security
from app.core.config import settings
from app.models.ai_jobs import AuditLog
from app.models.auth import EmailVerificationToken, PasswordResetToken, RefreshToken
from app.models.user import User, UserRole

GENERIC_CREDENTIAL_ERROR = "Invalid email or password"
GENERIC_REFRESH_ERROR = "Invalid or expired refresh token"
GENERIC_ONE_TIME_TOKEN_ERROR = "Invalid or expired token"


class AuthServiceError(Exception):
    def __init__(self, status_code: int, detail: str, *, headers: dict[str, str] | None = None):
        super().__init__(detail)
        self.status_code = status_code
        self.detail = detail
        self.headers = headers or {}


class InvalidCredentialsError(AuthServiceError):
    def __init__(self) -> None:
        super().__init__(401, GENERIC_CREDENTIAL_ERROR, headers={"WWW-Authenticate": "Bearer"})


class InvalidRefreshTokenError(AuthServiceError):
    def __init__(self) -> None:
        super().__init__(401, GENERIC_REFRESH_ERROR, headers={"WWW-Authenticate": "Bearer"})


class InvalidOneTimeTokenError(AuthServiceError):
    def __init__(self) -> None:
        super().__init__(400, GENERIC_ONE_TIME_TOKEN_ERROR)


class RateLimitExceededError(AuthServiceError):
    def __init__(self, retry_after: int) -> None:
        super().__init__(
            429,
            "Too many login attempts. Please try again later.",
            headers={"Retry-After": str(max(retry_after, 1))},
        )


class AuthDependencyUnavailableError(AuthServiceError):
    def __init__(self) -> None:
        super().__init__(503, "Authentication service is temporarily unavailable")


class UserConflictError(AuthServiceError):
    def __init__(self) -> None:
        super().__init__(409, "Unable to create account with the supplied details")


class UserNotFoundError(AuthServiceError):
    def __init__(self) -> None:
        super().__init__(404, "User not found")


class SessionNotFoundError(AuthServiceError):
    def __init__(self) -> None:
        super().__init__(404, "Session not found")


class LastAdministratorError(AuthServiceError):
    def __init__(self) -> None:
        super().__init__(409, "The last active administrator cannot be deactivated or demoted")


class PasswordChangeError(AuthServiceError):
    def __init__(self, detail: str) -> None:
        super().__init__(400, detail)


class EmailVerificationRequiredError(AuthServiceError):
    def __init__(self) -> None:
        super().__init__(403, "Email verification is required")


@dataclass(frozen=True, repr=False)
class TokenBundle:
    access_token: str
    refresh_token: str
    expires_in: int
    refresh_expires_in: int


@dataclass(frozen=True, repr=False)
class OneTimeTokenDelivery:
    """Internal delivery payload; it must never be serialized in an API response."""

    email: str
    token: str


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


def ensure_utc(value: datetime) -> datetime:
    if value.tzinfo is None:
        return value.replace(tzinfo=timezone.utc)
    return value.astimezone(timezone.utc)


def normalize_email(email: str) -> str:
    return email.strip().lower()


@lru_cache(maxsize=1)
def _dummy_password_hash() -> str:
    # Equalizes the expensive password verification path for unknown accounts.
    return security.get_password_hash("dummy-password-4815162342")


class LoginRateLimiter:
    """Redis-backed fixed-window limiter with a local/test fallback.

    Staging and production fail closed when Redis is unavailable. Local and test
    environments fall back to an in-process store so developer workflows remain
    usable without weakening deployed environments.
    """

    _local_lock = threading.Lock()
    _local_attempts: dict[str, tuple[int, datetime]] = {}
    _redis_client = None
    _redis_disabled = False

    def __init__(self) -> None:
        self.max_attempts = settings.LOGIN_RATE_LIMIT_ATTEMPTS
        self.window_seconds = settings.LOGIN_RATE_LIMIT_WINDOW_SECONDS

    @staticmethod
    def _identifier(email: str, ip_address: str | None) -> str:
        source = f"{normalize_email(email)}|{ip_address or 'unknown'}"
        digest = hashlib.sha256(source.encode("utf-8")).hexdigest()
        return f"auth:login-failures:{digest}"

    @classmethod
    def _get_redis(cls):
        if cls._redis_disabled:
            return None
        if cls._redis_client is None:
            try:
                import redis

                cls._redis_client = redis.Redis.from_url(
                    settings.REDIS_URL,
                    decode_responses=True,
                    socket_connect_timeout=0.25,
                    socket_timeout=0.25,
                )
            except Exception:
                if settings.ENVIRONMENT in {"staging", "production"}:
                    raise AuthDependencyUnavailableError()
                cls._redis_disabled = True
                return None
        return cls._redis_client

    @classmethod
    def _handle_redis_failure(cls) -> None:
        cls._redis_client = None
        if settings.ENVIRONMENT in {"staging", "production"}:
            raise AuthDependencyUnavailableError()
        cls._redis_disabled = True

    def _local_state(self, key: str) -> tuple[int, int]:
        now = utcnow()
        with self._local_lock:
            attempts, expires_at = self._local_attempts.get(
                key,
                (0, now + timedelta(seconds=self.window_seconds)),
            )
            if expires_at <= now:
                self._local_attempts.pop(key, None)
                return 0, self.window_seconds
            return attempts, max(int((expires_at - now).total_seconds()), 1)

    def check(self, email: str, ip_address: str | None) -> None:
        key = self._identifier(email, ip_address)
        client = self._get_redis()
        if client is not None:
            try:
                attempts = int(client.get(key) or 0)
                if attempts >= self.max_attempts:
                    raise RateLimitExceededError(client.ttl(key))
                return
            except RateLimitExceededError:
                raise
            except Exception:
                self._handle_redis_failure()

        attempts, retry_after = self._local_state(key)
        if attempts >= self.max_attempts:
            raise RateLimitExceededError(retry_after)

    def record_failure(self, email: str, ip_address: str | None) -> None:
        key = self._identifier(email, ip_address)
        client = self._get_redis()
        if client is not None:
            try:
                pipe = client.pipeline(transaction=True)
                pipe.incr(key)
                pipe.expire(key, self.window_seconds)
                pipe.execute()
                return
            except Exception:
                self._handle_redis_failure()

        now = utcnow()
        with self._local_lock:
            attempts, expires_at = self._local_attempts.get(
                key,
                (0, now + timedelta(seconds=self.window_seconds)),
            )
            if expires_at <= now:
                attempts = 0
                expires_at = now + timedelta(seconds=self.window_seconds)
            self._local_attempts[key] = (attempts + 1, expires_at)

    def clear(self, email: str, ip_address: str | None) -> None:
        key = self._identifier(email, ip_address)
        client = self._get_redis()
        if client is not None:
            try:
                client.delete(key)
            except Exception:
                self._handle_redis_failure()
        with self._local_lock:
            self._local_attempts.pop(key, None)


class AuthService:
    def __init__(self, db: Session):
        self.db = db
        self.rate_limiter = LoginRateLimiter()

    def register(self, *, email: str, password: str, profile: dict) -> User:
        canonical_email = normalize_email(email)
        existing = self.db.query(User.id).filter(func.lower(User.email) == canonical_email).first()
        if existing:
            raise UserConflictError()

        user = User(
            email=canonical_email,
            password_hash=security.get_password_hash(password),
            name=profile.get("name"),
            photo_url=profile.get("photo_url"),
            timezone=profile.get("timezone") or "UTC",
            target_level=profile.get("target_level") or "N5",
            role=UserRole.LEARNER,
            is_active=True,
        )
        self.db.add(user)
        try:
            self.db.commit()
        except IntegrityError as exc:
            self.db.rollback()
            raise UserConflictError() from exc
        self.db.refresh(user)
        return user

    def login(
        self,
        *,
        email: str,
        password: str,
        ip_address: str | None,
        device_info: str | None,
    ) -> TokenBundle:
        canonical_email = normalize_email(email)
        self.rate_limiter.check(canonical_email, ip_address)

        user = self.db.query(User).filter(func.lower(User.email) == canonical_email).first()
        stored_hash = user.password_hash if user is not None else _dummy_password_hash()
        password_valid = security.verify_password(password, stored_hash)
        email_verification_missing = (
            user is not None and settings.ENVIRONMENT in {"staging", "production"} and user.email_verified_at is None
        )
        if user is None or not password_valid or not user.is_active:
            self.rate_limiter.record_failure(canonical_email, ip_address)
            raise InvalidCredentialsError()
        if email_verification_missing:
            self.rate_limiter.clear(canonical_email, ip_address)
            raise EmailVerificationRequiredError()

        self.rate_limiter.clear(canonical_email, ip_address)
        if security.password_hash_needs_update(user.password_hash):
            user.password_hash = security.get_password_hash(password)
        user.last_login_at = utcnow()
        return self._create_session(user, ip_address=ip_address, device_info=device_info)

    def _create_session(
        self,
        user: User,
        *,
        ip_address: str | None,
        device_info: str | None,
        family_id: str | None = None,
    ) -> TokenBundle:
        session_id = str(uuid.uuid4())
        token_family_id = family_id or str(uuid.uuid4())
        refresh_lifetime = timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
        refresh_token = security.create_refresh_token(
            user.id,
            token_id=session_id,
            family_id=token_family_id,
            expires_delta=refresh_lifetime,
        )
        access_token = security.create_access_token(user.id, session_id=session_id)
        issued_at = utcnow()
        record = RefreshToken(
            id=session_id,
            user_id=user.id,
            family_id=token_family_id,
            token_hash=security.get_token_hash(refresh_token),
            expires_at=issued_at + refresh_lifetime,
            last_used_at=issued_at,
            device_info=(device_info or "Unknown device")[:255],
            ip_address=(ip_address or None),
        )
        self.db.add(record)
        try:
            self.db.commit()
        except IntegrityError as exc:
            self.db.rollback()
            raise AuthServiceError(503, "Unable to create login session") from exc

        access_lifetime_seconds = settings.ACCESS_TOKEN_EXPIRE_MINUTES * 60
        return TokenBundle(
            access_token=access_token,
            refresh_token=refresh_token,
            expires_in=access_lifetime_seconds,
            refresh_expires_in=int(refresh_lifetime.total_seconds()),
        )

    def refresh(
        self,
        *,
        raw_token: str,
        ip_address: str | None,
        device_info: str | None,
    ) -> TokenBundle:
        try:
            payload = security.decode_token(raw_token, expected_type="refresh")
        except security.TokenValidationError as exc:
            raise InvalidRefreshTokenError() from exc

        token_id = payload["jti"]
        user_id = payload["sub"]
        family_id = payload.get("family_id")
        if not isinstance(family_id, str) or not family_id:
            raise InvalidRefreshTokenError()

        record = (
            self.db.query(RefreshToken)
            .filter(
                RefreshToken.id == token_id,
                RefreshToken.user_id == user_id,
                RefreshToken.token_hash == security.get_token_hash(raw_token),
            )
            .with_for_update()
            .first()
        )
        if record is None or record.family_id != family_id:
            self.db.rollback()
            raise InvalidRefreshTokenError()

        now = utcnow()
        if record.is_revoked:
            self._revoke_family(record.user_id, record.family_id, reason="reuse_detected", now=now)
            self.db.commit()
            raise InvalidRefreshTokenError()
        if ensure_utc(record.expires_at) <= now:
            self._mark_revoked(record, reason="expired", now=now)
            self.db.commit()
            raise InvalidRefreshTokenError()

        user = self.db.query(User).filter(User.id == record.user_id).first()
        if user is None or not user.is_active:
            self._revoke_family(record.user_id, record.family_id, reason="account_inactive", now=now)
            self.db.commit()
            raise InvalidRefreshTokenError()

        self._mark_revoked(record, reason="rotated", now=now)
        record.last_used_at = now

        # Flush the revocation while holding the old token row lock, then create
        # the successor in the same transaction to prevent concurrent rotation.
        self.db.flush()
        return self._create_session(
            user,
            ip_address=ip_address,
            device_info=device_info or record.device_info,
            family_id=record.family_id,
        )

    @staticmethod
    def _mark_revoked(record: RefreshToken, *, reason: str, now: datetime | None = None) -> None:
        record.is_revoked = True
        record.revoked_at = now or utcnow()
        record.revoke_reason = reason

    def _revoke_family(self, user_id: str, family_id: str, *, reason: str, now: datetime | None = None) -> int:
        return (
            self.db.query(RefreshToken)
            .filter(
                RefreshToken.user_id == user_id,
                RefreshToken.family_id == family_id,
                RefreshToken.is_revoked.is_(False),
            )
            .update(
                {
                    RefreshToken.is_revoked: True,
                    RefreshToken.revoked_at: now or utcnow(),
                    RefreshToken.revoke_reason: reason,
                },
                synchronize_session=False,
            )
        )

    def revoke_token(self, *, user_id: str, raw_token: str, reason: str = "logout") -> None:
        record = (
            self.db.query(RefreshToken)
            .filter(
                RefreshToken.user_id == user_id,
                RefreshToken.token_hash == security.get_token_hash(raw_token),
            )
            .with_for_update()
            .first()
        )
        if record is not None and not record.is_revoked:
            self._mark_revoked(record, reason=reason)
            self.db.commit()
        else:
            self.db.rollback()

    def revoke_all(self, *, user_id: str, reason: str = "logout_all") -> int:
        count = (
            self.db.query(RefreshToken)
            .filter(RefreshToken.user_id == user_id, RefreshToken.is_revoked.is_(False))
            .update(
                {
                    RefreshToken.is_revoked: True,
                    RefreshToken.revoked_at: utcnow(),
                    RefreshToken.revoke_reason: reason,
                },
                synchronize_session=False,
            )
        )
        self.db.commit()
        return count

    def list_sessions(self, *, user_id: str) -> list[RefreshToken]:
        return (
            self.db.query(RefreshToken)
            .filter(
                RefreshToken.user_id == user_id,
                RefreshToken.is_revoked.is_(False),
                RefreshToken.expires_at > utcnow(),
            )
            .order_by(RefreshToken.created_at.desc())
            .all()
        )

    def revoke_session(self, *, user_id: str, session_id: str) -> None:
        record = (
            self.db.query(RefreshToken)
            .filter(RefreshToken.id == session_id, RefreshToken.user_id == user_id)
            .with_for_update()
            .first()
        )
        if record is None:
            self.db.rollback()
            raise SessionNotFoundError()
        if not record.is_revoked:
            self._mark_revoked(record, reason="session_deleted")
        self.db.commit()

    def session_is_active(self, *, user_id: str, session_id: str) -> bool:
        return (
            self.db.query(RefreshToken.id)
            .filter(
                RefreshToken.id == session_id,
                RefreshToken.user_id == user_id,
                RefreshToken.is_revoked.is_(False),
                RefreshToken.expires_at > utcnow(),
            )
            .first()
            is not None
        )

    def request_password_reset(self, *, email: str) -> OneTimeTokenDelivery | None:
        canonical_email = normalize_email(email)
        user = self.db.query(User).filter(func.lower(User.email) == canonical_email).first()
        if user is None or not user.is_active:
            return None

        now = utcnow()
        self.db.query(PasswordResetToken).filter(
            PasswordResetToken.user_id == user.id,
            PasswordResetToken.is_used.is_(False),
        ).update(
            {PasswordResetToken.is_used: True, PasswordResetToken.used_at: now},
            synchronize_session=False,
        )
        raw_token = security.create_one_time_token()
        self.db.add(
            PasswordResetToken(
                user_id=user.id,
                token_hash=security.get_token_hash(raw_token),
                expires_at=now + timedelta(minutes=settings.PASSWORD_RESET_EXPIRE_MINUTES),
            )
        )
        self.db.commit()
        return OneTimeTokenDelivery(email=user.email, token=raw_token)

    def reset_password(self, *, raw_token: str, new_password: str) -> None:
        token = (
            self.db.query(PasswordResetToken)
            .filter(PasswordResetToken.token_hash == security.get_token_hash(raw_token))
            .with_for_update()
            .first()
        )
        now = utcnow()
        if token is None or token.is_used or ensure_utc(token.expires_at) <= now:
            self.db.rollback()
            raise InvalidOneTimeTokenError()

        user = self.db.query(User).filter(User.id == token.user_id).first()
        if user is None or not user.is_active:
            self.db.rollback()
            raise InvalidOneTimeTokenError()

        user.password_hash = security.get_password_hash(new_password)
        token.is_used = True
        token.used_at = now
        self.db.query(PasswordResetToken).filter(
            PasswordResetToken.user_id == user.id,
            PasswordResetToken.id != token.id,
            PasswordResetToken.is_used.is_(False),
        ).update(
            {PasswordResetToken.is_used: True, PasswordResetToken.used_at: now},
            synchronize_session=False,
        )
        self._revoke_all_without_commit(user.id, reason="password_reset", now=now)
        self.db.commit()

    def request_email_verification(self, *, email: str) -> OneTimeTokenDelivery | None:
        canonical_email = normalize_email(email)
        user = self.db.query(User).filter(func.lower(User.email) == canonical_email).first()
        if user is None or not user.is_active or user.email_verified_at is not None:
            return None

        now = utcnow()
        self.db.query(EmailVerificationToken).filter(
            EmailVerificationToken.user_id == user.id,
            EmailVerificationToken.is_used.is_(False),
        ).update(
            {EmailVerificationToken.is_used: True, EmailVerificationToken.used_at: now},
            synchronize_session=False,
        )
        raw_token = security.create_one_time_token()
        self.db.add(
            EmailVerificationToken(
                user_id=user.id,
                token_hash=security.get_token_hash(raw_token),
                expires_at=now + timedelta(hours=24),
            )
        )
        self.db.commit()
        return OneTimeTokenDelivery(email=user.email, token=raw_token)

    def verify_email(self, *, raw_token: str) -> None:
        token = (
            self.db.query(EmailVerificationToken)
            .filter(EmailVerificationToken.token_hash == security.get_token_hash(raw_token))
            .with_for_update()
            .first()
        )
        now = utcnow()
        if token is None or token.is_used or ensure_utc(token.expires_at) <= now:
            self.db.rollback()
            raise InvalidOneTimeTokenError()

        user = self.db.query(User).filter(User.id == token.user_id).first()
        if user is None or not user.is_active:
            self.db.rollback()
            raise InvalidOneTimeTokenError()

        user.email_verified_at = user.email_verified_at or now
        token.is_used = True
        token.used_at = now
        self.db.query(EmailVerificationToken).filter(
            EmailVerificationToken.user_id == user.id,
            EmailVerificationToken.id != token.id,
            EmailVerificationToken.is_used.is_(False),
        ).update(
            {EmailVerificationToken.is_used: True, EmailVerificationToken.used_at: now},
            synchronize_session=False,
        )
        self.db.commit()

    def update_password(self, *, user: User, current_password: str, new_password: str) -> None:
        if not security.verify_password(current_password, user.password_hash):
            raise PasswordChangeError("Current password is incorrect")
        if security.verify_password(new_password, user.password_hash):
            raise PasswordChangeError("New password must be different from the current password")

        user.password_hash = security.get_password_hash(new_password)
        self._revoke_all_without_commit(user.id, reason="password_changed")
        self.db.commit()

    def update_profile(self, *, user: User, changes: dict) -> User:
        allowed_fields = {"name", "photo_url", "timezone", "target_level"}
        for field, value in changes.items():
            if field in allowed_fields:
                setattr(user, field, value)
        self.db.commit()
        self.db.refresh(user)
        return user

    def deactivate_account(self, *, user: User) -> None:
        if user.role == UserRole.ADMINISTRATOR and user.is_active:
            self._assert_not_last_active_administrator(user.id)

        now = utcnow()
        user.is_active = False
        user.deactivated_at = now
        self._revoke_all_without_commit(user.id, reason="account_deactivated", now=now)
        self._audit(
            actor_id=user.id,
            action="DEACTIVATE_OWN_ACCOUNT",
            target_id=user.id,
            details={"is_active": False},
        )
        self.db.commit()

    def list_users(self, *, offset: int, limit: int) -> tuple[list[User], int]:
        total = self.db.query(func.count(User.id)).scalar() or 0
        items = self.db.query(User).order_by(User.created_at.desc()).offset(offset).limit(limit).all()
        return items, int(total)

    def create_user_by_admin(
        self,
        *,
        actor: User,
        email: str,
        password: str,
        profile: dict,
        role: UserRole,
        is_active: bool,
        is_email_verified: bool,
    ) -> User:
        canonical_email = normalize_email(email)
        existing = self.db.query(User.id).filter(func.lower(User.email) == canonical_email).first()
        if existing:
            raise UserConflictError()

        now = utcnow()
        user = User(
            email=canonical_email,
            password_hash=security.get_password_hash(password),
            name=profile.get("name"),
            photo_url=profile.get("photo_url"),
            timezone=profile.get("timezone") or "UTC",
            target_level=profile.get("target_level") or "N5",
            role=UserRole.from_value(role),
            is_active=is_active,
            email_verified_at=now if is_email_verified else None,
            deactivated_at=None if is_active else now,
        )
        self.db.add(user)
        try:
            self.db.flush()
            self._audit(
                actor_id=actor.id,
                action="CREATE_USER",
                target_id=user.id,
                details={"email": user.email, "role": user.role.value, "is_active": user.is_active},
            )
            self.db.commit()
        except IntegrityError as exc:
            self.db.rollback()
            raise UserConflictError() from exc
        self.db.refresh(user)
        return user

    def get_user(self, *, user_id: str, for_update: bool = False) -> User:
        query = self.db.query(User).filter(User.id == user_id)
        if for_update:
            query = query.with_for_update()
        user = query.first()
        if user is None:
            raise UserNotFoundError()
        return user

    def set_user_status(self, *, actor: User, user_id: str, is_active: bool) -> User:
        user = self.get_user(user_id=user_id, for_update=True)
        if user.is_active == is_active:
            self.db.rollback()
            return user
        if user.role == UserRole.ADMINISTRATOR and user.is_active and not is_active:
            self._assert_not_last_active_administrator(user.id)

        old_status = user.is_active
        user.is_active = is_active
        user.deactivated_at = None if is_active else utcnow()
        if not is_active:
            self._revoke_all_without_commit(user.id, reason="deactivated_by_admin")
        self._audit(
            actor_id=actor.id,
            action="UPDATE_USER_STATUS",
            target_id=user.id,
            details={"old_is_active": old_status, "new_is_active": is_active},
        )
        self.db.commit()
        self.db.refresh(user)
        return user

    def update_user_by_admin(self, *, actor: User, user_id: str, changes: dict) -> User:
        user = self.get_user(user_id=user_id, for_update=True)
        old_role = user.role
        old_status = user.is_active

        requested_role = changes.pop("role", None)
        requested_status = changes.pop("is_active", None)
        if requested_role is not None:
            new_role = UserRole.from_value(requested_role)
            if user.role == UserRole.ADMINISTRATOR and user.is_active and new_role != UserRole.ADMINISTRATOR:
                self._assert_not_last_active_administrator(user.id)
            user.role = new_role
        if requested_status is not None:
            is_active = bool(requested_status)
            if user.role == UserRole.ADMINISTRATOR and user.is_active and not is_active:
                self._assert_not_last_active_administrator(user.id)
            if user.is_active != is_active:
                user.is_active = is_active
                user.deactivated_at = None if is_active else utcnow()
                if not is_active:
                    self._revoke_all_without_commit(user.id, reason="deactivated_by_admin")

        allowed_fields = {"name", "photo_url", "timezone", "target_level"}
        for field, value in changes.items():
            if field in allowed_fields:
                setattr(user, field, value)

        self._audit(
            actor_id=actor.id,
            action="UPDATE_USER",
            target_id=user.id,
            details={
                "old_role": old_role.value,
                "new_role": user.role.value,
                "old_is_active": old_status,
                "new_is_active": user.is_active,
            },
        )
        self.db.commit()
        self.db.refresh(user)
        return user

    def delete_user_by_admin(self, *, actor: User, user_id: str) -> User:
        user = self.set_user_status(actor=actor, user_id=user_id, is_active=False)
        self._audit(
            actor_id=actor.id,
            action="DELETE_USER_SOFT",
            target_id=user.id,
            details={"is_active": False},
        )
        self.db.commit()
        self.db.refresh(user)
        return user

    def set_user_role(self, *, actor: User, user_id: str, role: UserRole) -> User:
        user = self.get_user(user_id=user_id, for_update=True)
        role = UserRole.from_value(role)
        if user.role == role:
            self.db.rollback()
            return user
        if user.role == UserRole.ADMINISTRATOR and user.is_active and role != UserRole.ADMINISTRATOR:
            self._assert_not_last_active_administrator(user.id)

        old_role = user.role
        user.role = role
        self._audit(
            actor_id=actor.id,
            action="UPDATE_USER_ROLE",
            target_id=user.id,
            details={"old_role": old_role.value, "new_role": role.value},
        )
        self.db.commit()
        self.db.refresh(user)
        return user

    def _assert_not_last_active_administrator(self, target_user_id: str) -> None:
        active_admins = (
            self.db.query(User.id)
            .filter(User.role == UserRole.ADMINISTRATOR, User.is_active.is_(True))
            .with_for_update()
            .all()
        )
        if len(active_admins) <= 1 and any(admin_id == target_user_id for (admin_id,) in active_admins):
            self.db.rollback()
            raise LastAdministratorError()

    def _revoke_all_without_commit(
        self,
        user_id: str,
        *,
        reason: str,
        now: datetime | None = None,
    ) -> int:
        return (
            self.db.query(RefreshToken)
            .filter(RefreshToken.user_id == user_id, RefreshToken.is_revoked.is_(False))
            .update(
                {
                    RefreshToken.is_revoked: True,
                    RefreshToken.revoked_at: now or utcnow(),
                    RefreshToken.revoke_reason: reason,
                },
                synchronize_session=False,
            )
        )

    def _audit(self, *, actor_id: str, action: str, target_id: str, details: dict) -> None:
        self.db.add(
            AuditLog(
                user_id=actor_id,
                action=action,
                entity_name="User",
                entity_id=target_id,
                details=json.dumps(details, separators=(",", ":"), sort_keys=True),
            )
        )
