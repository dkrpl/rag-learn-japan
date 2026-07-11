# Workflow Repository dan Konfigurasi Environment

Dokumen ini menjelaskan strategi Git, aturan penulisan *commit*, dan daftar variabel konfigurasi sistem (*environment variables*) standar untuk di tahap pengembangan lokal (tanpa Docker).

## 1. Branch Strategy (Alur Kerja Git)

Kita akan menggunakan variasi **GitHub Flow** yang disederhanakan:

- `main` : Cabang utama yang *production-ready*. Semua kode yang masuk ke sini harus lolos *lint* dan *test*.
- `feature/*` : Cabang untuk fitur baru (contoh: `feature/auth-login`, `feature/learning-session`).
- `bugfix/*` : Cabang untuk perbaikan *bug* non-kritis.
- `hotfix/*` : Cabang untuk perbaikan darurat langsung ke production.

**Aturan Merge:**
Semua perubahan harus dibuat melalui Pull Request (PR) ke `main` dan wajib di-*review* sebelum di-*merge*.

## 2. Conventional Commits

Kita sepakat memakai [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) untuk pesan Git commit:
- `feat:` Sebuah fitur baru.
- `fix:` Perbaikan kutu (bug).
- `docs:` Pembaruan dokumentasi (contoh: PRD, ERD, README).
- `style:` Perubahan format (spasi, titik koma, dsb) tanpa mengubah logika.
- `refactor:` Perombakan kode (bukan menambah fitur, bukan memperbaiki *bug*).
- `test:` Penambahan/perubahan *unit tests*.
- `chore:` Perubahan sistem *build*, dependensi, dsb.

**Contoh:**
`feat(auth): menambahkan endpoint registrasi user`

## 3. Standard Environment Variables (Local)

Kita tidak memakai Docker untuk lokal. Berikut daftar *environment variables* yang wajib dimasukkan ke dalam file `.env` di komputer masing-masing (*developer*) pada saat memulai Tahap 2:

```env
# ENVIRONMENT
ENVIRONMENT=local

# DATABASE CONFIGURATION
# Format: mysql+pymysql://<user>:<password>@<host>:<port>/<db_name>
DATABASE_URL=mysql+pymysql://root:password@127.0.0.1:3306/nihongo_db

# SECURITY
# Secret key digunakan untuk encoding JWT. Generate secara acak!
SECRET_KEY=super_secret_key_change_this
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7

# CORS
# Domain yang diizinkan untuk memanggil API
CORS_ORIGINS=["http://localhost:3000"]
```

> **Catatan:**
> File `.env` dilarang dimasukkan (commit) ke dalam repositori Git karena berisi data sensitif (*credentials*). Simpan template-nya di file bernama `.env.example`.
