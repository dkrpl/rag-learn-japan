import hashlib
import secrets
import uuid
from datetime import datetime, timedelta, timezone
from typing import Any

import jwt
from passlib.context import CryptContext
from passlib.exc import UnknownHashError

from app.core.config import settings

ALGORITHM = settings.JWT_ALGORITHM
TOKEN_AUDIENCE = "nihongo-api"
TOKEN_ISSUER = settings.PROJECT_NAME

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


class TokenValidationError(ValueError):
    """Raised for every invalid token condition without leaking its cause."""


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    try:
        return pwd_context.verify(plain_password, hashed_password)
    except (TypeError, ValueError, UnknownHashError):
        return False


def password_hash_needs_update(hashed_password: str) -> bool:
    try:
        return pwd_context.needs_update(hashed_password)
    except (TypeError, ValueError, UnknownHashError):
        return True


def _create_token(
    *,
    subject: str | Any,
    token_type: str,
    expires_delta: timedelta,
    token_id: str | None = None,
    additional_claims: dict[str, Any] | None = None,
) -> str:
    now = utcnow()
    payload: dict[str, Any] = {
        "sub": str(subject),
        "jti": token_id or str(uuid.uuid4()),
        "token_type": token_type,
        "iat": now,
        "nbf": now,
        "exp": now + expires_delta,
        "iss": TOKEN_ISSUER,
        "aud": TOKEN_AUDIENCE,
    }
    if additional_claims:
        payload.update(additional_claims)
    return jwt.encode(payload, settings.SECRET_KEY, algorithm=ALGORITHM)


def create_access_token(
    subject: str | Any,
    expires_delta: timedelta | None = None,
    *,
    session_id: str | None = None,
) -> str:
    claims = {"sid": session_id} if session_id else None
    return _create_token(
        subject=subject,
        token_type="access",
        expires_delta=expires_delta or timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES),
        additional_claims=claims,
    )


def create_refresh_token(
    subject: str | Any,
    *,
    token_id: str,
    family_id: str,
    expires_delta: timedelta | None = None,
) -> str:
    return _create_token(
        subject=subject,
        token_type="refresh",
        token_id=token_id,
        expires_delta=expires_delta or timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS),
        additional_claims={"family_id": family_id},
    )


def create_one_time_token() -> str:
    """Generate an unguessable opaque token for reset/verification flows."""

    return secrets.token_urlsafe(48)


def get_token_hash(token: str) -> str:
    return hashlib.sha256(token.encode("utf-8")).hexdigest()


def decode_token(token: str, *, expected_type: str) -> dict[str, Any]:
    try:
        payload = jwt.decode(
            token,
            settings.SECRET_KEY,
            algorithms=[ALGORITHM],
            audience=TOKEN_AUDIENCE,
            issuer=TOKEN_ISSUER,
            options={
                "require": ["sub", "jti", "token_type", "iat", "nbf", "exp", "iss", "aud"],
            },
        )
    except jwt.PyJWTError as exc:
        raise TokenValidationError("Invalid or expired token") from exc

    if payload.get("token_type") != expected_type:
        raise TokenValidationError("Invalid or expired token")
    if not isinstance(payload.get("sub"), str) or not payload["sub"]:
        raise TokenValidationError("Invalid or expired token")
    if not isinstance(payload.get("jti"), str) or not payload["jti"]:
        raise TokenValidationError("Invalid or expired token")

    return payload


def verify_token(token: str, expected_type: str = "access") -> dict[str, Any] | None:
    """Compatibility wrapper for callers that prefer a nullable result."""

    try:
        return decode_token(token, expected_type=expected_type)
    except TokenValidationError:
        return None
