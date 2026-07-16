"""Material progress and XP persistence for the PDF quiz MVP."""

from __future__ import annotations

import enum

from sqlalchemy import (
    CheckConstraint,
    Column,
    Enum,
    ForeignKey,
    Index,
    Integer,
    String,
    UniqueConstraint,
)

from app.db.base_class import CustomBase


class MaterialProgressStatus(str, enum.Enum):
    NOT_STARTED = "NOT_STARTED"
    IN_PROGRESS = "IN_PROGRESS"
    COMPLETED = "COMPLETED"


class UserMaterialProgress(CustomBase):
    __tablename__ = "user_material_progress"
    __table_args__ = (
        UniqueConstraint("user_id", "material_id", name="uq_user_material_progress"),
        CheckConstraint("attempts_count >= 0", name="ck_material_progress_attempts"),
        CheckConstraint("best_score BETWEEN 0 AND 100", name="ck_material_progress_best_score"),
        CheckConstraint("last_score BETWEEN 0 AND 100", name="ck_material_progress_last_score"),
        Index("ix_material_progress_user_status", "user_id", "status"),
    )

    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    material_id = Column(String(36), ForeignKey("material_documents.id", ondelete="CASCADE"), nullable=False)
    status = Column(Enum(MaterialProgressStatus), default=MaterialProgressStatus.NOT_STARTED, nullable=False)
    attempts_count = Column(Integer, default=0, nullable=False)
    best_score = Column(Integer, default=0, nullable=False)
    last_score = Column(Integer, default=0, nullable=False)


class XPTransaction(CustomBase):
    __tablename__ = "xp_transactions"
    __table_args__ = (
        UniqueConstraint("session_id", name="uq_xp_transaction_session"),
        UniqueConstraint("user_id", "material_id", "reason", name="uq_xp_transaction_material_reward"),
        CheckConstraint("amount >= 0", name="ck_xp_transaction_amount"),
        Index("ix_xp_transactions_user_created", "user_id", "created_at"),
    )

    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    material_id = Column(String(36), ForeignKey("material_documents.id", ondelete="CASCADE"), nullable=True)
    amount = Column(Integer, nullable=False)
    reason = Column(String(255), nullable=False)
    session_id = Column(String(36), ForeignKey("learning_sessions.id", ondelete="SET NULL"), nullable=True)
