import enum

from sqlalchemy import Boolean, Column, Date, DateTime, Integer, String
from sqlalchemy import Enum as SQLEnum

from app.db.base_class import CustomBase


class UserRole(str, enum.Enum):
    """Canonical application roles exposed by the public API."""

    LEARNER = "learner"
    CONTENT_EDITOR = "content_editor"
    REVIEWER = "reviewer"
    ADMINISTRATOR = "administrator"

    @classmethod
    def from_value(cls, value: "UserRole | str") -> "UserRole":
        if isinstance(value, cls):
            return value
        return cls(str(value).strip().lower())


class User(CustomBase):
    """Authenticated account and learner profile."""

    email = Column(String(255), unique=True, index=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    name = Column(String(255), nullable=True)
    photo_url = Column(String(512), nullable=True)
    timezone = Column(String(50), default="UTC", nullable=False)
    target_level = Column(String(10), default="N5", nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)
    deactivated_at = Column(DateTime(timezone=True), nullable=True)
    email_verified_at = Column(DateTime(timezone=True), nullable=True)
    last_login_at = Column(DateTime(timezone=True), nullable=True)

    # Store enum values, rather than Python member names, so the database and API
    # both use the canonical lowercase representation from the PRD.
    role = Column(
        SQLEnum(
            UserRole,
            values_callable=lambda roles: [role.value for role in roles],
            name="user_role",
            native_enum=False,
            validate_strings=True,
            create_constraint=True,
            length=32,
        ),
        default=UserRole.LEARNER,
        nullable=False,
    )

    # User streak is intentionally denormalized on users for the MVP.
    current_streak = Column(Integer, default=0, nullable=False)
    longest_streak = Column(Integer, default=0, nullable=False)
    last_activity_date = Column(Date, nullable=True)

    @property
    def is_email_verified(self) -> bool:
        return self.email_verified_at is not None
