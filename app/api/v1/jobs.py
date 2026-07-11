from datetime import datetime
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy.orm import Session

from app.api.deps import get_current_user_require_roles
from app.db.session import get_db
from app.models.ai_jobs import GenerationJob, JobStatus
from app.models.user import User
from app.worker import celery_app

router = APIRouter()


class JobDetailResponse(BaseModel):
    id: str
    job_type: str
    status: str
    target_id: Optional[str]
    error_message: Optional[str]
    tokens_used: int
    started_at: Optional[datetime]
    completed_at: Optional[datetime]


@router.get("/{job_id}", response_model=JobDetailResponse)
def get_job_status(
    job_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user_require_roles(["administrator", "content_editor"])),
):
    job = db.query(GenerationJob).filter(GenerationJob.id == job_id).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    return JobDetailResponse(
        id=job.id,
        job_type=job.job_type.value,
        status=job.status.value,
        target_id=job.target_id,
        error_message=job.error_message,
        tokens_used=job.tokens_used,
        started_at=job.started_at,
        completed_at=job.completed_at,
    )


@router.delete("/{job_id}", status_code=status.HTTP_204_NO_CONTENT)
def cancel_job(
    job_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user_require_roles(["administrator", "content_editor"])),
):
    job = db.query(GenerationJob).filter(GenerationJob.id == job_id).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    if job.status in [JobStatus.COMPLETED, JobStatus.FAILED, JobStatus.CANCELLED]:
        raise HTTPException(status_code=400, detail="Job is already finished")

    job.status = JobStatus.CANCELLED
    db.commit()

    # Attempt to revoke celery task if running/pending
    if job.celery_task_id:
        celery_app.control.revoke(job.celery_task_id, terminate=True)
