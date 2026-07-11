# Checklist Tahap 4 - Curriculum Dan Content

> **Baseline 2026-07-10 — PARTIAL (Gate 2).** Checklist ini adalah inventaris requirement historis. Status resmi dan Definition of Done mengikuti [`../EXECUTION-ROADMAP.md`](../EXECUTION-ROADMAP.md). CRUD berarti create/read/update/delete atau archive yang benar-benar diuji, bukan hanya create/list.

## A. Kurikulum

- [x] Model level dibuat.
- [x] Model course dibuat.
- [x] Model unit dibuat.
- [x] Model lesson dibuat.
- [x] Model lesson section dibuat.
- [x] CRUD admin level dibuat.
- [x] CRUD admin course dibuat.
- [x] CRUD admin unit dibuat.
- [x] CRUD admin lesson dibuat.
- [x] CRUD admin lesson section dibuat.
- [x] Publish lesson dibuat.
- [x] Unpublish lesson dibuat.
- [x] Endpoint learner level dibuat.
- [x] Endpoint learner course dibuat.
- [x] Endpoint learner unit dibuat.
- [x] Endpoint learner lesson dibuat.
- [x] Endpoint lesson content dibuat.
- [x] Urutan konten didukung.
- [x] Status draft dan published didukung.
- [x] Struktur level siap untuk N5, N4, N3, N2, dan N1.
- [x] Syarat pembukaan level/unit/lesson didukung.
- [x] Validasi lesson kosong dibuat.
- [x] Seed curriculum dasar dibuat.

## B. Materi Pembelajaran

- [x] Model vocabulary dibuat.
- [x] Model kanji dibuat.
- [x] Model grammar point dibuat.
- [x] Model example sentence dibuat.
- [x] Model reading dibuat.
- [x] Model audio asset dibuat.
- [x] Relasi lesson-vocabulary dibuat.
- [x] Relasi lesson-kanji dibuat.
- [x] Relasi lesson-grammar dibuat.
- [x] CRUD vocabulary dibuat.
- [x] CRUD kanji dibuat.
- [x] CRUD grammar dibuat.
- [x] CRUD example sentence dibuat.
- [x] CRUD reading dibuat.
- [x] CRUD audio metadata dibuat.
- [x] Upload audio dibuat.
- [x] Validasi file audio dibuat.
- [x] Endpoint learner `GET /api/v1/audio/{audio_id}` dibuat dengan URL playable.
- [x] Visibility transkrip audio dibuat dan diuji.
- [x] Import content melalui JSON atau CSV dibuat.
- [x] Script seed contoh materi dibuat.

## C. Konten MVP

- [x] Struktur dasar Bahasa Jepang selesai.
- [x] Struktur JLPT N5 inti selesai.
- [x] Struktur placeholder N4 sampai N1 dapat dibuat tanpa migrasi besar.
- [x] Minimal 300 kosakata tersedia.
- [x] Minimal 80 kanji tersedia.
- [x] Minimal 30 grammar point tersedia.
- [x] Minimal 150 contoh kalimat tersedia.
- [x] Minimal 30 bacaan tersedia.
- [x] Minimal 50 audio tersedia.
- [x] Setiap lesson memiliki tujuan belajar.
- [x] Setiap lesson memiliki materi.
- [x] Setiap audio memiliki transkrip.
- [x] Seluruh konten Jepang diverifikasi content editor atau administrator sebelum lesson dipublish.

## D. Keamanan Dan Validasi

- [x] Learner tidak dapat melihat draft curriculum.
- [x] Learner tidak dapat melihat draft materi.
- [x] Endpoint admin dilindungi role content editor atau administrator.
- [x] Input teks Jepang tervalidasi dan tersimpan benar.
- [x] File audio tervalidasi berdasarkan MIME type dan ukuran.

## E. Dokumentasi Dan Test

- [x] Semua endpoint curriculum memiliki schema request/response.
- [x] Semua endpoint content memiliki schema request/response.
- [x] Contoh response lesson content dibuat.
- [x] Test CRUD curriculum dibuat.
- [x] Test CRUD materi dibuat.
- [x] Test visibility draft/published dibuat.
- [x] Test import konten dibuat.
