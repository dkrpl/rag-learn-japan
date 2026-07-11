from datetime import date, datetime, timezone
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

from pydantic import BaseModel, ConfigDict, EmailStr, Field, HttpUrl, field_validator

from app.models.user import UserRole
from app.schemas.auth import _validate_password


def _validate_timezone(value: str | None) -> str | None:
    if value is None:
        return value
    try:
        ZoneInfo(value)
    except ZoneInfoNotFoundError as exc:
        raise ValueError("Unknown IANA timezone") from exc
    return value


class UserBase(BaseModel):
    model_config = ConfigDict()

    email: EmailStr
    name: str | None = Field(default=None, max_length=255)
    photo_url: str | None = Field(default=None, max_length=512)
    timezone: str = Field(default="UTC", max_length=50)
    target_level: str = Field(default="N5", pattern=r"^N[1-5]$")

    _timezone_is_valid = field_validator("timezone")(_validate_timezone)

    @field_validator("photo_url")
    @classmethod
    def photo_url_is_http(cls, value: str | None) -> str | None:
        if value is None:
            return value
        return str(HttpUrl(value))


class UserCreate(UserBase):
    # Unknown fields are ignored deliberately: a submitted role/status can never
    # be mass-assigned because the service constructs an explicit learner User.
    model_config = ConfigDict(extra="ignore")

    password: str = Field(min_length=8, max_length=128)

    _password_policy = field_validator("password")(_validate_password)


class UserUpdate(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)

    name: str | None = Field(default=None, max_length=255)
    photo_url: str | None = Field(default=None, max_length=512)
    timezone: str | None = Field(default=None, max_length=50)
    target_level: str | None = Field(default=None, pattern=r"^N[1-5]$")

    _timezone_is_valid = field_validator("timezone")(_validate_timezone)

    @field_validator("photo_url")
    @classmethod
    def photo_url_is_http(cls, value: str | None) -> str | None:
        if value is None:
            return value
        return str(HttpUrl(value))


class UserPasswordUpdate(BaseModel):
    model_config = ConfigDict(extra="forbid")

    current_password: str = Field(min_length=1, max_length=128)
    new_password: str = Field(min_length=8, max_length=128)

    _password_policy = field_validator("new_password")(_validate_password)


class UserResponse(UserBase):
    model_config = ConfigDict(from_attributes=True)

    id: str
    is_active: bool
    is_email_verified: bool
    role: UserRole
    current_streak: int = 0
    longest_streak: int = 0
    last_activity_date: date | None = None
    last_login_at: datetime | None = None
    created_at: datetime
    updated_at: datetime

    @field_validator("last_login_at", "created_at", "updated_at")
    @classmethod
    def timestamps_are_utc(cls, value: datetime | None) -> datetime | None:
        if value is None:
            return value
        if value.tzinfo is None:
            return value.replace(tzinfo=timezone.utc)
        return value.astimezone(timezone.utc)


class UserStatusUpdate(BaseModel):
    model_config = ConfigDict(extra="forbid")

    is_active: bool


class UserRoleUpdate(BaseModel):
    model_config = ConfigDict(extra="forbid")

    role: UserRole


class UserListResponse(BaseModel):
    items: list[UserResponse]
    total: int
    offset: int
    limit: int


class UserMessageResponse(BaseModel):
    status: str = "success"
    message: str
