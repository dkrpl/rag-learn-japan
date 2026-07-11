# Checklist Tahap 2 - Bootstrap Backend

> **Baseline 2026-07-10 — BLOCKED (Gate 0).** Checklist ini adalah inventaris requirement historis. Status resmi dan Definition of Done mengikuti [`../EXECUTION-ROADMAP.md`](../EXECUTION-ROADMAP.md). Tanda `[x]` historis belum berarti tervalidasi pada clean environment.

## A. Repository Dan Tooling

- [x] `.gitignore` dibuat.
- [x] `pyproject.toml` dibuat.
- [x] `.env.example` dibuat.
- [x] Pre-commit hook dikonfigurasi.
- [x] Ruff dikonfigurasi.
- [x] Pytest dikonfigurasi.
- [x] Struktur folder aplikasi dibuat.
- [x] Struktur folder test dibuat.

## B. Fondasi FastAPI

- [x] `app/main.py` dibuat.
- [x] API prefix `/api/v1` dibuat.
- [x] Router utama dibuat.
- [x] Metadata OpenAPI dibuat.
- [x] Tag OpenAPI awal dibuat.
- [x] Swagger tersedia di `/docs`.
- [x] ReDoc tersedia di `/redoc`.
- [x] OpenAPI tersedia di `/openapi.json`.
- [x] Global exception handler dibuat.
- [x] Response envelope dibuat.
- [x] Request ID middleware dibuat.
- [x] CORS dikonfigurasi.
- [x] Health check dibuat.
- [x] Readiness check dibuat.
- [x] Endpoint `/api/v1/meta` dibuat.

## C. Database Dan Migration

- [x] MySQL dijalankan.
- [x] Database menggunakan `utf8mb4`.
- [x] SQLAlchemy dikonfigurasi.
- [x] Session database dibuat.
- [x] Base model dibuat.
- [x] Timestamp mixin dibuat.
- [x] Public UUID mixin dibuat.
- [x] Alembic dikonfigurasi.
- [x] Migration pertama dibuat sebagai artefak awal; eksekusi pada database kosong belum terverifikasi.
- [x] Migration dapat dijalankan pada database kosong.
- [x] Index penting awal disiapkan.

## D. Setup Instalasi Lokal

- [x] File konfigurasi dependensi (requirements.txt / sejenisnya) dibuat.
- [x] Panduan instalasi dan penggunaan virtual environment (venv) disertakan di README.
- [x] Panduan setup MySQL (native/XAMPP) disertakan.
- [x] Aplikasi berjalan sukses di environment lokal.
- [x] Service Redis disiapkan untuk kebutuhan worker berikutnya.
- [x] Environment variable dibaca dari konfigurasi aplikasi.

## E. Logging Dan Observability Awal

- [x] Structured logging dibuat dan diverifikasi.
- [x] Request ID dicatat pada structured log.
- [x] Error code konsisten disiapkan dan diuji.
- [x] Response time dapat dicatat.
- [x] Error production tidak menampilkan stack trace mentah.

## F. Testing Dan Quality Gate

- [x] Unit test health check dibuat.
- [x] Unit test readiness check dibuat.
- [x] Integration test database awal dibuat.
- [x] Lint berjalan lokal.
- [x] Test berjalan lokal.
