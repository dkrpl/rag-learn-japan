from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field
from typing import Dict, Any, Optional

from app.db.session import get_db
from app.models.user import User
from app.api.deps import get_current_user_require_roles
from app.models.ai_jobs import GenerationJob, JobType, JobStatus
from app.tasks.ai_tasks import generate_questions_task
from app.tasks.audio_tasks import generate_tts_task

router = APIRouter()

class GenerateQuestionsRequest(BaseModel):
    lesson_id: str
    prompt: str = Field(..., description="The raw prompt for the AI to generate questions")

class GenerateAudioRequest(BaseModel):
    transcript: str = Field(..., description="The transcript text for TTS")

class JobResponse(BaseModel):
    job_id: str
    status: str
    message: str

@router.post("/questions", response_model=JobResponse)
def trigger_question_generation(
    req: GenerateQuestionsRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user_require_roles(["administrator", "content_editor"]))
):
    job = GenerationJob(
        job_type=JobType.QUESTION_GENERATION,
        status=JobStatus.PENDING,
        prompt_json=req.prompt,
        target_id=req.lesson_id,
        created_by=current_user.id
    )
    db.add(job)
    db.commit()
    db.refresh(job)
    
    # Trigger celery task
    generate_questions_task.delay(job.id)
    
    return JobResponse(job_id=job.id, status=job.status.value, message="Question generation job started")

@router.post("/audio", response_model=JobResponse)
def trigger_audio_generation(
    req: GenerateAudioRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user_require_roles(["administrator", "content_editor"]))
):
    job = GenerationJob(
        job_type=JobType.TTS_GENERATION,
        status=JobStatus.PENDING,
        prompt_json=req.transcript,
        created_by=current_user.id
    )
    db.add(job)
    db.commit()
    db.refresh(job)
    
    # Trigger celery task
    generate_tts_task.delay(job.id)
    
    return JobResponse(job_id=job.id, status=job.status.value, message="Audio generation job started")
