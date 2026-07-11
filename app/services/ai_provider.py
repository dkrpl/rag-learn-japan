import os
from abc import ABC, abstractmethod
from typing import Any, Dict, Tuple

import requests


class BaseAIProvider(ABC):
    @abstractmethod
    def generate_questions(self, prompt: str) -> Tuple[str, Dict[str, Any]]:
        """Must return a raw JSON string and metadata (e.g. tokens_used)"""
        pass


class GeminiProvider(BaseAIProvider):
    def __init__(self):
        self.api_key = os.getenv("GEMINI_API_KEY")
        self.url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={self.api_key}"

    def generate_questions(self, prompt: str) -> Tuple[str, Dict[str, Any]]:
        if not self.api_key:
            raise ValueError("GEMINI_API_KEY is missing")

        payload = {
            "contents": [{"parts": [{"text": prompt}]}],
            "generationConfig": {"response_mime_type": "application/json"},
        }

        response = requests.post(self.url, json=payload)

        if response.status_code != 200:
            raise Exception(f"Gemini API Error: {response.text}")

        data = response.json()
        try:
            content = data["candidates"][0]["content"]["parts"][0]["text"]
            tokens = data.get("usageMetadata", {}).get("totalTokenCount", 0)
            return content, {"tokens_used": tokens}
        except (KeyError, IndexError) as e:
            raise Exception(f"Failed to parse Gemini response: {str(e)}")


def get_ai_provider() -> BaseAIProvider:
    return GeminiProvider()
