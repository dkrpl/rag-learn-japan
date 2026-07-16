from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.api.deps import RoleChecker
from app.db.session import get_db
from app.models.ai_jobs import AuditLog
from app.models.user import UserRole
from app.schemas.audit import AuditLogResponse

router = APIRouter(dependencies=[Depends(RoleChecker([UserRole.ADMINISTRATOR]))])


@router.get("", response_model=list[AuditLogResponse], summary="List admin audit logs")
def list_audit_logs(
    entity_name: str | None = Query(default=None, max_length=100),
    entity_id: str | None = Query(default=None, max_length=36),
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=50, ge=1, le=200),
    db: Session = Depends(get_db),
):
    query = db.query(AuditLog)
    if entity_name:
        query = query.filter(AuditLog.entity_name == entity_name)
    if entity_id:
        query = query.filter(AuditLog.entity_id == entity_id)
    return query.order_by(AuditLog.created_at.desc(), AuditLog.id.desc()).offset(offset).limit(limit).all()
