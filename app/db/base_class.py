import uuid
from datetime import datetime, timezone
from sqlalchemy import Column, DateTime, String
from sqlalchemy.orm import declarative_base, declared_attr

# Create declarative base
Base = declarative_base()

class UUIDMixin:
    """Mixin to add a UUID primary key"""
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()), index=True)

class TimestampMixin:
    """Mixin to add created_at and updated_at timestamps"""
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), nullable=False)
    updated_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc), nullable=False)

class CustomBase(Base, UUIDMixin, TimestampMixin):
    """Base class for most models, includes UUID and Timestamps"""
    __abstract__ = True
    
    @declared_attr.directive
    def __tablename__(cls) -> str:
        """Automatically generate table names based on class name (pluralized logic can be added later)"""
        return cls.__name__.lower() + "s"
