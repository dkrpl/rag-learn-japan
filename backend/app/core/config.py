from pathlib import Path
from typing import Literal

from pydantic import Field, field_validator, model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    PROJECT_NAME: str = "RAG Learn Japan API"
    VERSION: str = "1.0.0"
    ENVIRONMENT: Literal["local", "test", "staging", "production"] = "local"

    DATABASE_URL: str
    DB_POOL_SIZE: int = Field(default=10, ge=1, le=100)
    DB_MAX_OVERFLOW: int = Field(default=20, ge=0, le=200)
    DB_POOL_TIMEOUT_SECONDS: int = Field(default=30, ge=1, le=300)
    DB_POOL_RECYCLE_SECONDS: int = Field(default=1800, ge=60)

    REDIS_URL: str = "redis://127.0.0.1:6379/0"
    READINESS_CHECK_REDIS: bool = True

    SECRET_KEY: str = Field(min_length=32)
    JWT_ALGORITHM: Literal["HS256", "HS384", "HS512"] = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = Field(default=30, gt=0, le=1440)
    REFRESH_TOKEN_EXPIRE_DAYS: int = Field(default=7, gt=0, le=365)
    PASSWORD_RESET_EXPIRE_MINUTES: int = Field(default=30, gt=0, le=1440)
    LOGIN_RATE_LIMIT_ATTEMPTS: int = Field(default=5, ge=1, le=100)
    LOGIN_RATE_LIMIT_WINDOW_SECONDS: int = Field(default=300, ge=10)

    CORS_ORIGINS: list[str] = ["http://localhost:3000"]
    ALLOWED_HOSTS: list[str] = ["localhost", "127.0.0.1", "testserver"]
    CORS_ALLOW_CREDENTIALS: bool = True
    MAX_REQUEST_BODY_BYTES: int = Field(default=10 * 1024 * 1024, ge=1024)

    ENABLE_API_DOCS: bool = True
    ENABLE_METRICS: bool = True
    LOG_LEVEL: str = "INFO"

    AUDIO_STORAGE_PROVIDER: Literal["local", "s3"] = "local"
    AUDIO_STORAGE_PATH: Path = Path("data/uploads/audio")
    AUDIO_PUBLIC_BASE_URL: str = ""
    AUDIO_MAX_UPLOAD_BYTES: int = Field(default=10 * 1024 * 1024, ge=1024)
    AUDIO_ALLOWED_MIME_TYPES: list[str] = [
        "audio/mpeg",
        "audio/mp3",
        "audio/wav",
        "audio/x-wav",
        "audio/ogg",
        "audio/webm",
    ]
    S3_BUCKET_NAME: str = ""
    S3_ENDPOINT_URL: str = ""
    S3_REGION: str = "auto"
    S3_ACCESS_KEY_ID: str = ""
    S3_SECRET_ACCESS_KEY: str = ""
    S3_PRESIGNED_URL_EXPIRE_SECONDS: int = Field(default=900, ge=60, le=86400)

    AI_PROVIDER: Literal["gemini", "disabled"] = "disabled"
    GEMINI_API_KEY: str = ""
    GEMINI_MODEL: str = "gemini-3.5-flash"
    AI_REQUEST_TIMEOUT_SECONDS: int = Field(default=60, ge=5, le=300)
    AI_MAX_RETRIES: int = Field(default=3, ge=0, le=10)

    TTS_PROVIDER: Literal["google_cloud", "gtts", "disabled"] = "disabled"
    GOOGLE_TTS_LANGUAGE_CODE: str = "ja-JP"
    GOOGLE_TTS_VOICE_NAME: str = "ja-JP-Neural2-B"

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
        extra="ignore",
    )

    @field_validator("CORS_ORIGINS", "ALLOWED_HOSTS")
    @classmethod
    def reject_empty_items(cls, value: list[str]) -> list[str]:
        cleaned = [item.strip() for item in value if item and item.strip()]
        if not cleaned:
            raise ValueError("configuration list cannot be empty")
        return cleaned

    @field_validator("DATABASE_URL", mode="before")
    @classmethod
    def normalize_database_url(cls, value: str) -> str:
        if isinstance(value, str) and value.startswith("mysql://"):
            return value.replace("mysql://", "mysql+pymysql://", 1)
        return value

    @field_validator("LOG_LEVEL")
    @classmethod
    def normalize_log_level(cls, value: str) -> str:
        normalized = value.upper()
        if normalized not in {"DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"}:
            raise ValueError("LOG_LEVEL is invalid")
        return normalized

    @model_validator(mode="after")
    def validate_deployment_security(self) -> "Settings":
        if self.ENVIRONMENT in {"staging", "production"}:
            if self.SECRET_KEY.startswith("CHANGE_THIS") or "super_secret" in self.SECRET_KEY.lower():
                raise ValueError("SECRET_KEY must be replaced for staging/production")
            if "*" in self.CORS_ORIGINS and self.CORS_ALLOW_CREDENTIALS:
                raise ValueError("credentialed CORS cannot use a wildcard origin")
            if "*" in self.ALLOWED_HOSTS:
                raise ValueError("ALLOWED_HOSTS cannot use wildcard in staging/production")
        if self.AI_PROVIDER == "gemini" and not self.GEMINI_API_KEY:
            raise ValueError("GEMINI_API_KEY is required when AI_PROVIDER=gemini")
        if self.AUDIO_STORAGE_PROVIDER == "s3":
            required = [self.S3_BUCKET_NAME, self.S3_ACCESS_KEY_ID, self.S3_SECRET_ACCESS_KEY]
            if not all(required):
                raise ValueError("S3 bucket and credentials are required when AUDIO_STORAGE_PROVIDER=s3")
        if self.ENVIRONMENT == "production" and self.TTS_PROVIDER == "gtts":
            raise ValueError("gTTS is development-only; use google_cloud or disabled in production")
        return self


settings = Settings()
