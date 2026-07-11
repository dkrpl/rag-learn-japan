from datetime import datetime, timezone

from sqlalchemy import (
    Boolean,
    CheckConstraint,
    Column,
    DateTime,
    Float,
    ForeignKey,
    Index,
    Integer,
    String,
    Table,
    Text,
    UniqueConstraint,
)
from sqlalchemy.orm import relationship

from app.db.base_class import Base, CustomBase


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


# Ordering belongs to the lesson-material relation, not to the reusable
# material itself. The server defaults preserve compatibility with code that
# appends to the SQLAlchemy relationship without supplying an explicit order.
lesson_vocabularies = Table(
    "lesson_vocabularies",
    Base.metadata,
    Column("lesson_id", String(36), ForeignKey("lessons.id", ondelete="CASCADE"), primary_key=True),
    Column("vocabulary_id", String(36), ForeignKey("vocabularies.id", ondelete="CASCADE"), primary_key=True),
    Column("sequence", Integer, nullable=False, default=0, server_default="0"),
    CheckConstraint("sequence >= 0", name="ck_lesson_vocabularies_sequence_non_negative"),
)

lesson_kanjis = Table(
    "lesson_kanjis",
    Base.metadata,
    Column("lesson_id", String(36), ForeignKey("lessons.id", ondelete="CASCADE"), primary_key=True),
    Column("kanji_id", String(36), ForeignKey("kanjis.id", ondelete="CASCADE"), primary_key=True),
    Column("sequence", Integer, nullable=False, default=0, server_default="0"),
    CheckConstraint("sequence >= 0", name="ck_lesson_kanjis_sequence_non_negative"),
)

lesson_grammar_points = Table(
    "lesson_grammar_points",
    Base.metadata,
    Column("lesson_id", String(36), ForeignKey("lessons.id", ondelete="CASCADE"), primary_key=True),
    Column("grammar_point_id", String(36), ForeignKey("grammar_points.id", ondelete="CASCADE"), primary_key=True),
    Column("sequence", Integer, nullable=False, default=0, server_default="0"),
    CheckConstraint("sequence >= 0", name="ck_lesson_grammar_points_sequence_non_negative"),
)


class PublicationMixin:
    is_published = Column(Boolean, default=False, server_default="0", nullable=False)
    is_archived = Column(Boolean, default=False, server_default="0", nullable=False)
    published_at = Column(DateTime(timezone=True), nullable=True)
    archived_at = Column(DateTime(timezone=True), nullable=True)


class AudioAsset(PublicationMixin, CustomBase):
    """Metadata only; binary content is owned by the configured storage backend."""

    __tablename__ = "audio_assets"
    __table_args__ = (
        CheckConstraint("file_size_bytes >= 0", name="ck_audio_assets_file_size_non_negative"),
        CheckConstraint("duration_seconds >= 0", name="ck_audio_assets_duration_non_negative"),
        Index("ix_audio_assets_visibility", "is_published", "is_archived"),
        Index("ix_audio_assets_level_visibility", "level_id", "is_published", "is_archived"),
    )

    title = Column(String(255), nullable=True)
    # `file_path` and `file_url` are retained as compatibility columns while
    # storage_backend/storage_key are the canonical storage abstraction.
    file_path = Column(String(512), nullable=True)
    file_url = Column(String(512), nullable=False)
    storage_backend = Column(String(32), default="local", server_default="local", nullable=False)
    storage_key = Column(String(512), nullable=True)
    original_filename = Column(String(255), nullable=True)
    content_type = Column(String(100), default="audio/mpeg", server_default="audio/mpeg", nullable=False)
    file_size_bytes = Column(Integer, default=0, server_default="0", nullable=False)
    checksum = Column(String(64), unique=True, index=True, nullable=True)
    duration_seconds = Column(Float, default=0, server_default="0", nullable=False)
    transcript = Column(Text, nullable=True)
    translation = Column(Text, nullable=True)
    transcript_visible = Column(Boolean, default=False, server_default="0", nullable=False)
    speaker = Column(String(100), nullable=True)
    source_type = Column(String(32), default="upload", server_default="upload", nullable=False)
    provider = Column(String(64), nullable=True)
    level_id = Column(String(36), ForeignKey("levels.id", ondelete="SET NULL"), nullable=True)
    created_by_id = Column(String(36), ForeignKey("users.id", ondelete="SET NULL"), nullable=True)


class Vocabulary(PublicationMixin, CustomBase):
    __tablename__ = "vocabularies"
    __table_args__ = (
        UniqueConstraint("word", "kana", name="uq_vocabularies_word_kana"),
        Index("ix_vocabularies_level_visibility", "level_id", "is_published", "is_archived"),
    )

    word = Column(String(100), nullable=False)
    kana = Column(String(100), nullable=False)
    romaji = Column(String(100), nullable=True)
    meaning = Column(String(255), nullable=False)
    part_of_speech = Column(String(64), nullable=True)
    notes = Column(Text, nullable=True)
    level_id = Column(String(36), ForeignKey("levels.id", ondelete="SET NULL"), nullable=True)
    audio_id = Column(String(36), ForeignKey("audio_assets.id", ondelete="SET NULL"), nullable=True)

    audio = relationship("AudioAsset")
    lessons = relationship("Lesson", secondary="lesson_vocabularies", back_populates="vocabularies")
    example_sentences = relationship("ExampleSentence", back_populates="vocabulary")


class Kanji(PublicationMixin, CustomBase):
    __tablename__ = "kanjis"
    __table_args__ = (
        UniqueConstraint("character", name="uq_kanjis_character"),
        CheckConstraint("stroke_count >= 0", name="ck_kanjis_stroke_count_non_negative"),
        Index("ix_kanjis_level_visibility", "level_id", "is_published", "is_archived"),
    )

    character = Column(String(10), nullable=False)
    onyomi = Column(String(100), nullable=True)
    kunyomi = Column(String(100), nullable=True)
    meaning = Column(String(255), nullable=False)
    radical = Column(String(32), nullable=True)
    stroke_count = Column(Integer, default=0, server_default="0", nullable=False)
    notes = Column(Text, nullable=True)
    level_id = Column(String(36), ForeignKey("levels.id", ondelete="SET NULL"), nullable=True)

    lessons = relationship("Lesson", secondary="lesson_kanjis", back_populates="kanjis")


class GrammarPoint(PublicationMixin, CustomBase):
    __tablename__ = "grammar_points"
    __table_args__ = (
        UniqueConstraint("title", "structure", name="uq_grammar_points_title_structure"),
        Index("ix_grammar_points_level_visibility", "level_id", "is_published", "is_archived"),
    )

    title = Column(String(255), nullable=False)
    structure = Column(String(255), nullable=False)
    meaning = Column(Text, nullable=False)
    explanation = Column(Text, nullable=True)
    usage_notes = Column(Text, nullable=True)
    level_id = Column(String(36), ForeignKey("levels.id", ondelete="SET NULL"), nullable=True)

    lessons = relationship("Lesson", secondary="lesson_grammar_points", back_populates="grammar_points")
    example_sentences = relationship("ExampleSentence", back_populates="grammar_point")


class ExampleSentence(PublicationMixin, CustomBase):
    __tablename__ = "example_sentences"
    __table_args__ = (Index("ix_example_sentences_level_visibility", "level_id", "is_published", "is_archived"),)

    japanese = Column(Text, nullable=False)
    romaji = Column(Text, nullable=True)
    indonesian = Column(Text, nullable=False)
    audio_id = Column(String(36), ForeignKey("audio_assets.id", ondelete="SET NULL"), nullable=True)
    level_id = Column(String(36), ForeignKey("levels.id", ondelete="SET NULL"), nullable=True)
    vocabulary_id = Column(String(36), ForeignKey("vocabularies.id", ondelete="CASCADE"), nullable=True)
    grammar_point_id = Column(String(36), ForeignKey("grammar_points.id", ondelete="CASCADE"), nullable=True)

    audio = relationship("AudioAsset")
    vocabulary = relationship("Vocabulary", back_populates="example_sentences")
    grammar_point = relationship("GrammarPoint", back_populates="example_sentences")


class Reading(PublicationMixin, CustomBase):
    """A short reading passage owned by a lesson."""

    __tablename__ = "readings"
    __table_args__ = (
        UniqueConstraint("lesson_id", "title", name="uq_readings_lesson_title"),
        CheckConstraint("sequence >= 0", name="ck_readings_sequence_non_negative"),
        CheckConstraint("difficulty >= 1 AND difficulty <= 5", name="ck_readings_difficulty_range"),
        Index("ix_readings_lesson_visibility_sequence", "lesson_id", "is_published", "is_archived", "sequence"),
    )

    title = Column(String(255), nullable=False)
    content = Column(Text, nullable=False)
    furigana = Column(Text, nullable=True)
    translation = Column(Text, nullable=True)
    difficulty = Column(Integer, default=1, server_default="1", nullable=False)
    sequence = Column(Integer, default=0, server_default="0", nullable=False)
    lesson_id = Column(String(36), ForeignKey("lessons.id", ondelete="CASCADE"), nullable=True)
    level_id = Column(String(36), ForeignKey("levels.id", ondelete="SET NULL"), nullable=True)
    audio_id = Column(String(36), ForeignKey("audio_assets.id", ondelete="SET NULL"), nullable=True)

    audio = relationship("AudioAsset")
    lesson = relationship("Lesson", back_populates="readings")
