# Nihongo Learn API Overview

## Arsitektur MVP

Backend adalah API pembelajaran Bahasa Jepang berbasis PDF dengan alur material-first.

Kontrak utama:

- Public auth: `/api/v1/auth/*`
- User app: `/api/v1/app/*`
- Admin back-office: `/api/v1/admin/*`
- Operational/internal: health, readiness, metrics, worker.

## Arah Produk Baru

MVP tidak lagi berpusat pada struktur:

```text
Level -> Course -> Unit -> Lesson
```

MVP berpusat pada:

```text
Material PDF -> AI Quiz -> Attempt -> Pass/Fail -> EXP -> Leaderboard
```

Admin cukup upload PDF dan publish materi. User memilih materi, mengatur tingkat
kesulitan, generate quiz, lalu mengerjakan.

## Fitur MVP

1. Auth: login/register admin dan user.
2. Admin Materials: upload, edit metadata, preview extracted text, publish/unpublish, archive.
3. User Materials: list materi published dengan status locked/unlocked/completed.
4. PDF Viewer: stream file PDF untuk user.
5. AI Quiz Generation: generate soal dari PDF berdasarkan difficulty user.
6. Quiz Session: user mengerjakan soal pilihan ganda.
7. Scoring: backend menghitung benar/salah dan final score.
8. Pass/Fail Gate:
   - Lulus jika score >= passing_score.
   - Gagal jika score < passing_score.
9. EXP:
   - Hanya diberikan jika lulus.
   - Attempt gagal tidak memberi EXP.
10. Progress Locking:
   - Materi berikutnya terbuka hanya jika materi sebelumnya completed.
11. Attempt History.
12. Leaderboard berdasarkan EXP valid.
13. Admin Users: tambah, edit, deactivate user.

## Fitur Yang Tidak Menjadi MVP

- Admin curriculum kompleks.
- Level/course/unit/lesson management.
- Lesson section manual.
- Bank soal manual.
- Review soal manual admin.
- SRS.
- TTS/listening.
- Writing/handwriting.
- JLPT simulation bebas.

## Catatan Implementasi

Model dan endpoint curriculum lama sudah tidak menjadi kontrak MVP. Frontend harus
memakai endpoint material-first di `/api/v1/app/materials` dan
`/api/v1/app/quiz-sessions/*`.

## Auth

Semua endpoint `/api/v1/app/*` dan `/api/v1/admin/*` memakai:

```text
Authorization: Bearer <access_token>
```

Jika token tidak dikirim atau tidak valid, response yang benar adalah `401`.
