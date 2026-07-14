# Product Requirements Document (PRD) - Revisi MVP (Minimum Viable Product)

## 1. Visi & Objektif Produk
Membangun platform kursus Bahasa Jepang (Nihongo-Learn) interaktif yang berfokus pada **Pemahaman Membaca (*Reading Comprehension / Dokkai*)**. Platform ini menggunakan AI secara ekstensif untuk mengotomatisasi pembuatan ujian berdasarkan materi PDF yang disediakan instruktur, digabungkan dengan sistem progresi terstruktur layaknya sebuah kursus profesional.

**Tujuan Utama Revisi:**
Memangkas fitur-fitur kompleks yang tidak sejalan dengan alur belajar linier (Course), guna mempercepat rilis aplikasi (*time-to-market*) dengan hanya berfokus pada satu *Killer Feature* yang solid.

---

## 2. Target Pengguna (User Personas)
1.  **Admin (Instruktur/Guru):** Mengatur silabus kursus dan menyediakan materi bacaan berkualitas tinggi (PDF).
2.  **Learner (Murid):** Mengikuti kursus secara berurutan, membaca materi, dan diuji kemampuannya secara dinamis oleh AI untuk mendapatkan poin.

---

## 3. Alur Utama (The "Killer" Workflow)

Alur ini adalah inti dari aplikasi dan **harus** berjalan dengan sempurna:

### A. Sisi Admin (Course Preparation)
1.  Admin membuat struktur kurikulum: **Course ➡️ Unit ➡️ Lesson**.
2.  Pada sebuah **Lesson** (misal: "Cerita Rakyat: Momotaro"), Admin mengunggah dokumen/materi **PDF**.
3.  *(Selesai)* Admin tidak perlu membuat bank soal atau mengetik kunci jawaban.

### B. Sisi Murid (Learning & Evaluation)
1.  **Membaca (Learn):** Murid masuk ke dalam *Lesson* dan disajikan *PDF viewer* untuk membaca dokumen.
2.  **Generate Ujian (Challenge):** Setelah membaca, murid menekan tombol "Uji Pemahaman Saya". Sistem memanggil *backend* AI (Celery Worker) untuk membedah PDF tersebut dan membuat 5-10 soal Pilihan Ganda secara *real-time*.
3.  **Evaluasi (Test):** Murid mengerjakan kuis AI. Jika jawaban salah, sistem menampilkan penjelasan berdasarkan teks PDF.
4.  **Progresi (Reward & Unlock):** Jika murid mencapai KKM (misal >70% benar):
    *   Mendapatkan **XP (Experience Points)**.
    *   Status *Lesson* berubah menjadi **Selesai (Completed)**.
    *   *Lesson* berikutnya **Terbuka (Unlocked)**.
5.  **Kompetisi (Leaderboard):** XP yang didapat akan mengakumulasi peringkat murid di *Leaderboard* global.

---

## 4. Ruang Lingkup MVP (In-Scope)

Fitur-fitur yang **WAJIB** ada di Frontend dan dijaga di Backend untuk versi awal:

*   **Autentikasi:** Login/Register User & Admin.
*   **Katalog Kursus:** Tampilan daftar Course, Unit, dan Lesson yang bersifat *Locked/Unlocked*.
*   **PDF Viewer:** Integrasi penampil PDF di dalam halaman *Lesson*.
*   **AI Quiz Engine:** UI untuk mengerjakan soal pilihan ganda hasil *generate* AI.
*   **Dashboard Gamifikasi:** Halaman profil yang menunjukkan Total XP dan Halaman Leaderboard.

---

## 5. Fitur yang Dibuang / Ditunda (Out of Scope / Deprecated)

Berdasarkan revisi MVP, fitur-fitur berikut yang sebelumnya ada di rencana awal atau sudah terlanjur dibuat di *backend*, **TIDAK AKAN DITAMPILKAN / DIBUANG** dari UI *Frontend* saat ini:

1.  **Sistem Hafalan Cerdas (Spaced Repetition System / SRS):**
    *   *Alasan:* Merusak fokus belajar linier (*Course flow*). Membangun UI *flashcard* memakan waktu besar.
2.  **Input Soal Manual oleh Admin:**
    *   *Alasan:* Redundan. Kekuatan utama platform ini adalah AI yang membuat soal otomatis dari PDF.
3.  **Ujian Simulasi Adaptif / Bebas (JLPT Simulations):**
    *   *Alasan:* Bertentangan dengan konsep *Course* yang harus diselesaikan bab per bab secara berurutan.
4.  **Text-to-Speech (TTS / Audio):**
    *   *Alasan:* Fokus aplikasi direvisi menjadi Pemahaman Membaca (Dokumen visual/PDF). Penggunaan API suara menguras biaya tanpa relevansi tinggi untuk *Dokkai*.

---

## 6. Persyaratan Teknis (Technical Requirements)

*   **Backend:** Tetap menggunakan arsitektur yang sudah ada (FastAPI + SQLAlchemy). Semua model utama (`Course`, `Lesson`, `MaterialDocument`, `GenerationJob`, `XPTransaction`) sudah mendukung visi revisi ini.
*   **Background Jobs:** Penggunaan Celery + Redis WAJIB dipertahankan khusus untuk tugas *AI Question Generation* agar tidak memblokir antarmuka pengguna saat proses *parsing* PDF yang berat.
*   **Database:** Tetap menyimpan riwayat `Question` yang di-*generate* AI untuk keperluan analitik, namun tidak difokuskan sebagai "Bank Soal Manual" untuk Admin.

---

## 7. Saran Pengembangan Berikutnya (Post-MVP)

Fitur berikut tidak wajib untuk rilis MVP pertama, tetapi disarankan sebagai prioritas lanjutan karena masih selaras dengan alur utama: **Admin upload PDF -> User generate soal -> User mengerjakan -> XP -> Leaderboard**.

### Prioritas Tinggi

1.  **Riwayat Attempt User**
    *   User dapat melihat sesi yang pernah dikerjakan: tanggal, lesson, skor, jumlah benar, XP yang didapat, dan status lulus/tidak.
    *   Manfaat: user merasa progresnya nyata dan frontend punya halaman "aktivitas belajar" yang jelas.

2.  **Feedback Per Soal**
    *   Setelah user menjawab, sistem menampilkan penjelasan singkat berdasarkan isi PDF.
    *   Manfaat: aplikasi tidak hanya memberi nilai, tetapi benar-benar membantu evaluasi pemahaman bahasa.

3.  **Batas Generate AI Per User**
    *   Batasi jumlah generate soal per hari atau per lesson, misalnya 3-5 kali per hari untuk user biasa.
    *   Manfaat: mengontrol biaya AI dan mencegah spam job.

### Prioritas Menengah

4.  **Preview Hasil Ekstraksi PDF Untuk Admin**
    *   Setelah upload PDF, admin bisa melihat cuplikan teks hasil ekstraksi.
    *   Manfaat: admin bisa memastikan PDF terbaca dengan benar sebelum dipakai AI.

5.  **Publish/Unpublish PDF Material**
    *   Admin bisa menyembunyikan PDF yang belum siap tanpa menghapus file.
    *   Manfaat: materi bisa disiapkan bertahap tanpa langsung terlihat oleh user.

6.  **Regenerate Soal**
    *   User atau admin dapat membuat ulang soal dari PDF yang sama jika hasil AI kurang baik.
    *   Manfaat: menjaga kualitas pengalaman belajar tanpa perlu upload ulang materi.

7.  **Status AI Job Yang Lebih Informatif**
    *   Status tetap sederhana (`PENDING`, `PROCESSING`, `COMPLETED`, `FAILED`), tetapi pesan error dibuat ramah frontend.
    *   Manfaat: user tahu apakah harus menunggu, mencoba lagi, atau menghubungi admin.

### Prioritas Rendah / Future Enhancement

8.  **OCR Untuk PDF Scan**
    *   Mendukung PDF berbasis gambar melalui OCR.
    *   Manfaat: memperluas jenis materi yang bisa digunakan, tetapi tidak wajib untuk MVP karena menambah kompleksitas dan biaya.

9.  **Progress Per Lesson Lebih Detail**
    *   Tambahkan statistik seperti best score, last score, total attempt, dan waktu terakhir belajar.
    *   Manfaat: dashboard menjadi lebih informatif tanpa mengubah alur utama.

10. **Leaderboard Mingguan/Bulanan**
    *   Selain leaderboard total XP, tampilkan ranking periodik.
    *   Manfaat: user baru tetap punya peluang bersaing meskipun total XP masih kecil.
