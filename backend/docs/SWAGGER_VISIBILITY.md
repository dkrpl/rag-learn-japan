# Swagger Visibility Guide - Material-First MVP

Dokumen ini menjelaskan isi Swagger setelah backend dirombak ke material-first MVP.

## Prinsip

Swagger utama harus membantu frontend, bukan menampilkan semua endpoint internal.

Untuk MVP baru, Swagger utama cukup menampilkan:

- Auth
- User App material-first
- Admin Materials
- Admin Users

## Tampil Di Swagger Utama

### Auth

```http
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/refresh
POST /api/v1/auth/logout
```

### User App

```http
GET  /api/v1/app/me
GET  /api/v1/app/dashboard
GET  /api/v1/app/materials
GET  /api/v1/app/materials/{material_id}
GET  /api/v1/app/materials/{material_id}/file
POST /api/v1/app/materials/{material_id}/generate-quiz
GET  /api/v1/app/quiz-sessions/{session_id}/status
GET  /api/v1/app/quiz-sessions/{session_id}/questions
POST /api/v1/app/quiz-sessions/{session_id}/submit
GET  /api/v1/app/quiz-sessions/{session_id}/result
GET  /api/v1/app/attempts
GET  /api/v1/app/leaderboard
```

### Admin Materials

```http
POST   /api/v1/admin/materials/pdf
GET    /api/v1/admin/materials
GET    /api/v1/admin/materials/{material_id}
PATCH  /api/v1/admin/materials/{material_id}
GET    /api/v1/admin/materials/{material_id}/preview
POST   /api/v1/admin/materials/{material_id}/publish
POST   /api/v1/admin/materials/{material_id}/unpublish
DELETE /api/v1/admin/materials/{material_id}
```

### Admin Users

```http
GET    /api/v1/admin/users
POST   /api/v1/admin/users
GET    /api/v1/admin/users/{user_id}
PATCH  /api/v1/admin/users/{user_id}
DELETE /api/v1/admin/users/{user_id}
```

## Disembunyikan Dari Swagger Utama

Endpoint berikut tidak perlu dipakai frontend MVP baru:

```http
/api/v1/admin/curriculum/*
/api/v1/app/catalog
/api/v1/app/lessons/*
/api/v1/app/ai-question-jobs/*
/api/v1/app/sessions/*
```

Endpoint operasional juga tetap disembunyikan:

```http
GET /health
GET /ready
GET /metrics
```

## Catatan

Endpoint curriculum dan endpoint lesson/job/session lama sudah tidak muncul di
Swagger utama. Jika frontend membutuhkan daftar endpoint aktual, gunakan
`backend/docs/ENDPOINTS.md` atau `/docs` saat server berjalan.
