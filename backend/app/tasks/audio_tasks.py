import time
from datetime import datetime, timezone

from app.db.session import SessionLocal
from app.models.ai_jobs import GenerationJob, JobStatus
from app.models.content import AudioAsset
from app.services.tts_provider import get_tts_provider
from app.worker import celery_app


@celery_app.task(bind=True, name="audio.generate_tts")
def generate_tts_task(self, job_id: str):
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

        provider = get_tts_provider()
        prompt = job.prompt_json  # For TTS this should be the raw transcript string

        result = provider.generate_audio(text=prompt)

        latency = time.time() - start_time

        # Create AudioAsset
        asset = AudioAsset(
            file_url=result["file_url"],
            file_path=result.get("file_path"),
            storage_backend=result.get("storage_backend", "local"),
            storage_key=result.get("storage_key"),
            content_type=result.get("content_type", "audio/mpeg"),
            transcript=result["transcript"],
            duration_seconds=result["duration_seconds"],
            checksum=result["checksum"],
            is_published=False,
            created_by_id=job.created_by,
        )
        db.add(asset)
        db.flush()

        job.status = JobStatus.COMPLETED
        job.target_id = asset.id
        job.completed_at = datetime.now(timezone.utc)
        job.error_message = None
        db.commit()

        return {"status": "success", "asset_id": asset.id, "latency_seconds": latency}

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
