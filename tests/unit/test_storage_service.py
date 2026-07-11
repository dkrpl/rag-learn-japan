import asyncio
import io
import math
import struct
import wave

import pytest
from fastapi import UploadFile
from starlette.datastructures import Headers

from app.services import storage_service
from app.services.storage_service import AudioStorageError, LocalAudioStorage, S3AudioStorage


def wav_bytes(duration_seconds: float = 0.1, sample_rate: int = 8_000) -> bytes:
    buffer = io.BytesIO()
    with wave.open(buffer, "wb") as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        frames = bytearray()
        for index in range(int(duration_seconds * sample_rate)):
            sample = int(1_000 * math.sin(2 * math.pi * 440 * index / sample_rate))
            frames.extend(struct.pack("<h", sample))
        wav_file.writeframes(frames)
    return buffer.getvalue()


def upload(data: bytes, filename: str = "sample.wav", content_type: str = "audio/wav") -> UploadFile:
    return UploadFile(
        io.BytesIO(data),
        filename=filename,
        headers=Headers({"content-type": content_type}),
    )


def test_local_storage_validates_and_deduplicates_wav(tmp_path):
    storage = LocalAudioStorage(tmp_path, max_upload_bytes=1_000_000)
    data = wav_bytes()

    first = asyncio.run(storage.store_upload(upload(data)))
    second = asyncio.run(storage.store_upload(upload(data, filename="duplicate.wav")))

    assert first.checksum == second.checksum
    assert first.storage_key == second.storage_key
    assert first.content_type == "audio/wav"
    assert first.file_size_bytes == len(data)
    assert first.duration_seconds == pytest.approx(0.1, abs=0.001)
    assert first.absolute_path and first.absolute_path.is_file()
    assert list(tmp_path.rglob("*.wav")) == [first.absolute_path]


@pytest.mark.parametrize(
    ("data", "filename", "content_type", "message"),
    [
        (b"not audio", "fake.mp3", "audio/mpeg", "file signature"),
        (wav_bytes(), "sample.wav", "text/plain", "invalid audio MIME"),
        (wav_bytes(), "../sample.wav", "audio/wav", "must not contain a path"),
    ],
)
def test_local_storage_rejects_spoofed_or_unsafe_uploads(tmp_path, data, filename, content_type, message):
    storage = LocalAudioStorage(tmp_path, max_upload_bytes=1_000_000)
    with pytest.raises(AudioStorageError, match=message):
        asyncio.run(storage.store_upload(upload(data, filename=filename, content_type=content_type)))


def test_local_storage_enforces_streaming_size_limit(tmp_path):
    storage = LocalAudioStorage(tmp_path, max_upload_bytes=64)
    with pytest.raises(AudioStorageError, match="upload limit"):
        asyncio.run(storage.store_upload(upload(wav_bytes())))
    assert not list(tmp_path.rglob("*.part"))


class FakeS3Error(Exception):
    response = {"ResponseMetadata": {"HTTPStatusCode": 404}, "Error": {"Code": "NoSuchKey"}}


class FakeS3Client:
    def __init__(self):
        self.uploads = []

    def head_object(self, **kwargs):
        raise FakeS3Error

    def upload_file(self, filename, bucket, key, ExtraArgs):
        self.uploads.append((filename, bucket, key, ExtraArgs))

    def generate_presigned_url(self, operation, Params, ExpiresIn):
        return f"https://signed.example/{Params['Bucket']}/{Params['Key']}?ttl={ExpiresIn}"


class FakeBoto3:
    def __init__(self, client):
        self._client = client

    def client(self, service_name, **kwargs):
        assert service_name == "s3"
        return self._client


def test_s3_compatible_storage_upload_and_presigned_playback(tmp_path, monkeypatch):
    fake_client = FakeS3Client()
    real_import_module = storage_service.importlib.import_module

    def fake_import_module(name):
        if name == "boto3":
            return FakeBoto3(fake_client)
        return real_import_module(name)

    monkeypatch.setattr(storage_service.importlib, "import_module", fake_import_module)
    monkeypatch.setenv("AUDIO_S3_BUCKET", "nihongo-test")
    monkeypatch.setenv("AUDIO_S3_PREFIX", "managed/audio")
    monkeypatch.setenv("AUDIO_UPLOAD_SPOOL_ROOT", str(tmp_path / "spool"))
    monkeypatch.setenv("AUDIO_PRESIGNED_URL_TTL_SECONDS", "600")

    storage = S3AudioStorage()
    stored = asyncio.run(storage.store_upload(upload(wav_bytes())))

    assert stored.storage_backend == "s3"
    assert stored.absolute_path is None
    assert stored.storage_key.startswith("managed/audio/")
    assert fake_client.uploads[0][1:3] == ("nihongo-test", stored.storage_key)
    assert storage.playback_url(stored.storage_key).endswith("?ttl=600")

