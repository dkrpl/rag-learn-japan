from fastapi import APIRouter, Depends, HTTPException, status
from redis import Redis
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.core.config import settings
from app.db.session import get_db

router = APIRouter()

@router.get("/health", summary="Check API health")
def check_health():
    """
    Check if the API is running. Does not check database.
    """
    return {
        "status": "success",
        "data": {
            "status": "ok"
        }
    }

@router.get("/ready", summary="Check database readiness")
def check_readiness(db: Session = Depends(get_db)):
    """
    Check if the application dependencies (like database) are ready.
    """
    try:
        # Ping the database
        db.execute(text("SELECT 1"))
        dependencies = {"database": "connected"}
        if settings.READINESS_CHECK_REDIS:
            redis_client = Redis.from_url(
                settings.REDIS_URL,
                socket_connect_timeout=1,
                socket_timeout=1,
                decode_responses=True,
            )
            redis_client.ping()
            dependencies["redis"] = "connected"
        return {
            "status": "success",
            "data": {
                "status": "ready",
                **dependencies,
            },
        }
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail={"code": "DEPENDENCY_UNAVAILABLE", "message": "A required dependency is unavailable"},
        ) from None

@router.get("/meta", summary="Get application metadata")
def get_metadata():
    """
    Get basic application metadata (version, environment).
    """
    return {
        "status": "success",
        "data": {
            "name": settings.PROJECT_NAME,
            "version": settings.VERSION,
            "environment": settings.ENVIRONMENT
        }
    }
