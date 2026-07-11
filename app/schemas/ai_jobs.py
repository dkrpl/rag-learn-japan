from pydantic import BaseModel
from typing import Optional, Any
from datetime import datetime
from app.models.ai_jobs import JobStatus, JobType
from app.models.question import QuestionType, SkillType

class GenerationJobCreate(BaseModel):
    lesson_id: str
    question_type: QuestionType
    skill: SkillType
    count: int = 5
    difficulty: int = 1
    prompt_version: str = "v1"
    additional_notes: Optional[str] = None

class AudioJobCreate(BaseModel):
    transcript: str
    lesson_id: Optional[str] = None

class GenerationJobResponse(BaseModel):
    id: str
    job_type: JobType
    status: JobStatus
    prompt_json: str
    error_message: Optional[str]
    tokens_used: int
    created_by: Optional[str]
    started_at: Optional[datetime]
    completed_at: Optional[datetime]
    celery_task_id: Optional[str] = None
    target_id: Optional[str] = None

    class Config:
        from_attributes = True
