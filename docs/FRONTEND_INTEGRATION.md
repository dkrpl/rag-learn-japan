# Frontend Integration Guide

Dokumen ini adalah panduan singkat bagi Frontend Engineer untuk melakukan pemanggilan ke backend.

## Alur Dasar Belajar (Learning Flow)
1. **Pilih Lesson**: Ambil dari `GET /api/v1/curriculum/lessons/{id}`
2. **Mulai Session**: Buat session dengan `POST /api/v1/learning-sessions/start` dan berikan `lesson_id` beserta `mode="PRACTICE"`. Backend akan merespons dengan `session_id`.
3. **Minta Soal**: Panggil `GET /api/v1/learning-sessions/{session_id}/questions` untuk memuat soal ke state aplikasi frontend. (Ingat, ini tidak mengandung `is_correct` untuk alasan keamanan).
4. **Submisi Jawaban**: Saat User klik submit, kirim ke `POST /api/v1/learning-sessions/{session_id}/answers` beserta id soal dan `user_answer_json`. Backend akan mengembalikan `is_correct`. (Tampilkan UI Merah / Hijau berdasarkan respons ini).
5. **Selesaikan Session**: Panggil `POST /api/v1/learning-sessions/{session_id}/complete`.

## Alur Evaluasi Adaptif (AI RAG)
Jika Anda menyediakan tombol "Generate Quiz" atau "Evaluasi Materi Ini" pada halaman detail *Lesson*:
1. **Trigger AI**: Panggil `POST /api/v1/learning-sessions/adaptive` dengan *payload* `lesson_id` dan `question_count`.
2. **Polling Job**: Backend akan mengembalikan status `PENDING` dengan `id` job (GenerationJobResponse). Tampilkan *Loading Screen* dan *polling* `GET /api/v1/admin/ai_jobs/{id}` (jika rute learner belum dipisah, gunakan *state* lokal, atau implementasikan rute GET status pada v2) hingga status menjadi `COMPLETED`. 
   > *Catatan: Untuk MVP, soal yang dihasilkan akan langsung masuk ke database.*

## Audio

1. URL Audio dikembalikan di metadata berformat relatif atau absolut (tergantung konfigurasi).
2. Panggil URL secara normal di `src` tag `<audio>`. Token JWT tidak dibutuhkan untuk _streaming audio_ ke browser, selama URL tersebut memuat ID Publik.

---

## Alur Ujian Simulasi JLPT (Simulation Flow)

Simulasi JLPT memiliki perlindungan _Timer_ pada tingkat server.

1. **Lihat Daftar Simulasi**: `GET /api/v1/jlpt-simulations`
2. **Mulai Ujian (*Start Attempt*)**: `POST /api/v1/jlpt-simulations/{sim_id}/attempts`. Ini akan membuat catatan attempt, namun **waktu pengerjaan (timer) belum berjalan**.
3. **Mulai Seksi (*Start Section*)**: Panggil `POST /api/v1/jlpt-simulation-attempts/{attempt_id}/start-section`. 
   > ⚠️ **PERHATIAN**: Timer seksi secara resmi berdetak setelah panggilan ini berhasil! Anda akan menerima daftar soal (`questions`) khusus untuk seksi tersebut tanpa *kunci jawaban*.
4. **Pilih Jawaban**: Klien menyimpan respons sementara, kemudian setiap selesai memilih/tiap hitungan menit, panggil: 
   `POST /api/v1/jlpt-simulation-attempts/{attempt_id}/answers`
   *(Tidak seperti Learning Session, Rute ini TIDAK mengevaluasi BENAR/SALAH melainkan hanya mengunci input User ke Database).*
5. **Selesaikan Seksi**: Jika _Learner_ menyerahkan diri (*submit awal*) atau waktu lokal klien habis, panggil `POST /api/v1/jlpt-simulation-attempts/{attempt_id}/complete-section`.
   *(Penting: Backend akan menolak jawaban Anda jika waktu telah melebihi durasi resmi seksi + 30 detik toleransi server delay).*
6. **Lanjut Seksi Berikutnya**: Ulangi langkah ke-3 (Start Section) hingga seluruh seksi (Vocabulary, Grammar, Listening) habis.
7. **Selesaikan Ujian (*Final Submit*)**: `POST /api/v1/jlpt-simulation-attempts/{attempt_id}/complete`. Backend kemudian akan mengkalkulasi skor, ambang batas *passing grade* per seksi, analisis kemampuan, dan kelemahan. Hasilnya bisa dibaca secara langsung dari keluaran respons ini.
