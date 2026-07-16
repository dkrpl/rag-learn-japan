"""Seed local demo data for the material-first PDF quiz MVP.

Usage:
    python scripts/seed_dummy_data.py
"""

from __future__ import annotations

import hashlib
import sys
from datetime import datetime, timezone
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from app.core import security  # noqa: E402
from app.db.session import SessionLocal  # noqa: E402
from app.models.material import MaterialDocument  # noqa: E402
from app.models.user import User, UserRole  # noqa: E402
from app.services.pdf_material import store_pdf_material  # noqa: E402

DEMO_PASSWORD = "Password123"


def _text_pdf_bytes(text: str) -> bytes:
    escaped = text.replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)")
    stream = f"BT /F1 12 Tf 72 720 Td ({escaped}) Tj ET".encode("latin-1", errors="replace")
    objects = [
        b"<< /Type /Catalog /Pages 2 0 R >>",
        b"<< /Type /Pages /Kids [3 0 R] /Count 1 >>",
        b"<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] "
        b"/Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>",
        b"<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>",
        b"<< /Length %d >>\nstream\n" % len(stream) + stream + b"\nendstream",
    ]
    output = bytearray(b"%PDF-1.4\n")
    offsets = [0]
    for index, obj in enumerate(objects, start=1):
        offsets.append(len(output))
        output.extend(f"{index} 0 obj\n".encode() + obj + b"\nendobj\n")
    xref_offset = len(output)
    output.extend(f"xref\n0 {len(objects) + 1}\n".encode())
    output.extend(b"0000000000 65535 f \n")
    for offset in offsets[1:]:
        output.extend(f"{offset:010d} 00000 n \n".encode())
    output.extend(
        f"trailer\n<< /Size {len(objects) + 1} /Root 1 0 R >>\nstartxref\n{xref_offset}\n%%EOF\n".encode()
    )
    return bytes(output)


def _upsert_user(db, *, email: str, role: UserRole, name: str) -> User:
    user = db.query(User).filter(User.email == email).first()
    values = {
        "password_hash": security.get_password_hash(DEMO_PASSWORD),
        "name": name,
        "role": role,
        "is_active": True,
        "email_verified_at": datetime.now(timezone.utc),
        "timezone": "Asia/Jakarta",
        "target_level": "N5",
    }
    if user is None:
        user = User(email=email, **values)
        db.add(user)
    else:
        for field, value in values.items():
            setattr(user, field, value)
    db.flush()
    return user


def _upsert_material(
    db,
    *,
    admin: User,
    title: str,
    description: str,
    category: str,
    sequence: int,
    text: str,
) -> MaterialDocument:
    pdf_bytes = _text_pdf_bytes(text)
    checksum = hashlib.sha256(pdf_bytes).hexdigest()
    material = db.query(MaterialDocument).filter(MaterialDocument.checksum == checksum).first()
    values = {
        "title": title,
        "description": description,
        "level": "N5",
        "category": category,
        "sequence": sequence,
        "passing_score": 70,
        "original_filename": f"demo-{sequence}-{title.lower().replace(' ', '-')}.pdf"[:255],
        "content_type": "application/pdf",
        "file_size_bytes": len(pdf_bytes),
        "checksum": checksum,
        "storage_key": store_pdf_material(pdf_bytes, checksum),
        "page_count": 1,
        "extracted_text": text,
        "is_published": True,
        "is_archived": False,
        "published_at": datetime.now(timezone.utc),
        "archived_at": None,
        "created_by_id": admin.id,
    }
    if material is None:
        material = MaterialDocument(**values)
        db.add(material)
    else:
        for field, value in values.items():
            setattr(material, field, value)
    db.flush()
    return material


def seed_dummy_data() -> dict[str, int]:
    db = SessionLocal()
    try:
        admin = _upsert_user(db, email="admin@example.com", role=UserRole.ADMINISTRATOR, name="Demo Admin")
        _upsert_user(db, email="learner@example.com", role=UserRole.LEARNER, name="Demo Learner")

        materials = [
            _upsert_material(
                db,
                admin=admin,
                title="Salam Dasar",
                description="Materi awal tentang salam sehari-hari bahasa Jepang.",
                category="greetings",
                sequence=1,
                text=(
                    "Materi Salam Dasar N5. Konnichiwa berarti halo atau selamat siang. "
                    "Ohayou gozaimasu berarti selamat pagi. Konbanwa berarti selamat malam. "
                    "Arigatou gozaimasu berarti terima kasih. Gunakan salam sesuai waktu dan situasi."
                ),
            ),
            _upsert_material(
                db,
                admin=admin,
                title="Partikel Wa dan Desu",
                description="Materi pengenalan pola kalimat sederhana.",
                category="grammar",
                sequence=2,
                text=(
                    "Partikel wa menandai topik kalimat. Watashi wa gakusei desu berarti saya adalah pelajar. "
                    "Desu membuat kalimat terdengar sopan. Dalam percakapan dasar, pola A wa B desu sering digunakan."
                ),
            ),
            _upsert_material(
                db,
                admin=admin,
                title="Angka dan Waktu",
                description="Materi membaca angka dasar dan waktu sederhana.",
                category="vocabulary",
                sequence=3,
                text=(
                    "Ichi berarti satu, ni berarti dua, san berarti tiga, dan yon berarti empat. "
                    "Ji digunakan untuk menyebut jam, misalnya san-ji berarti jam tiga. "
                    "Han berarti setengah, sehingga san-ji han berarti pukul setengah empat."
                ),
            ),
        ]

        db.commit()
        return {"users": 2, "materials": len(materials)}
    finally:
        db.close()


def main() -> None:
    counts = seed_dummy_data()
    print(f"Dummy data ready: {counts}")
    print("Demo accounts: admin@example.com / Password123, learner@example.com / Password123")


if __name__ == "__main__":
    main()
