# Checklist Tahap 3 - Authentication Dan User

> **Baseline 2026-07-10 — PARTIAL (Gate 1).** Checklist ini adalah inventaris requirement historis. Status resmi dan Definition of Done mengikuti [`../EXECUTION-ROADMAP.md`](../EXECUTION-ROADMAP.md). Seluruh token dan RBAC wajib diaudit ulang sebelum tahap berikutnya.

## A. Model Dan Migration

- [x] Model `user` dibuat.
- [x] Enum dan kolom `users.role` canonical lowercase dibuat dan dimigrasikan.
- [x] Model `refresh_token` dibuat.
- [x] Model `password_reset_token` dibuat.
- [x] Model `email_verification_token` dibuat.
- [x] Migration auth dibuat.
- [x] Nilai role canonical divalidasi tanpa tabel/seed role terpisah.
- [x] Seed administrator dibuat.
- [x] Unique index email dibuat.

## B. Autentikasi

- [x] Password hashing dibuat.
- [x] Registrasi dibuat.
- [x] Login dibuat.
- [x] JWT access token dibuat.
- [x] Refresh token dibuat.
- [x] Logout dibuat.
- [x] Revocation token dibuat.
- [x] Lupa password dibuat.
- [x] Reset password dibuat.
- [x] Email verification dibuat.
- [x] Resend verification dibuat.
- [x] Rate limit login dibuat.

## C. User Profile Dan Session

- [x] Endpoint `users/me` dibuat.
- [x] Perubahan profil dibuat.
- [x] Perubahan password dibuat.
- [x] Soft deactivation akun learner dibuat.
- [x] Daftar session login dibuat.
- [x] Hapus session login dibuat.
- [x] Logout semua session dibuat.
- [x] Timezone user disimpan.
- [x] Target level user disimpan.

## D. Role-Based Access Control

- [x] Role learner dibuat.
- [x] Role content editor dibuat.
- [x] Role reviewer dibuat.
- [x] Role administrator dibuat.
- [x] Role dependency dibuat.
- [x] Permission helper endpoint admin dibuat.
- [x] Test learner ditolak pada endpoint admin dibuat.

## E. Administrasi User Dan Role

- [x] Endpoint daftar/detail user admin dibuat.
- [x] Endpoint perubahan status user admin dibuat.
- [x] Endpoint role assignment admin dibuat.
- [x] Pengubahan role/status dicatat pada audit log.
- [x] Administrator terakhir tidak dapat dinonaktifkan atau diturunkan rolenya.
- [x] Permission dan safety test admin user management dibuat.

## F. Dokumentasi Frontend

- [x] Dokumentasi flow registrasi dibuat.
- [x] Dokumentasi flow login dibuat.
- [x] Dokumentasi flow refresh token dibuat.
- [x] Dokumentasi flow logout dibuat.
- [x] Dokumentasi error auth dibuat.
- [x] Contoh request dan response auth dibuat.

## G. Testing Dan Security

- [x] Auth unit test dibuat.
- [x] Auth integration test dibuat.
- [x] Test password hashing dibuat.
- [x] Test refresh token revoked dibuat.
- [x] Test token expired dibuat.
- [x] Test invalid credential dibuat.
- [x] Secret tidak masuk Git.
- [x] Log tidak menyimpan password atau token.
