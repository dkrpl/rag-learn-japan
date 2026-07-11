# Changelog

Semua perubahan penting pada proyek Nihongo Learn Backend API akan didokumentasikan pada file ini.

Format changelog ini merujuk pada prinsip [Keep a Changelog](https://keepachangelog.com/id/1.0.0/), dan proyek ini menganut [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0-MVP] - 2026-07-11

Rilis utama pertama untuk Nihongo Learn MVP.

### Added
- **Authentication & RBAC**: Endpoint registrasi, login, logout, refresh token, revocation token, list/manage account admin, forgot/reset password. (Gate 1)
- **Curriculum & Content Management**: Pengelolaan Hierarki (Level, Course, Unit, Lesson), Lesson Section, Vocabulary, Kanji, Grammar, Reading, dan Audio Upload/Storage dengan sistem publikasi/draf. (Gate 2)
- **Question Bank**: Workflow khusus untuk bank soal (Draft -> In Review -> Published), pelacakan versi, import soal, dan perlindungan *answer-leakage*. (Gate 3)
- **Learning Engine End-to-End**: Sesi latihan berbasis JSON (multiple choice, fill in the blank, match, dsb.) dengan keamanan dan sistem skor. (Gate 4)
- **Progress, Mastery & SRS Engine**: Ledger idempotency, pelacakan *Mistake Book*, jadwal pengulangan berkala (*Spaced Repetition System*), serta penghitungan XP dan Streak menggunakan batas zona waktu UTC. (Gate 5)
- **Durable AI & TTS Pipelines**: Worker tangguh berbasis redis untuk membuat kerangka bank soal dari OpenAI/Gemini (mock) dan konversi audio (mock), dilengkapi _retry_ dan _observability_. (Gate 6)
- **JLPT N5 Simulation Engine**: Simulasi JLPT yang mencakup pemisahan Seksi Ujian, penegakan pengatur waktu server (*Timer Enforcement*), penilaian akhir per-seksi, serta status kelulusan (MVP). (Gate 9)
- **Observability & QA Tools**: Middleware pencatatan waktu pemrosesan (*Response Time*), Seeders JLPT N5 (Gate 7), 100% tes dasar meliputi uji injeksi, kebocoran data, _expired token_, dan RBAC. (Gate 8 & 10)

### Changed
- Refaktorisasi masif untuk menstabilkan kontrak JSON (tidak diserialisasi ganda sebagai string) dan menggunakan arsitektur skema tunggal (Gate 0).

### Security
- Menambahkan **Rate Limiting** untuk Endpoint Login dan Pembuatan Soal berbasis IP dan User ID.
- Pemeriksaan izin ekstensif untuk rute **Admin** dan **Reviewer**.

## [0.1.0-alpha] - 2026-06-XX

Rilis pengembangan internal dan penyusunan prototipe (*Out of Scope MVP Changelog*).
