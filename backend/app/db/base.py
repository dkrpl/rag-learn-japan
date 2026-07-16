# ruff: noqa: F401
# Import Base from base_class
from app.db.base_class import Base

# Import all models here so Alembic can detect them
from app.models.ai_jobs import AuditLog, GenerationJob
from app.models.auth import PasswordResetToken, RefreshToken
from app.models.learning import LearningSession, LearningSessionQuestion
from app.models.material import MaterialDocument
from app.models.progress import UserMaterialProgress, XPTransaction
from app.models.question import Question, QuestionRevision
from app.models.user import User
