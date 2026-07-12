from __future__ import annotations

import hashlib
from dataclasses import dataclass
from io import BytesIO
from pathlib import Path

from fastapi import UploadFile
from pypdf import PdfReader

from app.core.config import settings

MAX_PDF_BYTES = 20 * 1024 * 1024
MAX_EXTRACTED_TEXT_CHARS = 120_000


class PdfMaterialError(ValueError):
    pass


@dataclass(frozen=True)
class ExtractedPdfMaterial:
    original_filename: str
    content_type: str
    file_size_bytes: int
    checksum: str
    page_count: int
    text: str
    data: bytes


def material_storage_path(storage_key: str) -> Path:
    root = settings.MATERIAL_STORAGE_PATH.resolve()
    path = (root / storage_key).resolve()
    if root != path and root not in path.parents:
        raise PdfMaterialError("Invalid material storage key")
    return path


def store_pdf_material(data: bytes, checksum: str) -> str:
    storage_key = f"{checksum[:2]}/{checksum}.pdf"
    path = material_storage_path(storage_key)
    path.parent.mkdir(parents=True, exist_ok=True)
    if not path.exists():
        path.write_bytes(data)
    return storage_key


def _normalize_text(value: str) -> str:
    return "\n".join(line.strip() for line in value.splitlines() if line.strip())


async def extract_pdf_material(upload: UploadFile) -> ExtractedPdfMaterial:
    content_type = (upload.content_type or "").split(";", 1)[0].strip().lower()
    filename = upload.filename or "material.pdf"
    if content_type not in {"application/pdf", "application/octet-stream"} and not filename.lower().endswith(".pdf"):
        raise PdfMaterialError("Only PDF files are supported")

    data = await upload.read(MAX_PDF_BYTES + 1)
    await upload.close()
    if not data:
        raise PdfMaterialError("PDF file is empty")
    if len(data) > MAX_PDF_BYTES:
        raise PdfMaterialError("PDF file exceeds the 20 MiB upload limit")

    try:
        reader = PdfReader(BytesIO(data))
        pages = []
        for page in reader.pages:
            pages.append(page.extract_text() or "")
    except Exception as exc:
        raise PdfMaterialError(f"Could not read PDF: {exc}") from exc

    text = _normalize_text("\n\n".join(pages))
    if not text:
        raise PdfMaterialError("PDF text could not be extracted. Use a text-based PDF, not a scanned image.")
    if len(text) > MAX_EXTRACTED_TEXT_CHARS:
        text = text[:MAX_EXTRACTED_TEXT_CHARS]

    return ExtractedPdfMaterial(
        original_filename=filename[:255],
        content_type="application/pdf",
        file_size_bytes=len(data),
        checksum=hashlib.sha256(data).hexdigest(),
        page_count=len(reader.pages),
        text=text,
        data=data,
    )
