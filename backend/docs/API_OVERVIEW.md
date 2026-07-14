# Nihongo Learn API Overview

## Arsitektur Utama

Backend menggunakan FastAPI, SQLAlchemy, Alembic, MySQL, Redis, dan Celery. Kontrak frontend sengaja dibuat kecil:

- Public auth: `/api/v1/auth/*`
- Frontend MVP: `/api/v1/app/*`
- Back-office admin: `/api/v1/admin/*`, disembunyikan dari Swagger utama.

## Fitur MVP

1. Curriculum: `Level -> Course -> Unit -> Lesson -> Section`.
2. Material PDF: admin upload PDF ke lesson, backend menyimpan file dan teks hasil ekstraksi.
3. AI Question Job: user generate soal dari PDF admin.
4. Learning Session: user mengerjakan soal pilihan ganda reading.
5. Feedback: setelah submit, user mendapat benar/salah dan penjelasan dari PDF.
6. Progress: jawaban divalidasi backend, skor lulus memberi XP dan menyelesaikan lesson.
7. Attempt History: user dapat melihat riwayat sesi, skor, dan XP yang didapat.
8. Leaderboard: ranking total, mingguan, dan bulanan berdasarkan XP.
9. Admin Material Control: admin dapat preview ekstraksi PDF serta publish/unpublish material.

## Kontrak Frontend

Frontend cukup mengikuti `backend/docs/FRONTEND_INTEGRATION.md` dan `backend/docs/ENDPOINTS.md`. Swagger utama juga hanya menampilkan `Auth` dan `Frontend`.

## Auth

Semua endpoint `/api/v1/app/*` memakai header:

```text
Authorization: Bearer <access_token>
```

Jika header tidak dikirim, response yang benar adalah `401 Authentication required`.
