import hashlib
import uuid
from abc import ABC, abstractmethod
from pathlib import Path

# pyrefly: ignore [missing-import]
from gtts import gTTS

from app.core.config import settings


class BaseTTSProvider(ABC):
    @abstractmethod
    def generate_audio(self, text: str, lang: str = "ja") -> dict:
        """Returns metadata including URL and duration."""
        pass


class DisabledTTSProvider(BaseTTSProvider):
    def generate_audio(self, text: str, lang: str = "ja") -> dict:
        raise RuntimeError("TTS provider is disabled. Set TTS_PROVIDER=gtts for local TTS generation.")


class GTTSProvider(BaseTTSProvider):
    def generate_audio(self, text: str, lang: str = "ja") -> dict:
        tts = gTTS(text=text, lang=lang)
        filename = f"{uuid.uuid4()}.mp3"

        save_path = Path(settings.AUDIO_STORAGE_PATH) / filename
        save_path.parent.mkdir(parents=True, exist_ok=True)
        tts.save(save_path)

        with save_path.open("rb") as f:
            checksum = hashlib.md5(f.read()).hexdigest()

        return {
            "file_url": f"/api/v1/audio/{filename}",
            "file_path": str(save_path),
            "storage_backend": "local",
            "storage_key": filename,
            "content_type": "audio/mpeg",
            "duration_seconds": max(1, len(text) // 5),  # Mock duration calculation
            "checksum": checksum,
            "transcript": text,
        }


def get_tts_provider() -> BaseTTSProvider:
    if settings.TTS_PROVIDER == "gtts":
        return GTTSProvider()
    return DisabledTTSProvider()
