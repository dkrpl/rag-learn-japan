from datetime import datetime, timezone

from pydantic import BaseModel, ConfigDict, EmailStr, Field, field_validator


def _validate_password(value: str) -> str:
    if len(value.encode("utf-8")) > 72:
        raise ValueError("Password must not exceed 72 UTF-8 bytes")
    if not any(character.isalpha() for character in value):
        raise ValueError("Password must contain at least one letter")
    if not any(character.isdigit() for character in value):
        raise ValueError("Password must contain at least one number")
    return value


class AuthRequest(BaseModel):
    # Passwords are intentionally not stripped; whitespace may be part of a
    # credential and must round-trip exactly.
    model_config = ConfigDict(extra="forbid")


class LoginRequest(AuthRequest):
    email: EmailStr
    # Login accepts legacy credentials; password strength is enforced only when
    # a password is created or changed.
    password: str = Field(min_length=1, max_length=128)
    device_name: str | None = Field(default=None, max_length=255)


class RefreshRequest(AuthRequest):
    refresh_token: str = Field(min_length=32, max_length=4096)


class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    expires_in: int
    refresh_expires_in: int


class ForgotPasswordRequest(AuthRequest):
    email: EmailStr


class ResetPasswordRequest(AuthRequest):
    token: str = Field(min_length=32, max_length=512)
    new_password: str = Field(min_length=8, max_length=128)

    _password_policy = field_validator("new_password")(_validate_password)


class VerifyEmailRequest(AuthRequest):
    token: str = Field(min_length=32, max_length=512)


class ResendVerificationRequest(AuthRequest):
    email: EmailStr


class AuthMessageResponse(BaseModel):
    status: str = "success"
    message: str


class SessionResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    device_info: str | None
    ip_address: str | None
    created_at: datetime
    last_used_at: datetime | None
    expires_at: datetime
    is_current: bool = False

    @field_validator("created_at", "last_used_at", "expires_at")
    @classmethod
    def timestamps_are_utc(cls, value: datetime | None) -> datetime | None:
        if value is None:
            return value
        if value.tzinfo is None:
            return value.replace(tzinfo=timezone.utc)
        return value.astimezone(timezone.utc)


class SessionListResponse(BaseModel):
    items: list[SessionResponse]
    total: int
