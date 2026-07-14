# Material PDF Workflow

Alur utama project:

1. Admin membuat struktur kursus:
   `Level -> Course -> Unit -> Lesson`.
2. Admin upload PDF ke lesson.
3. Backend menyimpan file PDF asli, mengekstrak teks PDF, dan menyimpannya sebagai `MaterialDocument`.
4. User melihat daftar PDF yang tersedia di lesson.
5. User membuat AI question job dari PDF pilihan.
6. Worker AI membuat soal private untuk user/job tersebut, lalu user memulai sesi dari hasil job.
7. User mengerjakan soal, jawaban divalidasi, dan jika skor mencapai KKM lesson, XP bertambah, lesson completed, lesson berikutnya unlocked, leaderboard naik.

## Endpoint Admin

Upload PDF:

```http
POST /api/v1/admin/materials/pdf
Authorization: Bearer <admin_access_token>
Content-Type: multipart/form-data

file=<material.pdf>
lesson_id=<lesson_id>
title=<optional title>
```

Generate soal dari PDF oleh admin tetap tersedia untuk back-office:

```http
POST /api/v1/admin/materials/{material_id}/question-jobs
Authorization: Bearer <admin_access_token>
Content-Type: application/json

{
  "question_count": 10,
  "question_type": "MULTIPLE_CHOICE",
  "skill": "READING",
  "difficulty": 1,
  "additional_notes": "Buat soal untuk pemula JLPT N5."
}
```

List material:

```http
GET /api/v1/admin/materials?lesson_id=<lesson_id>
```

Preview teks hasil ekstraksi PDF:

```http
GET /api/v1/admin/materials/{material_id}/preview
```

Publish/unpublish material:

```http
POST /api/v1/admin/materials/{material_id}/publish
POST /api/v1/admin/materials/{material_id}/unpublish
```

## Endpoint User

Frontend user tetap memakai endpoint sederhana:

```http
GET /api/v1/app/catalog
GET /api/v1/app/lessons/{lesson_id}
GET /api/v1/app/lessons/{lesson_id}/materials
GET /api/v1/app/materials/{material_id}/file
POST /api/v1/app/materials/{material_id}/ai-question-jobs
GET /api/v1/app/ai-question-jobs/{job_id}
POST /api/v1/app/ai-question-jobs/{job_id}/regenerate
POST /api/v1/app/ai-question-jobs/{job_id}/sessions
GET /api/v1/app/sessions/{session_id}/questions
POST /api/v1/app/sessions/{session_id}/answers
POST /api/v1/app/sessions/{session_id}/complete
GET /api/v1/app/dashboard
GET /api/v1/app/attempts
GET /api/v1/app/lessons/{lesson_id}/progress
GET /api/v1/app/leaderboard
```

Alur utama user dari PDF:

1. Ambil materi PDF lesson:
   `GET /api/v1/app/lessons/{lesson_id}/materials`
2. Buka PDF viewer dari `file_url`:
   `GET /api/v1/app/materials/{material_id}/file`
3. Generate soal dari PDF:
   `POST /api/v1/app/materials/{material_id}/ai-question-jobs`
4. Poll sampai job `COMPLETED`:
   `GET /api/v1/app/ai-question-jobs/{job_id}`
5. Jika perlu, regenerate dari job lama:
   `POST /api/v1/app/ai-question-jobs/{job_id}/regenerate`
6. Mulai sesi dari soal hasil AI:
   `POST /api/v1/app/ai-question-jobs/{job_id}/sessions`
7. Ambil soal, submit jawaban, lalu complete session.
8. Cek dashboard, riwayat attempt, progress lesson, dan ranking leaderboard.

User tidak memakai endpoint admin, tetapi user memang melihat daftar PDF/materi yang sudah di-upload admin.

## Catatan

- PDF harus berbasis teks. PDF hasil scan gambar belum didukung karena butuh OCR.
- AI hanya diinstruksikan memakai teks hasil ekstraksi PDF sebagai sumber soal.
- Soal hasil job user di MVP ini private untuk user/job, bukan bank soal global.
- XP utama dibuat saat session complete dan skor memenuhi KKM lesson, default 70.
- Lesson berikutnya dihitung unlocked jika lesson sebelumnya sudah completed.
- Generate soal user dibatasi per hari dengan `AI_DAILY_GENERATION_LIMIT`.
- Leaderboard mendukung periode `all`, `weekly`, dan `monthly`.
- Untuk menjalankan AI sungguhan di Railway, aktifkan Redis/Celery dan set `AI_PROVIDER=gemini` serta `GEMINI_API_KEY`.
