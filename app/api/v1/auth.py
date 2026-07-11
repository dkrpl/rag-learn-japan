import logging
from collections.abc import Callable

from fastapi import APIRouter, Depends, HTTPException, Request, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.db.session import get_db
from app.models.user import User
from app.schemas.auth import (
    AuthMessageResponse,
    ForgotPasswordRequest,
    LoginRequest,
    RefreshRequest,
    ResendVerificationRequest,
    ResetPasswordRequest,
    TokenResponse,
    VerifyEmailRequest,
)
from app.schemas.user import UserCreate, UserResponse
from app.services.auth_service import AuthService, AuthServiceError, OneTimeTokenDelivery, TokenBundle

router = APIRouter()
logger = logging.getLogger("nihongo.auth")


def _client_ip(request: Request) -> str | None:
    # Do not trust X-Forwarded-For here unless a trusted proxy middleware has
    # normalized it. Starlette's request.client is the safe default.
    return request.client.host[:45] if request.client and request.client.host else None


def _device_info(request: Request, supplied_name: str | None = None) -> str:
    return (supplied_name or request.headers.get("user-agent") or "Unknown device")[:255]


def _raise_service_error(error: AuthServiceError) -> None:
    raise HTTPException(
        status_code=error.status_code,
        detail=error.detail,
        headers=error.headers,
    ) from error


def _token_response(bundle: TokenBundle) -> TokenResponse:
    return TokenResponse(
        access_token=bundle.access_token,
        refresh_token=bundle.refresh_token,
        expires_in=bundle.expires_in,
        refresh_expires_in=bundle.refresh_expires_in,
    )


def _queue_auth_email(request: Request, purpose: str, delivery: OneTimeTokenDelivery | None) -> None:
    """Pass an internal token to an application-provided email queue callback.

    The callback is optional so local/test environments can exercise the API
    without SMTP. Raw tokens are never returned or logged by this module.
    """

    callback: Callable[..., None] | None = getattr(request.app.state, "auth_email_delivery", None)
    if callback is not None and delivery is not None:
        callback(purpose=purpose, email=delivery.email, token=delivery.token)


@router.post(
    "/register",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Register a learner account",
)
def register(user_in: UserCreate, request: Request, db: Session = Depends(get_db)) -> User:
    service = AuthService(db)
    try:
        user = service.register(
            email=str(user_in.email),
            password=user_in.password,
            profile=user_in.model_dump(exclude={"email", "password"}),
        )
        delivery = service.request_email_verification(email=user.email)
        try:
            _queue_auth_email(request, "verify_email", delivery)
        except Exception:
            # Account creation has already committed. Keep the response
            # idempotent for the client; resend-verification can retry delivery.
            logger.error("registration_verification_delivery_failed")
        return user
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.post("/login", response_model=TokenResponse, summary="Create a login session")
def login(login_in: LoginRequest, request: Request, db: Session = Depends(get_db)) -> TokenResponse:
    try:
        bundle = AuthService(db).login(
            email=str(login_in.email),
            password=login_in.password,
            ip_address=_client_ip(request),
            device_info=_device_info(request, login_in.device_name),
        )
        return _token_response(bundle)
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.post("/refresh", response_model=TokenResponse, summary="Rotate a refresh token")
def refresh(refresh_in: RefreshRequest, request: Request, db: Session = Depends(get_db)) -> TokenResponse:
    try:
        bundle = AuthService(db).refresh(
            raw_token=refresh_in.refresh_token,
            ip_address=_client_ip(request),
            device_info=_device_info(request),
        )
        return _token_response(bundle)
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.post("/logout", response_model=AuthMessageResponse, summary="Revoke one login session")
def logout(
    refresh_in: RefreshRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> AuthMessageResponse:
    try:
        AuthService(db).revoke_token(user_id=current_user.id, raw_token=refresh_in.refresh_token)
        return AuthMessageResponse(message="Session logged out")
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.post("/logout-all", response_model=AuthMessageResponse, summary="Revoke all login sessions")
def logout_all(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
) -> AuthMessageResponse:
    try:
        AuthService(db).revoke_all(user_id=current_user.id)
        return AuthMessageResponse(message="All sessions logged out")
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.post("/forgot-password", response_model=AuthMessageResponse, summary="Request a password reset")
def forgot_password(
    request_in: ForgotPasswordRequest,
    request: Request,
    db: Session = Depends(get_db),
) -> AuthMessageResponse:
    # The same response is returned for existing, unknown, inactive, and already
    # verified accounts to prevent account enumeration.
    try:
        delivery = AuthService(db).request_password_reset(email=str(request_in.email))
        _queue_auth_email(request, "reset_password", delivery)
    except Exception:
        # Keep this endpoint enumeration-safe. Delivery/storage failures must be
        # observed by the configured queue rather than reflected to the caller.
        logger.error("password_reset_request_failed")
    return AuthMessageResponse(message="If the account exists, password reset instructions will be sent")


@router.post("/reset-password", response_model=AuthMessageResponse, summary="Reset a password")
def reset_password(request_in: ResetPasswordRequest, db: Session = Depends(get_db)) -> AuthMessageResponse:
    try:
        AuthService(db).reset_password(raw_token=request_in.token, new_password=request_in.new_password)
        return AuthMessageResponse(message="Password has been reset")
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.post("/verify-email", response_model=AuthMessageResponse, summary="Verify an email address")
def verify_email(request_in: VerifyEmailRequest, db: Session = Depends(get_db)) -> AuthMessageResponse:
    try:
        AuthService(db).verify_email(raw_token=request_in.token)
        return AuthMessageResponse(message="Email address verified")
    except AuthServiceError as exc:
        _raise_service_error(exc)


@router.post(
    "/resend-verification",
    response_model=AuthMessageResponse,
    summary="Request another verification email",
)
def resend_verification(
    request_in: ResendVerificationRequest,
    request: Request,
    db: Session = Depends(get_db),
) -> AuthMessageResponse:
    try:
        delivery = AuthService(db).request_email_verification(email=str(request_in.email))
        _queue_auth_email(request, "verify_email", delivery)
    except Exception:
        logger.error("email_verification_request_failed")
    return AuthMessageResponse(message="If verification is required, instructions will be sent")
