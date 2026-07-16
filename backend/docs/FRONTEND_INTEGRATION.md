# Frontend Integration Guide - Material-First MVP

Dokumen ini adalah kontrak frontend untuk backend material-first.

## Prinsip Integrasi

Frontend tidak perlu memikirkan course, unit, atau lesson.

Frontend cukup memakai alur:

```text
Login
GET materials
Open material PDF
Choose difficulty
Generate quiz
Poll session status
Show questions
Submit answers
Show result
Update dashboard/attempt/leaderboard
```

## Auth

Login:

```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "learner@example.com",
  "password": "Password123",
  "device_name": "Web"
}
```

Pakai token:

```http
Authorization: Bearer <access_token>
```

## User App Flow

### 1. Ambil profil user

```http
GET /api/v1/app/me
```

### 2. Ambil dashboard

```http
GET /api/v1/app/dashboard
```

Dashboard minimal menampilkan:

- total EXP
- jumlah materi completed
- attempt count
- accuracy
- current rank
- next locked/unlocked material

### 3. Ambil daftar materi

```http
GET /api/v1/app/materials
```

Response:

```json
[
  {
    "id": "material_id",
    "title": "Reading N5 - Salam Dasar",
    "description": "Latihan pemahaman bacaan dasar.",
    "level": "N5",
    "category": "reading",
    "sequence": 1,
    "passing_score": 70,
    "page_count": 1,
    "file_url": "/api/v1/app/materials/material_id/file",
    "status": "unlocked",
    "is_locked": false,
    "best_score": 0,
    "last_score": 0,
    "attempts_count": 0
  }
]
```

Status material:

- `locked`
- `unlocked`
- `completed`

### 4. Ambil detail materi

```http
GET /api/v1/app/materials/{material_id}
```

Detail menampilkan metadata dan `file_url`.

### 5. Buka file PDF

```http
GET /api/v1/app/materials/{material_id}/file
```

### 6. Generate quiz

User memilih difficulty sebelum generate.

```http
POST /api/v1/app/materials/{material_id}/generate-quiz
Content-Type: application/json

{
  "difficulty": "medium",
  "question_count": 10
}
```

Difficulty valid:

- `easy`
- `medium`
- `hard`

Response:

```json
{
  "session_id": "session_id",
  "material_id": "material_id",
  "status": "ACTIVE",
  "difficulty": 2,
  "passing_score": 70,
  "total_questions": 10,
  "ai_generation_id": "generation_id"
}
```

### 7. Poll status quiz

```http
GET /api/v1/app/quiz-sessions/{session_id}/status
```

Status mengikuti enum session backend, terutama `ACTIVE`, `COMPLETED`, `EXPIRED`, dan `CANCELLED`.

### 8. Ambil soal

```http
GET /api/v1/app/quiz-sessions/{session_id}/questions
```

Backend tidak boleh mengirim answer key sebelum submit.

### 9. Submit jawaban

```http
POST /api/v1/app/quiz-sessions/{session_id}/submit
Content-Type: application/json

{
  "answers": [
    {
      "session_question_id": "session_question_id",
      "answer_json": {
        "selected_option_id": "a"
      },
      "response_time_ms": 1200
    }
  ]
}
```

Response:

```json
{
  "session_id": "session_id",
  "material_id": "material_id",
  "score": 80,
  "passing_score": 70,
  "is_passed": true,
  "earned_exp": 100,
  "correct_answers": 8,
  "total_questions": 10,
  "completed_at": "2026-07-16T15:00:00",
  "message": "Selamat, materi berikutnya sudah terbuka.",
  "review": [
    {
      "session_question_id": "session_question_id",
      "order_number": 1,
      "question_id": "question_id",
      "prompt_json": {
        "text": "Pertanyaan",
        "options": [
          { "id": "a", "text": "Opsi A" },
          { "id": "b", "text": "Opsi B" },
          { "id": "c", "text": "Opsi C" },
          { "id": "d", "text": "Opsi D" }
        ]
      },
      "user_answer_json": { "selected_option_id": "a" },
      "is_correct": true,
      "score": 100,
      "correct_answer_json": { "correct_option_id": "a" },
      "explanation_json": { "text": "Penjelasan dari materi PDF." },
      "feedback_notes": "Correct. Penjelasan dari materi PDF."
    }
  ]
}
```

Jika tidak lulus:

```json
{
  "score": 50,
  "passing_score": 70,
  "is_passed": false,
  "earned_exp": 0
}
```

Frontend harus menampilkan pesan:

```text
Nilai belum cukup. Kamu harus mengulang materi ini untuk membuka materi berikutnya.
```

### 10. Riwayat attempt

```http
GET /api/v1/app/attempts
```

Attempt gagal tetap muncul, tetapi `earned_exp = 0`.

### 11. Leaderboard

```http
GET /api/v1/app/leaderboard?period=all
```

Leaderboard memakai total EXP dari attempt yang lulus saja.

Query `period`:

- `all`
- `weekly`
- `monthly`

## Admin Flow

### Upload PDF

```http
POST /api/v1/admin/materials/pdf
Content-Type: multipart/form-data

file=<material.pdf>
title=Reading N5 - Salam Dasar
description=Materi bacaan dasar
level=N5
category=reading
sequence=1
passing_score=70
is_published=true
```

### List materials

```http
GET /api/v1/admin/materials
```

### Edit material

```http
PATCH /api/v1/admin/materials/{material_id}
Content-Type: application/json

{
  "title": "Updated title",
  "level": "N5",
  "category": "reading",
  "sequence": 2,
  "passing_score": 75
}
```

### Preview extracted text

```http
GET /api/v1/admin/materials/{material_id}/preview
```

### Material analytics

```http
GET /api/v1/admin/materials/{material_id}/analytics
```

Response:

```json
{
  "material_id": "material_id",
  "title": "Reading N5",
  "total_attempts": 20,
  "completed_learners": 8,
  "average_score": 76,
  "pass_rate": 65,
  "most_used_difficulty": 2,
  "failed_attempts": 7,
  "passed_attempts": 13,
  "difficulty_breakdown": [
    { "label": "easy", "count": 8, "percentage": 40 },
    { "label": "medium", "count": 12, "percentage": 60 }
  ],
  "score_buckets": [
    { "label": "0-49", "count": 3, "percentage": 15 },
    { "label": "50-69", "count": 4, "percentage": 20 },
    { "label": "70-84", "count": 9, "percentage": 45 },
    { "label": "85-100", "count": 4, "percentage": 20 }
  ],
  "recent_attempts": [
    {
      "session_id": "session_id",
      "learner_name": "Learner",
      "final_score": 80,
      "is_passed": true,
      "difficulty": 2,
      "earned_exp": 100,
      "completed_at": "2026-07-16T15:00:00"
    }
  ]
}
```

Export CSV analytics:

```http
GET /api/v1/admin/materials/{material_id}/analytics.csv
```

Endpoint ini tetap membutuhkan Bearer token admin. Di browser frontend, gunakan `fetch`
dengan header `Authorization`, lalu ubah response menjadi Blob untuk download.

### Audit log admin

```http
GET /api/v1/admin/audit-logs?limit=100
```

Response:

```json
[
  {
    "id": "audit_id",
    "user_id": "admin_id",
    "action": "material.publish",
    "entity_name": "learning_material",
    "entity_id": "material_id",
    "details": "{\"title\":\"Reading N5\"}",
    "created_at": "2026-07-16T15:00:00"
  }
]
```

### Publish/unpublish

```http
POST /api/v1/admin/materials/{material_id}/publish
POST /api/v1/admin/materials/{material_id}/unpublish
```

### Delete/archive

```http
DELETE /api/v1/admin/materials/{material_id}
```

Delete harus soft delete/archive.

## Frontend Routing Target

User:

```text
/app/dashboard
/app/materials
/app/materials/:id
/app/quiz/:sessionId
/app/attempts
/app/leaderboard
```

Admin:

```text
/admin/dashboard
/admin/materials
/admin/analytics
/admin/audit-logs
/admin/users
```

Tidak perlu halaman admin curriculum untuk MVP baru.

## UX Production Notes

Frontend production harus menjaga beberapa aturan:

- Jangan tampilkan answer key sebelum quiz selesai.
- Setelah submit, tampilkan ringkasan hasil dan review per soal jika backend mengirim `is_correct` atau `feedback_notes`.
- Tampilkan pesan jelas saat user gagal: EXP tidak masuk dan material berikutnya tetap locked.
- Tampilkan sisa kuota generate AI harian di dashboard user.
- Leaderboard harus punya filter `all`, `weekly`, dan `monthly` jika UI sudah menampilkan ranking lengkap.
- Jelaskan bahwa leaderboard dihitung dari EXP valid, bukan jumlah percobaan.
- Admin material page tidak boleh meminta course/unit/lesson. PDF adalah sumber materi utama.
- Admin harus bisa preview extracted text sebelum publish agar kualitas PDF bisa dicek.

## Production Readiness Reference

Roadmap detail untuk production ada di:

```text
backend/docs/PRODUCTION_READINESS_ROADMAP.md
```
