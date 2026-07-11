# Import Base from base_class
from app.db.base_class import Base

# Import all models here so Alembic can detect them
from app.models.user import User
from app.models.auth import RefreshToken, PasswordResetToken
from app.models.curriculum import Level, Course, Unit, Lesson, LessonSection
from app.models.content import Vocabulary, Kanji, GrammarPoint, ExampleSentence, Reading, AudioAsset
from app.models.question import Question, QuestionReview
from app.models.learning import LearningSession, LearningSessionQuestion
from app.models.progress import UserLessonProgress, UserMastery, UserMistake, XPTransaction, ReviewSchedule
from app.models.ai_jobs import GenerationJob, AuditLog
from app.models.simulation import JlptSimulation, JlptSimulationSection, JlptSimulationQuestion, UserSimulationAttempt, UserSimulationAttemptSection, UserSimulationAttemptQuestion
