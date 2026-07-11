# Nihongo Learn API Overview

## Arsitektur Utama
Nihongo Learn API dibangun menggunakan **FastAPI** (Python) dengan **SQLAlchemy** sebagai ORM. 
Terdapat pemisahan akses rute API yang jelas:
- **Public API** (`/api/v1/...`): Digunakan oleh Learner (Mobile / Web App).
- **Admin API** (`/api/v1/admin/...`): Digunakan oleh Content Editor dan Administrator.

## Fitur Utama
1. **Curriculum Engine**: Hirarki Level > Course > Unit > Lesson > Section.
2. **Learning Engine**: Sesi belajar (*Practice* & *Exam*) dengan perlindungan kebocoran kunci jawaban.
3. **Progress Engine**: Sistem XP, Streak, Mastery (penguasaan skill), dan Mistake Book.
4. **AI & Audio Generator**: *Background workers* untuk membuat soal secara otomatis (Gemini API) dan membuat berkas MP3 dari narasi teks (TTS).

## Rate Limiting

- **Login**: `5 request / menit` per IP.
- **Generate AI Question**: `10 request / menit` per User ID.
Jika melebihi batas, server mengembalikan status `429 Too Many Requests`.

---

## Kebijakan Pembaruan Tak Terduga (Breaking Change Policy)

Proyek ini telah membekukan kontrak `v1` (Versi 1) per rilis MVP perdana. 
Pihak Frontend Engineering disarankan bertaut (*bind*) secara penuh pada path `/api/v1/`.

1. **Jaminan Stabilitas (*No Breaking Change on v1*)**: Parameter permintaan (Request Payload), Skema Envelop Respons, Parameter Autentikasi, dan Lokasi Endpoint pada `v1` **tidak akan diubah secara radikal** selama *lifecycle* versi ini. Field baru hanya akan ditambahkan secara eksklusif (opsional).
2. **Peralihan Versi (*Version Migration*)**: Jika terdapat perubahan drastis di kemudian hari (contoh, perubahan total arsitektur evaluasi ujian), backend akan memperkenalkan `v2` (contoh: `/api/v2/`) sementara membiarkan `v1` menyala dengan peringatan *Deprecation Header*.

## Autentikasi
Menggunakan **JWT (JSON Web Tokens)** Bearer Authentication. 
Silakan lihat panduan detailnya di `AUTHENTICATION.md`.

## Response Format
Hampir seluruh respons API dibungkus secara murni sesuai skema data (Kecuali yang ditolak akan mengembalikan format spesifik exception FastAPI / HttpException).
