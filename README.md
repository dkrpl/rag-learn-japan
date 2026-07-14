# RAG Learn Japan Workspace (Monorepo)

Proyek ini adalah repositori *monorepo* yang menaungi *backend* dan *frontend* untuk platform RAG Learn Japan.

- **`backend/`**: Dibangun dengan FastAPI, SQLAlchemy, dan MySQL.
- **`frontend/`**: Tempat untuk meletakkan aplikasi *client* (Web/Mobile).

## Prasyarat (Local Development Backend)

- Python 3.10 atau lebih baru
- MySQL Server (Native, XAMPP, atau Laragon) berjalan di port 3306

## Panduan Instalasi Lokal (Tanpa Docker)

### 1. Persiapan Database MySQL
1. Pastikan service MySQL sudah berjalan.
2. Buka klien database (seperti phpMyAdmin, DBeaver, atau MySQL CLI).
3. Buat database baru dengan nama `nihongo_db` dan charset `utf8mb4`:
   ```sql
   CREATE DATABASE nihongo_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

### 2. Setup Virtual Environment (venv)
Buka terminal/command prompt, masuk ke dalam folder `backend`, lalu buat *environment*:

**Windows:**
```bash
cd backend
python -m venv venv
venv\Scripts\activate
```

**Linux/macOS:**
```bash
python3 -m venv venv
source venv/bin/activate
```

### 3. Instalasi Dependensi
Setelah `venv` aktif (terlihat tulisan `(venv)` di terminal), install pustaka yang dibutuhkan:
```bash
pip install -r requirements.txt
```

### 4. Konfigurasi Environment Variable
1. Salin file template environment:
   ```bash
   cp .env.example .env
   ```
2. Buka file `.env`. Pastikan `DATABASE_URL` sesuai dengan *username* dan *password* MySQL Anda. 
   *(Contoh: jika menggunakan XAMPP, biasanya usernya `root` dan password kosong).*

### 5. Inisialisasi Database (Migration)
Untuk membuat tabel-tabel awal, jalankan Alembic:
```bash
alembic upgrade head
```

Untuk reset database lokal sekaligus mengisi data dummy siap pakai:
```bash
python import_db.py --yes
```

Script ini membaca `DATABASE_URL` dari `backend/.env`, menolak reset host MySQL non-local secara default, menjalankan migration, lalu mengisi akun dan data demo:

- Admin: `admin@example.com` / `Password123`
- Learner: `learner@example.com` / `Password123`
- Data: kurikulum N5, lesson, materi PDF demo, dan akun demo untuk flow MVP.

### 6. Menjalankan Server API
Jalankan FastAPI menggunakan Uvicorn:
```bash
uvicorn app.main:app --reload
```
Server akan berjalan di `http://127.0.0.1:8000`.

- Dokumentasi Swagger: `http://127.0.0.1:8000/docs`
- Cek Health: `http://127.0.0.1:8000/health`
- Cek Readiness: `http://127.0.0.1:8000/ready`

Swagger utama menampilkan kontrak untuk frontend user dan admin/back-office: `Auth`, `/api/v1/app/*`, dan `/api/v1/admin/*`.
Endpoint internal/operasional tetap disembunyikan agar integrasi frontend tidak bercampur dengan route kompatibilitas dan monitoring.
Detail endpoint yang tampil dan yang disembunyikan ada di `backend/docs/SWAGGER_VISIBILITY.md`.

## Catatan Deploy Railway

Jika database Railway pernah memakai migration lama dan log menampilkan:

```text
Can't locate revision identified by '69e963bb7b7b'
```

Redeploy kode terbaru ini. Migration `69e963bb7b7b` sudah disediakan kembali sebagai anchor kompatibilitas, lalu Alembic akan menaikkan database ke head `000000000001`. Tidak perlu reset database Railway untuk error ini.

## Panduan Tim Frontend (Web / Mobile)

Bagi tim yang akan mengintegrasikan aplikasi *Frontend* dengan *Backend* ini, kami telah menyiapkan dokumentasi super komprehensif di dalam direktori `backend/docs/`! 
Silakan baca urutan berikut agar Anda paham cara berinteraksi dengan API ini:

1. **[Frontend Integration Guide (Penting)](backend/docs/FRONTEND_INTEGRATION.md)**: Kontrak simpel untuk frontend: auth, katalog Course -> Unit -> Lesson, PDF viewer, AI quiz dari PDF, attempt history, dashboard, dan leaderboard.
2. **[Material PDF Workflow](backend/docs/MATERIAL_PDF_WORKFLOW.md)**: Alur admin upload PDF, AI generate soal dari materi, lalu user mengerjakan soal.
3. **[Gambaran Umum API (Arsitektur)](backend/docs/API_OVERVIEW.md)**: Ringkasan endpoint MVP, auth, dan batas kontrak frontend.
4. **[Swagger Visibility Guide](backend/docs/SWAGGER_VISIBILITY.md)**: Daftar endpoint yang tampil di Swagger dan endpoint admin/internal yang sengaja disembunyikan.
5. **[Cara Autentikasi JWT](backend/docs/AUTHENTICATION.md)**: Pelajari cara mendapatkan Token saat Login, dan cara menyematkannya di *Header Authorization*.
6. **[Question Types Schema](backend/docs/QUESTION_TYPES.md)**: Bentuk JSON soal pilihan ganda reading dan payload submit jawaban.
7. **[Standarisasi Kode Error](backend/docs/ERROR_CODES.md)**: Daftar makna status HTTP (*400, 401, 403, 404*) yang dikembalikan sistem.
8. **[Changelog (Catatan Rilis)](backend/docs/CHANGELOG.md)**: Melacak penambahan fitur baru pada API dari rilis ke rilis.
9. **[Known Limitations](backend/docs/KNOWN_LIMITATIONS.md)**: Panduan mengenai beberapa keterbatasan MVP yang belum selesai saat peluncuran versi awal.

**Impor ke Postman:**
Jika Anda ingin mengetes API langsung menggunakan *Postman*, cukup jalankan skrip `python scripts/export_openapi.py` di dalam folder `backend`, kemudian impor file hasil cetakannya (`backend/docs/openapi.json`) ke dalam *Postman Collection* Anda!


## Pengujian (Testing)
Untuk menjalankan pengujian otomatis, pastikan Anda berada di dalam folder `backend`:
```bash
cd backend
pytest
```

Smoke test manual yang disarankan setelah `python import_db.py --yes`:

1. Login learner: `POST /api/v1/auth/login`.
2. Simpan `access_token`, lalu kirim header `Authorization: Bearer <access_token>` untuk semua endpoint `/api/v1/app/*`.
3. Ambil profil user: `GET /api/v1/app/me`.
4. Ambil katalog kursus: `GET /api/v1/app/catalog`.
5. Ambil detail lesson: `GET /api/v1/app/lessons/{lesson_id}`.
6. Ambil materi `GET /api/v1/app/lessons/{lesson_id}/materials`.
7. Buka PDF viewer dari `file_url`: `GET /api/v1/app/materials/{material_id}/file`.
8. Generate soal dari materi: `POST /api/v1/app/materials/{material_id}/ai-question-jobs`.
9. Poll job: `GET /api/v1/app/ai-question-jobs/{job_id}` sampai `status=COMPLETED`.
10. Jika perlu generate ulang: `POST /api/v1/app/ai-question-jobs/{job_id}/regenerate`.
11. Mulai sesi dari job: `POST /api/v1/app/ai-question-jobs/{job_id}/sessions`.
12. Ambil soal, submit jawaban pilihan ganda, lalu complete session:
   `GET /api/v1/app/sessions/{session_id}/questions`,
   `POST /api/v1/app/sessions/{session_id}/answers`,
   `POST /api/v1/app/sessions/{session_id}/complete`.
13. Cek riwayat attempt: `GET /api/v1/app/attempts`.
14. Cek progress lesson: `GET /api/v1/app/lessons/{lesson_id}/progress`.
15. Cek dashboard: `GET /api/v1/app/dashboard`.
16. Cek ranking: `GET /api/v1/app/leaderboard?period=weekly`.
