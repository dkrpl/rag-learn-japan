# Known Limitations (MVP v1.0.0)

Dokumen ini memuat daftar batasan sistem dan cakupan yang **di luar prioritas (out of scope)** untuk rilis MVP, beserta rekomendasi penanganannya di masa mendatang.

## 1. AI & TTS Providers

- **AI Question Generator**: Saat ini implementasinya menggunakan logika _mock_ untuk memastikan antrean (*durable worker queue*) bekerja secara handal. Sebelum merilis secara publik, **sebuah token OpenAI / Gemini API yang sah harus disematkan** pada *environment variables* produksi.
- **Audio TTS**: Sama dengan AI Generator, audio *Text-To-Speech* (TTS) di-generate menggunakan _mock_. Integrasi seperti ElevenLabs atau Google Cloud TTS harus dihubungkan.
- **Object Storage**: Penyimpanan Audio saat ini disimpan secara fisik di folder lokal (`uploads/audio/`). Disarankan menggunakan penyimpanan eksternal semacam AWS S3 atau Cloudflare R2 dengan menyempurnakan `FileStorageService` jika aplikasi akan disebarkan (*deploy*) menggunakan arsitektur nirkab (misal Vercel / Cloud Run).

## 2. Cakupan Konten (N4 - N1)

- Secara *database scheme*, fondasi untuk konten JLPT tingkat N4, N3, N2, dan N1 telah **sepenuhnya disiapkan**. Kolom tingkatan, relasi, dan sistem simulasi mendukung berbagai tingkat JLPT.
- Namun, **Data Aktual** (Seeds) difokuskan dan diisi hanya untuk **JLPT N5** agar MVP dapat beroperasi lebih ringan.

## 3. Fitur Yang Ditunda (Deferred)

Fitur-fitur berikut di luar cakupan peluncuran *v1.0.0 MVP*:
- **Pendeteksi Suara (Speaking Evaluation & Speech-To-Text)**: Tidak ada integrasi untuk menilai lafal _Learner_.
- **Pengenal Tulisan Tangan (Kanji Tracing)**: Harus dikembangkan secara independen di sisi klien *Frontend*.
- **Upload File (PDF/Image) oleh Learner**: Hanya *Content Editor* dan *Admin* yang dapat mengunggah _resource_.
- **Payment & Langganan (Monetisasi)**: Arsitektur _Role-Based Access_ siap, namun manajemen pembayaran tidak di-implementasikan.
- **Forum & Chat Tutor Langsung**: Sistem interaksi *Peer-to-Peer* antar pelajar dihapus demi MVP.

## 4. Keamanan dan Observability Skala Enterprise

- Logika API membatasi kecepatan (*Rate Limiter*) sudah berjalan untuk mencegah brute-force. Namun pada level peluncuran massal, pertimbangkan memindahkan kontrol tingkat akses lalu lintas menggunakan API Gateway terdedikasi, *WAF* (Cloudflare dsb.), atau *Nginx Reverse Proxy*.
