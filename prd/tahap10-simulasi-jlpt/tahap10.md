# Tahap 10 - Simulasi JLPT

Sumber tahap: Sprint 9 - Simulasi JLPT.

## 1. Ringkasan Produk

Tahap ini membangun backend simulation engine untuk JLPT. Learner dapat memilih simulasi, memulai attempt, mengerjakan section dengan timer, submit jawaban, complete attempt, melihat hasil, melihat riwayat, dan mendapat analisis kelemahan.

MVP wajib menyediakan simulasi JLPT N5. Struktur data dan API harus siap untuk N4, N3, N2, dan N1.

## 2. Tujuan Tahap

- Menyediakan struktur ujian JLPT.
- Menyediakan section ujian: vocabulary/kanji, grammar/reading, listening.
- Menyediakan timer simulasi.
- Menyediakan attempt pengguna.
- Menyediakan submit answer simulasi.
- Menyediakan scoring total dan per section.
- Menyediakan hasil, riwayat, analisis skill, dan rekomendasi belajar.
- Menyediakan endpoint admin untuk konfigurasi simulasi.

## 3. Scope

- Model simulasi.
- Model section simulasi.
- Relasi soal simulasi.
- Model attempt.
- Model section score.
- Endpoint learner simulasi.
- Endpoint admin simulasi.
- Timer dan status attempt.
- Scoring.
- History.
- Skill analysis.
- Admin analytics JLPT.
- Dokumentasi `JLPT_SIMULATION.md`.

## 4. Non-Scope

- Konten lengkap N4 sampai N1.
- Simulasi resmi identik 100 persen dengan format lembaga penyelenggara.
- Proctoring.
- Anti-cheat lanjutan.
- Frontend timer UI.

## 5. Functional Requirements

- FR-030: Simulasi JLPT.
- FR-029: Dashboard progres dan prediksi kesiapan JLPT.
- FR-021: Pemeriksaan jawaban.
- FR-022: Mode ujian.
- FR-031: Audit log.

## 6. Struktur Ujian

Simulasi mendukung level:

- N5.
- N4.
- N3.
- N2.
- N1.

Section minimum:

- Vocabulary dan kanji.
- Grammar dan reading.
- Listening.

Setiap section memiliki `section_type`, `order_number`, `duration_minutes`, `question_count`, dan daftar question published.

## 7. Data Model

- `jlpt_simulations`
- `jlpt_simulation_sections`
- `jlpt_simulation_questions`
- `user_simulation_attempts`
- `user_simulation_attempt_questions`
- `user_simulation_section_scores`
- `questions`
- `user_masteries`
- `audit_logs`

`jlpt_simulation_questions` menyimpan template relasi soal untuk konfigurasi simulasi. Saat attempt dimulai, backend membuat snapshot urutan soal pada `user_simulation_attempt_questions`; tabel ini menyimpan section, question/version snapshot, answer JSON, correct flag, score, response time, dan answered status. Scoring menggunakan deterministic scoring service yang sama dengan learning engine, tetapi lifecycle attempt tetap terpisah dari learning session biasa.

## 8. Endpoint Learner

- `GET /api/v1/jlpt-simulations`
- `GET /api/v1/jlpt-simulations/{simulation_id}`
- `POST /api/v1/jlpt-simulations/{simulation_id}/attempts`
- `GET /api/v1/jlpt-simulation-attempts/{attempt_id}`
- `POST /api/v1/jlpt-simulation-attempts/{attempt_id}/answers`
- `POST /api/v1/jlpt-simulation-attempts/{attempt_id}/complete`
- `GET /api/v1/jlpt-simulation-attempts/{attempt_id}/result`
- `GET /api/v1/jlpt-simulation-attempts`
- `POST /api/v1/jlpt-simulation-attempts/{attempt_id}/cancel`

## 9. Endpoint Admin

- `GET /api/v1/admin/jlpt-simulations`
- `POST /api/v1/admin/jlpt-simulations`
- `GET /api/v1/admin/jlpt-simulations/{simulation_id}`
- `PATCH /api/v1/admin/jlpt-simulations/{simulation_id}`
- `POST /api/v1/admin/jlpt-simulations/{simulation_id}/archive`
- `POST /api/v1/admin/jlpt-simulations/{simulation_id}/publish`
- `POST /api/v1/admin/jlpt-simulations/{simulation_id}/unpublish`
- `GET /api/v1/admin/analytics/jlpt`

## 10. Aturan Bisnis

- Learner hanya melihat simulasi published.
- Simulasi hanya dapat published jika memiliki section dan jumlah soal sesuai konfigurasi.
- Soal simulasi harus berstatus `PUBLISHED`.
- Kunci jawaban tidak dikirim sebelum complete.
- Attempt yang complete, expired, atau cancelled tidak menerima jawaban baru.
- Timer dihitung dari `started_at` dan durasi simulasi/section.
- Hasil mencakup total score, section score, jumlah benar, jumlah soal, skill lemah, dan rekomendasi belajar.
- Detail attempt mengirim current section dan learner-safe question snapshot tanpa answer key.
- Complete dan cancel attempt harus idempotent.
- Hasil simulasi dapat mempengaruhi prediksi kesiapan JLPT.

## 11. Status Attempt

- `STARTED`
- `IN_PROGRESS`
- `COMPLETED`
- `EXPIRED`
- `CANCELLED`

## 12. Scoring Dan Analisis

- Score total dihitung dari seluruh jawaban.
- Score section disimpan terpisah.
- Analisis skill menggunakan mapping question skill.
- Skill lemah menghasilkan rekomendasi lesson/review.
- Riwayat attempt dapat dibandingkan untuk melihat peningkatan.

## 13. Deliverable

- Admin simulation API.
- Learner simulation API.
- Timer validation.
- Attempt lifecycle.
- Scoring total dan per section.
- Result dan history.
- JLPT analytics.
- Dokumentasi `JLPT_SIMULATION.md`.
- Simulasi N5 end-to-end.

## 14. Acceptance Criteria

- Simulasi JLPT N5 dapat dijalankan end-to-end.
- Learner hanya melihat simulasi published.
- Attempt expired menolak jawaban.
- Attempt completed menolak jawaban baru.
- Hasil tidak membocorkan kunci jawaban sebelum complete.
- Score per section tersimpan.
- Riwayat simulasi dapat dibaca learner.
- Admin analytics JLPT tersedia.
- Struktur data siap untuk N4 sampai N1.

## 15. Final MVP Release Gate

Setelah acceptance criteria Tahap 10 lulus, backend kembali menjalani final release hardening pada Gate 10 di `EXECUTION-ROADMAP.md`. OpenAPI, Postman, dokumentasi integrasi, full test suite, migration database kosong, security baseline, observability, staging smoke test, backup, dan rollback wajib diverifikasi ulang dengan endpoint simulasi sudah termasuk.
