# Tahap 6 - Learning Engine

Sumber tahap: Sprint 5 - Learning engine.

## 1. Ringkasan Produk

Tahap ini membangun engine sesi belajar. Engine ini memilih soal published dari question bank, membuat sesi latihan atau ujian, menerima jawaban learner, memeriksa jawaban berdasarkan aturan pasti, menyimpan hasil, dan menyiapkan data untuk progress engine.

Learning engine adalah pusat pengalaman learner. AI tidak digunakan untuk memeriksa jawaban MVP karena tipe soal MVP dapat dinilai deterministik.

## 2. Tujuan Tahap

- Menyediakan pembuatan learning session.
- Memilih soal dasar sesuai lesson, unit, skill, difficulty, history, atau latihan harian, serta menyediakan extension point untuk adaptive selection Tahap 7.
- Menyimpan daftar soal session.
- Menerima submit answer.
- Menilai jawaban untuk tipe soal MVP.
- Mendukung practice mode dan exam mode.
- Menyelesaikan session dan membuat ringkasan hasil.

## 3. Scope

- Model `learning_sessions`.
- Model `learning_session_questions`.
- Penyimpanan jawaban pada `learning_session_questions` sesuai keputusan denormalisasi MVP.
- Session creation.
- Question selection.
- Option randomization.
- Submit answer.
- Scoring.
- Feedback.
- Complete session.
- Cancel session secara idempotent tanpa hard delete history.
- Session expired.
- Integration point untuk progress update.

## 4. Non-Scope

- Perhitungan mastery final.
- SRS schedule final.
- XP dan streak final.
- Simulasi JLPT.
- AI grading untuk jawaban bebas.

## 5. Functional Requirements

- FR-019: Pembuatan sesi latihan.
- FR-020: Penyimpanan jawaban.
- FR-021: Pemeriksaan jawaban.
- FR-022: Mode latihan dan ujian.

## 6. Mode Belajar

### Practice Mode

- Jawaban diperiksa langsung.
- Feedback ditampilkan langsung.
- Pembahasan dapat ditampilkan setelah menjawab.
- Cocok untuk lesson practice dan review.

### Exam Mode

- Jawaban tidak diperiksa langsung kepada learner.
- Pembahasan disembunyikan sampai session selesai.
- Hasil diberikan setelah complete.
- Urutan soal dan opsi dapat diacak.

## 7. Data Model

- `learning_sessions`: user, mode, lesson/unit, status, total, answered, correct, score, started, completed.
- `learning_session_questions`: session, question, question revision/snapshot, order number, option order, answered status, answer JSON, correct flag, score, response time, dan feedback.

Tidak ada tabel `user_answers` terpisah. Question revision/snapshot dibekukan ketika session dibuat agar perubahan question bank tidak mengubah session historis. Semua update jawaban, counter session, progress hook, dan ledger terkait harus berada dalam transaction boundary yang atomic.

## 8. Endpoint

- `POST /api/v1/learning-sessions`
- `GET /api/v1/learning-sessions/{session_id}`
- `GET /api/v1/learning-sessions/{session_id}/questions`
- `POST /api/v1/learning-sessions/{session_id}/answers`
- `POST /api/v1/learning-sessions/{session_id}/complete`
- `POST /api/v1/learning-sessions/{session_id}/cancel`

## 9. Aturan Pemilihan Soal

Backend memilih soal berdasarkan:

- Status `PUBLISHED`.
- Level pengguna.
- Lesson atau unit.
- Skill yang diminta.
- Riwayat soal.
- Tingkat kesulitan.
- Extension point untuk materi belum dikuasai, review, dan mistake yang diaktifkan pada Tahap 7.
- Soal yang belum terlalu sering muncul.

## 10. Aturan Scoring

- Multiple choice dinilai dengan ID pilihan.
- True/false dinilai dengan boolean.
- Matching dinilai dengan pasangan ID.
- Ordering dinilai dengan urutan ID.
- Cloze pilihan ganda dinilai dengan pilihan yang dipilih.
- Membaca kanji dinilai dengan option ID atau normalized reading sesuai kontrak question.
- Pemahaman bacaan dinilai dengan option ID yang ditentukan question.
- Listening multiple choice dan listening dengan gambar dinilai dengan option ID.
- Listening true/false dinilai dengan boolean canonical.
- AI tidak diperlukan untuk pemeriksaan jawaban MVP.

## 11. Security Dan Integrity

- Hanya soal published yang dapat masuk session.
- Question di luar session ditolak.
- Jawaban ganda ditolak.
- Answer key tidak dikirim sebelum diperlukan.
- Learner tidak dapat mengakses session user lain.
- Session expired tidak menerima jawaban baru.

## 12. Deliverable

- Learning session API.
- Deterministic scoring engine.
- Practice mode.
- Exam mode.
- Session summary.
- Data siap untuk progress engine.

## 13. Acceptance Criteria

- Learner dapat membuat session.
- Learner dapat menjawab soal session.
- Backend dapat menilai tipe soal MVP.
- Session complete menghasilkan ringkasan.
- Jawaban ganda ditolak.
- Kunci jawaban tidak bocor.
- Test seluruh tipe soal lulus.
