import hashlib
import os
import uuid
from abc import ABC, abstractmethod

# pyrefly: ignore [missing-import]
from gtts import gTTS


class BaseTTSProvider(ABC):
    @abstractmethod
    def generate_audio(self, text: str, lang: str = "ja") -> dict:
        """Returns metadata including URL and duration."""
        pass


class MockTTSProvider(BaseTTSProvider):
    def generate_audio(self, text: str, lang: str = "ja") -> dict:
        # Use gTTS to generate actual audio (free)
        tts = gTTS(text=text, lang=lang)
        filename = f"{uuid.uuid4()}.mp3"

        # Save to local uploads folder
        save_path = os.path.join("uploads", "audio", filename)
        os.makedirs(os.path.dirname(save_path), exist_ok=True)
        tts.save(save_path)

        # Calculate Checksum
        with open(save_path, "rb") as f:
            checksum = hashlib.md5(f.read()).hexdigest()

        return {
            "file_url": f"/uploads/audio/{filename}",
            "duration_seconds": max(1, len(text) // 5),  # Mock duration calculation
            "checksum": checksum,
            "transcript": text,
        }


def get_tts_provider() -> BaseTTSProvider:
    return MockTTSProvider()
