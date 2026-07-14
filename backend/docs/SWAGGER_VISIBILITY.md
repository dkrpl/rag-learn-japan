# Swagger Visibility Guide

Swagger utama sekarang menampilkan endpoint yang dibutuhkan oleh **frontend user app** dan **frontend admin/back-office**.

Total endpoint yang tampil di `http://127.0.0.1:8000/docs`: **82 endpoint**.

## Tampil Di Swagger Utama

### Auth

```http
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/refresh
POST /api/v1/auth/logout
```

### Frontend User App

Base path:

```http
/api/v1/app/*
```

Dipakai untuk:

- Profil user.
- Katalog kursus.
- Detail lesson.
- PDF material untuk learner.
- Generate soal AI dari PDF.
- Regenerate soal.
- Learning session.
- Submit jawaban.
- Attempt history.
- Dashboard.
- Leaderboard.

### Admin Curriculum

Base path:

```http
/api/v1/admin/curriculum/*
```

Dipakai untuk:

- Mengelola level.
- Mengelola course.
- Mengelola unit.
- Mengelola lesson.
- Mengelola lesson section.
- Publish, unpublish, archive, restore resource curriculum.

### Admin Materials

Base path:

```http
/api/v1/admin/materials/*
```

Dipakai untuk:

- Upload PDF material.
- List material per lesson.
- Detail material.
- Preview teks hasil ekstraksi PDF.
- Publish/unpublish PDF material.
- Generate soal dari PDF untuk kebutuhan admin.

### Admin Users

Base path:

```http
/api/v1/admin/users/*
```

Dipakai untuk:

- List user.
- Detail user.
- Ubah role user.
- Ubah status aktif/nonaktif user.

## Tetap Disembunyikan Dari Swagger

Endpoint berikut masih ada di backend, tetapi bukan kontrak fitur frontend.

### System / Operational

```http
GET /health
GET /ready
GET /metrics
```

Dipakai untuk health check, readiness check, dan monitoring.

## Endpoint Internal Yang Sudah Dihapus

Endpoint berikut sudah dihapus karena sudah digantikan oleh `/api/v1/app/*`:

```http
/api/v1/curriculum/*
/api/v1/learning-sessions/*
/api/v1/users/*
```

## Rekomendasi Pemakaian

- Frontend learner/mobile/web user memakai `Auth` dan `/api/v1/app/*`.
- Frontend admin/back-office memakai `/api/v1/admin/*`.
- Endpoint operasional yang disembunyikan tidak perlu dipakai frontend.
