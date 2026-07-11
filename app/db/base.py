# ruff: noqa: F401
# Import Base from base_class
from app.db.base_class import Base

# Import all models here so Alembic can detect them
from app.models.ai_jobs import AuditLog, GenerationJob
from app.models.auth import PasswordResetToken, RefreshToken
from app.models.content import AudioAsset, ExampleSentence, GrammarPoint, Kanji, Reading, Vocabulary
from app.models.curriculum import Course, Lesson, LessonSection, Level, Unit
from app.models.learning import LearningSession, LearningSessionQuestion
from app.models.progress import ReviewSchedule, UserLessonProgress, UserMastery, UserMistake, XPTransaction
from app.models.question import Question, QuestionReview
from app.models.simulation import (
    JlptSimulation,
    JlptSimulationQuestion,
    JlptSimulationSection,
    UserSimulationAttempt,
    UserSimulationAttemptQuestion,
    UserSimulationAttemptSection,
)
from app.models.user import User
