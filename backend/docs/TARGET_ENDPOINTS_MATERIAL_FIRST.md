# Endpoint Catalog - Material-First MVP

Dokumen ini adalah ringkasan endpoint material-first yang dipakai frontend.
Daftar generated lengkap tersedia di `backend/docs/ENDPOINTS.md`.

## Auth

| Method | Path | Auth | Keterangan |
|:---|:---|:---|:---|
| POST | `/api/v1/auth/register` | Public | Register user learner |
| POST | `/api/v1/auth/login` | Public | Login |
| POST | `/api/v1/auth/refresh` | Public | Refresh token |
| POST | `/api/v1/auth/logout` | Bearer | Logout |

## User App

| Method | Path | Auth | Keterangan |
|:---|:---|:---|:---|
| GET | `/api/v1/app/me` | Bearer | Profil user |
| GET | `/api/v1/app/dashboard` | Bearer | Ringkasan EXP/progress |
| GET | `/api/v1/app/materials` | Bearer | Daftar materi published dengan lock status |
| GET | `/api/v1/app/materials/{material_id}` | Bearer | Detail materi |
| GET | `/api/v1/app/materials/{material_id}/file` | Bearer | Stream PDF |
| POST | `/api/v1/app/materials/{material_id}/generate-quiz` | Bearer | Generate quiz dari PDF dengan difficulty |
| GET | `/api/v1/app/quiz-sessions/{session_id}/status` | Bearer | Poll status generate/session |
| GET | `/api/v1/app/quiz-sessions/{session_id}/questions` | Bearer | Ambil soal tanpa answer key |
| POST | `/api/v1/app/quiz-sessions/{session_id}/submit` | Bearer | Submit jawaban dan hitung result |
| GET | `/api/v1/app/quiz-sessions/{session_id}/result` | Bearer | Ambil result setelah submit |
| GET | `/api/v1/app/attempts` | Bearer | Riwayat attempt |
| GET | `/api/v1/app/leaderboard` | Bearer | Leaderboard berdasarkan EXP |

## Admin Materials

| Method | Path | Auth | Keterangan |
|:---|:---|:---|:---|
| POST | `/api/v1/admin/materials/pdf` | Admin | Upload PDF material |
| GET | `/api/v1/admin/materials` | Admin | List material |
| GET | `/api/v1/admin/materials/{material_id}` | Admin | Detail material |
| PATCH | `/api/v1/admin/materials/{material_id}` | Admin | Edit metadata material |
| GET | `/api/v1/admin/materials/{material_id}/preview` | Admin | Preview extracted text |
| POST | `/api/v1/admin/materials/{material_id}/publish` | Admin | Publish material |
| POST | `/api/v1/admin/materials/{material_id}/unpublish` | Admin | Unpublish material |
| DELETE | `/api/v1/admin/materials/{material_id}` | Admin | Archive material |

## Admin Users

| Method | Path | Auth | Keterangan |
|:---|:---|:---|:---|
| GET | `/api/v1/admin/users` | Admin | List user |
| POST | `/api/v1/admin/users` | Admin | Create user |
| GET | `/api/v1/admin/users/{user_id}` | Admin | Detail user |
| PATCH | `/api/v1/admin/users/{user_id}` | Admin | Edit user |
| DELETE | `/api/v1/admin/users/{user_id}` | Admin | Deactivate user |

## Endpoint Lama Yang Sudah Tidak Dipakai MVP Baru

Endpoint berikut tidak dipakai frontend MVP material-first:

```text
/api/v1/admin/curriculum/*
/api/v1/app/catalog
/api/v1/app/lessons/*
/api/v1/app/ai-question-jobs/*
/api/v1/app/sessions/*
```

Endpoint lama tidak muncul di Swagger utama dan tidak perlu dipakai frontend.
