from __future__ import annotations

from fastapi import APIRouter, Depends, HTTPException, Response, status
from fastapi.responses import FileResponse, RedirectResponse
from sqlalchemy.orm import Session

from app.api.deps import get_current_user
from app.db.session import get_db
from app.models.content import AudioAsset
from app.schemas.content import AudioAssetResponse
from app.services.storage_service import AudioStorageError, get_audio_storage

router = APIRouter(dependencies=[Depends(get_current_user)])


def _published_asset(db: Session, audio_id: str) -> AudioAsset:
    asset = (
        db.query(AudioAsset)
        .filter(
            AudioAsset.id == audio_id,
            AudioAsset.is_published.is_(True),
            AudioAsset.is_archived.is_(False),
        )
        .first()
    )
    if asset is None:
        # Do not disclose whether the ID belongs to a draft or archived asset.
        raise HTTPException(status_code=404, detail="Published audio asset not found")
    return asset


def _public_metadata(asset: AudioAsset) -> AudioAssetResponse:
    values = {column.name: getattr(asset, column.name) for column in asset.__table__.columns}
    values["file_url"] = f"/api/v1/audio/{asset.id}"
    return AudioAssetResponse.model_validate(values)


@router.get("/audio/{audio_id}/metadata", response_model=AudioAssetResponse)
def get_audio_metadata(audio_id: str, db: Session = Depends(get_db)):
    return _public_metadata(_published_asset(db, audio_id))


def _playback_response(asset: AudioAsset):
    try:
        storage = get_audio_storage(asset.storage_backend)
        if asset.storage_backend == "local":
            path = storage.resolve_asset(asset.storage_key, asset.file_path)
            if not path.is_file():
                raise HTTPException(status_code=404, detail="Audio binary is unavailable")
            headers = {
                "Accept-Ranges": "bytes",
                "Cache-Control": "private, max-age=3600",
                "Content-Disposition": "inline",
                "X-Content-Type-Options": "nosniff",
            }
            if asset.checksum:
                headers["ETag"] = f'"sha256-{asset.checksum}"'
            return FileResponse(path=path, media_type=asset.content_type, headers=headers)

        playback_url = storage.playback_url(asset.storage_key)
        return RedirectResponse(
            url=playback_url,
            status_code=status.HTTP_307_TEMPORARY_REDIRECT,
            headers={"Cache-Control": "private, no-store", "X-Content-Type-Options": "nosniff"},
        )
    except AudioStorageError as exc:
        raise HTTPException(status_code=404, detail="Audio binary is unavailable") from exc
    except RuntimeError as exc:
        # Configuration faults should not leak storage credentials or internals.
        raise HTTPException(status_code=503, detail="Audio storage is temporarily unavailable") from exc


@router.get(
    "/audio/{audio_id}",
    response_class=FileResponse,
    responses={
        200: {"content": {"audio/mpeg": {}, "audio/wav": {}}, "description": "Playable audio stream"},
        307: {"description": "Redirect to a short-lived object-storage URL"},
        404: {"description": "Published audio asset or binary not found"},
    },
)
def stream_audio(audio_id: str, db: Session = Depends(get_db)):
    return _playback_response(_published_asset(db, audio_id))


@router.head("/audio/{audio_id}", include_in_schema=False)
def head_audio(audio_id: str, db: Session = Depends(get_db)):
    asset = _published_asset(db, audio_id)
    response = _playback_response(asset)
    if isinstance(response, FileResponse):
        return Response(
            status_code=200,
            headers={
                "Accept-Ranges": "bytes",
                "Cache-Control": "private, max-age=3600",
                "Content-Type": asset.content_type,
                "Content-Length": str(asset.file_size_bytes),
                "X-Content-Type-Options": "nosniff",
            },
        )
    return response
