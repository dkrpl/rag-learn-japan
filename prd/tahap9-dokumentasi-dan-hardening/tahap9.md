# Tahap 9 - Dokumentasi Dan Hardening

Sumber tahap: Sprint 8 - Dokumentasi dan hardening.

## 1. Ringkasan Produk

Tahap ini memastikan backend dan engine siap dipakai oleh tim frontend dan aman untuk staging. Fokusnya bukan membuat frontend, tetapi menyiapkan kontrak API yang lengkap, testing, security hardening, observability, deployment, dan definition of done endpoint.

Dokumentasi API menjadi pengganti koordinasi manual agar frontend apa pun dapat menggunakan backend dengan stabil.

Dalam execution roadmap, tahap ini dijalankan dua kali sebagai gate: hardening core sebelum implementasi simulasi JLPT dan final release hardening setelah Tahap 10 selesai. Acceptance MVP penuh baru dapat dinyatakan lulus pada final release gate.

## 2. Tujuan Tahap

- Melengkapi Swagger, ReDoc, dan OpenAPI.
- Membuat dokumentasi manual integrasi.
- Membuat Postman collection.
- Menjalankan contract testing.
- Menjalankan security testing.
- Menyiapkan CI quality gate.
- Menyiapkan staging deployment.
- Menyiapkan monitoring dan rollback procedure.

## 3. Scope

- OpenAPI metadata.
- Schema request/response semua endpoint.
- Operation ID unik.
- Error response.
- Postman collection.
- Frontend integration guide.
- Contract test.
- Unit, integration, worker, migration, permission, dan security test.
- Secret scanning.
- Logging dan observability.
- Script / Panduan Deployment API dan worker.
- Staging environment.

## 4. Non-Scope

- Implementasi UI frontend.
- Mobile app.
- Payment.
- Production scale tuning penuh.

## 5. Dokumentasi Wajib

- `API_OVERVIEW.md`
- `FRONTEND_INTEGRATION.md`
- `AUTHENTICATION.md`
- `ERROR_CODES.md`
- `QUESTION_TYPES.md`
- `JLPT_SIMULATION.md` dimiliki Tahap 10 dan diverifikasi ulang pada final release gate.
- `CHANGELOG.md`
- Postman collection.
- Postman development environment.
- Postman staging environment.

## 6. Definition Of Done Endpoint

Endpoint dianggap selesai jika:

- Router selesai.
- Request schema selesai.
- Response schema selesai.
- Authorization selesai.
- Business logic tidak berada di router.
- Database transaction benar.
- Error response sesuai standar.
- Unit atau integration test tersedia.
- OpenAPI summary dan description tersedia.
- Request example dan response example tersedia.
- Error response terdokumentasi.
- Postman request tersedia.
- Tidak membocorkan field internal.
- Lulus lint.
- Lulus test.
- Sudah ditinjau.

## 7. Testing Requirements

- Unit test service.
- Integration test database.
- API contract test.
- Permission test.
- File upload test.
- Worker test.
- Migration test.
- Security test.
- OpenAPI validation.
- Coverage report.
- Mock AI dan mock TTS.

## 8. Security Requirements

- Secret tidak masuk Git.
- Password dan refresh token di-hash.
- Token dapat dicabut.
- CORS menggunakan allowlist.
- Login dan AI memiliki rate limit.
- Input tervalidasi.
- File audio tervalidasi.
- IDOR diuji.
- SQL injection diuji.
- Mass assignment diuji.
- Jawaban benar tidak bocor.
- Log sensitif disaring.
- Error production tidak menampilkan stack trace.

## 9. Observability

- Structured logging.
- Request ID.
- Error code konsisten.
- Response time.
- Job ID.
- AI usage.
- TTS usage.
- Health monitoring.
- Queue monitoring.
- Database monitoring.
- Alert job gagal.

## 10. Deployment

- Script / Panduan Deployment API.
- Script / Panduan Deployment worker.
- Panduan Setup Lokal Penuh.
- Development environment.
- Staging environment.
- Production configuration.
- HTTPS.
- Database backup.
- Object storage.
- Redis.
- Migration deployment.
- Rollback procedure.

## 11. Kriteria Penerimaan MVP

- User dapat registrasi dan login.
- User dapat melihat kurikulum dan materi.
- User dapat memulai sesi latihan.
- User dapat menjawab seluruh tipe soal MVP.
- Backend memeriksa jawaban, menyimpan hasil, dan memperbarui progress.
- Backend membuat jadwal review.
- Audio dapat dimainkan melalui URL.
- Admin dapat mengelola konten.
- AI menghasilkan draft soal.
- Reviewer menyetujui dan menolak soal.
- Kunci jawaban tidak bocor.
- Swagger, ReDoc, OpenAPI JSON, Postman, dan panduan integrasi tersedia.
- Migration dapat membangun database kosong.
- Staging dapat digunakan frontend.
- Simulasi JLPT N5 dapat dijalankan setelah tahap 10.
- Arsitektur N4 sampai N1 tersedia.

## 12. Acceptance Criteria

- Semua endpoint punya schema, tag, operation ID, contoh, hak akses, dan error response.
- OpenAPI valid.
- Tidak ada operation ID duplikat.
- Hardening core mencakup flow auth, belajar, listening, dan error. Flow simulasi JLPT ditambahkan pada Tahap 10 lalu seluruh collection diverifikasi ulang pada final release gate.
- Test inti lulus di CI.
- Security baseline lulus.
- Staging environment berjalan.
