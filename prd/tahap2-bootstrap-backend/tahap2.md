# Tahap 2 - Bootstrap Backend

Sumber tahap: Sprint 1 - Bootstrap backend.

## 1. Ringkasan Produk

Tahap ini membangun fondasi teknis Nihongo Learning API sebagai layanan backend independen. Fokusnya adalah membuat aplikasi FastAPI yang modular, bisa dijalankan lokal, terkoneksi ke MySQL, memiliki migration, logging, error handling, health check, readiness check, dan dokumentasi OpenAPI dasar.

Tahap ini belum membangun fitur belajar, tetapi menjadi dasar semua modul backend dan engine berikutnya.

## 2. Tujuan Tahap

- Menyiapkan struktur project FastAPI.
- Menyiapkan konfigurasi environment.
- Menyiapkan koneksi database MySQL.
- Menyiapkan SQLAlchemy dan Alembic.
- Menyiapkan environment Python (venv) dan instalasi dependensi.
- Menyediakan standar error, response envelope, logging, dan request ID.
- Menyediakan endpoint system dasar.

## 3. Scope

- Project structure backend.
- `app/main.py`.
- Router utama.
- Prefix `/api/v1`.
- OpenAPI metadata.
- Global exception handler.
- Response envelope.
- Request ID middleware.
- CORS.
- Health check dan readiness check.
- MySQL connection.
- Alembic migration.
- File requirements.txt untuk manajemen dependensi.
- Redis local disiapkan sebagai dependency worker tahap berikutnya.
- Pytest, Ruff, dan pre-commit.

## 4. Non-Scope

- Auth dan user.
- CRUD curriculum.
- Question bank.
- AI worker.
- TTS worker.
- Learning engine.
- Simulasi JLPT.

## 5. Functional Requirements Terkait

Tahap ini mendukung semua FR sebagai fondasi teknis, tetapi belum menyelesaikan FR bisnis tertentu. Endpoint system dan standar API menjadi prasyarat untuk FR-001 sampai FR-031.

## 6. Nonfunctional Requirements

- REST API.
- JSON request dan response.
- Prefix `/api/v1`.
- Semua waktu disimpan UTC.
- Database MySQL menggunakan `utf8mb4`.
- Struktur modular.
- Business logic tidak berada di router.
- Provider dan service mudah diganti.
- Endpoint biasa menargetkan baseline awal p95 di bawah 500 ms pada beban development yang disepakati; profil beban dan threshold staging final dibekukan sebelum Gate 8.

## 7. Data Dan Database

Fondasi database yang dibuat:

- SQLAlchemy engine/session.
- Base model.
- Timestamp mixin.
- Public UUID mixin.
- Alembic environment.
- Migration pertama.
- Koneksi MySQL untuk local dan testing.

Migration production tidak boleh menggunakan `create_all()`.

## 8. Endpoint

- `GET /health`
- `GET /ready`
- `GET /api/v1/meta`
- `GET /docs`
- `GET /redoc`
- `GET /openapi.json`

## 9. Aturan Bisnis

- `health` hanya memeriksa proses API hidup.
- `ready` memeriksa dependency penting seperti database.
- Error response harus mengikuti envelope standar.
- Request ID harus tersedia untuk tracing log.
- CORS menggunakan allowlist dari environment.

## 10. Deliverable

- Backend FastAPI bisa dijalankan lokal.
- Petunjuk instalasi lokal untuk MySQL dan Redis serta panduan menjalankannya. Redis merupakan prerequisite durable worker Gate 6, walaupun proses worker belum diimplementasikan pada tahap bootstrap.
- Migration awal dapat dijalankan.
- Health/readiness tersedia.
- Swagger/ReDoc/OpenAPI aktif.
- Lint dan test dasar berjalan.

## 11. Acceptance Criteria

- Aplikasi berjalan dari local command (uvicorn).
- `GET /health` sukses tanpa database.
- `GET /ready` sukses ketika database tersedia dan gagal terkontrol saat database tidak tersedia.
- Alembic dapat membangun database kosong.
- OpenAPI dapat diakses.
- Test dasar dan lint lulus.
