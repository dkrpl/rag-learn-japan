# Pembagian PRD Backend Nihongo Learning API

Sumber utama: `prd_belajar_bahasa_jepang.md`

> Catatan revisi 2026-07-16:
> Folder `prd/` adalah arsip PRD backend lama. Sumber kebenaran produk terbaru untuk MVP sekarang adalah [`../prd-revisi/01-prd-revisi-mvp.md`](../prd-revisi/01-prd-revisi-mvp.md), dengan alur material-first: admin upload PDF, user pilih materi dan difficulty, AI generate soal, user mengerjakan, lulus mendapat EXP dan unlock, gagal wajib mengulang tanpa EXP.

Dokumen di folder ini adalah pecahan PRD backend dan engine untuk platform belajar Bahasa Jepang berbasis AI. Scope tetap backend: API, database, auth, content engine, question bank, learning engine, progress/SRS, AI generator, audio/TTS, simulasi JLPT, dokumentasi API, testing, dan deployment backend.

Frontend belum dikembangkan pada tahap ini. Dokumentasi frontend yang disebut di PRD berarti kontrak API, OpenAPI, Postman, dan panduan integrasi agar tim frontend bisa memakai backend nanti.

## Status Dan Sumber Kebenaran

Baseline audit 2026-07-10 menunjukkan implementasi masih parsial dan belum memenuhi acceptance criteria MVP. Eksekusi berikutnya wajib mengikuti [Master Execution Roadmap](EXECUTION-ROADMAP.md), yang mengatur dependency, quality gate, Definition of Done, dan urutan validasi.

Urutan sumber kebenaran:

1. `00-master-backend-engine-prd.md` untuk keputusan produk dan acceptance criteria.
2. `EXECUTION-ROADMAP.md` untuk urutan kerja dan status eksekusi resmi.
3. `MVP-TRACEABILITY.md` untuk pemetaan outcome MVP ke gate dan bukti validasi.
4. `tahap*/tahap*.md` untuk requirement domain rinci.
5. `tahap*/checklist-tahap*.md` untuk inventaris pekerjaan rinci.

Tanda `[~]` pada checklist tahap berarti artefak pernah diklaim atau terlihat tersedia, tetapi belum terverifikasi. Tanda `[x]` dicadangkan khusus untuk pekerjaan yang telah memenuhi Definition of Done pada execution roadmap.

## Susunan Tahap

0. `00-master-backend-engine-prd.md`
   - `EXECUTION-ROADMAP.md` sebagai urutan eksekusi lintas tahap.
   - `MVP-TRACEABILITY.md` sebagai matriks acceptance criteria dan evidence.
1. `tahap1-finalisasi-fondasi-produk`
2. `tahap2-bootstrap-backend`
3. `tahap3-authentication-dan-user`
4. `tahap4-curriculum-dan-content`
5. `tahap5-question-bank`
6. `tahap6-learning-engine`
7. `tahap7-progress-dan-review`
8. `tahap8-ai-generator-dan-audio`
9. `tahap9-dokumentasi-dan-hardening`
10. `tahap10-simulasi-jlpt`

## Catatan Scope

- MVP dimulai dari dasar Bahasa Jepang dan JLPT N5.
- Arsitektur harus siap berkembang sampai JLPT N1.
- Simulasi JLPT N5 masuk MVP backend.
- Struktur data simulasi harus mendukung N4, N3, N2, dan N1 untuk tahap berikutnya.
- Setiap `tahap*.md` adalah dokumen PRD tahap yang memuat ringkasan produk, tujuan, scope, requirements, data/API, aturan bisnis, deliverable, dan acceptance criteria.
- Setiap `checklist-tahap*.md` adalah checklist implementasi yang diturunkan dari PRD tahap tersebut.
- Checklist tahap adalah inventaris requirement; status eksekusi dan gate resmi berada di `EXECUTION-ROADMAP.md`.

## Referensi Tambahan

Dokumen teknis terperinci yang melengkapi PRD ini dapat ditemukan di folder `docs/`:
- [Standar API](../docs/api-standards.md)
- [Rancangan Database / ERD](../docs/erd-awal.md)
- [Aturan Repository dan Environment](../docs/workflow-and-env.md)
