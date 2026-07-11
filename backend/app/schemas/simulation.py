from datetime import datetime
from typing import Any, Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator

JlptLevel = Literal["N5", "N4", "N3", "N2", "N1"]
SectionType = Literal["VOCABULARY_KANJI", "GRAMMAR_READING", "LISTENING"]


class JlptSimulationQuestionCreate(BaseModel):
    question_id: str
    order_number: int = Field(ge=1)


class JlptSimulationQuestionResponse(JlptSimulationQuestionCreate):
    model_config = ConfigDict(from_attributes=True)

    id: str
    section_id: str


class JlptSimulationSectionCreate(BaseModel):
    title: str = Field(min_length=1, max_length=255)
    section_type: SectionType
    sequence: int = Field(ge=1)
    duration_minutes: int = Field(gt=0, le=240)
    passing_score: int = Field(ge=0, le=60)
    questions: list[JlptSimulationQuestionCreate] = Field(default_factory=list)


class JlptSimulationSectionUpdate(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=255)
    duration_minutes: int | None = Field(default=None, gt=0, le=240)
    passing_score: int | None = Field(default=None, ge=0, le=60)


class JlptSimulationSectionResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    simulation_id: str
    title: str
    section_type: SectionType
    sequence: int
    duration_minutes: int
    passing_score: int
    questions: list[JlptSimulationQuestionResponse] = Field(default_factory=list)


class JlptSimulationBase(BaseModel):
    title: str = Field(min_length=1, max_length=255)
    description: str | None = Field(default=None, max_length=500)
    level: JlptLevel
    passing_score: int = Field(ge=0, le=180)


class JlptSimulationCreate(JlptSimulationBase):
    sections: list[JlptSimulationSectionCreate] = Field(default_factory=list)

    @field_validator("sections")
    @classmethod
    def validate_section_sequences(cls, value: list[JlptSimulationSectionCreate]):
        sequences = [section.sequence for section in value]
        if len(sequences) != len(set(sequences)):
            raise ValueError("section sequence must be unique")
        return value


class JlptSimulationUpdate(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=255)
    description: str | None = Field(default=None, max_length=500)
    passing_score: int | None = Field(default=None, ge=0, le=180)
    sections: list[JlptSimulationSectionCreate] | None = None

    @field_validator("sections")
    @classmethod
    def validate_optional_section_sequences(cls, value: list[JlptSimulationSectionCreate] | None):
        if value is None:
            return value
        sequences = [section.sequence for section in value]
        if len(sequences) != len(set(sequences)):
            raise ValueError("section sequence must be unique")
        return value


class JlptSimulationResponse(JlptSimulationBase):
    model_config = ConfigDict(from_attributes=True)

    id: str
    is_published: bool
    is_archived: bool
    published_at: datetime | None
    sections: list[JlptSimulationSectionResponse] = Field(default_factory=list)
    created_at: datetime
    updated_at: datetime


class JlptSimulationListResponse(JlptSimulationBase):
    id: str
    is_published: bool
    is_archived: bool
    section_count: int
    total_duration_minutes: int
    created_at: datetime
    updated_at: datetime


class AttemptQuestionResponse(BaseModel):
    id: str
    question_id: str
    order_number: int
    is_answered: bool
    prompt_json: dict[str, Any]


class AttemptSectionResponse(BaseModel):
    id: str
    section_id: str
    status: str
    started_at: datetime | None
    completed_at: datetime | None
    title: str
    duration_minutes: int
    questions: list[AttemptQuestionResponse] = Field(default_factory=list)


class SimulationAttemptResponse(BaseModel):
    id: str
    simulation_id: str
    status: str
    started_at: datetime
    completed_at: datetime | None
    total_score: int
    is_passed: bool
    simulation_title: str
    current_section: AttemptSectionResponse | None = None


class SimulationAttemptHistoryItem(BaseModel):
    id: str
    simulation_id: str
    simulation_title: str
    status: str
    started_at: datetime
    completed_at: datetime | None
    total_score: int
    is_passed: bool


class SubmitSimulationAnswerRequest(BaseModel):
    question_id: str
    answer_data: dict[str, Any]
    response_time_ms: int | None = Field(default=None, ge=0, le=3_600_000)


# Backward-compatible import name while the learner router migrates to the
# explicit simulation-specific request type.
SubmitAnswerRequest = SubmitSimulationAnswerRequest


class WeaknessAnalysis(BaseModel):
    skill: str
    incorrect_count: int
    recommendation: str


class SectionScoreDetail(BaseModel):
    section_title: str
    score: int
    correct_count: int
    question_count: int
    is_passed: bool
    passing_score: int


class SimulationResultResponse(BaseModel):
    attempt_id: str
    simulation_title: str
    total_score: int
    passing_score: int
    correct_count: int
    question_count: int
    is_passed: bool
    completed_at: datetime
    section_scores: list[SectionScoreDetail] = Field(default_factory=list)
    weaknesses: list[WeaknessAnalysis] = Field(default_factory=list)


class SimulationAnalyticsResponse(BaseModel):
    simulation_id: str
    attempt_count: int
    completion_count: int
    pass_count: int
    average_score: float
