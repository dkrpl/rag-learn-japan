from sqlalchemy import Boolean, Column, DateTime, ForeignKey, Index, String

from app.db.base_class import CustomBase


class RefreshToken(CustomBase):
    """A refresh-token session.

    Only a SHA-256 digest of the signed refresh token is persisted. ``family_id``
    groups rotated tokens so reuse of an old token can invalidate only the
    compromised session family rather than every device owned by the user.
    """

    __tablename__ = "refresh_tokens"
    __table_args__ = (
        Index("ix_refresh_tokens_user_active", "user_id", "is_revoked", "expires_at"),
        Index("ix_refresh_tokens_family", "family_id"),
        Index("ix_refresh_tokens_expires_at", "expires_at"),
    )

    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    family_id = Column(String(36), nullable=False)
    token_hash = Column(String(64), unique=True, index=True, nullable=False)
    expires_at = Column(DateTime(timezone=True), nullable=False)
    is_revoked = Column(Boolean, default=False, nullable=False)
    revoked_at = Column(DateTime(timezone=True), nullable=True)
    revoke_reason = Column(String(50), nullable=True)
    last_used_at = Column(DateTime(timezone=True), nullable=True)
    device_info = Column(String(255), nullable=True)
    ip_address = Column(String(45), nullable=True)


class PasswordResetToken(CustomBase):
    """Single-use, short-lived password reset token."""

    __tablename__ = "password_reset_tokens"
    __table_args__ = (
        Index("ix_password_reset_tokens_user", "user_id", "is_used"),
        Index("ix_password_reset_tokens_expires_at", "expires_at"),
    )

    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    token_hash = Column(String(64), unique=True, index=True, nullable=False)
    expires_at = Column(DateTime(timezone=True), nullable=False)
    is_used = Column(Boolean, default=False, nullable=False)
    used_at = Column(DateTime(timezone=True), nullable=True)


class EmailVerificationToken(CustomBase):
    """Single-use email ownership verification token."""

    __tablename__ = "email_verification_tokens"
    __table_args__ = (
        Index("ix_email_verification_tokens_user", "user_id", "is_used"),
        Index("ix_email_verification_tokens_expires_at", "expires_at"),
    )

    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    token_hash = Column(String(64), unique=True, index=True, nullable=False)
    expires_at = Column(DateTime(timezone=True), nullable=False)
    is_used = Column(Boolean, default=False, nullable=False)
    used_at = Column(DateTime(timezone=True), nullable=True)
