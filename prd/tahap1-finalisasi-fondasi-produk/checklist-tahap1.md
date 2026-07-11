# Checklist Tahap 1 - Finalisasi Fondasi Produk

> **Baseline 2026-07-10 — REVALIDATE.** Checklist ini adalah inventaris requirement historis. Status resmi dan Definition of Done mengikuti [`../EXECUTION-ROADMAP.md`](../EXECUTION-ROADMAP.md). Tanda `[x]` historis belum berarti release-ready tanpa evidence.

## A. Perencanaan Produk

- [x] Nama sementara proyek ditentukan.
- [x] Tujuan produk disetujui.
- [x] Target pengguna disetujui.
- [x] Ruang lingkup MVP dikunci.
- [x] Fitur berbicara ditandai tidak termasuk MVP.
- [x] Fitur tulisan tangan ditandai tidak termasuk MVP.
- [x] Kanji tracing ditandai tidak termasuk MVP.
- [x] Upload PDF pengguna ditandai tidak termasuk MVP.
- [x] Target konten dasar dan JLPT N5 disetujui.
- [x] Target pengembangan JLPT N5 sampai N1 disetujui.
- [x] Simulasi JLPT N5 ditandai masuk MVP backend.
- [x] Arsitektur N4 sampai N1 ditandai perlu disiapkan.
- [x] Role pengguna ditentukan.
- [x] Hak akses tiap role diringkas.
- [x] Kriteria keberhasilan MVP ditentukan.
- [x] PRD dimasukkan ke repository.

## B. Persiapan Repository Dan Alur Kerja

- [x] Repository Git tersedia dan metadata Git dapat diverifikasi.
- [x] Nama repository ditentukan.
- [x] README awal dibuat.
- [x] Branch strategy ditentukan.
- [x] Conventional commit ditentukan.
- [x] Aturan pull request dan review ditentukan.
- [x] Struktur folder dokumentasi disepakati.

## C. Rancangan API

- [x] Base URL dan prefix `/api/v1` disepakati.
- [x] Format response berhasil disepakati.
- [x] Format pagination disepakati.
- [x] Format error response disepakati.
- [x] Daftar status HTTP standar disepakati.
- [x] Konvensi snake_case untuk field API disepakati.
- [x] Penggunaan UUID publik disepakati.

## D. Rancangan Database

- [x] ERD awal dibuat.
- [x] Domain tabel auth dirancang.
- [x] Domain tabel curriculum dirancang.
- [x] Domain tabel materi dirancang.
- [x] Domain tabel soal dirancang.
- [x] Domain tabel learning session dirancang.
- [x] Domain tabel progress dirancang.
- [x] Domain tabel simulasi JLPT dirancang.
- [x] Domain tabel sistem dirancang.
- [x] Index penting awal diidentifikasi.
- [x] Foreign key utama diidentifikasi.
- [x] Aturan cascade awal ditinjau.

## E. Environment Dan Operasional

- [x] Environment local ditentukan.
- [x] Environment testing ditentukan.
- [x] Environment staging ditentukan.
- [x] Environment production ditentukan.
- [x] Daftar environment variable awal disusun.
- [x] Strategi migration menggunakan Alembic disepakati.
- [x] Aturan backup sebelum migration besar disepakati.
