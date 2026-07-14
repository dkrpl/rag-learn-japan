"""Seed local demo data for the PDF reading-comprehension MVP.

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
from app.models.curriculum import Course, Lesson, LessonSection, Level, Unit  # noqa: E402
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


def seed_dummy_data() -> dict[str, int]:
    db = SessionLocal()
    try:
        admin = _upsert_user(db, email="admin@example.com", role=UserRole.ADMINISTRATOR, name="Demo Admin")
        _upsert_user(db, email="learner@example.com", role=UserRole.LEARNER, name="Demo Learner")

        level = db.query(Level).filter(Level.code == "N5").first()
        if level is None:
            level = Level(code="N5", name="JLPT N5", sequence=1)
            db.add(level)
        level.is_published = True
        level.is_archived = False
        level.published_at = datetime.now(timezone.utc)
        db.flush()

        course = db.query(Course).filter(Course.level_id == level.id, Course.title == "Dokkai N5").first()
        if course is None:
            course = Course(level_id=level.id, title="Dokkai N5", sequence=1)
            db.add(course)
        course.description = "Kursus pemahaman membaca bahasa Jepang berbasis PDF."
        course.is_published = True
        course.is_archived = False
        course.published_at = datetime.now(timezone.utc)
        db.flush()

        unit = db.query(Unit).filter(Unit.course_id == course.id, Unit.title == "Salam Dasar").first()
        if unit is None:
            unit = Unit(course_id=course.id, title="Salam Dasar", sequence=1)
            db.add(unit)
        unit.is_published = True
        unit.is_archived = False
        unit.published_at = datetime.now(timezone.utc)
        db.flush()

        lesson = db.query(Lesson).filter(Lesson.unit_id == unit.id, Lesson.title == "Membaca Salam Dasar").first()
        if lesson is None:
            lesson = Lesson(unit_id=unit.id, title="Membaca Salam Dasar", sequence=1)
            db.add(lesson)
        lesson.summary = "Baca materi PDF singkat, lalu uji pemahaman dengan quiz AI."
        lesson.learning_objective = "Learner memahami arti salam dasar bahasa Jepang dari materi bacaan."
        lesson.passing_score = 70
        lesson.is_published = True
        lesson.is_archived = False
        lesson.published_at = datetime.now(timezone.utc)
        db.flush()

        section = (
            db.query(LessonSection)
            .filter(LessonSection.lesson_id == lesson.id, LessonSection.sequence == 1)
            .first()
        )
        if section is None:
            section = LessonSection(lesson_id=lesson.id, title="Instruksi", sequence=1)
            db.add(section)
        section.content = "Baca PDF materi, lalu tekan tombol Uji Pemahaman Saya."
        section.is_published = True
        section.is_archived = False
        section.published_at = datetime.now(timezone.utc)

        extracted_text = (
            "Materi Salam Dasar N5. Konnichiwa berarti halo atau selamat siang. "
            "Ohayou gozaimasu berarti selamat pagi. Konbanwa berarti selamat malam. "
            "Arigatou gozaimasu berarti terima kasih. Gunakan salam sesuai waktu dan situasi."
        )
        pdf_bytes = _text_pdf_bytes(extracted_text)
        checksum = hashlib.sha256(pdf_bytes).hexdigest()
        material = db.query(MaterialDocument).filter(MaterialDocument.checksum == checksum).first()
        values = {
            "lesson_id": lesson.id,
            "title": "Demo PDF Salam Dasar",
            "original_filename": "demo-salam-dasar.pdf",
            "content_type": "application/pdf",
            "file_size_bytes": len(pdf_bytes),
            "checksum": checksum,
            "storage_key": store_pdf_material(pdf_bytes, checksum),
            "page_count": 1,
            "extracted_text": extracted_text,
            "is_published": True,
            "published_at": datetime.now(timezone.utc),
            "created_by_id": admin.id,
        }
        if material is None:
            db.add(MaterialDocument(**values))
        else:
            for field, value in values.items():
                setattr(material, field, value)

        db.commit()
        return {"users": 2, "levels": 1, "courses": 1, "units": 1, "lessons": 1, "materials": 1}
    finally:
        db.close()


def main() -> None:
    counts = seed_dummy_data()
    print(f"Dummy data ready: {counts}")
    print("Demo accounts: admin@example.com / Password123, learner@example.com / Password123")


if __name__ == "__main__":
    main()
