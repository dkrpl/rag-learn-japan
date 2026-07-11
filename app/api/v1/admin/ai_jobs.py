import json
from fastapi import APIRouter, Depends, BackgroundTasks, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime, timezone
from typing import List

from app.db.session import get_db, SessionLocal
from app.api.deps import RoleChecker, get_current_user
from app.models.user import User, UserRole
from app.models.ai_jobs import GenerationJob, JobType, JobStatus, AuditLog
from app.models.question import Question, QuestionStatus
from app.schemas.ai_jobs import GenerationJobCreate, AudioJobCreate, GenerationJobResponse
from app.services.ai_provider import get_ai_provider
from app.tasks.ai_tasks import generate_questions_task
from app.tasks.audio_tasks import generate_tts_task
from app.worker import celery_app

admin_checker = RoleChecker([UserRole.CONTENT_EDITOR, UserRole.ADMINISTRATOR])
router = APIRouter(dependencies=[Depends(admin_checker)])



@router.post("/", response_model=GenerationJobResponse)
def create_generation_job(
    job_in: GenerationJobCreate, 
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_user)
):
    job = GenerationJob(
        job_type=JobType.QUESTION_GENERATION,
        status=JobStatus.PENDING,
        prompt_json=job_in.model_dump_json(),
        target_id=job_in.lesson_id,
        created_by=current_user.id
    )
    db.add(job)
    
    # Audit Log
    log = AuditLog(
        user_id=current_user.id,
        action="CREATE_AI_JOB",
        entity_name="generation_jobs",
        entity_id="PENDING_ID", # Will update below
        details=f"Job Type: {JobType.QUESTION_GENERATION}"
    )
    db.add(log)
    
    db.commit()
    db.refresh(job)
    
    log.entity_id = job.id
    db.commit()
    
    # Send to background worker
    generate_questions_task.delay(job.id)
    
    return job

@router.get("/", response_model=List[GenerationJobResponse])
def get_jobs(db: Session = Depends(get_db)):
    return db.query(GenerationJob).all()

@router.get("/{job_id}", response_model=GenerationJobResponse)
def get_job(job_id: str, db: Session = Depends(get_db)):
    job = db.query(GenerationJob).filter(GenerationJob.id == job_id).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    return job

@router.post("/audio", response_model=GenerationJobResponse)
def create_audio_job(
    job_in: AudioJobCreate, 
    db: Session = Depends(get_db), 
    current_user: User = Depends(get_current_user)
):
    job = GenerationJob(
        job_type=JobType.TTS_GENERATION,
        status=JobStatus.PENDING,
        prompt_json=job_in.transcript,
        target_id=job_in.lesson_id,
        created_by=current_user.id
    )
    db.add(job)
    
    log = AuditLog(
        user_id=current_user.id,
        action="CREATE_TTS_JOB",
        entity_name="generation_jobs",
        entity_id="PENDING_ID",
        details="Job Type: TTS_GENERATION"
    )
    db.add(log)
    
    db.commit()
    db.refresh(job)
    
    log.entity_id = job.id
    db.commit()
    
    # Send to background worker
    generate_tts_task.delay(job.id)
    
    return job

@router.delete("/{job_id}", status_code=204)
def cancel_job(
    job_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
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

