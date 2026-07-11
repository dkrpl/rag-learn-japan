# Tahap 3 - Authentication Dan User

Sumber tahap: Sprint 2 - Authentication dan user.

## 1. Ringkasan Produk

Tahap ini menyediakan identitas dan akses untuk seluruh backend. Semua fitur learner, content editor, reviewer, administrator, dan engine administratif membutuhkan autentikasi, token, session, dan role-based access control.

Auth harus aman karena backend menyimpan progres belajar, jawaban, kunci soal, draft AI, dan endpoint admin.

## 2. Tujuan Tahap

- Menyediakan registrasi, login, refresh token, dan logout.
- Menyediakan profil user aktif.
- Menyediakan perubahan profil dan password.
- Menyediakan lupa password dan reset password.
- Menyediakan verifikasi email.
- Menyediakan role dan RBAC.
- Menyiapkan seed administrator.

## 3. Scope

- Model user dengan kolom role canonical, refresh token, password reset token, dan email verification token.
- Password hashing.
- JWT access token.
- Refresh token dengan hash dan revocation.
- Endpoint `auth`.
- Endpoint `users/me`.
- User session management.
- Role dependency untuk endpoint admin.
- Rate limit login.
- Unit dan integration test auth.

## 4. Non-Scope

- Social login.
- OAuth provider eksternal.
- Multi-factor authentication.
- Frontend auth screen.
- Billing account.

## 5. Functional Requirements

### FR-001 - Autentikasi

Sistem menyediakan registrasi, login, JWT, refresh token, logout, lupa password, reset password, verifikasi email, perubahan password, dan informasi pengguna aktif.

### FR-002 - Manajemen Pengguna

Sistem mendukung profil, nama, foto, timezone, target level, status akun, session login, dan riwayat aktivitas belajar.

### FR-003 - Manajemen Role

Role minimum:

- `learner`
- `content_editor`
- `reviewer`
- `administrator`

Setiap endpoint administratif wajib memeriksa role.

## 6. Data Model

- `users`: identitas, email, password hash, role, timezone, target level, status aktif.
- `users.role`: nilai canonical `learner`, `content_editor`, `reviewer`, atau `administrator`.
- `refresh_tokens`: hash token, expiry, revoked status, device info, IP.
- `password_reset_tokens`: hash token reset, expiry, used status.
- `email_verification_tokens`: hash token verifikasi, expiry, used status.

## 7. Endpoint

- `POST /api/v1/auth/register`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/refresh`
- `POST /api/v1/auth/logout`
- `POST /api/v1/auth/logout-all`
- `POST /api/v1/auth/forgot-password`
- `POST /api/v1/auth/reset-password`
- `POST /api/v1/auth/verify-email`
- `POST /api/v1/auth/resend-verification`
- `GET /api/v1/users/me`
- `PATCH /api/v1/users/me`
- `PATCH /api/v1/users/me/password`
- `DELETE /api/v1/users/me`
- `GET /api/v1/users/me/sessions`
- `DELETE /api/v1/users/me/sessions`
- `DELETE /api/v1/users/me/sessions/{session_id}`
- `GET /api/v1/admin/users`
- `GET /api/v1/admin/users/{user_id}`
- `PATCH /api/v1/admin/users/{user_id}/status`
- `PATCH /api/v1/admin/users/{user_id}/role`

## 8. Aturan Bisnis

- Password tidak disimpan dalam bentuk asli.
- Refresh token disimpan sebagai hash.
- Access token memiliki masa berlaku pendek.
- Refresh token dapat dicabut.
- Access token dan refresh token memiliki claim `token_type` yang berbeda.
- Refresh token wajib melalui lookup hash, expiry validation, rotation, dan revocation.
- Logout mencabut refresh session yang terkait.
- User nonaktif tidak dapat login.
- Endpoint admin menolak token learner.
- Login gagal berulang terkena rate limit.
- Secret berasal dari environment variable.
- `DELETE /users/me` melakukan soft deactivation agar progress dan audit history tetap terjaga.
- Pengubahan role/status user hanya dapat dilakukan administrator, dicatat pada audit log, dan tidak boleh menonaktifkan administrator terakhir.

## 9. Security Requirements

- Log tidak boleh menyimpan password, access token, atau refresh token.
- Error auth tidak membocorkan apakah email terdaftar.
- Token expired dan token revoked harus ditangani jelas.
- CORS tetap menggunakan allowlist.

## 10. Deliverable

- Auth API lengkap.
- User profile API.
- RBAC dependency.
- Validasi role canonical dan seed administrator.
- Dokumentasi auth awal.
- Test auth.

## 11. Acceptance Criteria

- User dapat registrasi dan login.
- User dapat refresh token dan logout.
- Token revoked tidak dapat digunakan.
- Endpoint protected menolak request tanpa token valid.
- Endpoint admin menolak learner.
- User dapat membaca dan mengubah profilnya sendiri.
- Test auth lulus.
