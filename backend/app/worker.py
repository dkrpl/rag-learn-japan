from celery import Celery

from app.core.config import settings

celery_app = Celery(
    "nihongo_worker",
    broker=settings.REDIS_URL,
    backend=settings.REDIS_URL,
    include=["app.tasks.ai_tasks"],
)

celery_app.config_from_object("app.core.celery_config")

if __name__ == "__main__":
    celery_app.start()
