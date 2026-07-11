"""Seed one production-shaped, idempotent N5 vertical slice.

The committed manifest contains real UTF-8 Japanese material. A deterministic
WAV tone is generated only to verify upload/playback plumbing; it is explicitly
marked as non-speech and must not be presented as Japanese pronunciation.

Usage:
    python scripts/seed_n5_content.py
    python scripts/seed_n5_content.py --dry-run
"""

from __future__ import annotations

import argparse
import json
import math
import struct
import sys
import wave
from pathlib import Path
from typing import Any

from sqlalchemy import insert, select, update
from sqlalchemy.orm import Session

PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from app.db.session import SessionLocal  # noqa: E402
from app.models.content import (  # noqa: E402
    AudioAsset,
    ExampleSentence,
    GrammarPoint,
    Kanji,
    Reading,
    Vocabulary,
    lesson_grammar_points,
    lesson_kanjis,
    lesson_vocabularies,
)
from app.models.curriculum import Course, Lesson, LessonSection, Level, Unit  # noqa: E402
from app.services.curriculum_content_service import publish, restore  # noqa: E402
from app.services.storage_service import LocalAudioStorage  # noqa: E402

MANIFEST_PATH = PROJECT_ROOT / "data" / "seed" / "n5_vertical_slice.json"
GENERATED_ASSET_PATH = PROJECT_ROOT / "data" / "seed" / "generated" / "n5_audio_pipeline_fixture.wav"


def _load_manifest() -> dict[str, Any]:
    payload = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    if payload.get("schema_version") != 1:
        raise RuntimeError("unsupported N5 seed manifest schema_version")
    return payload


def _ensure_wav_fixture(duration_seconds: int) -> Path:
    GENERATED_ASSET_PATH.parent.mkdir(parents=True, exist_ok=True)
    sample_rate = 16_000
    frame_count = sample_rate * duration_seconds
    amplitude = 2_500
    frequency_hz = 440
    with wave.open(str(GENERATED_ASSET_PATH), "wb") as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        frames = bytearray()
        for index in range(frame_count):
            sample = int(amplitude * math.sin(2 * math.pi * frequency_hz * index / sample_rate))
            frames.extend(struct.pack("<h", sample))
        wav_file.writeframes(frames)
    return GENERATED_ASSET_PATH


def _set_fields(resource: Any, values: dict[str, Any]) -> None:
    for field, value in values.items():
        setattr(resource, field, value)
    if resource.is_archived:
        restore(resource)


def _upsert_level(db: Session, values: dict[str, Any]) -> Level:
    level = db.query(Level).filter((Level.code == values["code"]) | (Level.name == values["name"])).first()
    if level is None:
        level = Level(**values)
        db.add(level)
    else:
        _set_fields(level, values)
    db.flush()
    publish(level)
    return level


def _upsert_child(db: Session, model: type[Any], parent_field: str, parent_id: str, values: dict[str, Any]) -> Any:
    resource = db.query(model).filter(getattr(model, parent_field) == parent_id, model.title == values["title"]).first()
    materialized = {parent_field: parent_id, **values}
    if resource is None:
        resource = model(**materialized)
        db.add(resource)
    else:
        _set_fields(resource, materialized)
    db.flush()
    return resource


def _upsert_audio(db: Session, values: dict[str, Any]) -> AudioAsset:
    fixture = _ensure_wav_fixture(int(values["duration_seconds"]))
    stored = LocalAudioStorage().copy_managed_file(fixture, "audio/wav", fixture.name)
    asset = db.query(AudioAsset).filter(AudioAsset.checksum == stored.checksum).first()
    metadata = {
        "title": values["title"],
        "file_path": stored.storage_key,
        "storage_backend": stored.storage_backend,
        "storage_key": stored.storage_key,
        "original_filename": stored.original_filename,
        "content_type": stored.content_type,
        "file_size_bytes": stored.file_size_bytes,
        "checksum": stored.checksum,
        "duration_seconds": stored.duration_seconds,
        "transcript": values["transcript"],
        "translation": values["translation"],
        "transcript_visible": False,
        "speaker": values["speaker"],
        "source_type": "fixture",
        "provider": "deterministic-wav-generator",
    }
    if asset is None:
        asset = AudioAsset(file_url="pending", **metadata)
        db.add(asset)
    else:
        _set_fields(asset, metadata)
    db.flush()
    asset.file_url = f"/api/v1/audio/{asset.id}"
    publish(asset)
    return asset


def _upsert_vocabulary(db: Session, level: Level, values: dict[str, Any]) -> Vocabulary:
    sequence = values.pop("sequence")
    resource = db.query(Vocabulary).filter(Vocabulary.word == values["word"], Vocabulary.kana == values["kana"]).first()
    materialized = {**values, "level_id": level.id}
    if resource is None:
        resource = Vocabulary(**materialized)
        db.add(resource)
    else:
        _set_fields(resource, materialized)
    db.flush()
    publish(resource)
    resource._seed_sequence = sequence
    return resource


def _upsert_kanji(db: Session, level: Level, values: dict[str, Any]) -> Kanji:
    sequence = values.pop("sequence")
    resource = db.query(Kanji).filter(Kanji.character == values["character"]).first()
    materialized = {**values, "level_id": level.id}
    if resource is None:
        resource = Kanji(**materialized)
        db.add(resource)
    else:
        _set_fields(resource, materialized)
    db.flush()
    publish(resource)
    resource._seed_sequence = sequence
    return resource


def _upsert_grammar(db: Session, level: Level, values: dict[str, Any]) -> GrammarPoint:
    sequence = values.pop("sequence")
    resource = (
        db.query(GrammarPoint)
        .filter(GrammarPoint.title == values["title"], GrammarPoint.structure == values["structure"])
        .first()
    )
    materialized = {**values, "level_id": level.id}
    if resource is None:
        resource = GrammarPoint(**materialized)
        db.add(resource)
    else:
        _set_fields(resource, materialized)
    db.flush()
    publish(resource)
    resource._seed_sequence = sequence
    return resource


def _upsert_association(
    db: Session,
    table: Any,
    id_column: Any,
    lesson_id: str,
    content_id: str,
    sequence: int,
) -> None:
    criteria = (table.c.lesson_id == lesson_id) & (id_column == content_id)
    if db.execute(select(table.c.lesson_id).where(criteria)).first():
        db.execute(update(table).where(criteria).values(sequence=sequence))
    else:
        db.execute(insert(table).values(lesson_id=lesson_id, **{id_column.name: content_id}, sequence=sequence))


def seed_n5(*, dry_run: bool = False) -> dict[str, int]:
    manifest = _load_manifest()
    db: Session = SessionLocal()
    counts = {"levels": 0, "courses": 0, "units": 0, "lessons": 0, "content": 0, "audio": 0}
    try:
        level = _upsert_level(db, dict(manifest["level"]))
        counts["levels"] = 1
        course = _upsert_child(db, Course, "level_id", level.id, dict(manifest["course"]))
        publish(course)
        counts["courses"] = 1
        unit = _upsert_child(db, Unit, "course_id", course.id, dict(manifest["unit"]))
        publish(unit)
        counts["units"] = 1
        lesson = _upsert_child(db, Lesson, "unit_id", unit.id, dict(manifest["lesson"]))
        counts["lessons"] = 1

        for section_values in manifest["sections"]:
            section = (
                db.query(LessonSection)
                .filter(LessonSection.lesson_id == lesson.id, LessonSection.sequence == section_values["sequence"])
                .first()
            )
            materialized = {"lesson_id": lesson.id, **section_values}
            if section is None:
                section = LessonSection(**materialized)
                db.add(section)
            else:
                _set_fields(section, materialized)
            db.flush()
            publish(section)
            counts["content"] += 1

        _upsert_audio(db, dict(manifest["audio_fixture"]))
        counts["audio"] = 1

        vocab_by_word: dict[str, Vocabulary] = {}
        for values in manifest["vocabularies"]:
            vocabulary = _upsert_vocabulary(db, level, dict(values))
            vocab_by_word[vocabulary.word] = vocabulary
            _upsert_association(
                db,
                lesson_vocabularies,
                lesson_vocabularies.c.vocabulary_id,
                lesson.id,
                vocabulary.id,
                vocabulary._seed_sequence,
            )
            counts["content"] += 1

        grammar_by_title: dict[str, GrammarPoint] = {}
        for values in manifest["grammar_points"]:
            grammar = _upsert_grammar(db, level, dict(values))
            grammar_by_title[grammar.title] = grammar
            _upsert_association(
                db,
                lesson_grammar_points,
                lesson_grammar_points.c.grammar_point_id,
                lesson.id,
                grammar.id,
                grammar._seed_sequence,
            )
            counts["content"] += 1

        for values in manifest["kanjis"]:
            kanji = _upsert_kanji(db, level, dict(values))
            _upsert_association(
                db,
                lesson_kanjis,
                lesson_kanjis.c.kanji_id,
                lesson.id,
                kanji.id,
                kanji._seed_sequence,
            )
            counts["content"] += 1

        for values in manifest["example_sentences"]:
            sentence_values = dict(values)
            vocabulary_word = sentence_values.pop("vocabulary_word", None)
            grammar_title = sentence_values.pop("grammar_title", None)
            resource = (
                db.query(ExampleSentence)
                .filter(
                    ExampleSentence.japanese == sentence_values["japanese"],
                    ExampleSentence.indonesian == sentence_values["indonesian"],
                )
                .first()
            )
            materialized = {
                **sentence_values,
                "level_id": level.id,
                "vocabulary_id": vocab_by_word[vocabulary_word].id if vocabulary_word else None,
                "grammar_point_id": grammar_by_title[grammar_title].id if grammar_title else None,
            }
            if resource is None:
                resource = ExampleSentence(**materialized)
                db.add(resource)
            else:
                _set_fields(resource, materialized)
            db.flush()
            publish(resource)
            counts["content"] += 1

        for values in manifest["readings"]:
            resource = (
                db.query(Reading).filter(Reading.lesson_id == lesson.id, Reading.title == values["title"]).first()
            )
            materialized = {**values, "lesson_id": lesson.id, "level_id": level.id}
            if resource is None:
                resource = Reading(**materialized)
                db.add(resource)
            else:
                _set_fields(resource, materialized)
            db.flush()
            publish(resource)
            counts["content"] += 1

        db.flush()
        db.expire(lesson, ["sections", "vocabularies", "kanjis", "grammar_points", "readings"])
        publish(lesson)
        if dry_run:
            db.rollback()
        else:
            db.commit()
        return counts
    except Exception:
        db.rollback()
        raise
    finally:
        db.close()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true", help="Validate and roll back all database writes")
    args = parser.parse_args()
    counts = seed_n5(dry_run=args.dry_run)
    mode = "dry-run" if args.dry_run else "committed"
    print(f"N5 vertical slice {mode}: {json.dumps(counts, ensure_ascii=False, sort_keys=True)}")


if __name__ == "__main__":
    main()
