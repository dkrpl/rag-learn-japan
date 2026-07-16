from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field

from app.models.question import QuestionType, SkillType


class MaterialDocumentResponse(BaseModel):
    id: str
    lesson_id: str | None = None
    title: str
    description: str | None = None
    level: str
    category: str | None = None
    sequence: int
    passing_score: int
    original_filename: str
    content_type: str
    file_size_bytes: int
    checksum: str
    file_url: str
    page_count: int
    extracted_text_preview: str
    extracted_text_char_count: int
    is_published: bool
    is_archived: bool
    created_by_id: str | None = None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


class MaterialQuestionJobCreate(BaseModel):
    question_count: int = Field(default=10, ge=1, le=30)
    question_type: QuestionType = QuestionType.MULTIPLE_CHOICE
    skill: SkillType = SkillType.READING
    difficulty: int = Field(default=1, ge=1, le=5)
    additional_notes: str | None = Field(default=None, max_length=4000)

    model_config = ConfigDict(extra="forbid")


class MaterialPreviewResponse(BaseModel):
    id: str
    title: str
    page_count: int
    extracted_text: str
    extracted_text_char_count: int
    is_published: bool


class MaterialUpdateRequest(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=255)
    description: str | None = Field(default=None, max_length=4000)
    level: str | None = Field(default=None, min_length=1, max_length=16)
    category: str | None = Field(default=None, max_length=100)
    sequence: int | None = Field(default=None, ge=0)
    passing_score: int | None = Field(default=None, ge=0, le=100)

    model_config = ConfigDict(extra="forbid")
