# Checklist Tahap 5 - Question Bank

> **Baseline 2026-07-10 — PARTIAL (Gate 3).** Checklist ini adalah inventaris requirement historis. Status resmi dan Definition of Done mengikuti [`../EXECUTION-ROADMAP.md`](../EXECUTION-ROADMAP.md). Workflow dan keamanan learner harus dibuktikan dengan transition serta leak test.

## A. Model Dan Schema

- [x] Enum question type dibuat.
- [x] Enum skill dibuat.
- [x] Enum question status dibuat.
- [x] Model question dibuat.
- [x] Kontrak objek `options` di `prompt_json` dibuat untuk setiap tipe soal; tidak ada model/tabel `question_options`.
- [x] Model question review dibuat.
- [x] Schema internal dibuat.
- [x] Schema learner dibuat.
- [x] Answer key dipisahkan dari schema learner.
- [x] Field `is_correct` tidak dikirim kepada learner.
- [x] Model `question_revisions` dan snapshot version history dibuat.

## B. CRUD Dan Filter

- [x] CRUD soal manual dibuat.
- [x] Filter lesson dibuat.
- [x] Filter skill dibuat.
- [x] Filter difficulty dibuat.
- [x] Filter status dibuat.
- [x] Pagination dibuat.
- [x] Detail soal admin dibuat.
- [x] Archive soal dibuat; hard delete tidak digunakan untuk soal yang sudah direferensikan.

## C. Review Workflow

- [x] Submit review dibuat.
- [x] Status `IN_REVIEW` dan transition submit-review dibuat.
- [x] Approve dibuat.
- [x] Reject dibuat.
- [x] Request revision dibuat.
- [x] Publish dibuat.
- [x] Unpublish dibuat.
- [x] Catatan review disimpan.
- [x] Riwayat perubahan disimpan.
- [x] Reviewer dapat melihat sumber materi.

## D. Validasi Soal

- [x] Validasi tipe soal dibuat.
- [x] Validasi opsi duplikat dibuat.
- [x] Validasi jawaban benar dibuat.
- [x] Validasi jumlah opsi dibuat.
- [x] Validasi lesson sumber dibuat.
- [x] Validasi difficulty dibuat.
- [x] Validasi pembahasan dibuat.
- [x] Validasi schema per tipe soal dibuat.
- [x] Validasi audio wajib untuk soal listening dibuat.
- [x] Duplicate detection dibuat.
- [x] Soal belum approved tidak dapat publish.
- [x] Soal tidak dapat auto-publish.

## E. Dokumentasi Question Type

- [x] Kontrak multiple choice dibuat.
- [x] Kontrak cloze pilihan ganda dibuat.
- [x] Kontrak true/false dibuat.
- [x] Kontrak listening multiple choice dibuat.
- [x] Kontrak listening true/false dibuat.
- [x] Kontrak listening dengan gambar dibuat.
- [x] Kontrak matching dibuat.
- [x] Kontrak ordering dibuat.
- [x] Kontrak membaca kanji dibuat.
- [x] Kontrak pemahaman bacaan dibuat.
- [x] Contoh request dan response admin question dibuat.
- [x] Contoh response learner question dibuat.

## F. Testing Dan Security

- [x] Test kebocoran jawaban dibuat.
- [x] Test publish tanpa approval dibuat.
- [x] Test filter soal dibuat.
- [x] Test pagination soal dibuat.
- [x] Test review workflow dibuat.
- [x] Test validasi schema tipe soal dibuat.
- [x] Admin endpoint diuji dengan learner token.
