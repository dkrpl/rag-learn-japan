import json
import time
from datetime import datetime, timezone
from app.worker import celery_app
from app.db.session import SessionLocal
from app.models.ai_jobs import GenerationJob, JobStatus, JobType
from app.models.question import Question, QuestionStatus, QuestionType
from app.models.curriculum import Lesson
from app.services.ai_provider import get_ai_provider

@celery_app.task(bind=True, name="ai.generate_questions")
def generate_questions_task(self, job_id: str):
    start_time = time.time()
    db = SessionLocal()
    
    try:
        job = db.query(GenerationJob).filter(GenerationJob.id == job_id).first()
        if not job:
            return {"status": "error", "message": f"Job {job_id} not found"}
            
        if job.status == JobStatus.CANCELLED:
            return {"status": "cancelled", "message": "Job was cancelled"}
            
        job.status = JobStatus.PROCESSING
        job.started_at = datetime.now(timezone.utc)
        job.celery_task_id = self.request.id
        db.commit()
        
        provider = get_ai_provider()
        prompt = job.prompt_json  # Assuming prompt_json contains the literal prompt for MVP
        
        content, metadata = provider.generate_questions(prompt)
        
        # Calculate latency
        latency = time.time() - start_time
        
        # Parse JSON and validate
        try:
            questions_data = json.loads(content)
            if not isinstance(questions_data, list):
                raise ValueError("AI response must be a JSON array of questions")
            
            created_questions = []
            for q_data in questions_data:
                # Basic validation for required fields
                if "type" not in q_data or "prompt" not in q_data or "correct_answer" not in q_data:
                    continue # Skip invalid
                
                lesson_id = job.target_id
                # Check if lesson exists
                lesson = db.query(Lesson).filter(Lesson.id == lesson_id).first() if lesson_id else None
                
                new_q = Question(
                    type=QuestionType(q_data["type"]),
                    lesson_id=lesson.id if lesson else None,
                    difficulty=q_data.get("difficulty", 1),
                    prompt_json=q_data,  # Store the whole object in prompt_json
                    correct_answer=q_data["correct_answer"],
                    explanation=q_data.get("explanation"),
                    status=QuestionStatus.AUTO_VALIDATED, # Per PRD
                    created_by_id=job.created_by
                )
                db.add(new_q)
                created_questions.append(new_q)
                
            db.commit()
            
            job.status = JobStatus.COMPLETED
            job.raw_response = content
            job.tokens_used = metadata.get("tokens_used", 0)
            job.completed_at = datetime.now(timezone.utc)
            job.error_message = None
            
        except json.JSONDecodeError as e:
            raise Exception(f"AI returned invalid JSON: {str(e)}\nResponse: {content}")
        except Exception as e:
            raise Exception(f"Validation error: {str(e)}")
            
        db.commit()
        return {"status": "success", "created_count": len(created_questions), "latency_seconds": latency}

    except Exception as e:
        db.rollback()
        job = db.query(GenerationJob).filter(GenerationJob.id == job_id).first()
        if job:
            job.status = JobStatus.FAILED
            job.error_message = str(e)
            job.completed_at = datetime.now(timezone.utc)
            db.commit()
        return {"status": "error", "message": str(e)}
    finally:
        db.close()
