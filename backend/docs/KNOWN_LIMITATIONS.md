# Known Limitations

## AI Provider

- Generator soal bisa berjalan dengan provider AI yang dikonfigurasi lewat environment.
- Untuk mode production, set `AI_PROVIDER=gemini` dan `GEMINI_API_KEY`.
- Jika provider belum aktif, backend memakai fallback generator sederhana dari teks PDF agar flow MVP tetap bisa dites.

## PDF

- PDF harus berbasis teks. PDF scan/gambar akan ditolak dengan pesan bahwa OCR belum tersedia.
- Soal hanya dibuat dari teks hasil ekstraksi PDF.

## Cakupan MVP

Fitur berikut sengaja tidak menjadi bagian MVP saat ini:

- Admin curriculum kompleks (`Level -> Course -> Unit -> Lesson`).
- Lesson section manual.
- Audio/TTS/listening.
- JLPT simulation.
- SRS/review schedule dan mistake book khusus.
- Manual question review workflow.
- Bank vocabulary/kanji/grammar terpisah.
- Upload materi oleh learner.
- Payment, forum, chat tutor, speaking evaluation, dan handwriting.

## Aturan Progress

- User hanya mendapat EXP jika skor memenuhi passing score.
- Attempt gagal tetap disimpan, tetapi `earned_exp = 0`.
- Materi berikutnya tetap locked jika user belum lulus materi saat ini.
- User harus mengulang quiz pada materi yang gagal.

## Catatan Backend

- Endpoint course/lesson lama sudah bukan kontrak MVP.
- Kontrak aktif mengikuti material-first MVP di `prd-revisi/01-prd-revisi-mvp.md`.
- `ENDPOINTS.md` digenerate dari OpenAPI backend saat ini.
