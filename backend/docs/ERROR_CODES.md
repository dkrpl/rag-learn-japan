# Error Codes Standard

Jika permintaan gagal, API akan selalu mengembalikan status kode HTTP non-2xx dengan struktur JSON berikut:

```json
{
  "detail": "Human readable error message",
  "error_code": "ERR_SPECIFIC_CODE" // (optional for specific errors)
}
```

## Daftar HTTP Status Codes
- `400 Bad Request`: Validasi payload gagal (lihat array `detail` untuk field spesifik dari Pydantic).
- `401 Unauthorized`: Token Bearer salah, expired, atau tidak dikirim.
- `403 Forbidden`: Role pengguna tidak cukup (Contoh: Akun *Learner* dilarang memanggil `admin/`).
- `404 Not Found`: Resource (Lesson, Session, Question) tidak ditemukan.
- `422 Unprocessable Entity`: Mirip dengan 400, biasanya karena tipe data salah.
- `500 Internal Server Error`: Sistem crash atau Database putus. (Kami menyembunyikan stack trace di produksi).
