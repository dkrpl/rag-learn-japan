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
  "message": "Selamat, materi berikutnya sudah terbuka."
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
GET /api/v1/app/leaderboard
```

Leaderboard memakai total EXP dari attempt yang lulus saja.

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
/admin/users
```

Tidak perlu halaman admin curriculum untuk MVP baru.
