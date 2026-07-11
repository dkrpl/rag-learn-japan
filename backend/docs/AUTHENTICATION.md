# Authentication Guide

Nihongo Learn menggunakan skema standar OAuth2 Password Bearer dengan JWT.

## 1. Mendapatkan Token (Login)
**Endpoint**: `POST /api/v1/auth/login`
- Body `application/x-www-form-urlencoded`: `username=emailanda@test.com&password=passwordanda`
- Mengembalikan: `{"access_token": "ey...", "token_type": "bearer"}`

## 2. Menggunakan Token
Sisipkan token di Header pada semua permintaan yang dilindungi:
`Authorization: Bearer <access_token>`

## 3. Register
Bisa menggunakan `POST /api/v1/auth/register` dengan Body JSON standar (email, username, password).
