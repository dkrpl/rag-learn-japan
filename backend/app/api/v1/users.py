from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_session_id, get_current_user
from app.db.session import get_db
from app.models.user import User
from app.schemas.auth import AuthMessageResponse, SessionListResponse, SessionResponse
from app.schemas.user import UserPasswordUpdate, UserResponse, UserUpdate
from app.services.auth_service import AuthService, AuthServiceError

router = APIRouter()


def _raise_service_error(error: AuthServiceError) -> None:
    raise HTTPException(
        status_code=error.status_code,
        detail=error.detail,
        headers=error.headers,
    ) from error


@router.get("/me", response_model=UserResponse, summary="Get the current user profile")
def read_user_me(current_user: User = Depends(get_current_user)) -> User:
    return current_user


@router.patch("/me", response_model=UserResponse, summary="Update the current user profile")
def update_user_me(
    user_in: UserUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> User:
    try:
        return AuthService(db).update_profile(
            user=current_user,
            changes=user_in.model_dump(exclude_unset=True),
        )
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.patch(
    "/me/password",
    response_model=AuthMessageResponse,
    summary="Change the current user password",
)
def update_password_me(
    password_in: UserPasswordUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> AuthMessageResponse:
    try:
        AuthService(db).update_password(
            user=current_user,
            current_password=password_in.current_password,
            new_password=password_in.new_password,
        )
        return AuthMessageResponse(message="Password updated; all sessions were revoked")
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.delete(
    "/me",
    response_model=AuthMessageResponse,
    summary="Deactivate the current account",
)
def deactivate_user_me(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> AuthMessageResponse:
    try:
        AuthService(db).deactivate_account(user=current_user)
        return AuthMessageResponse(message="Account deactivated")
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.get(
    "/me/sessions",
    response_model=SessionListResponse,
    summary="List active login sessions",
)
def list_user_sessions(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    current_session_id: str | None = Depends(get_current_session_id),
) -> SessionListResponse:
    sessions = AuthService(db).list_sessions(user_id=current_user.id)
    items = [
        SessionResponse(
            id=session.id,
            device_info=session.device_info,
            ip_address=session.ip_address,
            created_at=session.created_at,
            last_used_at=session.last_used_at,
            expires_at=session.expires_at,
            is_current=session.id == current_session_id,
        )
        for session in sessions
    ]
    return SessionListResponse(items=items, total=len(items))


@router.delete(
    "/me/sessions",
    response_model=AuthMessageResponse,
    summary="Revoke all login sessions",
)
def delete_user_sessions(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> AuthMessageResponse:
    AuthService(db).revoke_all(user_id=current_user.id, reason="sessions_deleted")
    return AuthMessageResponse(message="All sessions revoked")


@router.delete(
    "/me/sessions/{session_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Revoke one login session",
)
def delete_user_session(
    session_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> Response:
    try:
        AuthService(db).revoke_session(user_id=current_user.id, session_id=session_id)
        return Response(status_code=status.HTTP_204_NO_CONTENT)
    except AuthServiceError as exc:
        _raise_service_error(exc)
