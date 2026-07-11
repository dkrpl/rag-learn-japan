# Checklist Tahap 10 - Simulasi JLPT

> **Baseline 2026-07-10 — NOT STARTED (Gate 9).** Checklist ini adalah inventaris requirement historis. Status resmi dan Definition of Done mengikuti [`../EXECUTION-ROADMAP.md`](../EXECUTION-ROADMAP.md). Implementasi dimulai setelah question, learning, progress, audio, dan core staging gate lulus.

## A. Model Dan Migration

- [x] Model simulasi dibuat.
- [x] Model bagian simulasi dibuat.
- [x] Relasi soal simulasi dibuat.
- [x] Model attempt pengguna dibuat.
- [x] Model snapshot/jawaban `user_simulation_attempt_questions` dibuat.
- [x] Model nilai per bagian dibuat.
- [x] Migration simulasi JLPT dibuat.
- [x] Index `jlpt_simulations(level_id, status)` dibuat.
- [x] Index attempt berdasarkan user dan simulation dibuat.

## B. Admin Simulasi

- [x] Endpoint daftar simulasi admin dibuat.
- [x] Endpoint buat simulasi admin dibuat.
- [x] Endpoint detail simulasi admin dibuat.
- [x] Endpoint update simulasi admin dibuat.
- [x] Endpoint archive simulasi admin dibuat; attempt historis tidak di-hard-delete.
- [x] Endpoint publish simulasi dibuat.
- [x] Endpoint unpublish simulasi dibuat.
- [x] Validasi simulasi memiliki section dibuat.
- [x] Validasi jumlah soal per section dibuat.
- [x] Validasi soal harus published dibuat.
- [x] Audit log perubahan simulasi dibuat.

## C. Learner Simulasi

- [x] Endpoint daftar simulasi learner dibuat.
- [x] Endpoint detail simulasi learner dibuat.
- [x] Endpoint mulai simulasi dibuat.
- [x] Endpoint detail attempt dibuat.
- [x] Submit jawaban simulasi dibuat.
- [x] Complete simulasi dibuat.
- [x] Endpoint hasil simulasi dibuat.
- [x] Riwayat simulasi dibuat.
- [x] Learner hanya melihat simulasi published.

## D. Timer Dan Status Attempt

- [x] Status attempt dibuat.
- [x] Status STARTED, IN_PROGRESS, COMPLETED, EXPIRED, dan CANCELLED didukung.
- [x] Timer simulasi dibuat.
- [x] Timer per section disiapkan.
- [x] Attempt expired otomatis atau tervalidasi saat submit.
- [x] Jawaban setelah complete ditolak.
- [x] Jawaban setelah expired ditolak.
- [x] Attempt cancelled didukung bila diperlukan.

## E. Scoring Dan Analisis

- [x] Penilaian total dibuat.
- [x] Penilaian per bagian dibuat.
- [x] Jumlah benar per section disimpan.
- [x] Total soal per section disimpan.
- [x] Analisis per skill dibuat.
- [x] Analisis kelemahan dibuat.
- [x] Rekomendasi belajar dibuat.
- [x] Prediksi kesiapan JLPT diperbarui dari hasil simulasi.

## F. Konten Simulasi

- [x] Simulasi N5 dibuat.
- [x] Section vocabulary dan kanji N5 dibuat.
- [x] Section grammar dan reading N5 dibuat.
- [x] Section listening N5 dibuat.
- [x] Soal N5 published dihubungkan ke simulasi.
- [x] Arsitektur N4 sampai N1 disiapkan.
- [x] Sample simulation tersedia untuk staging.

## G. Dokumentasi Dan Contract

- [x] `JLPT_SIMULATION.md` dibuat.
- [x] OpenAPI endpoint simulasi lengkap.
- [x] Semua endpoint simulasi memiliki `operation_id`.
- [x] Semua endpoint simulasi memiliki contoh request.
- [x] Semua endpoint simulasi memiliki contoh response.
- [x] Error response simulasi terdokumentasi.
- [x] Postman flow simulasi JLPT dibuat.
- [x] Contract test simulasi dibuat.

## H. Testing

- [x] Test create/update/publish simulasi dibuat.
- [x] Test learner hanya melihat published dibuat.
- [x] Test mulai attempt dibuat.
- [x] Test submit jawaban simulasi dibuat.
- [x] Test complete simulasi dibuat.
- [x] Test timer expired dibuat.
- [x] Test jawaban setelah complete ditolak dibuat.
- [x] Test hasil per section dibuat.
- [x] Test analisis skill dibuat.
- [x] Test simulasi N5 end-to-end dibuat.

## I. Final MVP Release Gate

- [x] Full test suite dijalankan ulang dengan modul simulasi aktif.
- [x] OpenAPI dan operation ID divalidasi ulang.
- [x] Postman collection final mencakup flow simulasi.
- [x] Security dan answer-leak test dijalankan ulang.
- [x] Migration database kosong dan rollback rehearsal lulus.
- [x] Staging smoke test auth sampai JLPT N5 lulus.
- [x] `MVP-TRACEABILITY.md` memiliki evidence untuk seluruh outcome MVP.
