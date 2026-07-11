# Checklist Tahap 6 - Learning Engine

> **Baseline 2026-07-10 — PARTIAL (Gate 4).** Checklist ini adalah inventaris requirement historis. Status resmi dan Definition of Done mengikuti [`../EXECUTION-ROADMAP.md`](../EXECUTION-ROADMAP.md). Satu learning flow belum DONE sampai learner dapat menerima soal aman, menjawab, dan complete end-to-end.

## A. Model Session

- [x] Model learning session dibuat.
- [x] Model session question dibuat.
- [x] Question revision/snapshot dibekukan pada session question.
- [x] Field jawaban, skor, dan response time digabung pada `learning_session_questions`.
- [x] Migration learning session dibuat.
- [x] Status session dibuat.
- [x] Session expired dibuat.

## B. Session Creation

- [x] Endpoint membuat session dibuat.
- [x] Endpoint learner-safe daftar soal session dibuat.
- [x] Pemilihan soal berdasarkan lesson dibuat.
- [x] Pemilihan soal berdasarkan unit dibuat.
- [x] Pemilihan soal berdasarkan skill dibuat.
- [x] Pemilihan soal berdasarkan review disiapkan.
- [x] Pemilihan soal berdasarkan mistake disiapkan.
- [x] Soal published saja yang dipilih.
- [x] Soal yang terlalu sering muncul dapat dikurangi.
- [x] Randomisasi opsi dibuat.

## C. Submit Answer Dan Scoring

- [x] Submit answer dibuat.
- [x] Validasi question bagian dari session dibuat.
- [x] Pencegahan jawaban ganda dibuat.
- [x] Penyimpanan response time dibuat.
- [x] Scoring multiple choice dibuat.
- [x] Scoring true/false dibuat.
- [x] Scoring matching dibuat.
- [x] Scoring ordering dibuat.
- [x] Scoring cloze pilihan ganda dibuat.
- [x] Scoring membaca kanji dibuat.
- [x] Scoring pemahaman bacaan dibuat.
- [x] Scoring listening multiple choice dibuat.
- [x] Scoring listening true/false dibuat.
- [x] Scoring listening dengan gambar dibuat.
- [x] Feedback latihan dibuat.

## D. Mode Practice Dan Exam

- [x] Mode latihan dibuat.
- [x] Mode ujian dibuat.
- [x] Pembahasan langsung hanya untuk practice mode.
- [x] Hasil akhir exam ditampilkan setelah complete.
- [x] Complete session dibuat.
- [x] Ringkasan hasil dibuat.
- [x] Cancel session idempotent dibuat; session historis tidak di-hard-delete.

## E. Integrasi Progress

- [x] Event atau service update progress disiapkan.
- [x] Event atau service update mastery disiapkan.
- [x] Data yang dibutuhkan tahap progress tersimpan.

## F. Testing

- [x] Test membuat session dibuat.
- [x] Test pemilihan soal published dibuat.
- [x] Test jawaban question di luar session dibuat.
- [x] Test jawaban ganda dibuat.
- [x] Test seluruh tipe soal dibuat.
- [x] Test practice feedback dibuat.
- [x] Test exam completion dibuat.
