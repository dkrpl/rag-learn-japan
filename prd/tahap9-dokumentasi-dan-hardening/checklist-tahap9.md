# Checklist Tahap 9 - Dokumentasi Dan Hardening

> **Baseline 2026-07-10 — PARTIAL (Gate 8 dan Gate 10).** Checklist ini adalah inventaris requirement historis. Hardening core dilakukan sebelum Tahap 10; final release verification diulang setelah simulasi tersedia. Status resmi mengikuti [`../EXECUTION-ROADMAP.md`](../EXECUTION-ROADMAP.md).

## A. Dokumentasi Otomatis

- [~] Judul dan deskripsi API di OpenAPI dibuat.
- [~] Semua endpoint memiliki tag.
- [x] Semua endpoint yang tersedia memiliki operation ID unik yang tervalidasi.
- [x] Semua request memiliki schema yang tervalidasi.
- [x] Semua response memiliki schema yang tervalidasi.
- [ ] Semua endpoint memiliki contoh request yang akurat.
- [ ] Semua endpoint memiliki contoh response yang akurat.
- [ ] Semua endpoint mencantumkan hak akses yang akurat.
- [ ] Semua endpoint mencantumkan error response yang akurat.
- [x] OpenAPI schema divalidasi dalam CI.
- [x] Tidak ada operation ID duplikat berdasarkan validasi OpenAPI.

## B. Dokumentasi Manual Frontend

- [x] `API_OVERVIEW.md` dibuat.
- [x] `FRONTEND_INTEGRATION.md` dibuat.
- [x] `AUTHENTICATION.md` dibuat.
- [x] `ERROR_CODES.md` dibuat.
- [x] `QUESTION_TYPES.md` dibuat.
- [ ] `JLPT_SIMULATION.md` dari Tahap 10 diverifikasi pada final release gate.
- [ ] `CHANGELOG.md` dibuat.
- [ ] Panduan pembuatan SDK frontend dibuat.
- [ ] Breaking change policy dibuat.

## C. Postman Dan Contoh Integrasi

- [x] Postman collection aktual dibuat dari OpenAPI tervalidasi dan disimpan sebagai artefak.
- [x] Postman development environment aktual dibuat dan disimpan sebagai artefak.
- [x] Postman staging environment dibuat.
- [ ] Contoh alur login dibuat dan cocok dengan JSON contract aktual.
- [ ] Contoh alur refresh token dibuat.
- [ ] Contoh alur belajar end-to-end dibuat dengan endpoint aktual.
- [ ] Contoh alur listening end-to-end dibuat dengan endpoint aktual.
- [ ] Postman flow simulasi dari Tahap 10 diverifikasi pada final release gate.
- [ ] Contoh alur error dibuat sesuai global error envelope aktual.
- [ ] Contoh response nyata yang telah diverifikasi tersedia.

## D. Testing Dan Quality Assurance

- [x] Unit test service dibuat.
- [x] Integration test database dibuat.
- [ ] Contract test dibuat.
- [x] Permission test dibuat.
- [ ] File upload test dibuat.
- [ ] Worker test dibuat.
- [ ] Migration test dibuat.
- [ ] Test database terpisah dibuat.
- [ ] Factory data dibuat.
- [ ] Mock AI dibuat.
- [ ] Mock TTS dibuat.
- [ ] Coverage report dibuat.
- [ ] Coverage service inti mencapai target.
- [x] Lint berjalan pada CI.
- [x] Test berjalan pada CI.
- [x] OpenAPI validation berjalan pada CI.
- [x] Secret scanning dikonfigurasi.

## E. Security Hardening

- [x] Secret tidak masuk Git.
- [ ] `.env.example` tidak mengandung key asli.
- [ ] Password di-hash.
- [ ] Refresh token di-hash.
- [ ] Token dapat dicabut.
- [ ] CORS menggunakan allowlist.
- [x] Rate limit login dibuat.
- [x] Rate limit AI dibuat.
- [ ] Input tervalidasi.
- [ ] File audio tervalidasi.
- [x] IDOR diuji.
- [x] SQL injection diuji.
- [x] Mass assignment diuji.
- [x] Admin endpoint diuji dengan learner token.
- [x] Jawaban benar tidak bocor.
- [ ] Log sensitif disaring.
- [ ] Error production tidak menampilkan stack trace.

## F. Logging Dan Observability

- [x] Structured logging dibuat.
- [ ] Request ID dibuat.
- [ ] Error code konsisten.
- [x] Response time dicatat.
- [ ] Job ID dicatat.
- [ ] AI usage dicatat.
- [ ] TTS usage dicatat.
- [ ] Health monitoring dibuat.
- [ ] Queue monitoring dibuat.
- [ ] Database monitoring dibuat.
- [ ] Alert job gagal dibuat.

## G. Deployment

- [x] Script / panduan deployment API dibuat.
- [ ] Script / panduan deployment worker dibuat.
- [ ] Panduan setup lokal selesai.
- [ ] Development environment berjalan.
- [x] Staging environment berjalan.
- [ ] Production configuration disiapkan.
- [ ] HTTPS dikonfigurasi.
- [ ] Database backup dikonfigurasi.
- [ ] Object storage dikonfigurasi.
- [ ] Redis dikonfigurasi.
- [ ] Migration deployment dibuat.
- [ ] Rollback procedure dibuat.
- [ ] Seed administrator production aman.
- [ ] OpenAPI production dapat diakses tim frontend.
- [ ] Monitoring production aktif.

## H. Persiapan Frontend

- [x] API staging stabil.
- [x] Dokumentasi auth selesai.
- [x] Dokumentasi question type selesai.
- [x] Dokumentasi error selesai.
- [x] Postman collection selesai.
- [x] OpenAPI schema selesai.
- [x] CORS staging dikonfigurasi.
- [x] Akun frontend developer tersedia.
- [x] Sample user tersedia.
- [x] Sample curriculum tersedia.
- [x] Sample session tersedia.
- [ ] Sample simulation tersedia.
- [ ] SDK dapat dibuat dari OpenAPI.
- [ ] Contract freeze versi pertama dilakukan.

## I. Acceptance MVP

- [ ] Pengguna dapat registrasi dan login.
- [ ] Pengguna dapat melihat kurikulum.
- [ ] Pengguna dapat membuka materi.
- [ ] Pengguna dapat memulai sesi latihan.
- [ ] Pengguna dapat menjawab seluruh jenis soal MVP.
- [ ] Backend dapat memeriksa jawaban.
- [ ] Backend dapat menyimpan hasil.
- [ ] Backend dapat memperbarui progress.
- [ ] Backend dapat membuat jadwal review.
- [ ] Pengguna dapat melihat kesalahan.
- [ ] Audio dapat dimainkan melalui URL.
- [ ] Admin dapat mengelola konten melalui API.
- [ ] AI dapat menghasilkan draft soal.
- [ ] Soal AI dapat divalidasi.
- [ ] Reviewer dapat menyetujui dan menolak.
- [ ] Soal yang belum dipublikasikan tidak muncul kepada learner.
- [ ] Kunci jawaban tidak bocor.
- [x] Dokumentasi Swagger tersedia.
- [x] Dokumentasi ReDoc tersedia.
- [x] OpenAPI JSON valid.
- [ ] Postman collection tersedia.
- [x] Panduan integrasi frontend tersedia.
- [x] Test inti lulus.
- [ ] Migration dapat membangun database kosong.
- [x] Staging environment dapat digunakan oleh frontend.
- [ ] Simulasi JLPT N5 dapat dijalankan.
- [ ] Arsitektur level N4 sampai N1 telah disiapkan.
