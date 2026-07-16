from datetime import datetime

from pydantic import BaseModel, ConfigDict


class AuditLogResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    user_id: str | None = None
    action: str
    entity_name: str
    entity_id: str
    details: str | None = None
    created_at: datetime
