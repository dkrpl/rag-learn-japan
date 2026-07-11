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

### 6. Menjalankan Server API
Jalankan FastAPI menggunakan Uvicorn:
```bash
uvicorn app.main:app --reload
```
Server akan berjalan di `http://127.0.0.1:8000`.

- Dokumentasi Swagger: `http://127.0.0.1:8000/docs`
- Cek Health: `http://127.0.0.1:8000/health`
- Cek Readiness: `http://127.0.0.1:8000/ready`

## 📚 Panduan Tim Frontend (Web / Mobile)

Bagi tim yang akan mengintegrasikan aplikasi *Frontend* dengan *Backend* ini, kami telah menyiapkan dokumentasi super komprehensif di dalam direktori `backend/docs/`! 
Silakan baca urutan berikut agar Anda paham cara berinteraksi dengan API ini:

1. **[Gambaran Umum API (Arsitektur)](backend/docs/API_OVERVIEW.md)**: Pahami *endpoint* yang tersedia, perbedaan *Public* vs *Admin* API, _Rate Limiting_, serta **Breaking Change Policy**.
2. **[Cara Autentikasi JWT](backend/docs/AUTHENTICATION.md)**: Pelajari cara mendapatkan Token saat Login, dan cara menyematkannya di *Header Authorization*.
3. **[Frontend Integration Guide (Penting)](backend/docs/FRONTEND_INTEGRATION.md)**: Dokumen paling penting yang mengupas tuntas alur teknis sesi belajar (*Practice/Exam*), ujian **Simulasi JLPT N5**, pengambilan soal, hingga pengumpulan jawaban yang aman tanpa *Answer Leak*.
4. **[Question Types Schema](backend/docs/QUESTION_TYPES.md)**: Penjelasan mengenai bentuk-bentuk JSON yang dinamis untuk tiap tipe pertanyaan (Pilihan Ganda, Benar/Salah, *Matching*).
5. **[Standarisasi Kode Error](backend/docs/ERROR_CODES.md)**: Daftar makna status HTTP (*400, 401, 403, 404*) yang dikembalikan sistem.
6. **[Changelog (Catatan Rilis)](backend/docs/CHANGELOG.md)**: Melacak penambahan fitur baru pada API dari rilis ke rilis.
7. **[Known Limitations](backend/docs/KNOWN_LIMITATIONS.md)**: Panduan mengenai beberapa keterbatasan MVP yang belum selesai saat peluncuran versi awal.

**Impor ke Postman:**
Jika Anda ingin mengetes API langsung menggunakan *Postman*, cukup jalankan skrip `python scripts/export_openapi.py` di dalam folder `backend`, kemudian impor file hasil cetakannya (`backend/docs/openapi.json`) ke dalam *Postman Collection* Anda!


## Pengujian (Testing)
Untuk menjalankan pengujian otomatis, pastikan Anda berada di dalam folder `backend`:
```bash
cd backend
pytest
```
