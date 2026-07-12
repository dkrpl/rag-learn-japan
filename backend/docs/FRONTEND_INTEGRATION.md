# Frontend Integration Guide

Swagger utama sekarang sengaja kecil. Untuk frontend kursus, gunakan hanya:

- `POST /api/v1/auth/register`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/refresh`
- `POST /api/v1/auth/logout`
- Semua endpoint di `/api/v1/app/*`

Endpoint `/api/v1/admin/*`, `/api/v1/curriculum/*`, `/api/v1/learning-sessions/*`, dan `/api/v1/users/*`
tetap ada untuk back-office/test/kompatibilitas, tetapi bukan kontrak utama MVP frontend.

## Autentikasi Wajib

Semua endpoint `/api/v1/app/*` wajib memakai access token dari login. Token tidak dibaca dari body atau cookie.

1. Login:

```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "learner@example.com",
  "password": "Password123"
}
```

2. Ambil `access_token` dari response.

3. Kirim token di setiap request `/api/v1/app/*`:

```http
GET /api/v1/app/me
Authorization: Bearer <access_token>
```

Contoh frontend:

```ts
const loginRes = await fetch(`${API_URL}/api/v1/auth/login`, {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    email: "learner@example.com",
    password: "Password123",
  }),
});

const { access_token } = await loginRes.json();

const meRes = await fetch(`${API_URL}/api/v1/app/me`, {
  headers: { Authorization: `Bearer ${access_token}` },
});
```

Di Swagger, klik tombol **Authorize**, lalu paste nilai `access_token` saja.
Untuk request manual seperti Postman/fetch/cURL, header lengkapnya tetap:

```text
Authorization: Bearer <access_token>
```

Kalau header ini tidak dikirim, response yang benar adalah `401 Authentication required`.

## Alur Frontend Utama

1. Login:
   `POST /api/v1/auth/login`

2. Ambil user:
   `GET /api/v1/app/me`

3. Ambil katalog kursus:
   `GET /api/v1/app/catalog`

   Frontend memakai status lesson: `locked`, `unlocked`, atau `completed`.

4. Ambil detail lesson:
   `GET /api/v1/app/lessons/{lesson_id}`

5. Ambil materi PDF yang di-upload admin:
   `GET /api/v1/app/lessons/{lesson_id}/materials`

6. Tampilkan PDF viewer dari `file_url` material:
   `GET /api/v1/app/materials/{material_id}/file`

7. Generate soal dari PDF:
   `POST /api/v1/app/materials/{material_id}/ai-question-jobs`

8. Poll status AI job:
   `GET /api/v1/app/ai-question-jobs/{job_id}`

9. Kalau job sudah `COMPLETED`, mulai sesi dari soal hasil AI:
   `POST /api/v1/app/ai-question-jobs/{job_id}/sessions`

10. Ambil soal session:
   `GET /api/v1/app/sessions/{session_id}/questions`

11. Submit jawaban:
   `POST /api/v1/app/sessions/{session_id}/answers`

12. Complete session:
   `POST /api/v1/app/sessions/{session_id}/complete`

13. Dashboard:
   `GET /api/v1/app/dashboard`

14. Leaderboard:
   `GET /api/v1/app/leaderboard`

## Generate Soal Dengan AI

Frontend tidak perlu memakai endpoint admin.

Generate dari materi PDF admin:

```http
POST /api/v1/app/materials/{material_id}/ai-question-jobs
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "question_count": 10,
  "difficulty": 1,
  "prompt": "Fokus pada pemahaman arti kalimat."
}
```

Poll status:
`GET /api/v1/app/ai-question-jobs/{job_id}`

Setelah status `COMPLETED`, buat session:
`POST /api/v1/app/ai-question-jobs/{job_id}/sessions`

Jika Redis/Celery belum hidup, job akan cepat menjadi `FAILED` dengan `error_message`.
Untuk menjalankan AI sungguhan, jalankan Redis + worker Celery, lalu set:

```env
AI_PROVIDER=gemini
GEMINI_API_KEY=...
```

## Bentuk Jawaban

MVP frontend hanya perlu mendukung pilihan ganda reading:

- `MULTIPLE_CHOICE`: `{"selected_option_id":"a"}`

Backend tidak pernah mengirim answer key sebelum jawaban dikirim, jadi frontend aman dari answer leak.

## Fitur Yang Tidak Dipakai MVP Frontend

- SRS/review schedule.
- Mistake review khusus.
- JLPT simulation.
- TTS/audio/listening.
- Admin manual question bank dan review workflow.
- Generate soal bebas dari lesson tanpa PDF.
