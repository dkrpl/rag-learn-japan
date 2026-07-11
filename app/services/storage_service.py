"""Storage abstraction and defensive validation for audio uploads.

Only local storage is implemented for now. Database rows store a backend and
key so S3-compatible storage can be added without changing API contracts.
"""

from __future__ import annotations

import hashlib
import importlib
import os
import shutil
import tempfile
import wave
from dataclasses import dataclass
from pathlib import Path
from urllib.parse import quote

from fastapi import UploadFile

from app.core.config import settings

ALLOWED_AUDIO_MIME_TYPES = {"audio/mpeg", "audio/mp3", "audio/wav", "audio/x-wav", "audio/wave"}
CANONICAL_MIME_TYPES = {
    "audio/mpeg": "audio/mpeg",
    "audio/mp3": "audio/mpeg",
    "audio/wav": "audio/wav",
    "audio/x-wav": "audio/wav",
    "audio/wave": "audio/wav",
}
PROJECT_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_STORAGE_ROOT = PROJECT_ROOT / "data" / "uploads" / "audio"
DEFAULT_MAX_UPLOAD_BYTES = 10 * 1024 * 1024
READ_CHUNK_SIZE = 1024 * 1024


class AudioStorageError(ValueError):
    """A client-safe validation error raised before persistence."""


@dataclass(frozen=True)
class StoredAudio:
    storage_backend: str
    storage_key: str
    absolute_path: Path | None
    original_filename: str
    content_type: str
    file_size_bytes: int
    checksum: str
    duration_seconds: float


def _configured_max_upload_bytes() -> int:
    raw_value = os.getenv("AUDIO_MAX_UPLOAD_BYTES")
    if not raw_value:
        return settings.AUDIO_MAX_UPLOAD_BYTES or DEFAULT_MAX_UPLOAD_BYTES
    try:
        value = int(raw_value)
    except ValueError as exc:
        raise RuntimeError("AUDIO_MAX_UPLOAD_BYTES must be an integer") from exc
    if value < 1 or value > 100 * 1024 * 1024:
        raise RuntimeError("AUDIO_MAX_UPLOAD_BYTES must be between 1 byte and 100 MiB")
    return value


def _safe_original_filename(filename: str | None) -> str:
    if not filename:
        return "audio"
    if "\x00" in filename or len(filename) > 255:
        raise AudioStorageError("invalid audio filename")
    normalized = filename.replace("\\", "/")
    basename = normalized.rsplit("/", 1)[-1]
    if not basename or basename in {".", ".."} or basename != normalized:
        raise AudioStorageError("audio filename must not contain a path")
    return basename


def _synchsafe_to_int(value: bytes) -> int:
    if len(value) != 4:
        return 0
    return ((value[0] & 0x7F) << 21) | ((value[1] & 0x7F) << 14) | ((value[2] & 0x7F) << 7) | (value[3] & 0x7F)


def _find_mp3_frame(data: bytes) -> tuple[int, int] | None:
    """Return (frame offset, bitrate kbps) for a plausible MPEG audio frame."""

    start = 0
    if len(data) >= 10 and data[:3] == b"ID3":
        start = 10 + _synchsafe_to_int(data[6:10])

    # MPEG-1 Layer III bitrates. MPEG-2/2.5 use the smaller table.
    bitrate_mpeg1_l3 = [0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, 0]
    bitrate_mpeg2_l3 = [0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, 0]

    for offset in range(max(0, start), max(0, len(data) - 3)):
        header = int.from_bytes(data[offset : offset + 4], "big")
        if (header & 0xFFE00000) != 0xFFE00000:
            continue
        version_bits = (header >> 19) & 0b11
        layer_bits = (header >> 17) & 0b11
        bitrate_index = (header >> 12) & 0b1111
        sample_rate_index = (header >> 10) & 0b11
        if version_bits == 0b01 or layer_bits != 0b01 or bitrate_index in {0, 15} or sample_rate_index == 3:
            continue
        bitrates = bitrate_mpeg1_l3 if version_bits == 0b11 else bitrate_mpeg2_l3
        return offset, bitrates[bitrate_index]
    return None


def _detect_audio_type(path: Path, claimed_mime: str) -> tuple[str, str]:
    with path.open("rb") as handle:
        header = handle.read(min(path.stat().st_size, 256 * 1024))

    if len(header) >= 12 and header[:4] == b"RIFF" and header[8:12] == b"WAVE":
        detected_mime, extension = "audio/wav", ".wav"
    elif _find_mp3_frame(header):
        detected_mime, extension = "audio/mpeg", ".mp3"
    else:
        raise AudioStorageError("file signature is not a supported MP3 or WAV audio stream")

    if CANONICAL_MIME_TYPES[claimed_mime] != detected_mime:
        raise AudioStorageError("declared MIME type does not match the audio file signature")
    return detected_mime, extension


def _wav_duration(path: Path) -> float:
    try:
        with wave.open(str(path), "rb") as wav_file:
            frame_rate = wav_file.getframerate()
            frame_count = wav_file.getnframes()
            if frame_rate <= 0 or frame_count <= 0:
                raise AudioStorageError("WAV audio contains no playable frames")
            return frame_count / float(frame_rate)
    except (wave.Error, EOFError) as exc:
        raise AudioStorageError("WAV metadata is invalid") from exc


def _mp3_duration(path: Path) -> float:
    with path.open("rb") as handle:
        header = handle.read(min(path.stat().st_size, 256 * 1024))
    frame = _find_mp3_frame(header)
    if not frame:
        raise AudioStorageError("MP3 stream does not contain a valid audio frame")
    offset, bitrate_kbps = frame
    if bitrate_kbps <= 0:
        raise AudioStorageError("MP3 bitrate metadata is invalid")
    audio_bytes = max(0, path.stat().st_size - offset)
    duration = audio_bytes * 8 / float(bitrate_kbps * 1000)
    if duration <= 0:
        raise AudioStorageError("MP3 audio contains no playable data")
    return duration


def _duration_seconds(path: Path, content_type: str) -> float:
    duration = _wav_duration(path) if content_type == "audio/wav" else _mp3_duration(path)
    # Millisecond precision is enough for API metadata and stable tests.
    return round(duration, 3)


class LocalAudioStorage:
    backend_name = "local"

    def __init__(self, root: str | Path | None = None, max_upload_bytes: int | None = None) -> None:
        configured_root = root or os.getenv("AUDIO_STORAGE_ROOT") or settings.AUDIO_STORAGE_PATH or DEFAULT_STORAGE_ROOT
        self.root = Path(configured_root).expanduser().resolve()
        self.max_upload_bytes = max_upload_bytes or _configured_max_upload_bytes()
        if self.max_upload_bytes < 1:
            raise ValueError("max_upload_bytes must be positive")
        self.root.mkdir(parents=True, exist_ok=True)
        self._temporary_root = self.root / ".tmp"
        self._temporary_root.mkdir(parents=True, exist_ok=True)

    async def store_upload(self, upload: UploadFile, supplied_duration: float | None = None) -> StoredAudio:
        claimed_mime = (upload.content_type or "").split(";", 1)[0].strip().lower()
        if claimed_mime not in ALLOWED_AUDIO_MIME_TYPES:
            raise AudioStorageError("invalid audio MIME type; allowed types are audio/mpeg and audio/wav")

        original_filename = _safe_original_filename(upload.filename)
        checksum = hashlib.sha256()
        total_bytes = 0
        temporary_path: Path | None = None

        try:
            with tempfile.NamedTemporaryFile(
                dir=self._temporary_root,
                prefix="upload-",
                suffix=".part",
                delete=False,
            ) as temp:
                temporary_path = Path(temp.name)
                while chunk := await upload.read(READ_CHUNK_SIZE):
                    total_bytes += len(chunk)
                    if total_bytes > self.max_upload_bytes:
                        raise AudioStorageError(f"audio file exceeds the {self.max_upload_bytes}-byte upload limit")
                    checksum.update(chunk)
                    temp.write(chunk)
                temp.flush()
                os.fsync(temp.fileno())

            if total_bytes == 0:
                raise AudioStorageError("audio file is empty")

            content_type, extension = _detect_audio_type(temporary_path, claimed_mime)
            measured_duration = _duration_seconds(temporary_path, content_type)
            if supplied_duration is not None:
                if supplied_duration <= 0 or supplied_duration > 86_400:
                    raise AudioStorageError("duration_seconds must be between 0 and 86400")
                tolerance = max(1.0, measured_duration * 0.1)
                if abs(supplied_duration - measured_duration) > tolerance:
                    raise AudioStorageError("duration_seconds does not match the uploaded audio metadata")

            digest = checksum.hexdigest()
            storage_key = f"{digest[:2]}/{digest}{extension}"
            destination = self.resolve(storage_key)
            destination.parent.mkdir(parents=True, exist_ok=True)
            if destination.exists():
                temporary_path.unlink(missing_ok=True)
            else:
                # os.replace is atomic when source and destination share a filesystem.
                os.replace(temporary_path, destination)
            temporary_path = None

            return StoredAudio(
                storage_backend=self.backend_name,
                storage_key=storage_key,
                absolute_path=destination,
                original_filename=original_filename,
                content_type=content_type,
                file_size_bytes=total_bytes,
                checksum=digest,
                duration_seconds=measured_duration,
            )
        finally:
            if temporary_path is not None:
                temporary_path.unlink(missing_ok=True)
            await upload.close()

    def resolve(self, storage_key: str) -> Path:
        if not storage_key or "\x00" in storage_key:
            raise AudioStorageError("invalid storage key")
        candidate = (self.root / storage_key).resolve()
        try:
            candidate.relative_to(self.root)
        except ValueError as exc:
            raise AudioStorageError("storage key escapes the configured audio root") from exc
        return candidate

    def resolve_asset(self, storage_key: str | None, legacy_file_path: str | None = None) -> Path:
        if storage_key:
            return self.resolve(storage_key)
        if not legacy_file_path:
            raise AudioStorageError("audio asset has no local storage key")

        legacy_path = Path(legacy_file_path)
        if legacy_path.is_absolute():
            candidate = legacy_path.resolve()
        else:
            project_relative = (PROJECT_ROOT / legacy_path).resolve()
            root_relative = (self.root / legacy_path).resolve()
            candidate = project_relative if project_relative.exists() else root_relative
        try:
            candidate.relative_to(self.root)
        except ValueError as exc:
            raise AudioStorageError("legacy audio path is outside the configured storage root") from exc
        return candidate

    def assert_exists(self, storage_key: str | None) -> None:
        if not storage_key or not self.resolve(storage_key).is_file():
            raise AudioStorageError("audio binary is missing from local storage")

    def playback_url(self, storage_key: str) -> str | None:
        # Local assets are streamed through the authenticated API endpoint.
        return None

    def copy_managed_file(self, source: Path, content_type: str, original_filename: str) -> StoredAudio:
        """Import a trusted seed/generated file through the same content-addressed layout."""

        claimed_mime = content_type.split(";", 1)[0].strip().lower()
        if claimed_mime not in ALLOWED_AUDIO_MIME_TYPES:
            raise AudioStorageError("unsupported audio MIME type")
        if not source.is_file():
            raise AudioStorageError("source audio file does not exist")
        if source.stat().st_size > self.max_upload_bytes:
            raise AudioStorageError("source audio file exceeds the upload limit")

        detected_mime, extension = _detect_audio_type(source, claimed_mime)
        checksum = hashlib.sha256(source.read_bytes()).hexdigest()
        key = f"{checksum[:2]}/{checksum}{extension}"
        destination = self.resolve(key)
        destination.parent.mkdir(parents=True, exist_ok=True)
        if not destination.exists():
            with tempfile.NamedTemporaryFile(
                dir=destination.parent,
                prefix="seed-",
                suffix=".part",
                delete=False,
            ) as temp:
                temporary_path = Path(temp.name)
            try:
                shutil.copyfile(source, temporary_path)
                os.replace(temporary_path, destination)
            finally:
                temporary_path.unlink(missing_ok=True)

        return StoredAudio(
            storage_backend=self.backend_name,
            storage_key=key,
            absolute_path=destination,
            original_filename=_safe_original_filename(original_filename),
            content_type=detected_mime,
            file_size_bytes=source.stat().st_size,
            checksum=checksum,
            duration_seconds=_duration_seconds(source, detected_mime),
        )


class S3AudioStorage:
    """S3-compatible backend with optional public or short-lived signed URLs."""

    backend_name = "s3"

    def __init__(self) -> None:
        self.bucket = (os.getenv("AUDIO_S3_BUCKET") or settings.S3_BUCKET_NAME).strip()
        if not self.bucket:
            raise RuntimeError("AUDIO_S3_BUCKET is required when AUDIO_STORAGE_BACKEND=s3")
        self.prefix = os.getenv("AUDIO_S3_PREFIX", "audio").strip("/")
        self.public_base_url = (os.getenv("AUDIO_PUBLIC_BASE_URL") or settings.AUDIO_PUBLIC_BASE_URL).rstrip("/")
        self.presigned_ttl_seconds = int(
            os.getenv("AUDIO_PRESIGNED_URL_TTL_SECONDS", str(settings.S3_PRESIGNED_URL_EXPIRE_SECONDS))
        )
        if self.presigned_ttl_seconds < 60 or self.presigned_ttl_seconds > 86_400:
            raise RuntimeError("AUDIO_PRESIGNED_URL_TTL_SECONDS must be between 60 and 86400")

        try:
            boto3 = importlib.import_module("boto3")
        except ImportError as exc:
            raise RuntimeError("boto3 is required for the S3 audio storage backend") from exc

        client_options: dict[str, str] = {}
        endpoint_url = os.getenv("AUDIO_S3_ENDPOINT_URL") or settings.S3_ENDPOINT_URL or os.getenv("AWS_ENDPOINT_URL")
        region_name = os.getenv("AWS_REGION") or os.getenv("AWS_DEFAULT_REGION") or settings.S3_REGION
        if endpoint_url:
            client_options["endpoint_url"] = endpoint_url
        if region_name:
            client_options["region_name"] = region_name
        access_key_id = os.getenv("AWS_ACCESS_KEY_ID") or settings.S3_ACCESS_KEY_ID
        secret_access_key = os.getenv("AWS_SECRET_ACCESS_KEY") or settings.S3_SECRET_ACCESS_KEY
        if access_key_id:
            client_options["aws_access_key_id"] = access_key_id
        if secret_access_key:
            client_options["aws_secret_access_key"] = secret_access_key
        self.client = boto3.client("s3", **client_options)
        self.max_upload_bytes = _configured_max_upload_bytes()
        spool_root = os.getenv("AUDIO_UPLOAD_SPOOL_ROOT") or (Path(tempfile.gettempdir()) / "nihongo-audio-spool")
        self._spool = LocalAudioStorage(root=spool_root, max_upload_bytes=self.max_upload_bytes)

    def _object_key(self, content_key: str) -> str:
        return f"{self.prefix}/{content_key}" if self.prefix else content_key

    async def store_upload(self, upload: UploadFile, supplied_duration: float | None = None) -> StoredAudio:
        local = await self._spool.store_upload(upload, supplied_duration=supplied_duration)
        if local.absolute_path is None:
            raise RuntimeError("temporary audio spool did not return a local file")
        object_key = self._object_key(local.storage_key)
        try:
            try:
                self.client.head_object(Bucket=self.bucket, Key=object_key)
            except Exception as exc:  # boto3 exception types are created dynamically
                response = getattr(exc, "response", {})
                status = response.get("ResponseMetadata", {}).get("HTTPStatusCode")
                error_code = str(response.get("Error", {}).get("Code", ""))
                if status != 404 and error_code not in {"404", "NoSuchKey", "NotFound"}:
                    raise
                extra_args: dict[str, str] = {
                    "ContentType": local.content_type,
                    "Metadata": {"sha256": local.checksum},
                }
                encryption = os.getenv("AUDIO_S3_SERVER_SIDE_ENCRYPTION", "").strip()
                if encryption:
                    extra_args["ServerSideEncryption"] = encryption
                self.client.upload_file(str(local.absolute_path), self.bucket, object_key, ExtraArgs=extra_args)
        finally:
            local.absolute_path.unlink(missing_ok=True)

        return StoredAudio(
            storage_backend=self.backend_name,
            storage_key=object_key,
            absolute_path=None,
            original_filename=local.original_filename,
            content_type=local.content_type,
            file_size_bytes=local.file_size_bytes,
            checksum=local.checksum,
            duration_seconds=local.duration_seconds,
        )

    def resolve_asset(self, storage_key: str | None, legacy_file_path: str | None = None) -> Path:
        raise AudioStorageError("S3 objects do not have a local filesystem path")

    def assert_exists(self, storage_key: str | None) -> None:
        if not storage_key:
            raise AudioStorageError("audio asset has no S3 storage key")
        try:
            self.client.head_object(Bucket=self.bucket, Key=storage_key)
        except Exception as exc:
            raise AudioStorageError("audio binary is missing from S3-compatible storage") from exc

    def playback_url(self, storage_key: str) -> str:
        if not storage_key:
            raise AudioStorageError("audio asset has no S3 storage key")
        if self.public_base_url:
            return f"{self.public_base_url}/{quote(storage_key, safe='/')}"
        return self.client.generate_presigned_url(
            "get_object",
            Params={"Bucket": self.bucket, "Key": storage_key},
            ExpiresIn=self.presigned_ttl_seconds,
        )


AudioStorage = LocalAudioStorage | S3AudioStorage


def get_audio_storage(backend: str | None = None) -> AudioStorage:
    selected_backend = (
        backend or os.getenv("AUDIO_STORAGE_BACKEND") or settings.AUDIO_STORAGE_PROVIDER or "local"
    ).strip().lower()
    if selected_backend == "local":
        return LocalAudioStorage()
    if selected_backend in {"s3", "s3-compatible", "minio"}:
        return S3AudioStorage()
    raise RuntimeError(f"unsupported AUDIO_STORAGE_BACKEND: {selected_backend}")
