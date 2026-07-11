# Product Requirements Document (PRD)

## Platform Belajar Bahasa Jepang Berbasis AI

**Nama sementara:** Nihongo Learning API  
**Versi PRD:** 1.0  
**Fokus pengembangan:** Backend API  
**Backend:** Python dan FastAPI  
**Database:** MySQL  
**Frontend:** Belum ditentukan  
**Bahasa aplikasi:** Bahasa Indonesia dan Bahasa Jepang  
**Target awal:** Dasar Bahasa Jepang dan JLPT N5  
**Target pengembangan:** JLPT N5 sampai N1  

---

## 1. Ringkasan Produk

Nihongo Learning API adalah backend untuk platform pembelajaran bahasa Jepang dengan kurikulum yang disediakan dan dikelola oleh platform.

Berbeda dengan Credas yang mengharuskan pengguna mengunggah PDF, seluruh materi dalam aplikasi ini dimasukkan oleh administrator atau pengelola konten. Materi tersebut kemudian digunakan sebagai sumber pembuatan soal oleh AI.

AI tidak membuat kurikulum secara bebas. AI hanya menghasilkan variasi soal berdasarkan:

- Materi yang telah disimpan.
- Kosakata yang telah diverifikasi.
- Kanji yang telah diverifikasi.
- Poin tata bahasa.
- Contoh kalimat.
- Bacaan.
- Transkrip audio.
- Level dan tingkat kesulitan.

Soal yang dihasilkan AI tidak langsung dipublikasikan. Soal harus melewati validasi otomatis dan pemeriksaan administrator atau reviewer.

Aplikasi berfokus pada:

1. Hiragana dan katakana.
2. Kosakata.
3. Kanji.
4. Tata bahasa.
5. Membaca.
6. Mendengarkan.
7. Latihan adaptif.
8. Pengulangan terjadwal.
9. Evaluasi hasil belajar.
10. Simulasi persiapan JLPT N5 sampai N1.

Aplikasi tidak menyediakan latihan berbicara. Latihan tulisan tangan, pengenalan goresan kanji, dan tracing kanji juga tidak termasuk dalam MVP.

---

## 2. Keputusan Produk

### 2.1 Keputusan tetap

- Backend menggunakan Python.
- Framework API menggunakan FastAPI.
- Database menggunakan MySQL.
- Arsitektur menggunakan REST API berbasis JSON.
- Frontend belum ditentukan.
- Pengguna tidak dapat mengunggah PDF.
- Materi hanya dikelola oleh administrator.
- AI menghasilkan soal dari materi yang sudah tersedia.
- Soal AI harus melalui proses review.
- Fitur mendengarkan masuk dalam MVP.
- Fitur berbicara tidak dikembangkan.
- Fitur tulisan tangan dan tracing kanji tidak dikembangkan dalam MVP.
- Bahasa penjelasan utama adalah Bahasa Indonesia.
- Materi awal berfokus pada dasar Bahasa Jepang dan JLPT N5.
- Sistem dirancang agar dapat dikembangkan sampai JLPT N1.
- Backend harus menyediakan dokumentasi lengkap untuk frontend.

### 2.2 Keputusan yang dapat berubah

- Nama resmi produk.
- Teknologi frontend.
- Penyedia AI.
- Penyedia text-to-speech.
- Penyedia object storage.
- Model bisnis.
- Desain visual.
- Jumlah akhir unit dan pelajaran.
- Metode pembayaran.

---

## 3. Permasalahan yang Ingin Diselesaikan

Pengguna Indonesia yang belajar bahasa Jepang sering menghadapi masalah berikut:

- Materi tersebar di banyak sumber.
- Penjelasan sering menggunakan Bahasa Inggris.
- Latihan tidak menyesuaikan kemampuan pengguna.
- Soal yang sama muncul berulang tanpa variasi.
- Pengguna kesulitan mengetahui materi yang belum dikuasai.
- Pengguna tidak memiliki jadwal pengulangan.
- Aplikasi latihan JLPT sering hanya memberikan soal tanpa pembahasan.
- Pengguna pemula kesulitan menentukan urutan belajar.
- Latihan mendengarkan sering tidak terhubung langsung dengan materi.
- Soal yang dibuat AI berpotensi salah atau ambigu apabila tidak diperiksa.

Produk ini menyelesaikan masalah tersebut dengan menyediakan kurikulum terstruktur, soal dinamis, pembahasan Bahasa Indonesia, pengulangan otomatis, dan sistem review soal.

---

## 4. Visi Produk

Membangun platform belajar bahasa Jepang berbahasa Indonesia yang menyediakan kurikulum terstruktur, latihan dinamis, pembelajaran adaptif, serta evaluasi kemampuan berdasarkan progres dan kesalahan pengguna.

---

## 5. Tujuan Produk

### 5.1 Tujuan utama

- Memberikan jalur belajar Bahasa Jepang yang terstruktur.
- Menyediakan materi yang telah diverifikasi.
- Menghasilkan variasi soal secara efisien menggunakan AI.
- Menghindari soal AI yang salah melalui proses review.
- Menyediakan latihan mendengarkan yang sesuai materi.
- Menyimpan perkembangan setiap pengguna.
- Menentukan materi yang perlu dipelajari kembali.
- Menyediakan latihan dan simulasi JLPT N5 sampai N1.
- Menyediakan API yang mudah digunakan oleh frontend apa pun.
- Menyediakan dokumentasi endpoint yang lengkap dan selalu diperbarui.

### 5.2 Tujuan MVP

MVP dianggap berhasil ketika sistem dapat:

1. Mengelola pengguna dan autentikasi.
2. Mengelola kurikulum.
3. Mengelola materi dasar dan N5.
4. Mengelola bank soal.
5. Menghasilkan draft soal menggunakan AI.
6. Memvalidasi struktur soal AI.
7. Memungkinkan reviewer menyetujui atau menolak soal.
8. Menyediakan sesi latihan kepada pengguna.
9. Memeriksa jawaban.
10. Menyimpan nilai dan progres.
11. Menyediakan latihan mendengarkan.
12. Menentukan materi yang perlu diulang.
13. Menyediakan dokumentasi Swagger, ReDoc, OpenAPI, Postman, dan panduan frontend.

---

## 6. Hal yang Tidak Termasuk dalam MVP

- Latihan berbicara.
- Penilaian pengucapan.
- Speech-to-text.
- Percakapan menggunakan mikrofon.
- Pengenalan tulisan tangan.
- Kanji tracing.
- Penilaian urutan goresan kanji.
- Pengunggahan PDF oleh pengguna.
- Pembuatan materi bebas oleh pengguna.
- JLPT N4, N3, N2, dan N1 pada rilis pertama.
- Pembayaran dan langganan.
- Forum komunitas.
- Kelas langsung dengan guru.
- Video pembelajaran.
- Aplikasi offline penuh.
- Chat tutor AI bebas.
- Papan peringkat global.
- Frontend web atau mobile.

---

## 7. Target Pengguna

### 7.1 Pelajar pemula

Pengguna yang belum memahami huruf Jepang dan ingin mulai dari hiragana serta katakana.

### 7.2 Pelajar JLPT

Pengguna yang ingin mempersiapkan diri untuk JLPT N5, N4, N3, N2, atau N1.

### 7.3 Pelajar mandiri

Pengguna yang ingin belajar berdasarkan jadwal sendiri dan membutuhkan pengulangan otomatis.

### 7.4 Administrator

Pengguna yang mengelola akun, kurikulum, konfigurasi, dan operasional sistem.

### 7.5 Content editor

Pengguna yang memasukkan kosakata, kanji, tata bahasa, contoh kalimat, materi membaca, materi mendengarkan, dan soal manual.

### 7.6 Reviewer

Pengguna yang memeriksa soal yang dibuat AI sebelum dipublikasikan.

---

## 8. Peran dan Hak Akses

### 8.1 Learner

Dapat:

- Melihat materi yang tersedia.
- Mengikuti sesi belajar.
- Menjawab soal.
- Mendengarkan audio.
- Melihat pembahasan.
- Melihat progres.
- Melihat daftar kesalahan.
- Mengikuti sesi pengulangan.
- Mengelola profil sendiri.
- Mengikuti latihan dan simulasi JLPT.

Tidak dapat:

- Melihat kunci jawaban sebelum menjawab.
- Melihat soal yang belum dipublikasikan.
- Mengakses endpoint administrator.
- Mengubah materi dan soal.

### 8.2 Content editor

Dapat:

- Membuat dan memperbarui materi.
- Membuat soal manual.
- Menjalankan generator soal AI.
- Mengunggah audio.
- Melihat draft soal.

### 8.3 Reviewer

Dapat:

- Melihat draft soal.
- Memperbaiki draft.
- Menyetujui soal.
- Menolak soal.
- Memberikan catatan review.
- Menonaktifkan soal bermasalah.

### 8.4 Administrator

Memiliki seluruh hak akses, termasuk manajemen akun, role, kurikulum, AI, TTS, audit log, statistik, dan publikasi.

---

## 9. Ruang Lingkup Konten MVP

### 9.1 Dasar Bahasa Jepang

- Pengenalan sistem penulisan.
- Hiragana dasar.
- Dakuten.
- Handakuten.
- Yōon.
- Sokuon.
- Bunyi panjang.
- Katakana dasar.
- Salam.
- Perkenalan.
- Angka.
- Waktu.
- Hari dan tanggal.

### 9.2 JLPT N5 inti

- Kosakata dasar.
- Kanji dasar.
- Partikel は, が, を, に, へ, で, と, も, の.
- Bentuk ます.
- Bentuk negatif.
- Bentuk lampau.
- Bentuk て.
- Kata sifat い.
- Kata sifat な.
- Kata tunjuk.
- Kata tanya.
- Kalimat keberadaan.
- Aktivitas harian.
- Keluarga.
- Sekolah.
- Makanan.
- Transportasi.
- Tempat.
- Cuaca.
- Hobi.
- Belanja.

### 9.3 Target konten awal

- 10 unit pembelajaran.
- 25–30 pelajaran.
- 300 kosakata.
- 80 kanji.
- 30–40 poin tata bahasa.
- 150 contoh kalimat.
- 30 bacaan pendek.
- 50 materi audio.
- 500 soal yang telah disetujui.
- Minimal 20 soal untuk setiap pelajaran utama.

---

## 10. Struktur Kurikulum

```text
Level
└── Course
    └── Unit
        └── Lesson
            ├── Lesson Section
            ├── Vocabulary
            ├── Kanji
            ├── Grammar
            ├── Example Sentence
            ├── Reading Content
            ├── Listening Content
            └── Questions
```

Contoh:

```text
Level: Dasar
└── Course: Dasar Bahasa Jepang
    └── Unit: Hiragana
        ├── Lesson: あ sampai お
        ├── Lesson: か sampai こ
        └── Lesson: さ sampai そ
```

Contoh N5:

```text
Level: JLPT N5
└── Course: Bahasa Jepang N5
    └── Unit: Perkenalan
        ├── Lesson: Memperkenalkan nama
        ├── Lesson: Menyebutkan asal
        └── Lesson: Menyebutkan pekerjaan
```

---

## 11. Jenis Soal MVP

### 11.1 Pilihan ganda

Digunakan untuk kosakata, tata bahasa, kanji, membaca, dan mendengarkan.

### 11.2 Cloze pilihan ganda

Contoh:

```text
わたしは学校 ___ 行きます。

A. に
B. を
C. が
D. で
```

### 11.3 Benar atau salah

Digunakan untuk bacaan dan listening.

### 11.4 Mencocokkan

Backend mengirim pasangan item, frontend mengatur tampilan interaktif.

### 11.5 Mengurutkan kata

Backend mengirim potongan kata dan urutan jawaban.

### 11.6 Membaca kanji

Pengguna memilih cara baca yang benar.

### 11.7 Pemahaman bacaan

Satu bacaan dapat memiliki beberapa pertanyaan.

### 11.8 Mendengarkan pilihan ganda

Frontend memainkan audio, lalu pengguna memilih jawaban.

### 11.9 Mendengarkan benar atau salah

Pengguna memeriksa kesesuaian pernyataan dengan audio.

### 11.10 Mendengarkan dengan gambar

Backend menyediakan audio dan daftar aset gambar.

### 11.11 Ditunda ke versi berikutnya

- Dikte bebas.
- Jawaban teks panjang.
- Terjemahan bebas.
- Penilaian semantik.
- Tulisan tangan.
- Percakapan suara.

---

## 12. Alur Pengguna

### 12.1 Registrasi

1. Pengguna membuat akun.
2. Sistem memvalidasi email.
3. Password di-hash.
4. Pengguna memperoleh access token dan refresh token.
5. Pengguna melengkapi profil.
6. Pengguna memilih target level.

### 12.2 Belajar pelajaran

1. Pengguna membuka level.
2. Pengguna memilih course.
3. Pengguna membuka unit.
4. Pengguna memilih lesson.
5. Backend mengembalikan materi.
6. Pengguna membaca materi.
7. Pengguna memulai sesi latihan.
8. Backend memilih soal.
9. Pengguna menjawab.
10. Backend memeriksa jawaban.
11. Backend memberikan pembahasan.
12. Backend memperbarui progres dan mastery.
13. Backend menentukan jadwal review.

### 12.3 Pengulangan

1. Pengguna membuka daftar review.
2. Backend mencari materi jatuh tempo.
3. Backend membuat sesi review.
4. Pengguna menjawab soal.
5. Sistem menghitung ulang mastery.
6. Sistem menetapkan jadwal review berikutnya.

### 12.4 Pembuatan soal AI

1. Content editor memilih lesson.
2. Content editor memilih jenis soal.
3. Content editor menentukan jumlah dan kesulitan.
4. Backend membuat generation job.
5. Worker mengambil materi sumber.
6. AI menghasilkan data JSON.
7. Backend memvalidasi JSON.
8. Backend memeriksa opsi dan kunci jawaban.
9. Backend memeriksa duplikasi.
10. Soal disimpan sebagai draft.
11. Reviewer memeriksa.
12. Reviewer menyetujui, menolak, atau meminta revisi.
13. Soal yang disetujui dapat dipublikasikan.

### 12.5 Evaluasi Otomatis dengan RAG

1. Learner meminta "Kuis Evaluasi" untuk sebuah *Lesson* tertentu.
2. Backend (RAG Pipeline) menarik silabus resmi dari *database* (Kosakata, Kanji, dan Tata Bahasa khusus *Lesson* tersebut) yang telah diinput Admin.
3. Backend menyuntikkan silabus resmi ini sebagai konteks (RAG) ke dalam *prompt* AI.
4. AI meng-generate soal unik secara dinamis yang *strict* hanya menggunakan materi dari silabus tersebut.
5. Soal disajikan kepada Learner sebagai sesi kuis evaluasi *real-time*.

---

## 13. Persyaratan Fungsional

### FR-001 — Autentikasi

Sistem menyediakan:

- Registrasi.
- Login.
- Refresh token.
- Logout.
- Lupa password.
- Reset password.
- Verifikasi email.
- Perubahan password.
- Informasi pengguna aktif.

### FR-002 — Manajemen pengguna

- Melihat profil.
- Mengubah nama.
- Mengubah foto.
- Menyimpan timezone.
- Menyimpan target level.
- Menonaktifkan akun.
- Menghapus sesi login.
- Menampilkan riwayat aktivitas belajar.

### FR-003 — Manajemen role

Role:

- Learner.
- Content editor.
- Reviewer.
- Administrator.

### FR-004 — Manajemen level

Administrator dapat membuat, mengubah, mengurutkan, mengaktifkan, dan menonaktifkan level.

### FR-005 — Manajemen course

Administrator dapat mengelola judul, deskripsi, level, gambar, status, urutan, dan jumlah pelajaran.

### FR-006 — Manajemen unit

Administrator dapat membuat unit, menghubungkan ke course, mengatur urutan, dan syarat pembukaan.

### FR-007 — Manajemen lesson

Lesson memiliki:

- Judul.
- Slug.
- Tujuan belajar.
- Ringkasan.
- Level.
- Unit.
- Urutan.
- Status.
- Estimasi durasi.
- Passing score.
- Konten pembelajaran.

### FR-008 — Materi kosakata

- Kata Jepang.
- Kana.
- Romaji.
- Arti Bahasa Indonesia.
- Kelas kata.
- Level.
- Contoh penggunaan.
- Audio.
- Catatan.
- Status publikasi.

### FR-009 — Materi kanji

- Karakter.
- Arti.
- Onyomi.
- Kunyomi.
- Level.
- Kosakata contoh.
- Radikal.
- Jumlah goresan.
- Contoh kalimat.
- Status publikasi.

### FR-010 — Materi tata bahasa

- Nama pola.
- Struktur.
- Penjelasan Bahasa Indonesia.
- Batasan penggunaan.
- Contoh benar.
- Contoh salah.
- Level.
- Perbandingan dengan pola lain.
- Status publikasi.

### FR-011 — Materi membaca

- Judul.
- Teks Jepang.
- Furigana opsional.
- Terjemahan.
- Kosakata kunci.
- Level.
- Tingkat kesulitan.
- Pertanyaan terkait.

### FR-012 — Materi mendengarkan

- Judul.
- File audio.
- Transkrip.
- Terjemahan.
- Durasi.
- Speaker.
- Level.
- Topik.
- Status.

### FR-013 — Bank soal

Setiap soal memiliki:

- ID publik.
- Lesson.
- Skill.
- Tipe.
- Tingkat kesulitan.
- Pertanyaan.
- Pilihan.
- Kunci jawaban.
- Pembahasan.
- Materi sumber.
- Status.
- Versi.
- Penanda AI atau manual.
- Pembuat.
- Reviewer.
- Tanggal publikasi.

### FR-014 — Status soal

```text
DRAFT
AUTO_VALIDATED
NEEDS_REVISION
APPROVED
PUBLISHED
REJECTED
ARCHIVED
```

Hanya soal `PUBLISHED` yang diberikan kepada learner.

### FR-015 — Generator soal AI

Content editor menentukan:

- Lesson sumber.
- Skill.
- Jenis soal.
- Jumlah soal.
- Tingkat kesulitan.
- Bahasa pembahasan.
- Apakah perlu audio.
- Catatan tambahan.
- Versi prompt.

### FR-016 — Validasi otomatis soal

- Pertanyaan tidak kosong.
- Tipe soal valid.
- Jumlah opsi sesuai.
- Opsi tidak duplikat.
- Kunci jawaban tersedia.
- Hanya satu jawaban benar untuk single choice.
- Jawaban benar termasuk dalam opsi.
- Lesson sumber tersedia.
- Tingkat kesulitan valid.
- Pembahasan tersedia.
- Tidak sama dengan soal lain.
- Tidak mengandung jawaban pada pertanyaan.
- Struktur JSON sesuai schema.

### FR-017 — Review soal

Reviewer dapat melihat sumber, hasil AI, mengubah soal, memberi catatan, menyetujui, menolak, dan melihat riwayat perubahan.

### FR-018 — Publikasi soal

Soal hanya dipublikasikan jika:

- Lulus validasi otomatis.
- Disetujui reviewer.
- Memiliki kunci jawaban.
- Memiliki pembahasan.
- Terhubung dengan lesson.
- Tidak dinonaktifkan.

### FR-019 — Pembuatan sesi latihan

Sesi berdasarkan:

- Lesson.
- Unit.
- Skill.
- Review.
- Kesalahan sebelumnya.
- Latihan harian.
- Simulasi JLPT.

### FR-020 — Penyimpanan jawaban

Setiap jawaban menyimpan:

- User.
- Session.
- Question.
- Jawaban pengguna.
- Benar atau salah.
- Nilai.
- Waktu menjawab.
- Nomor percobaan.
- Feedback.
- Tanggal.

### FR-021 — Pemeriksaan jawaban

MVP menggunakan aturan pasti:

- ID pilihan.
- Boolean.
- Urutan ID.
- Pasangan ID.
- Nilai yang dinormalisasi.

### FR-022 — Mode latihan dan ujian

Mode latihan:

- Jawaban diperiksa langsung.
- Pembahasan langsung.
- Jawaban benar dapat ditampilkan.

Mode ujian:

- Jawaban tidak diperiksa langsung.
- Pembahasan disembunyikan.
- Hasil diberikan setelah selesai.
- Urutan soal dan opsi dapat diacak.

### FR-023 — Progress lesson

- Belum mulai.
- Sedang dipelajari.
- Selesai.
- Nilai terbaik.
- Nilai terakhir.
- Jumlah percobaan.
- Tanggal terakhir belajar.
- Persentase penyelesaian.

### FR-024 — Mastery

Mastery berdasarkan:

- Kosakata.
- Kanji.
- Grammar.
- Membaca.
- Mendengarkan.
- Lesson.
- Unit.
- Level JLPT.

Nilai 0–100.

### FR-025 — SRS dan review

Sistem menyimpan:

- mastery_score.
- last_reviewed_at.
- next_review_at.
- review_interval.
- correct_streak.
- incorrect_count.

Interval awal:

```text
Jawaban pertama benar: 1 hari
Benar berikutnya: 3 hari
Benar berikutnya: 7 hari
Benar berikutnya: 14 hari
Benar berikutnya: 30 hari
Jawaban salah: kembali ke interval pendek
```

### FR-026 — Buku kesalahan

Menampilkan:

- Soal yang salah.
- Jumlah kesalahan.
- Pembahasan.
- Lesson terkait.
- Waktu terakhir salah.
- Status dipelajari ulang.

### FR-027 — XP

XP diberikan untuk:

- Menyelesaikan lesson.
- Menjawab benar.
- Menyelesaikan review.
- Menyelesaikan target harian.

### FR-028 — Streak

Streak dihitung berdasarkan timezone pengguna.

### FR-029 — Dashboard progres

Backend menyediakan:

- Level aktif.
- Course aktif.
- Lesson terakhir.
- Lesson selesai.
- Total waktu belajar.
- Akurasi.
- XP.
- Streak.
- Review jatuh tempo.
- Skill terkuat.
- Skill terlemah.
- Rekomendasi latihan.
- Prediksi kesiapan JLPT.

### FR-030 — Simulasi JLPT

Sistem mendukung:

- Pilihan level N5 sampai N1.
- Bagian kosakata dan kanji.
- Bagian tata bahasa dan membaca.
- Bagian mendengarkan.
- Timer.
- Penilaian per bagian.
- Riwayat simulasi.
- Analisis kelemahan.
- Rekomendasi belajar.

### FR-031 — Audit log

Mencatat tindakan administratif, perubahan konten, review, publikasi, role, dan konfigurasi.

---

## 14. Persyaratan Nonfungsional

### NFR-001 — Format API

- REST API.
- JSON.
- Prefix `/api/v1`.
- Field `snake_case`.
- Tanggal ISO 8601.
- Waktu disimpan UTC.
- Timezone pengguna terpisah.
- ID publik menggunakan UUID.
- ID internal dapat menggunakan BIGINT.

### NFR-002 — Performa

- Response p95 endpoint biasa di bawah 500 ms.
- Pagination untuk endpoint daftar.
- Hindari query N+1.
- Audio melalui object storage atau CDN.
- AI dan TTS tidak memblokir request utama.

### NFR-003 — Skalabilitas

Komponen dapat dipisahkan menjadi:

- API server.
- Worker AI.
- Worker TTS.
- MySQL.
- Redis.
- Object storage.

### NFR-004 — Keamanan

- Password di-hash.
- JWT memiliki masa berlaku.
- Refresh token dapat dicabut.
- Role-based access control.
- Rate limit login dan generator.
- CORS allowlist.
- Secret di environment variable.
- Log tidak menyimpan token atau password.
- Jawaban benar tidak bocor.
- Upload audio divalidasi.
- Seluruh input divalidasi.

### NFR-005 — Ketersediaan

- Health check.
- Readiness check.
- Backup database.
- Migration terkontrol.
- Job gagal dapat diulang.

### NFR-006 — Maintainability

- Struktur modular.
- Business logic tidak di router.
- Repository terpisah.
- Provider AI dapat diganti.
- Provider TTS dapat diganti.
- Provider storage dapat diganti.
- Unit test.
- Dokumentasi endpoint.

### NFR-007 — Dukungan karakter Jepang

Database menggunakan `utf8mb4`.

---

## 15. Rekomendasi Teknologi Backend

### Stack utama

- Python.
- FastAPI.
- Pydantic.
- SQLAlchemy ORM.
- Alembic.
- MySQL.
- PyMySQL atau asyncmy.
- Uvicorn.
- Pytest.
- HTTPX.
- Ruff.
- Docker.

### Komponen tambahan

- Redis.
- Celery.
- S3-compatible object storage.
- Provider AI melalui adapter.
- Provider TTS melalui adapter.
- SMTP provider.

### Provider abstraction

```text
QuestionGeneratorProvider
TextToSpeechProvider
ObjectStorageProvider
EmailProvider
```

---

## 16. Arsitektur Backend

```text
Frontend
    │
    ▼
REST API /api/v1
    │
    ▼
FastAPI Router
    │
    ▼
Service Layer
 ┌──┼───────────┐
 ▼  ▼           ▼
Repository     AI/TTS Provider
 │              │
 ▼              ▼
MySQL         Worker
                 │
               Redis
                 │
          Object Storage
```

### Lapisan aplikasi

- Router layer.
- Schema layer.
- Service layer.
- Repository layer.
- Integration layer.
- Worker layer.

---

## 17. Struktur Folder

```text
nihongo_learning_api/
├── app/
│   ├── main.py
│   ├── api/
│   │   ├── dependencies.py
│   │   └── v1/
│   │       ├── router.py
│   │       └── endpoints/
│   │           ├── auth.py
│   │           ├── users.py
│   │           ├── curriculum.py
│   │           ├── lessons.py
│   │           ├── learning_sessions.py
│   │           ├── progress.py
│   │           ├── reviews.py
│   │           ├── simulations.py
│   │           ├── audio.py
│   │           └── admin/
│   ├── core/
│   ├── models/
│   ├── schemas/
│   ├── repositories/
│   ├── services/
│   ├── integrations/
│   ├── workers/
│   └── utils/
├── alembic/
├── docs/
│   ├── API_OVERVIEW.md
│   ├── FRONTEND_INTEGRATION.md
│   ├── AUTHENTICATION.md
│   ├── ERROR_CODES.md
│   ├── QUESTION_TYPES.md
│   ├── JLPT_SIMULATION.md
│   └── CHANGELOG.md
├── scripts/
├── tests/
├── .env.example
├── alembic.ini
├── docker-compose.yml
├── Dockerfile
├── pyproject.toml
└── README.md
```

---

## 18. Desain Database

### 18.1 Autentikasi

#### users

- id
- public_id
- email
- password_hash
- full_name
- avatar_url
- role_id
- timezone
- target_level_id
- email_verified_at
- is_active
- last_login_at
- created_at
- updated_at

#### roles

- id
- name
- description

#### refresh_tokens

- id
- user_id
- token_hash
- expires_at
- revoked_at
- device_info
- ip_address
- created_at

#### password_reset_tokens

- id
- user_id
- token_hash
- expires_at
- used_at

### 18.2 Kurikulum

#### levels

- id
- public_id
- code
- name
- description
- order_number
- is_active

#### courses

- id
- public_id
- level_id
- title
- slug
- description
- image_url
- order_number
- status

#### units

- id
- public_id
- course_id
- title
- slug
- description
- order_number
- status

#### lessons

- id
- public_id
- unit_id
- title
- slug
- summary
- learning_objectives
- estimated_minutes
- passing_score
- order_number
- status
- published_at

#### lesson_sections

- id
- lesson_id
- section_type
- title
- content_json
- order_number
- status

### 18.3 Materi

#### vocabularies

- id
- public_id
- expression
- kana
- romaji
- meaning_id
- part_of_speech
- level_id
- notes
- status

#### kanjis

- id
- public_id
- character
- meaning_id
- onyomi_json
- kunyomi_json
- radical
- stroke_count
- level_id
- notes
- status

#### grammar_points

- id
- public_id
- title
- pattern
- explanation_id
- formation_json
- notes
- level_id
- status

#### example_sentences

- id
- public_id
- japanese_text
- reading_text
- translation_id
- level_id
- source_type
- source_id
- status

#### readings

- id
- public_id
- lesson_id
- title
- japanese_text
- furigana_json
- translation_id
- difficulty
- status

#### audio_assets

- id
- public_id
- lesson_id
- title
- storage_path
- public_url
- transcript
- translation_id
- duration_seconds
- speaker
- source_type
- provider
- status

### 18.4 Soal

#### questions

- id
- public_id
- lesson_id
- reading_id
- audio_asset_id
- type
- skill
- difficulty
- prompt_json
- answer_key_json
- explanation_json
- status
- source_type
- source_id
- is_ai_generated
- prompt_version
- version_number
- created_by
- reviewed_by
- reviewed_at
- published_at
- created_at
- updated_at

#### question_options

- id
- public_id
- question_id
- label
- content_json
- is_correct
- order_number

#### question_reviews

- id
- question_id
- reviewer_id
- action
- notes
- before_json
- after_json
- created_at

#### generation_jobs

- id
- public_id
- lesson_id
- requested_by
- provider
- model_name
- parameters_json
- status
- total_requested
- total_generated
- total_valid
- total_invalid
- error_message
- started_at
- finished_at
- created_at

### 18.5 Pembelajaran

#### learning_sessions

- id
- public_id
- user_id
- mode
- lesson_id
- unit_id
- jlpt_level_id
- status
- total_questions
- answered_questions
- correct_answers
- score
- started_at
- completed_at

#### learning_session_questions

- id
- session_id
- question_id
- order_number
- option_order_json
- answered_at

#### user_answers

- id
- user_id
- session_id
- question_id
- answer_json
- is_correct
- score
- response_time_ms
- feedback_json
- created_at

### 18.6 Progress

#### user_lesson_progress

- id
- user_id
- lesson_id
- status
- progress_percent
- best_score
- last_score
- attempt_count
- completed_at
- last_studied_at

#### user_masteries

- id
- user_id
- entity_type
- entity_id
- mastery_score
- correct_count
- incorrect_count
- correct_streak
- last_reviewed_at
- next_review_at
- review_interval_days

#### user_mistakes

- id
- user_id
- question_id
- mistake_count
- last_mistake_at
- resolved_at

#### xp_transactions

- id
- user_id
- source_type
- source_id
- amount
- description
- created_at

#### user_streaks

- id
- user_id
- current_streak
- longest_streak
- last_activity_date

### 18.7 Simulasi JLPT

#### jlpt_simulations

- id
- public_id
- level_id
- title
- description
- duration_minutes
- passing_score
- status
- published_at

#### jlpt_simulation_sections

- id
- simulation_id
- section_type
- order_number
- duration_minutes
- question_count

#### jlpt_simulation_questions

- id
- section_id
- question_id
- order_number

#### user_simulation_attempts

- id
- public_id
- user_id
- simulation_id
- status
- total_score
- started_at
- completed_at

#### user_simulation_section_scores

- id
- attempt_id
- section_id
- score
- correct_answers
- total_questions

---

## 19. Index Database Penting

```text
users.email UNIQUE
users.public_id UNIQUE
courses.slug UNIQUE
lessons.slug UNIQUE
questions.public_id UNIQUE
questions(lesson_id, status, skill, difficulty)
questions(status, published_at)
generation_jobs(status, created_at)
learning_sessions(user_id, started_at)
user_answers(user_id, question_id)
user_lesson_progress(user_id, lesson_id) UNIQUE
user_masteries(user_id, entity_type, entity_id) UNIQUE
user_masteries(user_id, next_review_at)
user_mistakes(user_id, resolved_at)
audio_assets(status, lesson_id)
audit_logs(entity_type, entity_id)
user_simulation_attempts(user_id, simulation_id)
```

---

## 20. Standar API

### Base URL

```text
/api/v1
```

### Response berhasil

```json
{
  "success": true,
  "message": "Data berhasil diambil.",
  "data": {},
  "meta": {
    "request_id": "uuid"
  }
}
```

### Response pagination

```json
{
  "success": true,
  "message": "Data berhasil diambil.",
  "data": [],
  "meta": {
    "pagination": {
      "page": 1,
      "per_page": 20,
      "total_items": 125,
      "total_pages": 7,
      "has_next": true,
      "has_previous": false
    },
    "request_id": "uuid"
  }
}
```

### Response error

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Data yang diberikan tidak valid.",
    "details": [
      {
        "field": "email",
        "message": "Format email tidak valid."
      }
    ]
  },
  "meta": {
    "request_id": "uuid"
  }
}
```

### Status HTTP

- 200 OK.
- 201 Created.
- 202 Accepted.
- 204 No Content.
- 400 Bad Request.
- 401 Unauthorized.
- 403 Forbidden.
- 404 Not Found.
- 409 Conflict.
- 422 Unprocessable Entity.
- 429 Too Many Requests.
- 500 Internal Server Error.

---

## 21. Daftar Endpoint MVP

### System

```text
GET    /health
GET    /ready
GET    /api/v1/meta
```

### Authentication

```text
POST   /api/v1/auth/register
POST   /api/v1/auth/login
POST   /api/v1/auth/refresh
POST   /api/v1/auth/logout
POST   /api/v1/auth/forgot-password
POST   /api/v1/auth/reset-password
POST   /api/v1/auth/verify-email
POST   /api/v1/auth/resend-verification
```

### User

```text
GET    /api/v1/users/me
PATCH  /api/v1/users/me
PATCH  /api/v1/users/me/password
DELETE /api/v1/users/me
GET    /api/v1/users/me/sessions
DELETE /api/v1/users/me/sessions/{session_id}
```

### Curriculum learner

```text
GET    /api/v1/levels
GET    /api/v1/levels/{level_id}
GET    /api/v1/levels/{level_id}/courses
GET    /api/v1/courses/{course_id}
GET    /api/v1/courses/{course_id}/units
GET    /api/v1/units/{unit_id}
GET    /api/v1/units/{unit_id}/lessons
GET    /api/v1/lessons/{lesson_id}
GET    /api/v1/lessons/{lesson_id}/content
GET    /api/v1/lessons/{lesson_id}/progress
```

### Learning sessions

```text
POST   /api/v1/learning-sessions
GET    /api/v1/learning-sessions/{session_id}
POST   /api/v1/learning-sessions/{session_id}/answers
POST   /api/v1/learning-sessions/{session_id}/complete
DELETE /api/v1/learning-sessions/{session_id}
```

### Reviews

```text
GET    /api/v1/reviews/summary
GET    /api/v1/reviews/due
POST   /api/v1/reviews/sessions
```

### Progress

```text
GET    /api/v1/progress/overview
GET    /api/v1/progress/skills
GET    /api/v1/progress/lessons
GET    /api/v1/progress/activity
GET    /api/v1/progress/mistakes
GET    /api/v1/progress/mistakes/{question_id}
```

### Audio

```text
GET    /api/v1/audio/{audio_id}
```

### Simulasi JLPT

```text
GET    /api/v1/jlpt-simulations
GET    /api/v1/jlpt-simulations/{simulation_id}
POST   /api/v1/jlpt-simulations/{simulation_id}/attempts
GET    /api/v1/jlpt-simulation-attempts/{attempt_id}
POST   /api/v1/jlpt-simulation-attempts/{attempt_id}/answers
POST   /api/v1/jlpt-simulation-attempts/{attempt_id}/complete
GET    /api/v1/jlpt-simulation-attempts/{attempt_id}/result
```

### Admin curriculum

```text
GET    /api/v1/admin/levels
POST   /api/v1/admin/levels
GET    /api/v1/admin/levels/{level_id}
PATCH  /api/v1/admin/levels/{level_id}
DELETE /api/v1/admin/levels/{level_id}

GET    /api/v1/admin/courses
POST   /api/v1/admin/courses
GET    /api/v1/admin/courses/{course_id}
PATCH  /api/v1/admin/courses/{course_id}
DELETE /api/v1/admin/courses/{course_id}

GET    /api/v1/admin/units
POST   /api/v1/admin/units
PATCH  /api/v1/admin/units/{unit_id}
DELETE /api/v1/admin/units/{unit_id}

GET    /api/v1/admin/lessons
POST   /api/v1/admin/lessons
GET    /api/v1/admin/lessons/{lesson_id}
PATCH  /api/v1/admin/lessons/{lesson_id}
DELETE /api/v1/admin/lessons/{lesson_id}
POST   /api/v1/admin/lessons/{lesson_id}/publish
POST   /api/v1/admin/lessons/{lesson_id}/unpublish
```

### Admin content

```text
GET    /api/v1/admin/vocabularies
POST   /api/v1/admin/vocabularies
PATCH  /api/v1/admin/vocabularies/{vocabulary_id}
DELETE /api/v1/admin/vocabularies/{vocabulary_id}

GET    /api/v1/admin/kanjis
POST   /api/v1/admin/kanjis
PATCH  /api/v1/admin/kanjis/{kanji_id}
DELETE /api/v1/admin/kanjis/{kanji_id}

GET    /api/v1/admin/grammar-points
POST   /api/v1/admin/grammar-points
PATCH  /api/v1/admin/grammar-points/{grammar_id}
DELETE /api/v1/admin/grammar-points/{grammar_id}

GET    /api/v1/admin/readings
POST   /api/v1/admin/readings
PATCH  /api/v1/admin/readings/{reading_id}
DELETE /api/v1/admin/readings/{reading_id}

GET    /api/v1/admin/audio
POST   /api/v1/admin/audio
PATCH  /api/v1/admin/audio/{audio_id}
DELETE /api/v1/admin/audio/{audio_id}
```

### Admin questions

```text
GET    /api/v1/admin/questions
POST   /api/v1/admin/questions
GET    /api/v1/admin/questions/{question_id}
PATCH  /api/v1/admin/questions/{question_id}
DELETE /api/v1/admin/questions/{question_id}

POST   /api/v1/admin/questions/{question_id}/submit-review
POST   /api/v1/admin/questions/{question_id}/approve
POST   /api/v1/admin/questions/{question_id}/reject
POST   /api/v1/admin/questions/{question_id}/publish
POST   /api/v1/admin/questions/{question_id}/unpublish
GET    /api/v1/admin/questions/{question_id}/history
```

### AI generation

```text
POST   /api/v1/admin/generation-jobs
GET    /api/v1/admin/generation-jobs
GET    /api/v1/admin/generation-jobs/{job_id}
POST   /api/v1/admin/generation-jobs/{job_id}/retry
POST   /api/v1/admin/generation-jobs/{job_id}/cancel
GET    /api/v1/admin/generation-jobs/{job_id}/questions
```

### Admin simulasi JLPT

```text
GET    /api/v1/admin/jlpt-simulations
POST   /api/v1/admin/jlpt-simulations
GET    /api/v1/admin/jlpt-simulations/{simulation_id}
PATCH  /api/v1/admin/jlpt-simulations/{simulation_id}
DELETE /api/v1/admin/jlpt-simulations/{simulation_id}
POST   /api/v1/admin/jlpt-simulations/{simulation_id}/publish
POST   /api/v1/admin/jlpt-simulations/{simulation_id}/unpublish
```

### Admin analytics

```text
GET    /api/v1/admin/analytics/overview
GET    /api/v1/admin/analytics/questions
GET    /api/v1/admin/analytics/lessons
GET    /api/v1/admin/analytics/users
GET    /api/v1/admin/analytics/jlpt
GET    /api/v1/admin/audit-logs
```

---

## 22. Contoh Kontrak Endpoint

### Membuat sesi latihan

```http
POST /api/v1/learning-sessions
Authorization: Bearer {access_token}
Content-Type: application/json
```

```json
{
  "mode": "lesson",
  "lesson_id": "uuid",
  "question_count": 10,
  "skills": [
    "vocabulary",
    "grammar",
    "listening"
  ]
}
```

Response:

```json
{
  "success": true,
  "message": "Sesi latihan berhasil dibuat.",
  "data": {
    "session_id": "uuid",
    "mode": "lesson",
    "total_questions": 10,
    "started_at": "2026-07-06T12:00:00Z",
    "questions": [
      {
        "id": "uuid",
        "type": "multiple_choice",
        "skill": "grammar",
        "difficulty": 1,
        "prompt": {
          "text": "わたしは学校 ___ 行きます。"
        },
        "options": [
          {
            "id": "option-a",
            "text": "に"
          },
          {
            "id": "option-b",
            "text": "を"
          }
        ]
      }
    ]
  },
  "meta": {
    "request_id": "uuid"
  }
}
```

Kunci jawaban tidak dikirim.

### Mengirim jawaban

```http
POST /api/v1/learning-sessions/{session_id}/answers
Authorization: Bearer {access_token}
Content-Type: application/json
```

```json
{
  "question_id": "uuid",
  "answer": {
    "option_id": "option-b"
  },
  "response_time_ms": 8400
}
```

Response mode latihan:

```json
{
  "success": true,
  "message": "Jawaban berhasil diperiksa.",
  "data": {
    "is_correct": false,
    "score": 0,
    "correct_answer": {
      "option_id": "option-a",
      "text": "に"
    },
    "explanation": {
      "text": "Partikel に digunakan untuk menunjukkan tujuan pergerakan."
    },
    "mastery_change": -3
  },
  "meta": {
    "request_id": "uuid"
  }
}
```

### Menjalankan generator soal

```http
POST /api/v1/admin/generation-jobs
Authorization: Bearer {admin_or_editor_token}
Content-Type: application/json
```

```json
{
  "lesson_id": "uuid",
  "question_types": [
    "multiple_choice",
    "cloze_choice",
    "listening_multiple_choice"
  ],
  "skills": [
    "vocabulary",
    "grammar",
    "listening"
  ],
  "difficulty_min": 1,
  "difficulty_max": 2,
  "question_count": 20,
  "generate_explanation": true,
  "generate_audio": false
}
```

Response:

```json
{
  "success": true,
  "message": "Job pembuatan soal berhasil dimasukkan ke antrean.",
  "data": {
    "job_id": "uuid",
    "status": "QUEUED",
    "question_count": 20
  },
  "meta": {
    "request_id": "uuid"
  }
}
```

HTTP status: `202 Accepted`.

---

## 23. Kontrak Tipe Soal untuk Frontend

Struktur umum:

```json
{
  "id": "uuid",
  "type": "multiple_choice",
  "skill": "grammar",
  "difficulty": 1,
  "prompt": {},
  "options": [],
  "media": {},
  "settings": {}
}
```

### Multiple choice

```json
{
  "type": "multiple_choice",
  "prompt": {
    "text": "「りんご」の意味は何ですか。"
  },
  "options": [
    {
      "id": "a",
      "text": "Apel"
    }
  ],
  "settings": {
    "allow_multiple": false,
    "shuffle_options": true
  }
}
```

### Listening multiple choice

```json
{
  "type": "listening_multiple_choice",
  "prompt": {
    "text": "Apa yang dikatakan dalam audio?"
  },
  "media": {
    "audio_url": "https://storage.example.com/audio/abc.mp3",
    "duration_seconds": 4,
    "max_play_count": null,
    "transcript_visible": false
  },
  "options": []
}
```

### Matching

```json
{
  "type": "matching",
  "prompt": {
    "text": "Cocokkan kata berikut."
  },
  "left_items": [
    {
      "id": "l1",
      "text": "ねこ"
    }
  ],
  "right_items": [
    {
      "id": "r1",
      "text": "Kucing"
    }
  ]
}
```

### Ordering

```json
{
  "type": "ordering",
  "prompt": {
    "text": "Susun menjadi kalimat yang benar."
  },
  "items": [
    {
      "id": "i1",
      "text": "です"
    },
    {
      "id": "i2",
      "text": "わたし"
    }
  ]
}
```

---

## 24. Dokumentasi API untuk Frontend

Dokumentasi frontend merupakan bagian wajib produk.

### Dokumentasi otomatis

```text
/docs
/redoc
/openapi.json
```

### Dokumentasi manual

#### API_OVERVIEW.md

- Base URL.
- Versi API.
- Format JSON.
- Pagination.
- Filtering.
- Sorting.
- Timestamp.
- Environment.

#### FRONTEND_INTEGRATION.md

- Cara login.
- Cara menyimpan token.
- Cara refresh token.
- Cara menangani token kadaluarsa.
- Cara memulai sesi.
- Cara mengirim jawaban.
- Cara memainkan audio.
- Cara menampilkan error.
- Cara menangani pagination.
- Cara menampilkan question type.
- Cara menjalankan simulasi JLPT.
- Contoh alur lengkap.

#### AUTHENTICATION.md

- Access token.
- Refresh token.
- Masa berlaku.
- Authorization header.
- Logout.
- Revocation.
- Role dan permission.

#### ERROR_CODES.md

Contoh:

```text
AUTH_INVALID_CREDENTIALS
AUTH_TOKEN_EXPIRED
AUTH_REFRESH_TOKEN_INVALID
FORBIDDEN
RESOURCE_NOT_FOUND
VALIDATION_ERROR
LESSON_LOCKED
SESSION_ALREADY_COMPLETED
QUESTION_NOT_IN_SESSION
ANSWER_ALREADY_SUBMITTED
GENERATION_JOB_FAILED
QUESTION_NOT_APPROVED
AUDIO_NOT_AVAILABLE
SIMULATION_ALREADY_COMPLETED
RATE_LIMIT_EXCEEDED
```

#### QUESTION_TYPES.md

Berisi kontrak JSON seluruh jenis soal.

#### JLPT_SIMULATION.md

Berisi struktur simulasi, pembagian bagian ujian, timer, submit jawaban, dan hasil.

#### CHANGELOG.md

- Endpoint baru.
- Field baru.
- Field deprecated.
- Breaking change.
- Versi rilis.

### Persyaratan dokumentasi endpoint

Setiap endpoint wajib memiliki:

- summary.
- description.
- operation_id.
- tag.
- hak akses.
- request schema.
- contoh request.
- response schema.
- contoh response.
- response error.
- status HTTP.
- query parameter.
- pagination.
- side effect.
- idempotency.

### Postman

Backend menyediakan:

- Postman collection.
- Environment development.
- Environment staging.
- Contoh token.
- Folder per modul.
- Test otomatis sederhana.

### SDK frontend

OpenAPI dapat digunakan untuk menghasilkan:

- TypeScript.
- Dart.
- Kotlin.
- Swift.

### Contract testing

CI memastikan:

- openapi.json valid.
- Tidak ada operation_id duplikat.
- Response sesuai schema.
- Perubahan breaking terdeteksi.
- Dokumentasi selalu dapat dibangun.

---

## 25. Autentikasi dan Keamanan

### Token

- Access token 15–30 menit.
- Refresh token 30 hari.
- Refresh token disimpan dalam bentuk hash.
- Refresh token dapat dicabut per perangkat.
- Token memiliki `sub`, `role`, `exp`, dan `jti`.

### Password

- Minimal delapan karakter.
- Disimpan dengan algoritma hashing modern.
- Tidak pernah dicatat pada log.
- Reset password menggunakan token sekali pakai.

### RBAC

Dependency:

```text
get_current_user
require_role
require_any_role
```

### Perlindungan jawaban

- Schema learner tidak memiliki `is_correct`.
- Schema learner tidak memiliki `answer_key`.
- Endpoint admin dan learner memakai schema berbeda.
- Soal ujian tidak menampilkan pembahasan sebelum selesai.
- Cache tidak mencampur response admin dan learner.

### Rate limiting

- Login.
- Lupa password.
- Refresh token.
- Generator soal.
- Upload audio.
- Pencarian.

### File upload

Audio dibatasi berdasarkan:

- MIME type.
- Ekstensi.
- Ukuran.
- Durasi.
- Nama file acak.
- Lokasi penyimpanan.
- Pemeriksaan metadata.

---

## 26. Strategi AI

### Prinsip utama

- AI bukan sumber kebenaran utama.
- AI hanya menghasilkan draft.
- Sumber materi berasal dari database.
- Output berbentuk JSON.
- Output divalidasi Pydantic.
- Soal tidak langsung dipublikasikan.
- Semua prompt memiliki versi.
- Hasil mentah AI dapat disimpan untuk audit.
- Biaya dicatat per job.

### Isi prompt generator

- Level.
- Lesson.
- Tujuan belajar.
- Materi yang boleh digunakan.
- Daftar kosakata.
- Daftar kanji.
- Poin tata bahasa.
- Contoh soal.
- Tipe soal.
- Tingkat kesulitan.
- Format JSON.
- Larangan materi di luar level.
- Larangan jawaban ambigu.
- Pembahasan Bahasa Indonesia.

### Pipeline validasi

```text
Raw AI response
      ↓
JSON parsing
      ↓
Pydantic validation
      ↓
Business validation
      ↓
Duplicate detection
      ↓
Answer validation
      ↓
Draft question
      ↓
Human review
```

### Status job

```text
QUEUED
PROCESSING
COMPLETED
PARTIALLY_COMPLETED
FAILED
CANCELLED
```

---

## 27. Strategi Audio dan Listening

### Sumber audio

- Rekaman manusia.
- Text-to-speech.
- Import admin.

### Prioritas

- Materi utama menggunakan audio yang diperiksa.
- Soal dinamis dapat menggunakan TTS.
- Audio disimpan agar tidak dibuat ulang.
- File memiliki checksum.

### Playback speed

Kecepatan 0,75×, 1×, dan 1,25× ditangani frontend.

### Transkrip

```json
{
  "transcript_available": true,
  "transcript_visible": false
}
```

Setelah dijawab:

```json
{
  "transcript_visible": true,
  "transcript": "今日は暑いですね。"
}
```

---

## 28. Testing

### Unit test

- Password hashing.
- JWT.
- Scoring.
- Mastery.
- Review scheduling.
- Question validation.
- Japanese text normalization.
- Permission checking.

### Integration test

- Auth.
- CRUD curriculum.
- CRUD question.
- Session creation.
- Answer submission.
- Session completion.
- Progress update.
- Migration.

### API contract test

- Response sesuai OpenAPI.
- Field rahasia tidak bocor.
- Error response konsisten.
- Pagination konsisten.
- Role restriction berjalan.

### Worker test

- Generation berhasil.
- Generation gagal.
- Retry.
- Partial result.
- TTS.
- Penyimpanan audio.

### Security test

- Token kadaluarsa.
- Refresh token dicabut.
- Akses role salah.
- IDOR.
- Rate limit.
- Upload file palsu.
- Injection.
- Mass assignment.
- Jawaban benar tidak bocor.

### Target kualitas

- Coverage service penting minimal 80%.
- Endpoint autentikasi memiliki test.
- Endpoint learner memiliki contract test.
- Permission admin memiliki test.
- Migration diuji pada database kosong.

---

## 29. Logging dan Monitoring

Setiap request memiliki `request_id`.

Log minimum:

- Request method.
- Path.
- Status code.
- Response time.
- User ID.
- Request ID.
- Error code.
- Job ID.

Jangan mencatat:

- Password.
- Access token.
- Refresh token.
- Reset token.
- API key.

Monitoring minimum:

- Error rate.
- Response time.
- Database connection.
- Queue length.
- Generation job failure.
- TTS failure.
- Storage failure.
- Jumlah request.
- Penggunaan dan biaya AI.

---

## 30. Deployment

### Environment

- Local.
- Testing.
- Staging.
- Production.

### Komponen Docker

```text
api
worker
mysql
redis
```

### Environment variable

```text
APP_ENV
APP_NAME
APP_URL
API_V1_PREFIX

DATABASE_URL
REDIS_URL

JWT_SECRET_KEY
JWT_ACCESS_TOKEN_MINUTES
JWT_REFRESH_TOKEN_DAYS

AI_PROVIDER
AI_API_KEY
AI_MODEL

TTS_PROVIDER
TTS_API_KEY

STORAGE_PROVIDER
STORAGE_BUCKET
STORAGE_ENDPOINT
STORAGE_ACCESS_KEY
STORAGE_SECRET_KEY

SMTP_HOST
SMTP_PORT
SMTP_USERNAME
SMTP_PASSWORD

CORS_ORIGINS
```

### Database migration

- Tidak menggunakan create_all pada production.
- Semua perubahan schema menggunakan Alembic.
- Migration ditinjau sebelum dijalankan.
- Backup sebelum migration besar.
- Migration memiliki rollback.

---

## 31. Tahapan Pengembangan

### Sprint 0 — Finalisasi fondasi

- Finalisasi PRD.
- Menentukan repository.
- Membuat ERD.
- Menentukan konvensi API.
- Menentukan branch.
- Menentukan environment.

### Sprint 1 — Bootstrap backend

- FastAPI.
- Environment.
- MySQL.
- SQLAlchemy.
- Alembic.
- Logging.
- Error handler.
- Docker.

### Sprint 2 — Authentication dan user

- Register.
- Login.
- JWT.
- Refresh token.
- Logout.
- Profil.
- Role.
- Test auth.

### Sprint 3 — Curriculum dan content

- Level.
- Course.
- Unit.
- Lesson.
- Vocabulary.
- Kanji.
- Grammar.
- Reading.
- Audio metadata.

### Sprint 4 — Question bank

- Model question.
- Option.
- Schema tipe soal.
- CRUD.
- Validasi.
- Review.
- Publish.

### Sprint 5 — Learning engine

- Session.
- Selection.
- Submit answer.
- Scoring.
- Complete.
- Practice.
- Exam.

### Sprint 6 — Progress dan review

- Lesson progress.
- Mastery.
- SRS.
- Mistake book.
- XP.
- Streak.
- Dashboard.

### Sprint 7 — AI generator dan audio

- AI adapter.
- Prompt version.
- Generation job.
- Worker.
- JSON validation.
- TTS adapter.
- Audio job.
- Retry.

### Sprint 8 — Dokumentasi dan hardening

- Swagger.
- ReDoc.
- OpenAPI.
- Postman.
- Frontend guide.
- Contract test.
- Security test.
- Staging.

### Sprint 9 — Simulasi JLPT

- Struktur ujian.
- Bagian ujian.
- Timer.
- Penilaian.
- Riwayat.
- Analisis kemampuan.
- Dokumentasi frontend.

---

# 32. Checklist Pengembangan

## A. Perencanaan produk

- [ ] Nama sementara proyek ditentukan.
- [ ] Tujuan produk disetujui.
- [ ] Target pengguna disetujui.
- [ ] Ruang lingkup MVP dikunci.
- [ ] Fitur berbicara tidak termasuk.
- [ ] Fitur tulisan tangan tidak termasuk.
- [ ] Upload PDF pengguna tidak termasuk.
- [ ] Target konten dasar dan N5 disetujui.
- [ ] Target pengembangan N5–N1 disetujui.
- [ ] Role pengguna ditentukan.
- [ ] Kriteria keberhasilan MVP ditentukan.
- [ ] PRD dimasukkan ke repository.

## B. Persiapan repository

- [ ] Repository Git dibuat.
- [ ] README dibuat.
- [ ] `.gitignore` dibuat.
- [ ] `pyproject.toml` dibuat.
- [ ] `.env.example` dibuat.
- [ ] Branch strategy ditentukan.
- [ ] Conventional commit ditentukan.
- [ ] Pre-commit hook dikonfigurasi.
- [ ] Ruff dikonfigurasi.
- [ ] Pytest dikonfigurasi.
- [ ] Dockerfile dibuat.
- [ ] Docker Compose dibuat.

## C. Fondasi FastAPI

- [ ] `app/main.py` dibuat.
- [ ] Prefix `/api/v1` dibuat.
- [ ] Router utama dibuat.
- [ ] Metadata OpenAPI dibuat.
- [ ] Tag OpenAPI dibuat.
- [ ] Swagger tersedia di `/docs`.
- [ ] ReDoc tersedia di `/redoc`.
- [ ] OpenAPI tersedia di `/openapi.json`.
- [ ] Global exception handler dibuat.
- [ ] Response envelope dibuat.
- [ ] Request ID middleware dibuat.
- [ ] CORS dikonfigurasi.
- [ ] Health check dibuat.
- [ ] Readiness check dibuat.

## D. Database

- [ ] MySQL dijalankan.
- [ ] Database menggunakan `utf8mb4`.
- [ ] SQLAlchemy dikonfigurasi.
- [ ] Session database dibuat.
- [ ] Base model dibuat.
- [ ] Timestamp mixin dibuat.
- [ ] Public UUID mixin dibuat.
- [ ] Alembic dikonfigurasi.
- [ ] Migration pertama dibuat.
- [ ] Migration dapat dijalankan pada database kosong.
- [ ] Seed administrator dibuat.
- [ ] Index penting dibuat.
- [ ] Foreign key ditentukan.
- [ ] Aturan cascade ditinjau.
- [ ] Backup development diuji.

## E. Authentication

- [ ] Model user dibuat.
- [ ] Model role dibuat.
- [ ] Model refresh token dibuat.
- [ ] Password hashing dibuat.
- [ ] Registrasi dibuat.
- [ ] Login dibuat.
- [ ] JWT access token dibuat.
- [ ] Refresh token dibuat.
- [ ] Logout dibuat.
- [ ] Revocation token dibuat.
- [ ] Endpoint `users/me` dibuat.
- [ ] Perubahan profil dibuat.
- [ ] Perubahan password dibuat.
- [ ] Lupa password dibuat.
- [ ] Reset password dibuat.
- [ ] Email verification dibuat.
- [ ] Role dependency dibuat.
- [ ] Auth unit test dibuat.
- [ ] Auth integration test dibuat.
- [ ] Rate limit login dibuat.

## F. Kurikulum

- [ ] Model level dibuat.
- [ ] Model course dibuat.
- [ ] Model unit dibuat.
- [ ] Model lesson dibuat.
- [ ] Model lesson section dibuat.
- [ ] CRUD admin level dibuat.
- [ ] CRUD admin course dibuat.
- [ ] CRUD admin unit dibuat.
- [ ] CRUD admin lesson dibuat.
- [ ] Endpoint learner level dibuat.
- [ ] Endpoint learner course dibuat.
- [ ] Endpoint learner unit dibuat.
- [ ] Endpoint learner lesson dibuat.
- [ ] Urutan konten didukung.
- [ ] Status draft dan published didukung.
- [ ] Validasi lesson kosong dibuat.
- [ ] Seed curriculum dasar dibuat.

## G. Materi pembelajaran

- [ ] Model vocabulary dibuat.
- [ ] Model kanji dibuat.
- [ ] Model grammar point dibuat.
- [ ] Model example sentence dibuat.
- [ ] Model reading dibuat.
- [ ] Model audio asset dibuat.
- [ ] Relasi lesson–vocabulary dibuat.
- [ ] Relasi lesson–kanji dibuat.
- [ ] Relasi lesson–grammar dibuat.
- [ ] CRUD vocabulary dibuat.
- [ ] CRUD kanji dibuat.
- [ ] CRUD grammar dibuat.
- [ ] CRUD reading dibuat.
- [ ] Upload audio dibuat.
- [ ] Validasi file audio dibuat.
- [ ] Import content JSON atau CSV dibuat.
- [ ] Script seed contoh materi dibuat.

## H. Bank soal

- [ ] Enum question type dibuat.
- [ ] Enum skill dibuat.
- [ ] Enum question status dibuat.
- [ ] Model question dibuat.
- [ ] Model question option dibuat.
- [ ] Model question review dibuat.
- [ ] Schema internal dibuat.
- [ ] Schema learner dibuat.
- [ ] Answer key dipisahkan dari schema learner.
- [ ] CRUD soal manual dibuat.
- [ ] Filter lesson dibuat.
- [ ] Filter skill dibuat.
- [ ] Filter difficulty dibuat.
- [ ] Filter status dibuat.
- [ ] Pagination dibuat.
- [ ] Submit review dibuat.
- [ ] Approve dibuat.
- [ ] Reject dibuat.
- [ ] Request revision dibuat.
- [ ] Publish dibuat.
- [ ] Unpublish dibuat.
- [ ] Version history dibuat.
- [ ] Duplicate detection dibuat.
- [ ] Validasi opsi duplikat dibuat.
- [ ] Validasi jawaban benar dibuat.
- [ ] Test kebocoran jawaban dibuat.

## I. Generator soal AI

- [ ] Interface AI provider dibuat.
- [ ] Implementasi provider pertama dibuat.
- [ ] Prompt dasar dibuat.
- [ ] Prompt disimpan dengan versi.
- [ ] Pydantic output schema dibuat.
- [ ] Model generation job dibuat.
- [ ] Endpoint membuat job dibuat.
- [ ] Endpoint status job dibuat.
- [ ] Worker generation dibuat.
- [ ] Retry dibuat.
- [ ] Cancel dibuat.
- [ ] Timeout dibuat.
- [ ] Rate limit dibuat.
- [ ] Raw response disimpan secara aman.
- [ ] JSON parsing dibuat.
- [ ] Business validation dibuat.
- [ ] Duplicate check dibuat.
- [ ] Draft question creation dibuat.
- [ ] AI tidak dapat auto-publish.
- [ ] Penggunaan token atau biaya dicatat.
- [ ] Test provider menggunakan mock dibuat.
- [ ] Test job gagal dibuat.
- [ ] Test partial result dibuat.

## J. Audio dan listening

- [ ] Interface TTS provider dibuat.
- [ ] Implementasi TTS pertama dibuat.
- [ ] Worker TTS dibuat.
- [ ] Audio cache dibuat.
- [ ] Checksum audio dibuat.
- [ ] Metadata durasi dibuat.
- [ ] Storage provider dibuat.
- [ ] Local storage development dibuat.
- [ ] Object storage production dibuat.
- [ ] Signed URL atau public URL dibuat.
- [ ] Transkrip disimpan.
- [ ] Visibility transkrip dibuat.
- [ ] Listening question schema dibuat.
- [ ] Audio tidak dikirim sebagai base64 pada JSON.
- [ ] Test audio endpoint dibuat.
- [ ] Test kegagalan TTS dibuat.

## K. Learning session

- [ ] Model learning session dibuat.
- [ ] Model session question dibuat.
- [ ] Model user answer dibuat.
- [ ] Endpoint membuat session dibuat.
- [ ] Pemilihan soal dibuat.
- [ ] Randomisasi opsi dibuat.
- [ ] Soal published saja yang dipilih.
- [ ] Submit answer dibuat.
- [ ] Validasi question bagian dari session dibuat.
- [ ] Pencegahan jawaban ganda dibuat.
- [ ] Scoring multiple choice dibuat.
- [ ] Scoring true/false dibuat.
- [ ] Scoring matching dibuat.
- [ ] Scoring ordering dibuat.
- [ ] Feedback latihan dibuat.
- [ ] Mode ujian dibuat.
- [ ] Complete session dibuat.
- [ ] Ringkasan hasil dibuat.
- [ ] Session expired dibuat.
- [ ] Test seluruh tipe soal dibuat.

## L. Progress dan adaptive learning

- [ ] Model lesson progress dibuat.
- [ ] Model mastery dibuat.
- [ ] Model mistake dibuat.
- [ ] Model XP transaction dibuat.
- [ ] Model streak dibuat.
- [ ] Update progress setelah session dibuat.
- [ ] Update mastery setelah jawaban dibuat.
- [ ] Review schedule dibuat.
- [ ] Review due endpoint dibuat.
- [ ] Review session dibuat.
- [ ] Mistake book dibuat.
- [ ] XP ledger dibuat.
- [ ] Streak berbasis timezone dibuat.
- [ ] Dashboard overview dibuat.
- [ ] Skill summary dibuat.
- [ ] Recommendation rule dibuat.
- [ ] Test perubahan mastery dibuat.
- [ ] Test pergantian tanggal timezone dibuat.

## M. Simulasi JLPT

- [ ] Model simulasi dibuat.
- [ ] Model bagian simulasi dibuat.
- [ ] Relasi soal simulasi dibuat.
- [ ] Model attempt pengguna dibuat.
- [ ] Model nilai per bagian dibuat.
- [ ] Endpoint daftar simulasi dibuat.
- [ ] Endpoint mulai simulasi dibuat.
- [ ] Timer simulasi dibuat.
- [ ] Submit jawaban simulasi dibuat.
- [ ] Complete simulasi dibuat.
- [ ] Hasil simulasi dibuat.
- [ ] Analisis per skill dibuat.
- [ ] Riwayat simulasi dibuat.
- [ ] Simulasi N5 dibuat.
- [ ] Arsitektur N4–N1 disiapkan.
- [ ] Test simulasi dibuat.

## N. Dokumentasi frontend

- [ ] Judul dan deskripsi API dibuat.
- [ ] Semua endpoint memiliki tag.
- [ ] Semua endpoint memiliki `operation_id`.
- [ ] Semua request memiliki schema.
- [ ] Semua response memiliki schema.
- [ ] Semua endpoint memiliki contoh request.
- [ ] Semua endpoint memiliki contoh response.
- [ ] Semua endpoint mencantumkan hak akses.
- [ ] Semua endpoint mencantumkan error response.
- [ ] `API_OVERVIEW.md` dibuat.
- [ ] `FRONTEND_INTEGRATION.md` dibuat.
- [ ] `AUTHENTICATION.md` dibuat.
- [ ] `ERROR_CODES.md` dibuat.
- [ ] `QUESTION_TYPES.md` dibuat.
- [ ] `JLPT_SIMULATION.md` dibuat.
- [ ] `CHANGELOG.md` dibuat.
- [ ] Postman collection dibuat.
- [ ] Postman development environment dibuat.
- [ ] Postman staging environment dibuat.
- [ ] Contoh alur login dibuat.
- [ ] Contoh alur refresh token dibuat.
- [ ] Contoh alur belajar dibuat.
- [ ] Contoh alur listening dibuat.
- [ ] Contoh alur simulasi JLPT dibuat.
- [ ] Contoh alur error dibuat.
- [ ] OpenAPI schema divalidasi dalam CI.
- [ ] Tidak ada `operation_id` duplikat.
- [ ] Panduan pembuatan SDK frontend dibuat.
- [ ] Breaking change policy dibuat.

## O. Testing dan quality assurance

- [ ] Unit test service dibuat.
- [ ] Integration test database dibuat.
- [ ] Contract test dibuat.
- [ ] Permission test dibuat.
- [ ] File upload test dibuat.
- [ ] Worker test dibuat.
- [ ] Migration test dibuat.
- [ ] Test database terpisah dibuat.
- [ ] Factory data dibuat.
- [ ] Mock AI dibuat.
- [ ] Mock TTS dibuat.
- [ ] Coverage report dibuat.
- [ ] Coverage service inti mencapai target.
- [ ] Lint berjalan pada CI.
- [ ] Test berjalan pada CI.
- [ ] OpenAPI validation berjalan pada CI.
- [ ] Secret scanning dikonfigurasi.

## P. Security

- [ ] Secret tidak masuk Git.
- [ ] `.env.example` tidak mengandung key asli.
- [ ] Password di-hash.
- [ ] Refresh token di-hash.
- [ ] Token dapat dicabut.
- [ ] CORS menggunakan allowlist.
- [ ] Rate limit login dibuat.
- [ ] Rate limit AI dibuat.
- [ ] Input tervalidasi.
- [ ] File audio tervalidasi.
- [ ] IDOR diuji.
- [ ] SQL injection diuji.
- [ ] Mass assignment diuji.
- [ ] Admin endpoint diuji dengan learner token.
- [ ] Jawaban benar tidak bocor.
- [ ] Log sensitif disaring.
- [ ] Error production tidak menampilkan stack trace.

## Q. Logging dan observability

- [ ] Structured logging dibuat.
- [ ] Request ID dibuat.
- [ ] Error code konsisten.
- [ ] Response time dicatat.
- [ ] Job ID dicatat.
- [ ] AI usage dicatat.
- [ ] TTS usage dicatat.
- [ ] Health monitoring dibuat.
- [ ] Queue monitoring dibuat.
- [ ] Database monitoring dibuat.
- [ ] Alert job gagal dibuat.

## R. Deployment

- [ ] Docker image API dibuat.
- [ ] Docker image worker dibuat.
- [ ] Docker Compose local berjalan.
- [ ] Development environment berjalan.
- [ ] Staging environment berjalan.
- [ ] Production configuration disiapkan.
- [ ] HTTPS dikonfigurasi.
- [ ] Database backup dikonfigurasi.
- [ ] Object storage dikonfigurasi.
- [ ] Redis dikonfigurasi.
- [ ] Migration deployment dibuat.
- [ ] Rollback procedure dibuat.
- [ ] Seed administrator production aman.
- [ ] OpenAPI production dapat diakses frontend.
- [ ] Monitoring production aktif.

## S. Konten MVP

- [ ] Struktur dasar Bahasa Jepang selesai.
- [ ] Struktur N5 inti selesai.
- [ ] Minimal 300 kosakata tersedia.
- [ ] Minimal 80 kanji tersedia.
- [ ] Minimal 30 grammar point tersedia.
- [ ] Minimal 150 contoh kalimat tersedia.
- [ ] Minimal 30 bacaan tersedia.
- [ ] Minimal 50 audio tersedia.
- [ ] Minimal 500 soal disetujui.
- [ ] Setiap lesson memiliki tujuan belajar.
- [ ] Setiap lesson memiliki materi.
- [ ] Setiap lesson memiliki latihan.
- [ ] Setiap soal memiliki pembahasan.
- [ ] Setiap audio memiliki transkrip.
- [ ] Seluruh konten Jepang diperiksa reviewer.

## T. Persiapan frontend

- [ ] API staging stabil.
- [ ] Dokumentasi auth selesai.
- [ ] Dokumentasi question type selesai.
- [ ] Dokumentasi simulasi JLPT selesai.
- [ ] Dokumentasi error selesai.
- [ ] Postman collection selesai.
- [ ] OpenAPI schema selesai.
- [ ] Contoh response nyata tersedia.
- [ ] CORS staging dikonfigurasi.
- [ ] Akun frontend developer tersedia.
- [ ] Sample user tersedia.
- [ ] Sample curriculum tersedia.
- [ ] Sample session tersedia.
- [ ] Sample simulation tersedia.
- [ ] SDK dapat dibuat dari OpenAPI.
- [ ] Contract freeze versi pertama dilakukan.

---

## 33. Definition of Done Endpoint

Sebuah endpoint dianggap selesai apabila:

- Router selesai.
- Request schema selesai.
- Response schema selesai.
- Authorization selesai.
- Business logic tidak berada di router.
- Database transaction benar.
- Error response sesuai standar.
- Unit atau integration test tersedia.
- OpenAPI summary tersedia.
- OpenAPI description tersedia.
- Request example tersedia.
- Response example tersedia.
- Error response terdokumentasi.
- Postman request tersedia.
- Tidak membocorkan field internal.
- Lulus lint.
- Lulus test.
- Sudah ditinjau.

---

## 34. Kriteria Penerimaan MVP

MVP siap ketika:

1. Pengguna dapat registrasi dan login.
2. Pengguna dapat melihat kurikulum.
3. Pengguna dapat membuka materi.
4. Pengguna dapat memulai sesi latihan.
5. Pengguna dapat menjawab seluruh jenis soal MVP.
6. Backend dapat memeriksa jawaban.
7. Backend dapat menyimpan hasil.
8. Backend dapat memperbarui progress.
9. Backend dapat membuat jadwal review.
10. Pengguna dapat melihat kesalahan.
11. Audio dapat dimainkan melalui URL.
12. Admin dapat mengelola konten melalui API.
13. AI dapat menghasilkan draft soal.
14. Soal AI dapat divalidasi.
15. Reviewer dapat menyetujui dan menolak.
16. Soal yang belum dipublikasikan tidak muncul kepada learner.
17. Kunci jawaban tidak bocor.
18. Dokumentasi Swagger tersedia.
19. Dokumentasi ReDoc tersedia.
20. OpenAPI JSON valid.
21. Postman collection tersedia.
22. Panduan integrasi frontend tersedia.
23. Test inti lulus.
24. Migration dapat membangun database kosong.
25. Staging dapat digunakan frontend.
26. Simulasi JLPT N5 dapat dijalankan.
27. Arsitektur level N4 sampai N1 telah disiapkan.

---

## 35. Kesimpulan Teknis

Frontend belum perlu dipilih pada tahap ini. Backend dikembangkan sebagai layanan API independen dengan kontrak data yang stabil.

Urutan pengerjaan:

```text
PRD
  ↓
ERD
  ↓
Database Migration
  ↓
Authentication
  ↓
Curriculum API
  ↓
Question Bank
  ↓
Learning Session
  ↓
Progress dan SRS
  ↓
AI Generator
  ↓
Listening dan TTS
  ↓
Simulasi JLPT
  ↓
Dokumentasi API
  ↓
Frontend
```

Keputusan utama:

- Materi dikelola platform.
- AI hanya membuat draft soal.
- Soal AI harus diperiksa.
- Soal dibuat secara batch dan disimpan.
- Soal tidak dibuat ulang setiap pengguna belajar.
- Kunci jawaban tidak boleh bocor.
- Listening tersedia tanpa speaking.
- API tidak bergantung pada teknologi frontend.
- Dokumentasi endpoint dikerjakan bersama endpoint.
- MVP dimulai dari N5.
- Sistem dikembangkan bertahap sampai N1.
- Aplikasi membantu kesiapan pengguna, tetapi tidak menjamin kelulusan JLPT.
