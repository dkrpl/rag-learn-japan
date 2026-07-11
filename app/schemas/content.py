from datetime import datetime
from typing import Any, Literal

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


class ORMResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)


class LifecycleResponse(ORMResponse):
    is_published: bool
    is_archived: bool
    published_at: datetime | None = None
    archived_at: datetime | None = None
    created_at: datetime
    updated_at: datetime


class AudioAssetResponse(LifecycleResponse):
    """Learner-safe audio metadata. Internal storage paths never leave the API."""

    id: str
    title: str | None = None
    file_url: str
    content_type: str
    duration_seconds: float = Field(ge=0)
    transcript_available: bool = False
    transcript_visible: bool = False
    transcript: str | None = None
    translation: str | None = None
    speaker: str | None = None
    source_type: str

    @model_validator(mode="after")
    def enforce_transcript_visibility(self) -> "AudioAssetResponse":
        self.transcript_available = bool(self.transcript)
        if self.__class__ is AudioAssetResponse and not self.transcript_visible:
            self.transcript = None
            self.translation = None
        return self


class AudioAssetAdminResponse(AudioAssetResponse):
    original_filename: str | None = None
    storage_backend: str
    storage_key: str | None = None
    file_size_bytes: int = Field(ge=0)
    checksum: str | None = None
    provider: str | None = None
    level_id: str | None = None
    created_by_id: str | None = None


class AudioAssetUpdate(InputSchema):
    title: str | None = Field(default=None, min_length=1, max_length=255)
    transcript: str | None = Field(default=None, max_length=100_000)
    translation: str | None = Field(default=None, max_length=100_000)
    transcript_visible: bool | None = None
    speaker: str | None = Field(default=None, max_length=100)
    level_id: str | None = None


class VocabularyBase(InputSchema):
    word: str = Field(min_length=1, max_length=100)
    kana: str = Field(min_length=1, max_length=100)
    romaji: str | None = Field(default=None, max_length=100)
    meaning: str = Field(min_length=1, max_length=255)
    part_of_speech: str | None = Field(default=None, max_length=64)
    notes: str | None = Field(default=None, max_length=10_000)
    level_id: str | None = None
    audio_id: str | None = None


class VocabularyCreate(VocabularyBase):
    is_published: bool = False


class VocabularyUpdate(InputSchema):
    word: str | None = Field(default=None, min_length=1, max_length=100)
    kana: str | None = Field(default=None, min_length=1, max_length=100)
    romaji: str | None = Field(default=None, max_length=100)
    meaning: str | None = Field(default=None, min_length=1, max_length=255)
    part_of_speech: str | None = Field(default=None, max_length=64)
    notes: str | None = Field(default=None, max_length=10_000)
    level_id: str | None = None
    audio_id: str | None = None


class VocabularyResponse(LifecycleResponse):
    id: str
    word: str
    kana: str
    romaji: str | None = None
    meaning: str
    part_of_speech: str | None = None
    notes: str | None = None
    level_id: str | None = None
    audio_id: str | None = None
    audio: AudioAssetResponse | None = None


class KanjiBase(InputSchema):
    character: str = Field(min_length=1, max_length=10)
    onyomi: str | None = Field(default=None, max_length=100)
    kunyomi: str | None = Field(default=None, max_length=100)
    meaning: str = Field(min_length=1, max_length=255)
    radical: str | None = Field(default=None, max_length=32)
    stroke_count: int = Field(default=0, ge=0, le=64)
    notes: str | None = Field(default=None, max_length=10_000)
    level_id: str | None = None


class KanjiCreate(KanjiBase):
    is_published: bool = False


class KanjiUpdate(InputSchema):
    character: str | None = Field(default=None, min_length=1, max_length=10)
    onyomi: str | None = Field(default=None, max_length=100)
    kunyomi: str | None = Field(default=None, max_length=100)
    meaning: str | None = Field(default=None, min_length=1, max_length=255)
    radical: str | None = Field(default=None, max_length=32)
    stroke_count: int | None = Field(default=None, ge=0, le=64)
    notes: str | None = Field(default=None, max_length=10_000)
    level_id: str | None = None


class KanjiResponse(LifecycleResponse):
    id: str
    character: str
    onyomi: str | None = None
    kunyomi: str | None = None
    meaning: str
    radical: str | None = None
    stroke_count: int
    notes: str | None = None
    level_id: str | None = None


class GrammarPointBase(InputSchema):
    title: str = Field(min_length=1, max_length=255)
    structure: str = Field(min_length=1, max_length=10_000)
    meaning: str = Field(min_length=1, max_length=10_000)
    explanation: str | None = Field(default=None, max_length=50_000)
    usage_notes: str | None = Field(default=None, max_length=20_000)
    level_id: str | None = None


class GrammarPointCreate(GrammarPointBase):
    is_published: bool = False


class GrammarPointUpdate(InputSchema):
    title: str | None = Field(default=None, min_length=1, max_length=255)
    structure: str | None = Field(default=None, min_length=1, max_length=10_000)
    meaning: str | None = Field(default=None, min_length=1, max_length=10_000)
    explanation: str | None = Field(default=None, max_length=50_000)
    usage_notes: str | None = Field(default=None, max_length=20_000)
    level_id: str | None = None


class GrammarPointResponse(LifecycleResponse):
    id: str
    title: str
    structure: str
    meaning: str
    explanation: str | None = None
    usage_notes: str | None = None
    level_id: str | None = None


class ExampleSentenceBase(InputSchema):
    japanese: str = Field(min_length=1, max_length=10_000)
    romaji: str | None = Field(default=None, max_length=10_000)
    indonesian: str = Field(min_length=1, max_length=10_000)
    audio_id: str | None = None
    level_id: str | None = None
    vocabulary_id: str | None = None
    grammar_point_id: str | None = None


class ExampleSentenceCreate(ExampleSentenceBase):
    is_published: bool = False


class ExampleSentenceUpdate(InputSchema):
    japanese: str | None = Field(default=None, min_length=1, max_length=10_000)
    romaji: str | None = Field(default=None, max_length=10_000)
    indonesian: str | None = Field(default=None, min_length=1, max_length=10_000)
    audio_id: str | None = None
    level_id: str | None = None
    vocabulary_id: str | None = None
    grammar_point_id: str | None = None


class ExampleSentenceResponse(LifecycleResponse):
    id: str
    japanese: str
    romaji: str | None = None
    indonesian: str
    audio_id: str | None = None
    level_id: str | None = None
    vocabulary_id: str | None = None
    grammar_point_id: str | None = None
    audio: AudioAssetResponse | None = None


class ReadingBase(InputSchema):
    title: str = Field(min_length=1, max_length=255)
    content: str = Field(min_length=1, max_length=100_000)
    furigana: str | None = Field(default=None, max_length=100_000)
    translation: str | None = Field(default=None, max_length=100_000)
    difficulty: int = Field(default=1, ge=1, le=5)
    sequence: int = Field(default=0, ge=0)
    lesson_id: str | None = None
    level_id: str | None = None
    audio_id: str | None = None


class ReadingCreate(ReadingBase):
    is_published: bool = False


class ReadingUpdate(InputSchema):
    title: str | None = Field(default=None, min_length=1, max_length=255)
    content: str | None = Field(default=None, min_length=1, max_length=100_000)
    furigana: str | None = Field(default=None, max_length=100_000)
    translation: str | None = Field(default=None, max_length=100_000)
    difficulty: int | None = Field(default=None, ge=1, le=5)
    sequence: int | None = Field(default=None, ge=0)
    lesson_id: str | None = None
    level_id: str | None = None
    audio_id: str | None = None


class ReadingResponse(LifecycleResponse):
    id: str
    title: str
    content: str
    furigana: str | None = None
    translation: str | None = None
    difficulty: int
    sequence: int
    lesson_id: str | None = None
    level_id: str | None = None
    audio_id: str | None = None
    audio: AudioAssetResponse | None = None


class ContentImportRequest(InputSchema):
    vocabularies: list[VocabularyCreate] = Field(default_factory=list, max_length=1_000)
    kanjis: list[KanjiCreate] = Field(default_factory=list, max_length=1_000)
    grammar_points: list[GrammarPointCreate] = Field(default_factory=list, max_length=1_000)
    example_sentences: list[ExampleSentenceCreate] = Field(default_factory=list, max_length=2_000)
    readings: list[ReadingCreate] = Field(default_factory=list, max_length=1_000)
    dry_run: bool = False

    @model_validator(mode="after")
    def ensure_non_empty(self) -> "ContentImportRequest":
        if not any(
            (
                self.vocabularies,
                self.kanjis,
                self.grammar_points,
                self.example_sentences,
                self.readings,
            )
        ):
            raise ValueError("at least one content collection is required")
        return self


class ContentImportResult(ORMResponse):
    created: dict[str, int]
    updated: dict[str, int]
    unchanged: dict[str, int]
    dry_run: bool


class CSVImportOptions(InputSchema):
    content_type: Literal["vocabulary", "kanji", "grammar_point", "example_sentence", "reading"]
    dry_run: bool = False


class LifecycleActionResponse(ORMResponse):
    id: str
    resource_type: str
    state: Literal["draft", "published", "archived"]
