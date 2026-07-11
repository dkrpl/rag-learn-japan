from collections.abc import Iterable
from typing import Any

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.orm import Session

from app.core import security
from app.core.config import settings
from app.db.session import get_db
from app.models.user import User, UserRole
from app.services.auth_service import AuthService

bearer_scheme = HTTPBearer(auto_error=False, scheme_name="BearerAuth")


def _credentials_error(detail: str = "Invalid or expired access token") -> HTTPException:
    return HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail=detail,
        headers={"WWW-Authenticate": "Bearer"},
    )


def get_current_token_payload(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_scheme),
) -> dict[str, Any]:
    if credentials is None or credentials.scheme.lower() != "bearer":
        raise _credentials_error("Authentication required")
    try:
        return security.decode_token(credentials.credentials, expected_type="access")
    except security.TokenValidationError as exc:
        raise _credentials_error() from exc


def get_current_user(
    db: Session = Depends(get_db),
    payload: dict[str, Any] = Depends(get_current_token_payload),
) -> User:
    user = db.query(User).filter(User.id == payload["sub"]).first()
    if user is None or not user.is_active:
        raise _credentials_error()

    # Tokens issued by the public login flow carry a session id. Checking the
    # backing session makes logout/deactivation effective immediately. Signed
    # session-less tokens are accepted only by local/test maintenance tooling.
    session_id = payload.get("sid")
    if session_id is None and settings.ENVIRONMENT in {"staging", "production"}:
        raise _credentials_error()
    if session_id is not None:
        if not isinstance(session_id, str) or not AuthService(db).session_is_active(
            user_id=user.id,
            session_id=session_id,
        ):
            raise _credentials_error()
    return user


def get_current_session_id(payload: dict[str, Any] = Depends(get_current_token_payload)) -> str | None:
    session_id = payload.get("sid")
    return session_id if isinstance(session_id, str) else None


class RoleChecker:
    def __init__(self, allowed_roles: Iterable[UserRole | str]):
        self.allowed_roles = frozenset(UserRole.from_value(role) for role in allowed_roles)

    def __call__(self, user: User = Depends(get_current_user)) -> User:
        if UserRole.from_value(user.role) not in self.allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions",
            )
        return user


def get_current_user_require_roles(allowed_roles: Iterable[UserRole | str]) -> RoleChecker:
    """Compatibility helper for routers that construct role dependencies inline."""

    return RoleChecker(allowed_roles)
