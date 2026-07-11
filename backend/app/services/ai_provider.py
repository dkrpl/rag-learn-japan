from abc import ABC, abstractmethod
from typing import Any

import requests

from app.core.config import settings


class BaseAIProvider(ABC):
    @abstractmethod
    def generate_questions(self, prompt: str) -> tuple[str, dict[str, Any]]:
        """Must return a raw JSON string and metadata (e.g. tokens_used)"""
        pass


class DisabledAIProvider(BaseAIProvider):
    def generate_questions(self, prompt: str) -> tuple[str, dict[str, Any]]:
        raise RuntimeError("AI provider is disabled. Set AI_PROVIDER=gemini and GEMINI_API_KEY to enable it.")


class GeminiProvider(BaseAIProvider):
    def __init__(self):
        self.api_key = settings.GEMINI_API_KEY
        self.url = (
            "https://generativelanguage.googleapis.com/v1beta/models/"
            f"{settings.GEMINI_MODEL}:generateContent?key={self.api_key}"
        )

    def generate_questions(self, prompt: str) -> tuple[str, dict[str, Any]]:
        if not self.api_key:
            raise ValueError("GEMINI_API_KEY is missing")

        payload = {
            "contents": [{"parts": [{"text": prompt}]}],
            "generationConfig": {"response_mime_type": "application/json"},
        }

        response = requests.post(self.url, json=payload, timeout=settings.AI_REQUEST_TIMEOUT_SECONDS)

        if response.status_code != 200:
            raise RuntimeError(f"Gemini API Error: {response.text}")

        data = response.json()
        try:
            content = data["candidates"][0]["content"]["parts"][0]["text"]
            tokens = data.get("usageMetadata", {}).get("totalTokenCount", 0)
            return content, {"tokens_used": tokens}
        except (KeyError, IndexError) as e:
            raise RuntimeError(f"Failed to parse Gemini response: {str(e)}") from e


def get_ai_provider() -> BaseAIProvider:
    if settings.AI_PROVIDER == "gemini":
        return GeminiProvider()
    return DisabledAIProvider()
