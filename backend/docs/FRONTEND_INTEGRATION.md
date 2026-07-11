# Frontend Integration Guide

Swagger utama sekarang sengaja kecil. Untuk frontend kursus, gunakan hanya:

- `POST /api/v1/auth/register`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/refresh`
- `POST /api/v1/auth/logout`
- Semua endpoint di `/api/v1/app/*`

Endpoint `/api/v1/admin/*`, `/api/v1/curriculum/*`, `/api/v1/learning-sessions/*`,
dan endpoint detail lain tetap hidup untuk back-office/test, tetapi disembunyikan dari Swagger utama.

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

3. Ambil katalog kursus lengkap:
   `GET /api/v1/app/catalog`

4. Ambil detail lesson:
   `GET /api/v1/app/lessons/{lesson_id}`

5. Mulai latihan:
   `POST /api/v1/app/lessons/{lesson_id}/sessions`

6. Ambil soal session:
   `GET /api/v1/app/sessions/{session_id}/questions`

7. Submit jawaban:
   `POST /api/v1/app/sessions/{session_id}/answers`

8. Complete session:
   `POST /api/v1/app/sessions/{session_id}/complete`

9. Dashboard:
   `GET /api/v1/app/dashboard`

## Generate Soal Dengan AI

Frontend tidak perlu memakai endpoint admin.

1. Buat job:
   `POST /api/v1/app/lessons/{lesson_id}/ai-question-jobs`

2. Poll status:
   `GET /api/v1/app/ai-question-jobs/{job_id}`

Jika Redis/Celery belum hidup, job akan cepat menjadi `FAILED` dengan `error_message`.
Untuk menjalankan AI sungguhan, jalankan Redis + worker Celery, lalu set:

```env
AI_PROVIDER=gemini
GEMINI_API_KEY=...
```

## Bentuk Jawaban

Gunakan `question.question_type` dari response question:

- `MULTIPLE_CHOICE`, `LISTENING_MULTIPLE_CHOICE`: `{"selected_option_id":"a"}`
- `TRUE_FALSE`: `{"value":true}`
- `READING_COMPREHENSION`: `{"selected_option_ids":["b"]}`

Backend tidak pernah mengirim answer key sebelum jawaban dikirim, jadi frontend aman dari answer leak.
