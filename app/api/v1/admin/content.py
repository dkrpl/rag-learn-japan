from __future__ import annotations

import csv
import io
from typing import Any

from fastapi import APIRouter, Body, Depends, File, Form, HTTPException, Query, UploadFile, status
from sqlalchemy import or_
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.api.deps import RoleChecker
from app.db.session import get_db
from app.models.content import AudioAsset, ExampleSentence, GrammarPoint, Kanji, Reading, Vocabulary
from app.models.user import User, UserRole
from app.schemas.content import (
    AudioAssetAdminResponse,
    AudioAssetUpdate,
    ContentImportRequest,
    ContentImportResult,
    ExampleSentenceCreate,
    ExampleSentenceResponse,
    ExampleSentenceUpdate,
    GrammarPointCreate,
    GrammarPointResponse,
    GrammarPointUpdate,
    KanjiCreate,
    KanjiResponse,
    KanjiUpdate,
    LifecycleActionResponse,
    ReadingCreate,
    ReadingResponse,
    ReadingUpdate,
    VocabularyCreate,
    VocabularyResponse,
    VocabularyUpdate,
)
from app.services.curriculum_content_service import (
    DomainError,
    apply_lifecycle_from_input,
    archive,
    get_or_raise,
    import_content,
    publish,
    restore,
    unpublish,
    validate_content_references,
)
from app.services.storage_service import AudioStorageError, get_audio_storage

admin_checker = RoleChecker([UserRole.CONTENT_EDITOR, UserRole.ADMINISTRATOR])
router = APIRouter(dependencies=[Depends(admin_checker)])


def _raise_domain_error(exc: DomainError) -> None:
    raise HTTPException(status_code=exc.status_code, detail=str(exc)) from exc


def _commit(db: Session, message: str) -> None:
    try:
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=message) from exc


def _create_content(db: Session, model: type[Any], payload: Any) -> Any:
    values = payload.model_dump(exclude={"is_published"})
    try:
        validate_content_references(db, model, values)
        resource = model(**values)
        db.add(resource)
        db.flush()
        apply_lifecycle_from_input(resource, payload.is_published)
        _commit(db, f"{model.__name__} conflicts with an existing content item")
        db.refresh(resource)
        return resource
    except DomainError as exc:
        db.rollback()
        _raise_domain_error(exc)


def _update_content(db: Session, model: type[Any], resource_id: str, payload: Any) -> Any:
    try:
        resource = get_or_raise(db, model, resource_id)
        values = payload.model_dump(exclude_unset=True)
        validate_content_references(db, model, values)
        for field, value in values.items():
            setattr(resource, field, value)
        db.flush()
        if resource.is_published:
            # A published item must remain valid after every edit.
            publish(resource)
        _commit(db, f"{model.__name__} conflicts with an existing content item")
        db.refresh(resource)
        return resource
    except DomainError as exc:
        db.rollback()
        _raise_domain_error(exc)


CONTENT_RESOURCES: dict[str, dict[str, Any]] = {
    "vocabularies": {
        "model": Vocabulary,
        "create": VocabularyCreate,
        "update": VocabularyUpdate,
        "response": VocabularyResponse,
        "search": (Vocabulary.word, Vocabulary.kana, Vocabulary.romaji, Vocabulary.meaning),
    },
    "kanjis": {
        "model": Kanji,
        "create": KanjiCreate,
        "update": KanjiUpdate,
        "response": KanjiResponse,
        "search": (Kanji.character, Kanji.onyomi, Kanji.kunyomi, Kanji.meaning),
    },
    "grammar-points": {
        "model": GrammarPoint,
        "create": GrammarPointCreate,
        "update": GrammarPointUpdate,
        "response": GrammarPointResponse,
        "search": (GrammarPoint.title, GrammarPoint.structure, GrammarPoint.meaning),
    },
    "example-sentences": {
        "model": ExampleSentence,
        "create": ExampleSentenceCreate,
        "update": ExampleSentenceUpdate,
        "response": ExampleSentenceResponse,
        "search": (ExampleSentence.japanese, ExampleSentence.romaji, ExampleSentence.indonesian),
    },
    "readings": {
        "model": Reading,
        "create": ReadingCreate,
        "update": ReadingUpdate,
        "response": ReadingResponse,
        "search": (Reading.title, Reading.content, Reading.translation),
    },
}


def _register_content_crud(resource_type: str, config: dict[str, Any], *, include_in_schema: bool = True) -> None:
    model = config["model"]
    create_schema = config["create"]
    update_schema = config["update"]
    response_schema = config["response"]
    search_columns = config["search"]

    def create_resource(payload, db: Session = Depends(get_db)):
        return _create_content(db, model, payload)

    create_resource.__annotations__["payload"] = create_schema
    create_resource.__name__ = f"create_{resource_type.replace('-', '_')}"

    def list_resources(
        search: str | None = Query(default=None, min_length=1, max_length=100),
        level_id: str | None = None,
        include_archived: bool = False,
        is_published: bool | None = None,
        offset: int = Query(default=0, ge=0),
        limit: int = Query(default=100, ge=1, le=500),
        db: Session = Depends(get_db),
    ):
        query = db.query(model)
        if search:
            pattern = f"%{search}%"
            query = query.filter(or_(*(column.ilike(pattern) for column in search_columns)))
        if level_id:
            query = query.filter(model.level_id == level_id)
        if not include_archived:
            query = query.filter(model.is_archived.is_(False))
        if is_published is not None:
            query = query.filter(model.is_published.is_(is_published))
        order_column = getattr(model, "sequence", model.created_at)
        return query.order_by(order_column, model.created_at, model.id).offset(offset).limit(limit).all()

    list_resources.__name__ = f"list_{resource_type.replace('-', '_')}"

    def get_resource(resource_id: str, db: Session = Depends(get_db)):
        try:
            return get_or_raise(db, model, resource_id)
        except DomainError as exc:
            _raise_domain_error(exc)

    get_resource.__name__ = f"get_{resource_type.replace('-', '_')}"

    def update_resource(resource_id: str, payload, db: Session = Depends(get_db)):
        return _update_content(db, model, resource_id, payload)

    update_resource.__annotations__["payload"] = update_schema
    update_resource.__name__ = f"update_{resource_type.replace('-', '_')}"

    router.add_api_route(
        f"/{resource_type}",
        create_resource,
        methods=["POST"],
        response_model=response_schema,
        status_code=status.HTTP_201_CREATED,
        include_in_schema=include_in_schema,
    )
    router.add_api_route(
        f"/{resource_type}",
        list_resources,
        methods=["GET"],
        response_model=list[response_schema],
        include_in_schema=include_in_schema,
    )
    router.add_api_route(
        f"/{resource_type}/{{resource_id}}",
        get_resource,
        methods=["GET"],
        response_model=response_schema,
        include_in_schema=include_in_schema,
    )
    router.add_api_route(
        f"/{resource_type}/{{resource_id}}",
        update_resource,
        methods=["PATCH"],
        response_model=response_schema,
        include_in_schema=include_in_schema,
    )
    router.add_api_route(
        f"/{resource_type}/{{resource_id}}",
        update_resource,
        methods=["PUT"],
        response_model=response_schema,
        include_in_schema=False,
        name=f"legacy_put_{resource_type}",
    )


for _resource_type, _config in CONTENT_RESOURCES.items():
    _register_content_crud(_resource_type, _config)

# Backward-compatible underscore paths are intentionally hidden from OpenAPI.
_register_content_crud("grammar_points", CONTENT_RESOURCES["grammar-points"], include_in_schema=False)
_register_content_crud("example_sentences", CONTENT_RESOURCES["example-sentences"], include_in_schema=False)


LIFECYCLE_MODELS: dict[str, type[Any]] = {
    **{name: config["model"] for name, config in CONTENT_RESOURCES.items()},
    "audio": AudioAsset,
}


def _lifecycle_action(db: Session, resource_type: str, resource_id: str, action: str) -> LifecycleActionResponse:
    model = LIFECYCLE_MODELS[resource_type]
    try:
        resource = get_or_raise(db, model, resource_id)
        if action == "publish":
            publish(resource)
            state = "published"
        elif action == "unpublish":
            unpublish(resource)
            state = "draft"
        elif action == "archive":
            archive(resource)
            state = "archived"
        elif action == "restore":
            restore(resource)
            state = "draft"
        else:  # pragma: no cover
            raise RuntimeError(f"unsupported lifecycle action: {action}")
        _commit(db, f"could not {action} {model.__name__}")
        return LifecycleActionResponse(id=resource.id, resource_type=resource_type, state=state)
    except DomainError as exc:
        db.rollback()
        _raise_domain_error(exc)


def _register_lifecycle_routes(resource_type: str) -> None:
    def publish_resource(resource_id: str, db: Session = Depends(get_db)):
        return _lifecycle_action(db, resource_type, resource_id, "publish")

    def unpublish_resource(resource_id: str, db: Session = Depends(get_db)):
        return _lifecycle_action(db, resource_type, resource_id, "unpublish")

    def archive_resource(resource_id: str, db: Session = Depends(get_db)):
        return _lifecycle_action(db, resource_type, resource_id, "archive")

    def restore_resource(resource_id: str, db: Session = Depends(get_db)):
        return _lifecycle_action(db, resource_type, resource_id, "restore")

    for action, endpoint in (
        ("publish", publish_resource),
        ("unpublish", unpublish_resource),
        ("archive", archive_resource),
        ("restore", restore_resource),
    ):
        router.add_api_route(
            f"/{resource_type}/{{resource_id}}/{action}",
            endpoint,
            methods=["POST"],
            response_model=LifecycleActionResponse,
            name=f"{action}_{resource_type}",
        )
    router.add_api_route(
        f"/{resource_type}/{{resource_id}}",
        archive_resource,
        methods=["DELETE"],
        response_model=LifecycleActionResponse,
        include_in_schema=False,
        name=f"delete_archives_{resource_type}",
    )


for _resource_type in LIFECYCLE_MODELS:
    _register_lifecycle_routes(_resource_type)


@router.post("/audio", response_model=AudioAssetAdminResponse, status_code=status.HTTP_201_CREATED)
@router.post("/audio/upload", response_model=AudioAssetAdminResponse, include_in_schema=False)
async def upload_audio(
    file: UploadFile = File(...),
    title: str | None = Form(default=None, min_length=1, max_length=255),
    transcript: str | None = Form(default=None, max_length=100_000),
    translation: str | None = Form(default=None, max_length=100_000),
    transcript_visible: bool = Form(default=False),
    speaker: str | None = Form(default=None, max_length=100),
    level_id: str | None = Form(default=None),
    duration_seconds: float | None = Form(default=None, gt=0, le=86_400),
    publish_immediately: bool = Form(default=False),
    current_user: User = Depends(admin_checker),
    db: Session = Depends(get_db),
):
    try:
        validate_content_references(db, AudioAsset, {"level_id": level_id})
        storage = get_audio_storage()
        stored = await storage.store_upload(file, supplied_duration=duration_seconds)
    except (AudioStorageError, RuntimeError) as exc:
        raise HTTPException(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=str(exc)) from exc
    except DomainError as exc:
        _raise_domain_error(exc)

    existing = db.query(AudioAsset).filter(AudioAsset.checksum == stored.checksum).first()
    if existing:
        # Content-addressed storage is idempotent, but silently replacing an
        # existing transcript/title would be surprising and unsafe.
        return existing

    asset = AudioAsset(
        title=title,
        file_path=stored.storage_key if stored.storage_backend == "local" else None,
        file_url="pending",
        storage_backend=stored.storage_backend,
        storage_key=stored.storage_key,
        original_filename=stored.original_filename,
        content_type=stored.content_type,
        file_size_bytes=stored.file_size_bytes,
        checksum=stored.checksum,
        duration_seconds=stored.duration_seconds,
        transcript=transcript,
        translation=translation,
        transcript_visible=transcript_visible,
        speaker=speaker,
        source_type="upload",
        level_id=level_id,
        created_by_id=current_user.id,
    )
    db.add(asset)
    try:
        db.flush()
        asset.file_url = f"/api/v1/audio/{asset.id}"
        if publish_immediately:
            publish(asset)
        _commit(db, "an audio asset with this checksum already exists")
        db.refresh(asset)
        return asset
    except DomainError as exc:
        db.rollback()
        _raise_domain_error(exc)


@router.get("/audio", response_model=list[AudioAssetAdminResponse])
def list_audio_assets(
    search: str | None = Query(default=None, min_length=1, max_length=100),
    level_id: str | None = None,
    include_archived: bool = False,
    is_published: bool | None = None,
    offset: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=500),
    db: Session = Depends(get_db),
):
    query = db.query(AudioAsset)
    if search:
        pattern = f"%{search}%"
        query = query.filter(
            or_(
                AudioAsset.title.ilike(pattern),
                AudioAsset.original_filename.ilike(pattern),
                AudioAsset.transcript.ilike(pattern),
                AudioAsset.checksum.ilike(pattern),
            )
        )
    if level_id:
        query = query.filter(AudioAsset.level_id == level_id)
    if not include_archived:
        query = query.filter(AudioAsset.is_archived.is_(False))
    if is_published is not None:
        query = query.filter(AudioAsset.is_published.is_(is_published))
    return query.order_by(AudioAsset.created_at.desc(), AudioAsset.id).offset(offset).limit(limit).all()


@router.get("/audio/{audio_id}", response_model=AudioAssetAdminResponse)
def get_audio_asset(audio_id: str, db: Session = Depends(get_db)):
    try:
        return get_or_raise(db, AudioAsset, audio_id)
    except DomainError as exc:
        _raise_domain_error(exc)


@router.patch("/audio/{audio_id}", response_model=AudioAssetAdminResponse)
def update_audio_asset(audio_id: str, payload: AudioAssetUpdate, db: Session = Depends(get_db)):
    return _update_content(db, AudioAsset, audio_id, payload)


@router.post("/imports/json", response_model=ContentImportResult)
def import_content_json(payload: ContentImportRequest, db: Session = Depends(get_db)):
    try:
        return import_content(db, payload)
    except DomainError as exc:
        db.rollback()
        _raise_domain_error(exc)
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(status_code=409, detail="content import conflicts with existing data") from exc


@router.post("/import/json", response_model=ContentImportResult, include_in_schema=False)
def import_legacy_vocabulary_json(
    payload: list[VocabularyCreate] = Body(..., max_length=1_000),
    db: Session = Depends(get_db),
):
    return import_content_json(ContentImportRequest(vocabularies=payload), db)


CSV_SCHEMAS: dict[str, tuple[str, type[Any]]] = {
    "vocabulary": ("vocabularies", VocabularyCreate),
    "kanji": ("kanjis", KanjiCreate),
    "grammar_point": ("grammar_points", GrammarPointCreate),
    "example_sentence": ("example_sentences", ExampleSentenceCreate),
    "reading": ("readings", ReadingCreate),
}


def _coerce_csv_value(field_name: str, value: str) -> Any:
    normalized = value.strip()
    if normalized == "":
        return None
    if field_name in {"stroke_count", "difficulty", "sequence"}:
        return int(normalized)
    if field_name == "is_published":
        lowered = normalized.lower()
        if lowered not in {"true", "false", "1", "0", "yes", "no"}:
            raise ValueError("is_published must be true or false")
        return lowered in {"true", "1", "yes"}
    return normalized


@router.post("/imports/csv", response_model=ContentImportResult)
async def import_content_csv(
    file: UploadFile = File(...),
    content_type: str = Form(...),
    dry_run: bool = Form(default=False),
    db: Session = Depends(get_db),
):
    if content_type not in CSV_SCHEMAS:
        raise HTTPException(status_code=422, detail=f"unsupported content_type: {content_type}")
    if (file.content_type or "").split(";", 1)[0].lower() not in {"text/csv", "text/plain", "application/csv"}:
        raise HTTPException(status_code=422, detail="CSV import requires a text/csv file")
    raw = await file.read(2 * 1024 * 1024 + 1)
    await file.close()
    if len(raw) > 2 * 1024 * 1024:
        raise HTTPException(status_code=413, detail="CSV import exceeds the 2 MiB limit")
    try:
        text = raw.decode("utf-8-sig", errors="strict")
        reader = csv.DictReader(io.StringIO(text, newline=""))
        if not reader.fieldnames:
            raise ValueError("CSV header is required")
        collection_name, schema = CSV_SCHEMAS[content_type]
        records = []
        for row_number, row in enumerate(reader, start=2):
            if row_number > 1_002:
                raise ValueError("CSV import is limited to 1000 rows")
            values = {
                field: _coerce_csv_value(field, value)
                for field, value in row.items()
                if field and value is not None and value.strip() != ""
            }
            try:
                records.append(schema(**values))
            except Exception as exc:
                raise ValueError(f"invalid CSV row {row_number}: {exc}") from exc
        if not records:
            raise ValueError("CSV file contains no data rows")
        payload = ContentImportRequest(**{collection_name: records}, dry_run=dry_run)
        return import_content_json(payload, db)
    except (UnicodeDecodeError, ValueError) as exc:
        raise HTTPException(status_code=422, detail=str(exc)) from exc
