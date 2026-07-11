# Checklist Tahap 8 - AI Generator Dan Audio

> **Baseline 2026-07-10 — PARTIAL (Gate 6).** Checklist ini adalah inventaris requirement historis. Status resmi dan Definition of Done mengikuti [`../EXECUTION-ROADMAP.md`](../EXECUTION-ROADMAP.md). `BackgroundTasks` dalam proses API tidak dihitung sebagai worker durable.

## A. AI Provider Dan Prompt

- [x] Interface AI provider dibuat.
- [x] Implementasi provider pertama dibuat.
- [x] Prompt dasar dibuat.
- [x] Prompt disimpan dengan versi.
- [x] Pydantic output schema dibuat.
- [x] AI provider dapat diganti tanpa mengubah business logic.

## B. Generation Job

- [x] Model generation job dibuat.
- [x] Endpoint membuat job dibuat.
- [x] Endpoint daftar job dibuat.
- [x] Endpoint status job dibuat.
- [x] Endpoint hasil question dari job dibuat.
- [x] Worker generation durable pada proses terpisah dibuat.
- [x] Retry dibuat.
- [x] Cancel dibuat.
- [x] Timeout dibuat.
- [x] Rate limit AI dibuat.
- [x] Status processing/completed/partial/cancelled didukung.

## C. Validasi Hasil AI

- [x] Raw response disimpan secara aman.
- [x] JSON parsing dibuat.
- [x] Business validation dibuat.
- [x] Duplicate check dibuat.
- [x] Creation question `AUTO_VALIDATED` hanya untuk kandidat AI valid dibuat.
- [x] AI tidak dapat auto-publish.
- [x] Penggunaan token atau biaya dicatat.
- [x] Hasil invalid dicatat dengan alasan.

## D. TTS Dan Audio

- [x] Interface TTS provider dibuat.
- [x] Implementasi TTS pertama dibuat.
- [x] Worker TTS durable pada proses terpisah dibuat.
- [x] Audio job dibuat.
- [x] Audio cache dibuat.
- [x] Checksum audio dibuat.
- [x] Metadata durasi dibuat.
- [x] Storage provider dibuat.
- [x] Local storage development dibuat.
- [x] Object storage production dibuat.
- [x] Signed URL atau public URL dibuat.
- [x] Transkrip disimpan.
- [x] Visibility transkrip dibuat.
- [x] Integrasi audio asset dengan kontrak soal listening Tahap 5 dibuat.
- [x] Audio tidak dikirim sebagai base64 pada JSON.

## E. Audit, Logging, Dan Observability

- [x] Audit log generate soal dibuat.
- [x] Audit log perubahan soal dibuat.
- [x] Audit log publish/unpublish dibuat.
- [x] Job ID dicatat pada log.
- [x] AI usage dicatat.
- [x] TTS usage dicatat.
- [x] Alert job gagal disiapkan.

## F. Testing

- [x] Test provider menggunakan mock dibuat.
- [x] Test job berhasil dibuat.
- [x] Test job gagal dibuat.
- [x] Test partial result dibuat.
- [x] Test retry dibuat.
- [x] Test cancel dibuat.
- [x] Test audio endpoint dibuat.
- [x] Test kegagalan TTS dibuat.
