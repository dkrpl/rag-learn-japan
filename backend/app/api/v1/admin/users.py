from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from app.api.deps import RoleChecker, get_current_user
from app.db.session import get_db
from app.models.user import User, UserRole
from app.schemas.user import (
    AdminUserCreate,
    AdminUserUpdate,
    UserListResponse,
    UserResponse,
    UserRoleUpdate,
    UserStatusUpdate,
)
from app.services.auth_service import AuthService, AuthServiceError

router = APIRouter(dependencies=[Depends(RoleChecker([UserRole.ADMINISTRATOR]))])


def _raise_service_error(error: AuthServiceError) -> None:
    raise HTTPException(
        status_code=error.status_code,
        detail=error.detail,
        headers=error.headers,
    ) from error


@router.get("", response_model=UserListResponse, summary="List users")
def get_users(
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=50, ge=1, le=100),
    db: Session = Depends(get_db),
) -> UserListResponse:
    items, total = AuthService(db).list_users(offset=offset, limit=limit)
    return UserListResponse(items=items, total=total, offset=offset, limit=limit)


@router.post("", response_model=UserResponse, status_code=status.HTTP_201_CREATED, summary="Create a user")
def create_user(
    request_in: AdminUserCreate,
    db: Session = Depends(get_db),
    administrator: User = Depends(get_current_user),
) -> User:
    try:
        return AuthService(db).create_user_by_admin(
            actor=administrator,
            email=str(request_in.email),
            password=request_in.password,
            profile=request_in.model_dump(
                exclude={"email", "password", "role", "is_active", "is_email_verified"},
            ),
            role=request_in.role,
            is_active=request_in.is_active,
            is_email_verified=request_in.is_email_verified,
        )
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.get("/{user_id}", response_model=UserResponse, summary="Get a user")
def get_user(user_id: str, db: Session = Depends(get_db)) -> User:
    try:
        return AuthService(db).get_user(user_id=user_id)
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.patch("/{user_id}", response_model=UserResponse, summary="Update a user")
def update_user(
    user_id: str,
    request_in: AdminUserUpdate,
    db: Session = Depends(get_db),
    administrator: User = Depends(get_current_user),
) -> User:
    try:
        return AuthService(db).update_user_by_admin(
            actor=administrator,
            user_id=user_id,
            changes=request_in.model_dump(exclude_unset=True),
        )
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.delete("/{user_id}", response_model=UserResponse, summary="Deactivate a user")
def delete_user(
    user_id: str,
    db: Session = Depends(get_db),
    administrator: User = Depends(get_current_user),
) -> User:
    try:
        return AuthService(db).delete_user_by_admin(actor=administrator, user_id=user_id)
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.patch("/{user_id}/status", response_model=UserResponse, summary="Change a user account status")
def update_user_status(
    user_id: str,
    request_in: UserStatusUpdate,
    db: Session = Depends(get_db),
    administrator: User = Depends(get_current_user),
) -> User:
    try:
        return AuthService(db).set_user_status(
            actor=administrator,
            user_id=user_id,
            is_active=request_in.is_active,
        )
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.patch("/{user_id}/role", response_model=UserResponse, summary="Assign a user role")
def update_user_role(
    user_id: str,
    request_in: UserRoleUpdate,
    db: Session = Depends(get_db),
    administrator: User = Depends(get_current_user),
) -> User:
    try:
        return AuthService(db).set_user_role(
            actor=administrator,
            user_id=user_id,
            role=request_in.role,
        )
    except AuthServiceError as exc:
        _raise_service_error(exc)
