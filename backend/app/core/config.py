import os
from pathlib import Path
from typing import Literal
from urllib.parse import quote_plus

from pydantic import Field, field_validator, model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


def _normalize_database_url(value: str) -> str:
    if value.startswith("mysql://"):
        return value.replace("mysql://", "mysql+pymysql://", 1)
    return value


def _railway_mysql_url_from_env() -> str:
    mysql_url = os.getenv("MYSQL_URL", "")
    if mysql_url:
        return _normalize_database_url(mysql_url)

    host = os.getenv("MYSQLHOST", "")
    port = os.getenv("MYSQLPORT", "3306")
    user = os.getenv("MYSQLUSER", "")
    password = os.getenv("MYSQLPASSWORD", "")
    database = os.getenv("MYSQLDATABASE", "")
    if all((host, port, user, database)):
        return (
            f"mysql+pymysql://{quote_plus(user)}:{quote_plus(password)}"
            f"@{host}:{port}/{quote_plus(database)}"
        )
    return ""


class Settings(BaseSettings):
    PROJECT_NAME: str = "RAG Learn Japan API"
    VERSION: str = "1.0.0"
    ENVIRONMENT: Literal["local", "test", "staging", "production"] = "local"

    DATABASE_URL: str = ""
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

    MATERIAL_STORAGE_PATH: Path = Path("data/uploads/materials")

    AI_PROVIDER: Literal["gemini", "disabled"] = "disabled"
    GEMINI_API_KEY: str = ""
    GEMINI_MODEL: str = "gemini-3.5-flash"
    AI_REQUEST_TIMEOUT_SECONDS: int = Field(default=60, ge=5, le=300)
    AI_MAX_RETRIES: int = Field(default=3, ge=0, le=10)
    AI_DAILY_GENERATION_LIMIT: int = Field(default=5, ge=1, le=100)

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
    def normalize_database_url(cls, value: str | None) -> str:
        if not value:
            return _railway_mysql_url_from_env()
        if isinstance(value, str):
            return _normalize_database_url(value)
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
        if not self.DATABASE_URL:
            raise ValueError("DATABASE_URL, MYSQL_URL, or MYSQLHOST/MYSQLUSER/MYSQLPASSWORD/MYSQLDATABASE must be set")
        if self.ENVIRONMENT in {"staging", "production"}:
            if self.SECRET_KEY.startswith("CHANGE_THIS") or "super_secret" in self.SECRET_KEY.lower():
                raise ValueError("SECRET_KEY must be replaced for staging/production")
            if "*" in self.CORS_ORIGINS and self.CORS_ALLOW_CREDENTIALS:
                raise ValueError("credentialed CORS cannot use a wildcard origin")
            if "*" in self.ALLOWED_HOSTS:
                raise ValueError("ALLOWED_HOSTS cannot use wildcard in staging/production")
        if self.AI_PROVIDER == "gemini" and not self.GEMINI_API_KEY:
            raise ValueError("GEMINI_API_KEY is required when AI_PROVIDER=gemini")
        return self


settings = Settings()
