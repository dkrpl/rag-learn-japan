# Known Limitations

## AI Provider

- Generator soal bisa berjalan dengan provider AI yang dikonfigurasi lewat environment.
- Untuk mode production, set `AI_PROVIDER=gemini` dan `GEMINI_API_KEY`.
- Jika provider belum aktif, job AI dapat gagal dan harus ditampilkan frontend sebagai status job biasa.

## PDF

- PDF harus berbasis teks. PDF scan/gambar akan ditolak dengan pesan bahwa OCR belum tersedia.
- Soal hanya dibuat dari teks hasil ekstraksi PDF.

## Cakupan MVP

Fitur berikut sengaja tidak menjadi bagian MVP saat ini:

- Audio/TTS/listening.
- JLPT simulation.
- SRS/review schedule dan mistake book khusus.
- Manual question review workflow.
- Bank vocabulary/kanji/grammar terpisah.
- Upload materi oleh learner.
- Payment, forum, chat tutor, speaking evaluation, dan handwriting.
