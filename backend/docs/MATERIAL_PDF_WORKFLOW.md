# Material PDF Workflow - Target MVP

## Alur Utama

Alur project direvisi menjadi material-first:

```text
Admin upload PDF
Backend extract text
Admin publish material
User membuka material
User memilih difficulty
User generate quiz
AI membuat soal dari PDF
User mengerjakan
Backend validasi
Jika lulus: EXP diberikan dan materi berikutnya unlock
Jika gagal: EXP 0 dan materi berikutnya tetap locked
```

## Admin Workflow

Admin tidak perlu membuat course, unit, atau lesson.

Admin cukup membuat material PDF.

### Upload PDF

```http
POST /api/v1/admin/materials/pdf
Authorization: Bearer <admin_access_token>
Content-Type: multipart/form-data

file=<material.pdf>
title=<material title>
description=<optional description>
level=N5
category=reading
sequence=1
passing_score=70
is_published=true
```

Backend menyimpan:

- file PDF asli
- teks hasil ekstraksi PDF
- metadata material
- status publish
- urutan material
- passing score

### Preview PDF Text

```http
GET /api/v1/admin/materials/{material_id}/preview
```

Dipakai admin untuk memastikan PDF terbaca.

### Publish/Unpublish

```http
POST /api/v1/admin/materials/{material_id}/publish
POST /api/v1/admin/materials/{material_id}/unpublish
```

### Edit Metadata

```http
PATCH /api/v1/admin/materials/{material_id}
```

Field yang boleh diedit:

- `title`
- `description`
- `level`
- `category`
- `sequence`
- `passing_score`

### Delete/Archive

```http
DELETE /api/v1/admin/materials/{material_id}
```

Delete harus berupa archive/soft delete agar riwayat attempt user tidak rusak.

## User Workflow

### List Material

```http
GET /api/v1/app/materials
```

Backend harus mengembalikan status progress user:

- `locked`
- `unlocked`
- `completed`

Materi pertama selalu unlocked.
Materi berikutnya unlocked jika materi sebelumnya completed.

### Detail Material

```http
GET /api/v1/app/materials/{material_id}
```

Jika material locked, backend mengembalikan `423 Locked`.

### Stream PDF

```http
GET /api/v1/app/materials/{material_id}/file
```

### Generate Quiz

```http
POST /api/v1/app/materials/{material_id}/generate-quiz
Content-Type: application/json

{
  "difficulty": "medium",
  "question_count": 10
}
```

Difficulty:

- `easy`
- `medium`
- `hard`

Backend membuat session/job khusus user tersebut.

### Status Quiz

```http
GET /api/v1/app/quiz-sessions/{session_id}/status
```

### Questions

```http
GET /api/v1/app/quiz-sessions/{session_id}/questions
```

Backend tidak boleh mengirim answer key sebelum submit.

### Submit

```http
POST /api/v1/app/quiz-sessions/{session_id}/submit
```

Jika score lulus:

- session `is_passed = true`
- `earned_exp > 0`
- material progress `completed`
- next material unlocked

Jika score gagal:

- session `is_passed = false`
- `earned_exp = 0`
- material progress tetap belum completed
- next material tetap locked

## EXP Rule

EXP hanya diberikan jika user lulus.

Formula MVP:

```text
easy:   round(100 * 1.0 * score / 100)
medium: round(100 * 1.25 * score / 100)
hard:   round(100 * 1.5 * score / 100)
```

Jika score kurang dari passing score:

```text
earned_exp = 0
```

## Catatan Teknis

- PDF harus berbasis teks.
- OCR untuk PDF scan tidak masuk MVP.
- AI harus dibatasi agar hanya membuat soal dari extracted text PDF.
- Generate quiz tetap boleh memakai Redis/Celery agar request frontend tidak menunggu lama.
- Jika Redis/Celery tidak aktif, backend harus memberi status `failed` yang ramah frontend.
- Admin generate soal manual/back-office tidak wajib untuk MVP.
