# Tahap 7 - Progress Dan Review

Sumber tahap: Sprint 6 - Progress dan review.

## 1. Ringkasan Produk

Tahap ini membangun adaptive learning engine. Setelah learner mengerjakan session, backend harus memperbarui progress, mastery, jadwal review, mistake book, XP, streak, dashboard, dan prediksi kesiapan JLPT.

Tujuan akhirnya adalah membuat belajar tidak hanya berupa daftar materi, tetapi sistem yang tahu apa yang sudah dikuasai, apa yang perlu diulang, dan latihan apa yang disarankan berikutnya.

## 2. Tujuan Tahap

- Menyimpan progress lesson.
- Menghitung mastery per entitas belajar.
- Membuat SRS/review schedule.
- Menyimpan mistake book.
- Mencatat XP dalam ledger.
- Menghitung streak berdasarkan timezone.
- Menyediakan dashboard progress.
- Menyediakan recommendation rule.
- Menyediakan prediksi kesiapan JLPT.

## 3. Scope

- Lesson progress.
- Mastery.
- Review due.
- Review session.
- Aktivasi adaptive question selection untuk review due, mistake, dan mastery lemah melalui extension point learning engine.
- Mistake book.
- XP transaction.
- Streak.
- Dashboard overview.
- Skill summary.
- Activity progress.
- Recommendation.
- Admin analytics dasar.

## 4. Non-Scope

- Gamification leaderboard global.
- Social sharing.
- Payment-related progress.
- AI tutor bebas.
- Simulasi JLPT attempt detail, karena ada di tahap 10.

## 5. Functional Requirements

- FR-023: Progress lesson.
- FR-024: Mastery.
- FR-025: SRS dan review.
- FR-026: Buku kesalahan.
- FR-027: XP.
- FR-028: Streak.
- FR-029: Dashboard progres.

## 6. Data Model

- `user_lesson_progress`
- `user_masteries`
- `user_mistakes`
- `xp_transactions`
- `review_schedules`
- Kolom `current_streak`, `longest_streak`, dan `last_activity_date` pada `users`.

Tidak ada tabel `user_streaks` terpisah. Perhitungan streak tetap menjadi service domain yang menggunakan timezone user dan memperbarui kolom denormalisasi pada tabel `users`.

## 7. Endpoint

- `GET /api/v1/reviews/summary`
- `GET /api/v1/reviews/due`
- `POST /api/v1/reviews/sessions`
- `GET /api/v1/progress/overview`
- `GET /api/v1/progress/skills`
- `GET /api/v1/progress/lessons`
- `GET /api/v1/progress/lessons/{lesson_id}`
- `GET /api/v1/progress/activity`
- `GET /api/v1/progress/mistakes`
- `GET /api/v1/progress/mistakes/{question_id}`
- `GET /api/v1/admin/analytics/overview`
- `GET /api/v1/admin/analytics/lessons`
- `GET /api/v1/admin/analytics/users`

## 8. Aturan SRS Awal

- Jawaban pertama benar: review 1 hari.
- Benar berikutnya: review 3 hari.
- Benar berikutnya: review 7 hari.
- Benar berikutnya: review 14 hari.
- Benar berikutnya: review 30 hari.
- Jawaban salah: kembali ke interval pendek.
- Interval harus dapat dikonfigurasi.

## 9. Aturan Progress

- Lesson berubah dari belum mulai, sedang dipelajari, sampai selesai.
- Best score dan last score disimpan.
- Attempt count bertambah saat session selesai.
- Mastery menggunakan rentang 0 sampai 100.
- Jawaban benar menaikkan mastery.
- Jawaban salah menurunkan atau menahan mastery sesuai rule.
- Mistake book dibuat dari jawaban salah.
- XP selalu dicatat sebagai ledger transaction.
- Streak dihitung berdasarkan timezone user.

## 10. Dashboard Data

Dashboard menyediakan:

- Level aktif.
- Course aktif.
- Lesson terakhir.
- Jumlah lesson selesai.
- Total waktu belajar.
- Akurasi.
- XP.
- Streak.
- Review jatuh tempo.
- Skill terkuat.
- Skill terlemah.
- Rekomendasi latihan.
- Prediksi kesiapan JLPT.

## 11. Deliverable

- Progress service.
- Mastery service.
- Review scheduler.
- Mistake book API.
- XP ledger.
- Streak service.
- Dashboard API.
- Recommendation rule.
- Prediksi kesiapan JLPT awal.

## 12. Acceptance Criteria

- Progress berubah setelah session selesai.
- Mastery berubah setelah jawaban.
- Review due muncul sesuai jadwal.
- Mistake book menampilkan soal salah dan pembahasan.
- XP tercatat di ledger.
- Streak menghormati timezone.
- Dashboard menampilkan overview dan skill summary.
- Test perubahan mastery dan timezone lulus.
