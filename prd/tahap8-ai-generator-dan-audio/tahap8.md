# Tahap 8 - AI Generator Dan Audio

Sumber tahap: Sprint 7 - AI generator dan audio.

## 1. Ringkasan Produk

Tahap ini membangun dua engine pendukung: AI question generator dan audio/TTS pipeline. AI bertugas menghasilkan draft soal dari materi terverifikasi, sedangkan audio/TTS mendukung materi listening dan soal listening.

Keduanya harus berjalan asynchronous melalui worker agar request utama tidak terblokir.

Worker wajib berjalan pada proses terpisah menggunakan queue/broker durable. FastAPI `BackgroundTasks` tidak memenuhi Definition of Done worker AI/TTS karena job dapat hilang ketika proses API berhenti.

## 2. Tujuan Tahap

- Menyediakan provider abstraction untuk AI.
- Menyediakan prompt versioning.
- Menyediakan generation job.
- Menjalankan worker AI.
- Memvalidasi JSON hasil AI.
- Membuat draft question dari output valid.
- Menyediakan provider abstraction untuk TTS.
- Menjalankan worker TTS/audio.
- Menyimpan audio metadata, cache, checksum, durasi, transkrip, dan URL.

## 3. Scope

- AI provider interface.
- Provider AI pertama (Catatan: Konfirmasi opsi penggunaan Gemini API kepada pengguna).
- Prompt dasar dan prompt version.
- Pydantic output schema.
- Generation job model.
- Endpoint generation job.
- Worker generation.
- Retry, cancel, timeout.
- Raw response safe storage.
- Business validation.
- Draft question creation.
- TTS provider interface.
- Worker TTS.
- Storage provider.
- Audio cache dan signed/public URL.
- Audit log untuk tindakan administratif.

## 4. Non-Scope

- Chat tutor AI bebas.
- Speaking assessment.
- Speech-to-text.
- AI grading jawaban bebas.
- Auto-publish soal AI.

## 5. Functional Requirements

- FR-012: Materi mendengarkan.
- FR-015: Generator soal AI.
- FR-016: Validasi otomatis soal.
- FR-031: Audit log.

## 6. Data Model

- `generation_jobs`
- `questions`
- `audio_assets`
- `audit_logs`
- `system_settings`

Output opsi soal AI mengikuti kontrak objek `options` di `questions.prompt_json`; pipeline AI tidak membuat tabel atau model `question_options` terpisah.

## 7. Endpoint AI Generation

- `POST /api/v1/admin/generation-jobs`
- `GET /api/v1/admin/generation-jobs`
- `GET /api/v1/admin/generation-jobs/{job_id}`
- `POST /api/v1/admin/generation-jobs/{job_id}/retry`
- `POST /api/v1/admin/generation-jobs/{job_id}/cancel`
- `GET /api/v1/admin/generation-jobs/{job_id}/questions`

## 8. Endpoint Audio

- `GET /api/v1/audio/{audio_id}` dan admin audio endpoint sudah disiapkan sebagai audio foundation di Tahap 4.
- Tahap ini menambahkan generation job TTS, cache, provider metadata, dan lifecycle asynchronous tanpa mengubah kontrak learner URL.

## 9. Pipeline AI

1. Content editor memilih lesson, skill, tipe soal, jumlah, difficulty, bahasa pembahasan, kebutuhan audio, catatan tambahan, dan prompt version.
2. Backend membuat generation job.
3. Worker mengambil materi sumber.
4. AI menghasilkan JSON terstruktur.
5. Backend parsing JSON.
6. Backend menjalankan validasi schema dan business rule.
7. Backend menjalankan duplicate check.
8. Hasil valid dibuat sebagai question `AUTO_VALIDATED`; hasil invalid tidak dibuat sebagai question dan alasannya dicatat pada job.
9. Reviewer memeriksa sebelum publish.

## 10. Validasi Hasil AI

- Pertanyaan tidak kosong.
- Tipe soal valid.
- Jumlah opsi sesuai.
- Opsi tidak duplikat.
- Kunci jawaban tersedia.
- Jawaban benar termasuk opsi.
- Lesson sumber tersedia.
- Difficulty valid.
- Pembahasan tersedia.
- Tidak sama dengan soal lain.
- Tidak mengandung jawaban di pertanyaan.
- Tidak auto-publish.
- JSON sesuai schema.

## 11. Pipeline Audio/TTS

- TTS provider membuat audio dari teks yang disetujui.
- Worker menyimpan file ke local storage atau object storage.
- Metadata durasi, checksum, speaker, transcript, dan provider dicatat.
- API mengembalikan metadata dan URL, bukan base64.
- Transkrip dapat disembunyikan sampai learner selesai menjawab.

## 12. Security Dan Observability

- Rate limit AI.
- Raw response disimpan aman.
- Token atau biaya dicatat.
- Job ID dicatat di log.
- AI/TTS usage dicatat.
- Job gagal dapat di-retry.
- Secret provider hanya dari environment.

## 13. Deliverable

- AI generation API dan worker.
- Validasi output AI.
- Draft question creation.
- TTS/audio worker.
- Storage abstraction.
- Audio endpoint.
- Audit log tindakan penting.

## 14. Acceptance Criteria

- AI job dapat dibuat dan diproses worker.
- Hasil valid menjadi question `AUTO_VALIDATED` yang tetap menunggu review manusia.
- Hasil invalid dicatat dengan alasan.
- AI tidak dapat publish otomatis.
- Job gagal dapat retry.
- Job dapat cancel.
- Audio metadata dan URL tersedia.
- Test provider mock dan job failure lulus.
