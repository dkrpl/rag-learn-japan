# Blueprint Simulasi JLPT N5

Dokumen ini mendefinisikan struktur beku untuk simulasi JLPT N5 sesuai dengan spesifikasi MVP (Gate 0 - Gate 9). 

## 1. Spesifikasi Umum

- **Total Durasi:** 105 menit
- **Total Soal:** 33 soal (Minimum viable, disederhanakan dari standar 105 soal untuk MVP, namun bisa diperluas) -> *Kita menggunakan proporsi yang mewakili setiap seksi*.
- **Skor Maksimal:** 180 poin
- **Batas Kelulusan (Passing Grade):** 80 poin total, DAN setiap seksi tidak boleh di bawah 19 poin (berdasarkan standar resmi JLPT).

## 2. Struktur Seksi (Sections)

Simulasi N5 dibagi menjadi 3 seksi utama yang harus diselesaikan secara berurutan. Timer berjalan per seksi.

### Seksi 1: Vocabulary & Kanji (Bahasa Pengetahuan - Kosakata/Kanji)
- **Durasi Alokasi:** 25 menit
- **Skor Maksimal:** 60 poin
- **Fokus Skill:** `VOCABULARY`, `KANJI`
- **Kebutuhan Soal MVP:**
  - Kanji Reading (Cara baca kanji): 3 soal
  - Orthography (Penulisan kanji): 3 soal
  - Contextually defined expressions (Pilihan kata dalam konteks): 3 soal
  - Paraphrases (Persamaan makna): 2 soal

### Seksi 2: Grammar & Reading (Bahasa Pengetahuan - Tata Bahasa & Membaca)
- **Durasi Alokasi:** 50 menit
- **Skor Maksimal:** 60 poin
- **Fokus Skill:** `GRAMMAR`, `READING`
- **Kebutuhan Soal MVP:**
  - Grammar forms (Partikel/Bentuk kata): 4 soal
  - Sentence composition (Menyusun kalimat): 3 soal
  - Text grammar (Tata bahasa dalam teks): 3 soal
  - Comprehension (Short): 2 bacaan pendek, masing-masing 1 soal
  - Comprehension (Medium): 1 bacaan menengah, 2 soal
  - Information retrieval (Mencari informasi): 1 soal

### Seksi 3: Listening (Mendengarkan)
- **Durasi Alokasi:** 30 menit
- **Skor Maksimal:** 60 poin
- **Fokus Skill:** `LISTENING`
- **Kebutuhan Soal MVP:**
  - Task-based comprehension (Memahami tugas): 3 soal
  - Comprehension of key points (Memahami poin kunci): 3 soal
  - Verbal expressions (Ekspresi lisan/respons gambar): 3 soal
  - Quick response (Respons cepat lisan): 3 soal

## 3. Aturan Pelaksanaan (Attempt Rules)

1. **Unanswered Handling (Jawaban Kosong):** Jika waktu seksi habis, soal yang belum dijawab otomatis mendapat skor 0.
2. **Timer Enforcement:** Timer dijaga oleh server berdasarkan `started_at` dari *attempt*. Frontend hanya menampilkan *countdown*. Jika *request* penyelesaian (atau jawaban) diterima melewati durasi seksi + masa toleransi (misal 30 detik), jawaban ditolak.
3. **Retake Policy:** Learner dapat mengulang simulasi (*retake*) kapan saja, tetapi setiap *retake* akan dicatat sebagai `SimulationAttempt` baru. Histori hasil sebelumnya tidak ditimpa.
4. **Visibility:** Hasil (skor, jawaban benar/salah) hanya bisa dilihat setelah keseluruhan sesi simulasi `COMPLETED`.

## 4. Kesiapan Migrasi N4-N1
Struktur yang didefinisikan di atas menggunakan model relasional generik (`Simulation`, `SimulationSection`, `SimulationSectionMapping`) yang secara arsitektur mampu mengakomodasi penambahan seksi atau perubahan alokasi waktu dan poin untuk level JLPT N4, N3, N2, maupun N1 di masa mendatang tanpa perlu *database migration* (redesign) secara besar-besaran.
