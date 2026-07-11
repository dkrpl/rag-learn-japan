"""Question validation, duplicate detection, versioning, and state transitions."""

from __future__ import annotations

import copy
import json
import math
import unicodedata
from datetime import datetime, timezone
from typing import Any

from sqlalchemy.orm import Session

from app.models.content import AudioAsset, Reading
from app.models.curriculum import Lesson
from app.models.question import (
    Question,
    QuestionReview,
    QuestionRevision,
    QuestionStatus,
    QuestionType,
    SkillType,
)
from app.models.user import User
from app.schemas.question import QuestionCreate, QuestionUpdate

JsonObject = dict[str, Any]
EDITABLE_STATUSES = {
    QuestionStatus.DRAFT,
    QuestionStatus.AUTO_VALIDATED,
    QuestionStatus.NEEDS_REVISION,
    QuestionStatus.REJECTED,
}
LISTENING_TYPES = {
    QuestionType.LISTENING_MULTIPLE_CHOICE,
    QuestionType.LISTENING_TRUE_FALSE,
    QuestionType.LISTENING_WITH_IMAGE,
}


class QuestionWorkflowError(RuntimeError):
    def __init__(self, message: str, *, status_code: int = 400, code: str = "QUESTION_WORKFLOW_ERROR") -> None:
        super().__init__(message)
        self.message = message
        self.status_code = status_code
        self.code = code


def _normalized(value: Any) -> Any:
    if isinstance(value, str):
        return " ".join(unicodedata.normalize("NFKC", value).casefold().split())
    if isinstance(value, dict):
        return {key: _normalized(value[key]) for key in sorted(value)}
    if isinstance(value, list):
        items = [_normalized(item) for item in value]
        if items and all(isinstance(item, dict) and "id" in item for item in items):
            return sorted(items, key=lambda item: str(item["id"]))
        return items
    return value


def _fingerprint(question_type: QuestionType, prompt_json: JsonObject) -> str:
    payload = {"question_type": question_type.value, "prompt": _normalized(prompt_json)}
    return json.dumps(payload, ensure_ascii=False, separators=(",", ":"), sort_keys=True)


def _require_text(prompt: JsonObject) -> None:
    value = prompt.get("text", prompt.get("question"))
    if not isinstance(value, str) or not value.strip():
        raise QuestionWorkflowError("prompt_json must contain non-empty text or question", code="INVALID_PROMPT")


def _item_ids(items: Any, field: str, *, min_items: int = 2) -> set[str]:
    if not isinstance(items, list) or len(items) < min_items:
        raise QuestionWorkflowError(f"{field} must contain at least {min_items} items", code="INVALID_OPTIONS")
    ids: set[str] = set()
    normalized_labels: set[str] = set()
    for item in items:
        if not isinstance(item, dict):
            raise QuestionWorkflowError(f"{field} entries must be objects", code="INVALID_OPTIONS")
        item_id = item.get("id")
        if not isinstance(item_id, str) or not item_id.strip():
            raise QuestionWorkflowError(f"{field} entries require a stable string id", code="INVALID_OPTIONS")
        if item_id in ids:
            raise QuestionWorkflowError(f"{field} contains duplicate ids", code="DUPLICATE_OPTION")
        ids.add(item_id)
        display = item.get("text", item.get("image_url", item.get("image_asset_id")))
        if not isinstance(display, str) or not display.strip():
            raise QuestionWorkflowError(
                f"{field} entries require text, image_url, or image_asset_id", code="INVALID_OPTIONS"
            )
        normalized_display = " ".join(unicodedata.normalize("NFKC", display).casefold().split())
        if normalized_display in normalized_labels:
            raise QuestionWorkflowError(f"{field} contains duplicate display values", code="DUPLICATE_OPTION")
        normalized_labels.add(normalized_display)
    return ids


def _validate_single_choice(prompt: JsonObject, answer_key: JsonObject, *, image: bool = False) -> None:
    option_ids = _item_ids(prompt.get("options"), "prompt_json.options")
    correct = answer_key.get("correct_option_id")
    if not isinstance(correct, str) or correct not in option_ids:
        raise QuestionWorkflowError("correct_option_id must reference an option", code="INVALID_ANSWER_KEY")
    if image:
        for item in prompt["options"]:
            if not item.get("image_url") and not item.get("image_asset_id"):
                raise QuestionWorkflowError(
                    "Listening image options require an image reference", code="INVALID_OPTIONS"
                )


def validate_question_payload(
    *,
    question_type: QuestionType,
    skill: SkillType,
    difficulty: int,
    prompt_json: JsonObject,
    answer_key_json: JsonObject,
    explanation_json: JsonObject | None,
    audio_asset_id: str | None,
    require_explanation: bool,
) -> None:
    """Validate the native JSON contract for one canonical question type."""

    if not 1 <= difficulty <= 5:
        raise QuestionWorkflowError("difficulty must be between 1 and 5", code="INVALID_DIFFICULTY")
    if not isinstance(prompt_json, dict) or not prompt_json:
        raise QuestionWorkflowError("prompt_json must be a non-empty object", code="INVALID_PROMPT")
    if not isinstance(answer_key_json, dict) or not answer_key_json:
        raise QuestionWorkflowError("answer_key_json must be a non-empty object", code="INVALID_ANSWER_KEY")
    if require_explanation and (not isinstance(explanation_json, dict) or not explanation_json):
        raise QuestionWorkflowError("explanation_json is required before review/publish", code="MISSING_EXPLANATION")

    _require_text(prompt_json)

    if question_type == QuestionType.MULTIPLE_CHOICE:
        _validate_single_choice(prompt_json, answer_key_json)

    elif question_type == QuestionType.CLOZE_MULTIPLE_CHOICE:
        blanks = prompt_json.get("blanks")
        if blanks is None:  # Supported single-blank form.
            _validate_single_choice(prompt_json, answer_key_json)
        else:
            if not isinstance(blanks, list) or not blanks:
                raise QuestionWorkflowError("prompt_json.blanks must be a non-empty array", code="INVALID_OPTIONS")
            answer_items = answer_key_json.get("answers")
            if isinstance(answer_items, list):
                answer_map = {
                    item.get("blank_id"): item.get("option_id")
                    for item in answer_items
                    if isinstance(item, dict)
                }
            elif isinstance(answer_items, dict):
                answer_map = answer_items
            else:
                raise QuestionWorkflowError("answer_key_json.answers is required", code="INVALID_ANSWER_KEY")
            blank_ids: set[str] = set()
            for blank in blanks:
                if not isinstance(blank, dict) or not isinstance(blank.get("id"), str):
                    raise QuestionWorkflowError("Each blank requires a stable id", code="INVALID_OPTIONS")
                blank_id = blank["id"]
                if blank_id in blank_ids:
                    raise QuestionWorkflowError("Duplicate blank id", code="DUPLICATE_OPTION")
                blank_ids.add(blank_id)
                option_ids = _item_ids(blank.get("options"), f"blank {blank_id} options")
                if answer_map.get(blank_id) not in option_ids:
                    raise QuestionWorkflowError(
                        f"Answer for blank {blank_id} must reference one of its options", code="INVALID_ANSWER_KEY"
                    )
            if set(answer_map) != blank_ids:
                raise QuestionWorkflowError(
                    "answers must contain exactly one entry per blank", code="INVALID_ANSWER_KEY"
                )

    elif question_type in {QuestionType.TRUE_FALSE, QuestionType.LISTENING_TRUE_FALSE}:
        value = answer_key_json.get("value", answer_key_json.get("is_true"))
        if not isinstance(value, bool):
            raise QuestionWorkflowError("Boolean questions require answer_key_json.value", code="INVALID_ANSWER_KEY")

    elif question_type == QuestionType.MATCHING:
        left = prompt_json.get("left_items", prompt_json.get("pairs_left"))
        right = prompt_json.get("right_items", prompt_json.get("pairs_right"))
        left_ids = _item_ids(left, "prompt_json.left_items")
        right_ids = _item_ids(right, "prompt_json.right_items")
        pairs = answer_key_json.get("pairs")
        if not isinstance(pairs, list) or len(pairs) != len(left_ids):
            raise QuestionWorkflowError("Matching answer must pair every left item", code="INVALID_ANSWER_KEY")
        seen_left: set[str] = set()
        seen_right: set[str] = set()
        for pair in pairs:
            if not isinstance(pair, dict):
                raise QuestionWorkflowError("Matching pairs must be objects", code="INVALID_ANSWER_KEY")
            left_id, right_id = pair.get("left_id"), pair.get("right_id")
            if left_id not in left_ids or right_id not in right_ids or left_id in seen_left or right_id in seen_right:
                raise QuestionWorkflowError("Matching pairs are not one-to-one valid ids", code="INVALID_ANSWER_KEY")
            seen_left.add(left_id)
            seen_right.add(right_id)

    elif question_type == QuestionType.ORDERING:
        item_ids = _item_ids(prompt_json.get("items"), "prompt_json.items")
        ordered = answer_key_json.get("ordered_ids")
        if not isinstance(ordered, list) or len(ordered) != len(item_ids) or set(ordered) != item_ids:
            raise QuestionWorkflowError("ordered_ids must contain every item exactly once", code="INVALID_ANSWER_KEY")

    elif question_type == QuestionType.KANJI_READING:
        if "correct_option_id" in answer_key_json:
            _validate_single_choice(prompt_json, answer_key_json)
        else:
            accepted = answer_key_json.get("accepted_readings")
            if not isinstance(accepted, list) or not accepted or not all(
                isinstance(item, str) and item.strip() for item in accepted
            ):
                raise QuestionWorkflowError(
                    "Kanji reading requires correct_option_id or accepted_readings", code="INVALID_ANSWER_KEY"
                )

    elif question_type == QuestionType.READING_COMPREHENSION:
        option_ids = _item_ids(prompt_json.get("options"), "prompt_json.options")
        if "correct_option_ids" in answer_key_json:
            correct = answer_key_json["correct_option_ids"]
            if (
                not isinstance(correct, list)
                or not correct
                or len(correct) != len(set(correct))
                or not set(correct) <= option_ids
            ):
                raise QuestionWorkflowError(
                    "correct_option_ids must reference unique options", code="INVALID_ANSWER_KEY"
                )
        else:
            correct = answer_key_json.get("correct_option_id")
            if correct not in option_ids:
                raise QuestionWorkflowError("correct_option_id must reference an option", code="INVALID_ANSWER_KEY")

    elif question_type == QuestionType.LISTENING_MULTIPLE_CHOICE:
        _validate_single_choice(prompt_json, answer_key_json)

    elif question_type == QuestionType.LISTENING_WITH_IMAGE:
        _validate_single_choice(prompt_json, answer_key_json, image=True)

    else:  # pragma: no cover - enum exhaustiveness guard
        raise QuestionWorkflowError("Unsupported question type", code="INVALID_QUESTION_TYPE")

    if question_type in LISTENING_TYPES:
        if skill != SkillType.LISTENING:
            raise QuestionWorkflowError("Listening question types must use LISTENING skill", code="INVALID_SKILL")
        if not audio_asset_id:
            raise QuestionWorkflowError("Listening questions require audio_asset_id", code="MISSING_AUDIO")


def _validate_sources(
    db: Session,
    *,
    lesson_id: str,
    reading_id: str | None,
    audio_asset_id: str | None,
) -> None:
    if not db.query(Lesson.id).filter(Lesson.id == lesson_id).first():
        raise QuestionWorkflowError("Lesson not found", status_code=404, code="LESSON_NOT_FOUND")
    if reading_id:
        reading = db.query(Reading).filter(Reading.id == reading_id).first()
        if not reading:
            raise QuestionWorkflowError("Reading not found", status_code=404, code="READING_NOT_FOUND")
        if reading.lesson_id and reading.lesson_id != lesson_id:
            raise QuestionWorkflowError("Reading does not belong to the selected lesson", code="SOURCE_MISMATCH")
    if audio_asset_id and not db.query(AudioAsset.id).filter(AudioAsset.id == audio_asset_id).first():
        raise QuestionWorkflowError("Audio asset not found", status_code=404, code="AUDIO_NOT_FOUND")


def _ensure_not_duplicate(db: Session, question: Question, *, exclude_id: str | None = None) -> None:
    fingerprint = _fingerprint(question.question_type, question.prompt_json)
    query = db.query(Question).filter(
        Question.lesson_id == question.lesson_id,
        Question.question_type == question.question_type,
        Question.status != QuestionStatus.ARCHIVED,
    )
    if exclude_id:
        query = query.filter(Question.id != exclude_id)
    for candidate in query.limit(500).all():
        if _fingerprint(candidate.question_type, candidate.prompt_json) == fingerprint:
            raise QuestionWorkflowError(
                "A semantically identical question already exists in this lesson",
                status_code=409,
                code="DUPLICATE_QUESTION",
            )


def snapshot_question(db: Session, question: Question, *, actor_id: str | None) -> QuestionRevision:
    existing = db.query(QuestionRevision).filter(
        QuestionRevision.question_id == question.id,
        QuestionRevision.version_number == question.version_number,
    ).first()
    if existing:
        return existing
    revision = QuestionRevision(
        question_id=question.id,
        version_number=question.version_number,
        lesson_id=question.lesson_id,
        reading_id=question.reading_id,
        audio_asset_id=question.audio_asset_id,
        question_type=question.question_type,
        skill=question.skill,
        difficulty=question.difficulty,
        prompt_json=copy.deepcopy(question.prompt_json),
        answer_key_json=copy.deepcopy(question.answer_key_json),
        explanation_json=copy.deepcopy(question.explanation_json),
        created_by=actor_id,
    )
    db.add(revision)
    db.flush()
    return revision


def get_question_or_error(db: Session, question_id: str, *, lock: bool = False) -> Question:
    query = db.query(Question).filter(Question.id == question_id)
    if lock:
        query = query.with_for_update()
    question = query.first()
    if not question:
        raise QuestionWorkflowError("Question not found", status_code=404, code="QUESTION_NOT_FOUND")
    return question


def create_question(db: Session, payload: QuestionCreate, actor: User) -> Question:
    data = payload.model_dump()
    _validate_sources(
        db,
        lesson_id=data["lesson_id"],
        reading_id=data["reading_id"],
        audio_asset_id=data["audio_asset_id"],
    )
    validate_question_payload(
        question_type=data["question_type"],
        skill=data["skill"],
        difficulty=data["difficulty"],
        prompt_json=data["prompt_json"],
        answer_key_json=data["answer_key_json"],
        explanation_json=data["explanation_json"],
        audio_asset_id=data["audio_asset_id"],
        require_explanation=False,
    )
    question = Question(**data, status=QuestionStatus.DRAFT, created_by=actor.id)
    _ensure_not_duplicate(db, question)
    try:
        db.add(question)
        db.flush()
        snapshot_question(db, question, actor_id=actor.id)
        db.commit()
        db.refresh(question)
        return question
    except Exception:
        db.rollback()
        raise


def update_question(db: Session, question_id: str, payload: QuestionUpdate, actor: User) -> Question:
    question = get_question_or_error(db, question_id, lock=True)
    if question.status not in EDITABLE_STATUSES:
        raise QuestionWorkflowError("Question cannot be edited in its current status", status_code=409)
    changes = payload.model_dump(exclude_unset=True)
    prospective = {
        "lesson_id": changes.get("lesson_id", question.lesson_id),
        "reading_id": changes.get("reading_id", question.reading_id),
        "audio_asset_id": changes.get("audio_asset_id", question.audio_asset_id),
        "question_type": changes.get("question_type", question.question_type),
        "skill": changes.get("skill", question.skill),
        "difficulty": changes.get("difficulty", question.difficulty),
        "prompt_json": changes.get("prompt_json", question.prompt_json),
        "answer_key_json": changes.get("answer_key_json", question.answer_key_json),
        "explanation_json": changes.get("explanation_json", question.explanation_json),
    }
    _validate_sources(
        db,
        lesson_id=prospective["lesson_id"],
        reading_id=prospective["reading_id"],
        audio_asset_id=prospective["audio_asset_id"],
    )
    validate_question_payload(
        question_type=prospective["question_type"],
        skill=prospective["skill"],
        difficulty=prospective["difficulty"],
        prompt_json=prospective["prompt_json"],
        answer_key_json=prospective["answer_key_json"],
        explanation_json=prospective["explanation_json"],
        audio_asset_id=prospective["audio_asset_id"],
        require_explanation=False,
    )
    for field, value in changes.items():
        setattr(question, field, value)
    question.version_number = (question.version_number or 0) + 1
    question.status = QuestionStatus.DRAFT
    question.reviewed_by = None
    question.published_at = None
    _ensure_not_duplicate(db, question, exclude_id=question.id)
    try:
        snapshot_question(db, question, actor_id=actor.id)
        db.commit()
        db.refresh(question)
        return question
    except Exception:
        db.rollback()
        raise


def auto_validate(db: Session, question_id: str, actor: User) -> Question:
    question = get_question_or_error(db, question_id, lock=True)
    if question.status not in {QuestionStatus.DRAFT, QuestionStatus.NEEDS_REVISION}:
        raise QuestionWorkflowError("Only DRAFT or NEEDS_REVISION can be auto-validated", status_code=409)
    _validate_sources(
        db,
        lesson_id=question.lesson_id,
        reading_id=question.reading_id,
        audio_asset_id=question.audio_asset_id,
    )
    validate_question_payload(
        question_type=question.question_type,
        skill=question.skill,
        difficulty=question.difficulty,
        prompt_json=question.prompt_json,
        answer_key_json=question.answer_key_json,
        explanation_json=question.explanation_json,
        audio_asset_id=question.audio_asset_id,
        require_explanation=True,
    )
    _ensure_not_duplicate(db, question, exclude_id=question.id)
    snapshot_question(db, question, actor_id=actor.id)
    question.status = QuestionStatus.AUTO_VALIDATED
    db.commit()
    db.refresh(question)
    return question


def submit_for_review(db: Session, question_id: str) -> Question:
    question = get_question_or_error(db, question_id, lock=True)
    if question.status != QuestionStatus.AUTO_VALIDATED:
        raise QuestionWorkflowError("Only AUTO_VALIDATED questions can be submitted for review", status_code=409)
    question.status = QuestionStatus.IN_REVIEW
    db.commit()
    db.refresh(question)
    return question


def _assert_separation_of_duty(question: Question, actor: User) -> None:
    if question.created_by and question.created_by == actor.id:
        raise QuestionWorkflowError(
            "Separation of duty: reviewers cannot act on their own question",
            status_code=403,
            code="SEPARATION_OF_DUTY",
        )


def review_question(
    db: Session,
    question_id: str,
    *,
    target: QuestionStatus,
    actor: User,
    notes: str | None,
) -> Question:
    if target not in {QuestionStatus.APPROVED, QuestionStatus.REJECTED, QuestionStatus.NEEDS_REVISION}:
        raise QuestionWorkflowError("Invalid review action", code="INVALID_TRANSITION")
    question = get_question_or_error(db, question_id, lock=True)
    if question.status != QuestionStatus.IN_REVIEW:
        raise QuestionWorkflowError("Only IN_REVIEW questions can receive a review decision", status_code=409)
    _assert_separation_of_duty(question, actor)
    if target in {QuestionStatus.REJECTED, QuestionStatus.NEEDS_REVISION} and not (notes and notes.strip()):
        raise QuestionWorkflowError("Review notes are required for rejection or revision", code="MISSING_REVIEW_NOTES")
    db.add(
        QuestionReview(
            question_id=question.id,
            reviewer_id=actor.id,
            status_given=target,
            notes=notes.strip() if notes else None,
        )
    )
    question.status = target
    question.reviewed_by = actor.id
    db.commit()
    db.refresh(question)
    return question


def publish_question(db: Session, question_id: str, actor: User) -> Question:
    question = get_question_or_error(db, question_id, lock=True)
    if question.status != QuestionStatus.APPROVED:
        raise QuestionWorkflowError("Only APPROVED questions can be published", status_code=409)
    _assert_separation_of_duty(question, actor)
    validate_question_payload(
        question_type=question.question_type,
        skill=question.skill,
        difficulty=question.difficulty,
        prompt_json=question.prompt_json,
        answer_key_json=question.answer_key_json,
        explanation_json=question.explanation_json,
        audio_asset_id=question.audio_asset_id,
        require_explanation=True,
    )
    snapshot_question(db, question, actor_id=actor.id)
    question.status = QuestionStatus.PUBLISHED
    question.published_at = datetime.now(timezone.utc)
    db.commit()
    db.refresh(question)
    return question


def unpublish_question(db: Session, question_id: str, actor: User) -> Question:
    question = get_question_or_error(db, question_id, lock=True)
    if question.status != QuestionStatus.PUBLISHED:
        raise QuestionWorkflowError("Only PUBLISHED questions can be unpublished", status_code=409)
    _assert_separation_of_duty(question, actor)
    question.status = QuestionStatus.APPROVED
    question.published_at = None
    db.commit()
    db.refresh(question)
    return question


def archive_question(db: Session, question_id: str) -> Question:
    question = get_question_or_error(db, question_id, lock=True)
    if question.status == QuestionStatus.PUBLISHED:
        raise QuestionWorkflowError("Unpublish the question before archiving it", status_code=409)
    if question.status == QuestionStatus.ARCHIVED:
        return question
    if question.status == QuestionStatus.IN_REVIEW:
        raise QuestionWorkflowError("A question currently in review cannot be archived", status_code=409)
    question.status = QuestionStatus.ARCHIVED
    db.commit()
    db.refresh(question)
    return question


def paginate_questions(
    db: Session,
    *,
    page: int,
    page_size: int,
    lesson_id: str | None,
    skill: SkillType | None,
    difficulty: int | None,
    status: QuestionStatus | None,
    question_type: QuestionType | None,
    is_ai_generated: bool | None,
) -> tuple[list[Question], int, int]:
    query = db.query(Question)
    if lesson_id:
        query = query.filter(Question.lesson_id == lesson_id)
    if skill:
        query = query.filter(Question.skill == skill)
    if difficulty is not None:
        query = query.filter(Question.difficulty == difficulty)
    if status:
        query = query.filter(Question.status == status)
    if question_type:
        query = query.filter(Question.question_type == question_type)
    if is_ai_generated is not None:
        query = query.filter(Question.is_ai_generated.is_(is_ai_generated))
    total = query.count()
    pages = math.ceil(total / page_size) if total else 0
    items = (
        query.order_by(Question.updated_at.desc(), Question.id.desc())
        .offset((page - 1) * page_size)
        .limit(page_size)
        .all()
    )
    return items, total, pages
