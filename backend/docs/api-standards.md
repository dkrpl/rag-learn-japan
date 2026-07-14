# Standar API - Nihongo Learning

Dokumen ini mendefinisikan standar dan konvensi pembuatan API untuk backend Nihongo Learning. Semua endpoint yang dibuat dalam proyek ini wajib mematuhi panduan di bawah ini agar konsisten.

## 1. Konvensi Dasar

- **Base URL API**: Semua endpoint API harus diawali dengan prefix `/api/v1`. Contoh: `https://api.nihongolearn.com/api/v1/app/me`
- **Format Data**: Request dan Response payload harus dalam format JSON (`application/json`).
- **Format Nama Field**: Menggunakan `snake_case` untuk *semua* key pada JSON.
  - ✅ Benar: `first_name`, `is_active`
  - ❌ Salah: `firstName`, `isActive`
- **Identitas Publik**: Endpoint yang mengekspos ID resource keluar (ke *client*) sebaiknya menggunakan `UUID` dan bukan *auto-increment integer* untuk alasan keamanan (mencegah *enumeration attack*).

## 2. Standar HTTP Status Code

Kode HTTP yang digunakan harus memiliki makna yang baku:
- `200 OK`: Request sukses.
- `201 Created`: Request sukses dan resource baru berhasil dibuat.
- `400 Bad Request`: Data request tidak valid (contoh: validasi input gagal).
- `401 Unauthorized`: Token auth tidak ada, salah, atau kedaluwarsa.
- `403 Forbidden`: Token valid, tapi *user* tidak memiliki hak akses (role) untuk resource tersebut.
- `404 Not Found`: Resource yang dicari tidak ditemukan.
- `500 Internal Server Error`: Terjadi kesalahan yang tidak terduga pada server.

## 3. Format Response (Response Envelope)

Untuk menjaga struktur konsisten di *client*, kita menggunakan *response envelope*. 

### 3.1 Response Berhasil (Success)
Bila data tunggal atau *list* tanpa *pagination*:
```json
{
  "status": "success",
  "data": {
    "id": "e6f4...",
    "name": "Taro Yamada"
  }
}
```

### 3.2 Response List Dengan Pagination
```json
{
  "status": "success",
  "data": [
    {"id": "uuid-1", "title": "Vocabulary 1"},
    {"id": "uuid-2", "title": "Vocabulary 2"}
  ],
  "meta": {
    "pagination": {
      "page": 1,
      "per_page": 20,
      "total_items": 100,
      "total_pages": 5
    }
  }
}
```

### 3.3 Response Gagal (Error)
```json
{
  "status": "error",
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Input data is not valid",
    "details": [
      {
        "field": "email",
        "message": "Email is already in use."
      }
    ]
  }
}
```

## 4. Konvensi Tanggal dan Waktu

- Disimpan dalam database dengan format UTC.
- Di dalam response JSON, diformat menggunakan standar **ISO 8601**.
  - Contoh: `"created_at": "2026-07-10T11:09:13Z"`
