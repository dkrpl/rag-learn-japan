# Product Requirements Document (PRD) - Revisi Total MVP

## 1. Visi Produk

Nihongo Learn adalah platform evaluasi pemahaman Bahasa Jepang berbasis PDF dan AI.
Fokus MVP bukan manajemen kursus yang rumit, tetapi alur sederhana:

```text
Admin upload PDF
User pilih materi
User pilih tingkat kesulitan
AI generate soal
User mengerjakan
Backend validasi jawaban
Jika lulus: dapat EXP dan lanjut materi berikutnya
Jika tidak lulus: wajib mengulang dan tidak mendapat EXP
```

Tujuan utama revisi ini adalah menghapus kerumitan `Level -> Course -> Unit -> Lesson`
dari MVP. Materi PDF menjadi pusat sistem.

## 2. Persona Pengguna

### Admin

Admin bertugas menyediakan materi belajar.

Admin tidak perlu:

- Membuat course, unit, lesson secara manual.
- Membuat soal manual.
- Membuat kunci jawaban manual.
- Mengatur struktur kurikulum yang panjang.

Admin cukup:

- Upload PDF.
- Mengisi judul, deskripsi, level, kategori, dan urutan materi.
- Publish/unpublish materi.
- Melihat preview hasil ekstraksi teks PDF.

### User

User belajar dari materi PDF yang sudah dipublish admin.

User dapat:

- Melihat daftar materi.
- Membuka PDF.
- Memilih tingkat kesulitan soal.
- Generate soal dari PDF.
- Mengerjakan soal.
- Melihat hasil, feedback, dan penjelasan.
- Mendapat EXP hanya jika skor memenuhi batas lulus.
- Lanjut ke materi berikutnya hanya jika materi sebelumnya lulus.

## 3. Prinsip Produk

1. Material-first, bukan course-first.
2. Admin workflow harus pendek.
3. AI menghasilkan soal dari PDF, bukan dari bank soal manual.
4. User tidak bisa lanjut jika belum lulus.
5. EXP hanya diberikan saat lulus.
6. Attempt gagal tetap disimpan sebagai riwayat, tetapi tidak memberi EXP.
7. Leaderboard dihitung dari EXP valid, bukan dari total attempt.

## 4. Alur Admin

### 4.1 Upload Materi

Admin membuka halaman Materials dan upload PDF.

Input minimal:

- `title`
- `description` optional
- `level` misalnya `N5`, `N4`, `N3`, `N2`, `N1`
- `category` misalnya `reading`, `grammar`, `vocabulary`
- `sequence` untuk urutan materi
- `file` PDF

Backend melakukan:

- Validasi file PDF.
- Simpan file.
- Ekstrak teks PDF.
- Simpan metadata dan `extracted_text`.
- Default status: draft atau published sesuai pilihan admin.

### 4.2 Kelola Materi

Admin dapat:

- List materi.
- Detail materi.
- Edit metadata.
- Preview teks hasil ekstraksi.
- Publish materi.
- Unpublish materi.
- Delete/archive materi.

Delete disarankan soft delete/archive agar attempt user lama tidak rusak.

## 5. Alur User

### 5.1 Lihat Materi

User melihat daftar materi yang sudah published.

Daftar materi harus menampilkan:

- Judul.
- Level.
- Kategori.
- Status lock/unlock.
- Best score.
- Attempt count.
- Passing score.

Materi pertama terbuka secara default.
Materi berikutnya hanya terbuka jika materi sebelumnya sudah lulus.

### 5.2 Buka PDF

User membuka detail materi dan melihat PDF viewer.

User membaca materi terlebih dahulu sebelum generate soal.

### 5.3 Pilih Tingkat Kesulitan

Sebelum generate soal, user memilih difficulty:

- `easy`
- `medium`
- `hard`

Atau representasi angka:

- `1` easy
- `2` medium
- `3` hard

Frontend boleh menampilkan label sederhana, backend menyimpan nilai difficulty.

### 5.4 Generate Soal

User menekan tombol generate.

Backend membuat AI job berdasarkan:

- `material_id`
- `difficulty`
- `question_count`
- teks hasil ekstraksi PDF
- user yang meminta generate

Soal yang dibuat bersifat session/user scoped, bukan bank soal global untuk admin.

### 5.5 Mengerjakan Soal

User mengerjakan soal pilihan ganda.

MVP hanya wajib mendukung:

- Multiple choice.
- Reading comprehension.
- Feedback setelah submit.

### 5.6 Submit Dan Validasi

Backend menghitung:

- Total soal.
- Jawaban benar.
- Jawaban salah.
- Score persentase.
- Status lulus/gagal.

Passing score default:

```text
70
```

Passing score bisa dibuat configurable per material, tetapi MVP boleh memakai default global.

### 5.7 Reward Dan Locking

Jika `score >= passing_score`:

- Attempt status: `passed`.
- User mendapat EXP.
- Progress material menjadi `completed`.
- Materi berikutnya terbuka.
- Leaderboard naik.

Jika `score < passing_score`:

- Attempt status: `failed`.
- User tidak mendapat EXP.
- Progress material belum completed.
- Materi berikutnya tetap locked.
- User harus generate/mengerjakan ulang.

## 6. Gamifikasi

### 6.1 EXP

EXP hanya diberikan untuk attempt yang lulus.

Formula MVP:

```text
base_exp = 100
difficulty_multiplier:
  easy = 1.0
  medium = 1.25
  hard = 1.5

earned_exp = round(base_exp * difficulty_multiplier * (score / 100))
```

Jika gagal:

```text
earned_exp = 0
```

### 6.2 Leaderboard

Leaderboard dihitung dari total EXP valid.

Mode MVP:

- Global leaderboard.

Post-MVP:

- Weekly leaderboard.
- Monthly leaderboard.

## 7. Data Model Target

Model utama MVP:

### `materials`

Menyimpan PDF yang diupload admin.

Field target:

- `id`
- `title`
- `description`
- `level`
- `category`
- `sequence`
- `original_filename`
- `content_type`
- `file_size_bytes`
- `checksum`
- `storage_key`
- `page_count`
- `extracted_text`
- `is_published`
- `is_archived`
- `passing_score`
- `created_by_id`
- `created_at`
- `updated_at`

### `question_jobs`

Menyimpan proses generate AI.

Field target:

- `id`
- `material_id`
- `user_id`
- `difficulty`
- `question_count`
- `status`
- `error_message`
- `raw_response`
- `created_question_count`
- `created_at`
- `completed_at`

### `questions`

Menyimpan soal hasil AI.

Field target:

- `id`
- `job_id`
- `material_id`
- `user_id`
- `question_type`
- `prompt_json`
- `answer_key_json`
- `explanation_json`
- `difficulty`

### `practice_sessions`

Menyimpan sesi pengerjaan user.

Field target:

- `id`
- `user_id`
- `material_id`
- `job_id`
- `difficulty`
- `status`
- `total_questions`
- `answered_questions`
- `correct_answers`
- `final_score`
- `passing_score`
- `is_passed`
- `earned_exp`
- `started_at`
- `completed_at`

### `answers`

Menyimpan jawaban user.

Field target:

- `id`
- `session_id`
- `question_id`
- `user_answer_json`
- `is_correct`
- `score`
- `feedback`
- `answered_at`

### `user_material_progress`

Menyimpan progress per user per materi.

Field target:

- `id`
- `user_id`
- `material_id`
- `status`: `locked`, `unlocked`, `completed`
- `best_score`
- `last_score`
- `attempt_count`
- `completed_at`

### `xp_transactions`

Menyimpan riwayat EXP.

Field target:

- `id`
- `user_id`
- `material_id`
- `session_id`
- `amount`
- `reason`
- `created_at`

## 8. Endpoint Target MVP

### Auth

```http
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/refresh
POST /api/v1/auth/logout
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

## 9. Out Of Scope MVP

Fitur berikut tidak masuk MVP:

- Course, unit, lesson management kompleks.
- Lesson section manual.
- Bank soal manual admin.
- Review soal manual admin.
- SRS/spaced repetition.
- TTS/listening.
- Writing/handwriting.
- JLPT simulation bebas.
- Upload PDF oleh user.
- Payment/forum/chat tutor.

## 10. Catatan Rombak Backend

Backend saat ini masih course-first.
Rombak berikutnya harus mengubah kontrak menjadi material-first.

Prioritas rombak:

1. Jadikan `MaterialDocument` tidak wajib terkait `lesson_id`.
2. Tambahkan metadata material: `level`, `category`, `sequence`, `passing_score`, `is_archived`.
3. Ganti `/app/catalog` menjadi `/app/materials`.
4. Ganti flow lesson-based menjadi material-based.
5. Pastikan EXP hanya diberikan jika session passed.
6. Pastikan unlock materi berikutnya dihitung dari `user_material_progress`.
7. Sembunyikan atau hapus endpoint admin curriculum dari Swagger dan frontend.
