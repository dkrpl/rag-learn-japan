from datetime import datetime
from typing import Any

from pydantic import BaseModel, ConfigDict, Field, model_validator


def _reject_unsafe_control_characters(value: Any) -> Any:
    if isinstance(value, str):
        if any(ord(char) < 32 and char not in "\n\r\t" for char in value):
            raise ValueError("text contains an unsupported control character")
        return value
    if isinstance(value, list):
        return [_reject_unsafe_control_characters(item) for item in value]
    if isinstance(value, dict):
        return {key: _reject_unsafe_control_characters(item) for key, item in value.items()}
    return value


class InputSchema(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)

    @model_validator(mode="before")
    @classmethod
    def reject_control_characters(cls, value: Any) -> Any:
        return _reject_unsafe_control_characters(value)


class LifecycleResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    is_published: bool
    is_archived: bool
    published_at: datetime | None = None
    archived_at: datetime | None = None
    created_at: datetime
    updated_at: datetime


class LifecycleActionResponse(BaseModel):
    id: str
    resource_type: str
    state: str


class LevelCreate(InputSchema):
    code: str | None = Field(default=None, min_length=1, max_length=16, pattern=r"^[A-Za-z0-9_-]+$")
    name: str = Field(min_length=1, max_length=50)
    description: str | None = Field(default=None, max_length=10_000)
    sequence: int = Field(default=0, ge=0)
    is_published: bool = False


class LevelUpdate(InputSchema):
    code: str | None = Field(default=None, min_length=1, max_length=16, pattern=r"^[A-Za-z0-9_-]+$")
    name: str | None = Field(default=None, min_length=1, max_length=50)
    description: str | None = Field(default=None, max_length=10_000)
    sequence: int | None = Field(default=None, ge=0)
    is_published: bool | None = None


class LevelResponse(LifecycleResponse):
    id: str
    code: str | None = None
    name: str
    description: str | None = None
    sequence: int


class CourseCreate(InputSchema):
    level_id: str
    title: str = Field(min_length=1, max_length=255)
    slug: str | None = Field(default=None, min_length=1, max_length=255, pattern=r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
    description: str | None = Field(default=None, max_length=20_000)
    image_url: str | None = Field(default=None, max_length=512)
    sequence: int = Field(default=0, ge=0)
    is_published: bool = False


class CourseUpdate(InputSchema):
    level_id: str | None = None
    title: str | None = Field(default=None, min_length=1, max_length=255)
    slug: str | None = Field(default=None, min_length=1, max_length=255, pattern=r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
    description: str | None = Field(default=None, max_length=20_000)
    image_url: str | None = Field(default=None, max_length=512)
    sequence: int | None = Field(default=None, ge=0)
    is_published: bool | None = None


class CourseResponse(LifecycleResponse):
    id: str
    level_id: str
    title: str
    slug: str | None = None
    description: str | None = None
    image_url: str | None = None
    sequence: int


class UnitCreate(InputSchema):
    course_id: str
    title: str = Field(min_length=1, max_length=255)
    slug: str | None = Field(default=None, min_length=1, max_length=255, pattern=r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
    description: str | None = Field(default=None, max_length=20_000)
    sequence: int = Field(default=0, ge=0)
    is_published: bool = False


class UnitUpdate(InputSchema):
    course_id: str | None = None
    title: str | None = Field(default=None, min_length=1, max_length=255)
    slug: str | None = Field(default=None, min_length=1, max_length=255, pattern=r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
    description: str | None = Field(default=None, max_length=20_000)
    sequence: int | None = Field(default=None, ge=0)
    is_published: bool | None = None


class UnitResponse(LifecycleResponse):
    id: str
    course_id: str
    title: str
    slug: str | None = None
    description: str | None = None
    sequence: int


class LessonSectionCreate(InputSchema):
    lesson_id: str | None = None
    section_type: str = Field(default="article", min_length=1, max_length=32)
    title: str = Field(min_length=1, max_length=255)
    content: str | None = Field(default=None, max_length=100_000)
    sequence: int = Field(default=0, ge=0)
    is_published: bool = False


class LessonSectionUpdate(InputSchema):
    section_type: str | None = Field(default=None, min_length=1, max_length=32)
    title: str | None = Field(default=None, min_length=1, max_length=255)
    content: str | None = Field(default=None, max_length=100_000)
    sequence: int | None = Field(default=None, ge=0)
    is_published: bool | None = None


class LessonSectionResponse(LifecycleResponse):
    id: str
    lesson_id: str
    section_type: str
    title: str
    content: str | None = None
    sequence: int


class LessonCreate(InputSchema):
    unit_id: str
    title: str = Field(min_length=1, max_length=255)
    slug: str | None = Field(default=None, min_length=1, max_length=255, pattern=r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
    summary: str | None = Field(default=None, max_length=20_000)
    learning_objective: str | None = Field(default=None, max_length=20_000)
    estimated_minutes: int = Field(default=15, ge=1, le=600)
    passing_score: int = Field(default=70, ge=0, le=100)
    sequence: int = Field(default=0, ge=0)
    is_published: bool = False


class LessonUpdate(InputSchema):
    unit_id: str | None = None
    title: str | None = Field(default=None, min_length=1, max_length=255)
    slug: str | None = Field(default=None, min_length=1, max_length=255, pattern=r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
    summary: str | None = Field(default=None, max_length=20_000)
    learning_objective: str | None = Field(default=None, max_length=20_000)
    estimated_minutes: int | None = Field(default=None, ge=1, le=600)
    passing_score: int | None = Field(default=None, ge=0, le=100)
    sequence: int | None = Field(default=None, ge=0)
    is_published: bool | None = None


class LessonResponse(LifecycleResponse):
    id: str
    unit_id: str
    title: str
    slug: str | None = None
    summary: str | None = None
    learning_objective: str | None = None
    estimated_minutes: int
    passing_score: int
    sequence: int


class LessonContentResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    lesson: LessonResponse
    sections: list[LessonSectionResponse] = Field(default_factory=list)


class LessonDetailResponse(LessonResponse):
    sections: list[LessonSectionResponse] = Field(default_factory=list)
