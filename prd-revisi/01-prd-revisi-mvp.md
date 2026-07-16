# Product Requirements Document (PRD) - Revisi Total MVP

## 1. Visi Produk

Nihongo Learn adalah platform evaluasi pemahaman Bahasa Jepang berbasis PDF dan AI.
Fokus MVP bukan manajemen kursus yang rumit, tetapi alur sederhana:

```text
Admin upload PDF
User pilih materi
User pilih tingkat kesulitan
AI generate soal
User mengerjakan
Backend validasi jawaban
Jika lulus: dapat EXP dan lanjut materi berikutnya
Jika tidak lulus: wajib mengulang dan tidak mendapat EXP
```

Tujuan utama revisi ini adalah menghapus kerumitan `Level -> Course -> Unit -> Lesson`
dari MVP. Materi PDF menjadi pusat sistem.

## 2. Persona Pengguna

### Admin

Admin bertugas menyediakan materi belajar.

Admin tidak perlu:

- Membuat course, unit, lesson secara manual.
- Membuat soal manual.
- Membuat kunci jawaban manual.
- Mengatur struktur kurikulum yang panjang.

Admin cukup:

- Upload PDF.
- Mengisi judul, deskripsi, level, kategori, dan urutan materi.
- Publish/unpublish materi.
- Melihat preview hasil ekstraksi teks PDF.

### User

User belajar dari materi PDF yang sudah dipublish admin.

User dapat:

- Melihat daftar materi.
- Membuka PDF.
- Memilih tingkat kesulitan soal.
- Generate soal dari PDF.
- Mengerjakan soal.
- Melihat hasil, feedback, dan penjelasan.
- Mendapat EXP hanya jika skor memenuhi batas lulus.
- Lanjut ke materi berikutnya hanya jika materi sebelumnya lulus.

## 3. Prinsip Produk

1. Material-first, bukan course-first.
2. Admin workflow harus pendek.
3. AI menghasilkan soal dari PDF, bukan dari bank soal manual.
4. User tidak bisa lanjut jika belum lulus.
5. EXP hanya diberikan saat lulus.
6. Attempt gagal tetap disimpan sebagai riwayat, tetapi tidak memberi EXP.
7. Leaderboard dihitung dari EXP valid, bukan dari total attempt.

## 4. Alur Admin

### 4.1 Upload Materi

Admin membuka halaman Materials dan upload PDF.

Input minimal:

- `title`
- `description` optional
- `level` misalnya `N5`, `N4`, `N3`, `N2`, `N1`
- `category` misalnya `reading`, `grammar`, `vocabulary`
- `sequence` untuk urutan materi
- `file` PDF

Backend melakukan:

- Validasi file PDF.
- Simpan file.
- Ekstrak teks PDF.
- Simpan metadata dan `extracted_text`.
- Default status: draft atau published sesuai pilihan admin.

### 4.2 Kelola Materi

Admin dapat:

- List materi.
- Detail materi.
- Edit metadata.
- Preview teks hasil ekstraksi.
- Publish materi.
- Unpublish materi.
- Delete/archive materi.

Delete disarankan soft delete/archive agar attempt user lama tidak rusak.

## 5. Alur User

### 5.1 Lihat Materi

User melihat daftar materi yang sudah published.

Daftar materi harus menampilkan:

- Judul.
- Level.
- Kategori.
- Status lock/unlock.
- Best score.
- Attempt count.
- Passing score.

Materi pertama terbuka secara default.
Materi berikutnya hanya terbuka jika materi sebelumnya sudah lulus.

### 5.2 Buka PDF

User membuka detail materi dan melihat PDF viewer.

User membaca materi terlebih dahulu sebelum generate soal.

### 5.3 Pilih Tingkat Kesulitan

Sebelum generate soal, user memilih difficulty:

- `easy`
- `medium`
- `hard`

Atau representasi angka:

- `1` easy
- `2` medium
- `3` hard

Frontend boleh menampilkan label sederhana, backend menyimpan nilai difficulty.

### 5.4 Generate Soal

User menekan tombol generate.

Backend membuat AI job berdasarkan:

- `material_id`
- `difficulty`
- `question_count`
- teks hasil ekstraksi PDF
- user yang meminta generate

Soal yang dibuat bersifat session/user scoped, bukan bank soal global untuk admin.

### 5.5 Mengerjakan Soal

User mengerjakan soal pilihan ganda.

MVP hanya wajib mendukung:

- Multiple choice.
- Reading comprehension.
- Feedback setelah submit.

### 5.6 Submit Dan Validasi

Backend menghitung:

- Total soal.
- Jawaban benar.
- Jawaban salah.
- Score persentase.
- Status lulus/gagal.

Passing score default:

```text
70
```

Passing score bisa dibuat configurable per material, tetapi MVP boleh memakai default global.

### 5.7 Reward Dan Locking

Jika `score >= passing_score`:

- Attempt status: `passed`.
- User mendapat EXP.
- Progress material menjadi `completed`.
- Materi berikutnya terbuka.
- Leaderboard naik.

Jika `score < passing_score`:

- Attempt status: `failed`.
- User tidak mendapat EXP.
- Progress material belum completed.
- Materi berikutnya tetap locked.
- User harus generate/mengerjakan ulang.

## 6. Gamifikasi

### 6.1 EXP

EXP hanya diberikan untuk attempt yang lulus.

Formula MVP:

```text
base_exp = 100
difficulty_multiplier:
  easy = 1.0
  medium = 1.25
  hard = 1.5

earned_exp = round(base_exp * difficulty_multiplier * (score / 100))
```

Jika gagal:

```text
earned_exp = 0
```

### 6.2 Leaderboard

Leaderboard dihitung dari total EXP valid.

Mode MVP:

- Global leaderboard.

Post-MVP:

- Weekly leaderboard.
- Monthly leaderboard.

## 7. Data Model Target

Model utama MVP:

### `materials`

Menyimpan PDF yang diupload admin.

Field target:

- `id`
- `title`
- `description`
- `level`
- `category`
- `sequence`
- `original_filename`
- `content_type`
- `file_size_bytes`
- `checksum`
- `storage_key`
- `page_count`
- `extracted_text`
- `is_published`
- `is_archived`
- `passing_score`
- `created_by_id`
- `created_at`
- `updated_at`

### `question_jobs`

Menyimpan proses generate AI.

Field target:

- `id`
- `material_id`
- `user_id`
- `difficulty`
- `question_count`
- `status`
- `error_message`
- `raw_response`
- `created_question_count`
- `created_at`
- `completed_at`

### `questions`

Menyimpan soal hasil AI.

Field target:

- `id`
- `job_id`
- `material_id`
- `user_id`
- `question_type`
- `prompt_json`
- `answer_key_json`
- `explanation_json`
- `difficulty`

### `practice_sessions`

Menyimpan sesi pengerjaan user.

Field target:

- `id`
- `user_id`
- `material_id`
- `job_id`
- `difficulty`
- `status`
- `total_questions`
- `answered_questions`
- `correct_answers`
- `final_score`
- `passing_score`
- `is_passed`
- `earned_exp`
- `started_at`
- `completed_at`

### `answers`

Menyimpan jawaban user.

Field target:

- `id`
- `session_id`
- `question_id`
- `user_answer_json`
- `is_correct`
- `score`
- `feedback`
- `answered_at`

### `user_material_progress`

Menyimpan progress per user per materi.

Field target:

- `id`
- `user_id`
- `material_id`
- `status`: `locked`, `unlocked`, `completed`
- `best_score`
- `last_score`
- `attempt_count`
- `completed_at`

### `xp_transactions`

Menyimpan riwayat EXP.

Field target:

- `id`
- `user_id`
- `material_id`
- `session_id`
- `amount`
- `reason`
- `created_at`

## 8. Endpoint Target MVP

### Auth

```http
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/refresh
POST /api/v1/auth/logout
```

### Admin Materials

```http
POST   /api/v1/admin/materials/pdf
GET    /api/v1/admin/materials
GET    /api/v1/admin/materials/{material_id}
PATCH  /api/v1/admin/materials/{material_id}
GET    /api/v1/admin/materials/{material_id}/preview
GET    /api/v1/admin/materials/{material_id}/analytics
POST   /api/v1/admin/materials/{material_id}/publish
POST   /api/v1/admin/materials/{material_id}/unpublish
DELETE /api/v1/admin/materials/{material_id}
```

### Admin Users

```http
GET    /api/v1/admin/users
POST   /api/v1/admin/users
GET    /api/v1/admin/users/{user_id}
PATCH  /api/v1/admin/users/{user_id}
DELETE /api/v1/admin/users/{user_id}
```

### User App

```http
GET  /api/v1/app/me
GET  /api/v1/app/dashboard
GET  /api/v1/app/materials
GET  /api/v1/app/materials/{material_id}
GET  /api/v1/app/materials/{material_id}/file
POST /api/v1/app/materials/{material_id}/generate-quiz
GET  /api/v1/app/quiz-sessions/{session_id}/status
GET  /api/v1/app/quiz-sessions/{session_id}/questions
POST /api/v1/app/quiz-sessions/{session_id}/submit
GET  /api/v1/app/quiz-sessions/{session_id}/result
GET  /api/v1/app/attempts
GET  /api/v1/app/leaderboard
```

## 9. Out Of Scope MVP

Fitur berikut tidak masuk MVP:

- Course, unit, lesson management kompleks.
- Lesson section manual.
- Bank soal manual admin.
- Review soal manual admin.
- SRS/spaced repetition.
- TTS/listening.
- Writing/handwriting.
- JLPT simulation bebas.
- Upload PDF oleh user.
- Payment/forum/chat tutor.

## 10. Catatan Rombak Backend

Backend saat ini masih course-first.
Rombak berikutnya harus mengubah kontrak menjadi material-first.

Prioritas rombak:

1. Jadikan `MaterialDocument` tidak wajib terkait `lesson_id`.
2. Tambahkan metadata material: `level`, `category`, `sequence`, `passing_score`, `is_archived`.
3. Ganti `/app/catalog` menjadi `/app/materials`.
4. Ganti flow lesson-based menjadi material-based.
5. Pastikan EXP hanya diberikan jika session passed.
6. Pastikan unlock materi berikutnya dihitung dari `user_material_progress`.
7. Sembunyikan atau hapus endpoint admin curriculum dari Swagger dan frontend.

## 11. Roadmap Produksi

Bagian ini adalah pengembangan setelah MVP material-first stabil. Prioritasnya bukan
menambah fitur besar yang melebar, tetapi membuat sistem layak dipakai production.

### 11.1 Stabilitas Alur Utama

Alur wajib production:

```text
Admin upload PDF
Admin preview hasil ekstraksi
Admin publish material
User membuka material yang unlocked
User memilih difficulty
User generate quiz
User submit jawaban
Backend menghitung score
Jika lulus: EXP masuk dan material berikutnya terbuka
Jika gagal: EXP tetap 0 dan user wajib mengulang
```

Acceptance criteria:

- Attempt gagal tetap tersimpan.
- Attempt gagal tidak membuat `xp_transactions`.
- Material berikutnya tidak terbuka sebelum material sebelumnya lulus.
- Dashboard, attempt history, dan leaderboard selalu konsisten setelah submit.

### 11.2 Review Hasil Quiz

Setelah submit, user harus melihat:

- Status lulus/gagal.
- Score dan passing score.
- EXP yang didapat.
- Jumlah jawaban benar.
- Review per soal: jawaban benar/salah dan feedback jika tersedia.

Frontend tidak boleh menampilkan answer key sebelum quiz selesai.

### 11.3 Admin Material Analytics

Admin perlu ringkasan sederhana per material:

- Total attempt.
- Average score.
- Pass rate.
- Jumlah learner yang completed.
- Difficulty yang paling sering dipakai.

Analytics ini membantu admin mengetahui PDF mana yang terlalu sulit atau kurang jelas.

### 11.4 Anti EXP Farming

Sistem harus mencegah EXP farming dari materi yang sama.

Aturan production yang disarankan:

- EXP penuh hanya diberikan saat pertama kali user lulus material.
- Attempt ulang untuk menaikkan score boleh disimpan.
- Attempt ulang tidak boleh menggandakan EXP secara berlebihan.
- Leaderboard dihitung dari transaksi EXP valid, bukan total attempt.

### 11.5 Leaderboard Production

Leaderboard perlu mode:

- All time.
- Weekly.
- Monthly.

Frontend harus menjelaskan bahwa leaderboard memakai EXP valid dari attempt lulus.

### 11.6 AI Quality Guard

AI generator harus punya pengaman:

- Validasi JSON response.
- Cegah soal kosong.
- Cegah opsi jawaban duplikat.
- Cegah soal yang tidak berdasarkan PDF.
- Simpan raw AI response untuk audit.
- Beri pesan error ramah jika generate gagal.

### 11.7 Security Dan Deployment

Syarat production:

- CORS hanya domain frontend production.
- Rate limit login dan generate quiz.
- Validasi ukuran PDF.
- Validasi MIME type PDF.
- Admin endpoint wajib role-based.
- Migration Railway harus bisa jalan dari database kosong.
- Health check dan ready check tetap tersedia untuk platform deploy.

### 11.8 Testing Production

Test minimal:

- Register/login user.
- Admin upload PDF.
- Admin publish/unpublish PDF.
- Learner generate quiz.
- Learner submit quiz lulus.
- Learner submit quiz gagal.
- EXP tidak masuk saat gagal.
- Leaderboard berubah hanya saat EXP valid.
- Learner tidak bisa akses endpoint admin.
- Build frontend production berhasil.

## 12. Prioritas Implementasi Berikutnya

Urutan eksekusi setelah revisi ini:

1. Review hasil quiz per soal di frontend.
2. Filter leaderboard weekly/monthly/all time.
3. Dashboard user menampilkan streak, answered questions, dan sisa generate AI.
4. Landing copy disesuaikan dengan readiness production.
5. Dokumentasi frontend diperbarui untuk route, endpoint, env, dan testing.
6. Endpoint analytics admin per material tersedia untuk production monitoring.
7. Anti EXP farming tersedia: kelulusan ulang tidak menggandakan EXP.
8. Frontend mendukung refresh token otomatis dan embedded PDF viewer.
9. Smoke test deploy tersedia melalui `backend/scripts/smoke_test.py`.

## 13. Roadmap Produk Besar

Roadmap ini berada di luar MVP dan dipakai jika produk ingin naik kelas menjadi
platform publik/komersial dengan banyak user.

### 13.1 Production Engineering

- CI/CD otomatis untuk backend test, frontend lint/build, dan smoke test deploy.
- Environment staging dan production terpisah.
- Rollback plan untuk migration database.
- Backup database terjadwal.
- Retention cleanup untuk raw AI response lama.
- Release checklist per versi.
- Blue/green deployment jika traffic sudah tinggi.
- Feature flag untuk merilis fitur baru bertahap.
- Background job dashboard untuk melihat antrian AI, retry, dan failed job.
- Load test berkala untuk endpoint login, material list, generate quiz, dan submit.

### 13.2 Observability Dan Reliability

- Structured log sudah menjadi baseline.
- Tambahkan error tracking eksternal seperti Sentry.
- Dashboard metrics: generate success rate, login failure rate, pass rate, p95 latency.
- Alerting untuk AI failure spike, database error, dan response time tinggi.
- Audit log admin untuk upload, update, publish, unpublish, archive, dan user changes.
- Distributed tracing untuk request API -> worker -> AI provider.
- Incident runbook untuk outage database, Redis, storage PDF, dan AI provider.
- Status page internal untuk admin operasional.

### 13.3 Learning Experience Premium

- Attempt detail historis.
- PDF viewer dengan page control, zoom, search, dan posisi baca terakhir.
- Highlight teks PDF yang menjadi sumber jawaban.
- Weak-area insight per user: grammar, vocabulary, reading.
- Rekomendasi materi berikutnya berdasarkan kegagalan user.
- Ringkasan belajar mingguan.
- Adaptive learning path: difficulty otomatis naik/turun dari performa user.
- Personal goal dan study plan harian/mingguan.
- Mistake book otomatis dari soal yang salah.
- Spaced repetition untuk vocabulary/grammar yang sering gagal.
- AI tutor chat berbasis materi PDF, tetapi tidak membocorkan answer key quiz aktif.
- Placement test untuk menentukan level awal user.

### 13.4 Admin Intelligence

- Analytics per material: attempts, average score, pass rate, difficulty breakdown, score bucket, recent attempts.
- Export CSV.
- Daftar soal yang paling sering salah.
- Failure-rate ranking antar materi.
- Cohort analytics untuk melihat perkembangan batch user.
- Admin notes untuk menandai PDF yang perlu revisi.
- Organization dashboard untuk sekolah/lembaga.
- Learner risk indicator untuk user yang sering gagal atau tidak aktif.
- Content quality score untuk PDF berdasarkan extraction quality dan pass/fail pattern.
- Scheduled report email untuk admin.
- Data warehouse/event tracking jika data analytics sudah besar.

### 13.5 AI Excellence

- Auto-regenerate jika output AI gagal guard.
- Semantic grounding terhadap teks PDF.
- Quality score per generated question.
- Duplicate question detection lintas attempt.
- Prompt versioning dan A/B testing prompt.
- Model fallback jika provider utama gagal.
- Human review optional untuk material penting.
- AI rubric evaluator untuk menjelaskan kenapa jawaban salah.
- Support tipe soal lanjutan: reading comprehension, cloze test, ordering sentence, short answer.
- Cache generation berbasis material+difficulty untuk menekan biaya AI.
- Cost monitoring per user, material, dan organization.
- Offline/batch generation untuk material populer.
- Safety policy agar AI tidak menghasilkan konten di luar materi belajar.

### 13.6 Security Enterprise

- 2FA untuk admin.
- Audit log lebih lengkap dengan IP/device.
- Session management UI untuk revoke device.
- Password policy configurable.
- Admin permission lebih granular: viewer, content editor, super admin.
- Data export access dibatasi role.
- Multi-tenant isolation untuk organization/workspace.
- SSO SAML/OIDC untuk sekolah atau perusahaan.
- Admin approval workflow untuk material penting sebelum publish.
- Security review untuk file upload, token, rate limit, dan object storage.
- Academic integrity guard: deteksi pola jawaban tidak wajar dan attempt abuse.

### 13.7 Business Dan Monetisasi

- Subscription plan.
- Limit generate AI per plan.
- Usage billing untuk AI cost.
- Organization/workspace mode.
- Seat management untuk sekolah/lembaga.
- Invoice dan payment integration.
- Free trial dan upgrade flow.
- Plan untuk individual, classroom, school, dan enterprise.
- Coupon/promo/referral.
- Marketplace materi premium dari creator terverifikasi.
- Revenue share untuk creator materi.
- Admin billing dashboard untuk melihat usage dan invoice.

### 13.8 Integrasi Eksternal

- LMS integration.
- Webhook untuk completion event.
- CSV import user.
- CSV export analytics.
- API key untuk integrasi server-to-server.
- SSO/OAuth untuk organisasi.
- Integrasi Google Classroom/Moodle/Canvas jika target sekolah.
- SCORM/xAPI export untuk learning record.
- Webhook untuk material published, quiz completed, learner passed, dan learner at risk.
- Public API/SDK dengan rate limit dan audit.

### 13.9 Mobile Dan Multi-Platform

- PWA offline cache untuk daftar material.
- Mobile app learner.
- Push notification untuk reminder belajar.
- Admin tetap web-first.
- Offline attempt draft untuk koneksi lemah, dengan submit saat online.
- Deep link dari reminder ke material yang harus diulang.
- Tablet-friendly mode untuk kelas.
- Widget progress harian untuk mobile.

### 13.10 Compliance Dan Data Governance

- Backup policy.
- Data retention policy.
- User data deletion request.
- Privacy policy dan terms.
- Audit export untuk admin.
- PII minimization.
- Data processing agreement untuk organization.
- Consent management untuk email/reporting.
- Regional data residency jika masuk enterprise besar.
- Legal review untuk penggunaan PDF berhak cipta.
- Data classification untuk file material, profile, answer, dan AI logs.

### 13.11 Marketplace Dan Ecosystem

- Creator portal untuk upload paket materi.
- Review dan rating material.
- Moderation queue untuk materi publik.
- Template materi resmi per JLPT level.
- Affiliate/referral untuk creator atau sekolah.
- Public profile untuk creator premium.

### 13.12 Certification Dan Assessment

- Exam mode dengan timer, lock navigation, dan randomization.
- Certificate setelah menyelesaikan track tertentu.
- Proctored exam integration jika target enterprise.
- Skill transcript per user.
- Badge dan credential sharing.
- Validity period untuk sertifikat.

### 13.13 Organization Suite

- Workspace per sekolah/lembaga/perusahaan.
- Class/group management.
- Teacher role untuk memantau learner di kelasnya.
- Assignment/deadline material.
- Bulk invite user.
- Progress report per class, per learner, dan per material.

## 14. Batas Mentok Pengembangan

Setelah roadmap produk besar di atas, pengembangan berikutnya tidak lagi berupa
kebutuhan inti, tetapi pilihan strategi bisnis:

- Masuk pasar sekolah/lembaga.
- Membuat marketplace materi.
- Menambah tutor/live class.
- Membuat mobile app native.
- Menjual API/SDK.
- Menambah multi bahasa di luar Bahasa Jepang.
- Menjadi platform certification resmi.
- Menjadi learning operating system untuk institusi.
- Menjadi content commerce platform untuk creator bahasa.

Artinya, dari sisi produk belajar PDF -> AI quiz -> evaluasi -> EXP -> analytics,
roadmap ini sudah mencakup jalur pengembangan sampai level produk besar. Setelah
titik ini, pengembangan bukan lagi kekurangan fitur inti, melainkan keputusan
arah bisnis: B2C, B2B sekolah, enterprise, marketplace, certification, atau API platform.

## 15. Saran Pengembangan Akhir

Bagian ini adalah batas akhir saran pengembangan. Jika semua roadmap sebelumnya
sudah dikerjakan, produk tidak lagi berada di fase mencari fitur utama, tetapi
fase memilih posisi bisnis.

Prioritas akhir yang paling masuk akal:

1. Stabilkan produk inti untuk learner individual.
2. Naikkan ke paket organization untuk sekolah/lembaga.
3. Tambahkan certification jika produk ingin menjadi alat evaluasi resmi.
4. Tambahkan marketplace materi jika ingin membuka kontribusi creator.
5. Tambahkan mobile native jika retensi user harian sudah tinggi.
6. Tambahkan API/SDK jika ada permintaan integrasi dari partner.
7. Tambahkan multi bahasa hanya jika fondasi Bahasa Jepang sudah kuat.

Saran terakhir:

- Jangan menambah fitur besar baru sebelum analytics membuktikan kebutuhan user.
- Jangan membuka marketplace sebelum moderation dan quality review kuat.
- Jangan membuat mobile native sebelum web/PWA terbukti dipakai rutin.
- Jangan menjual API/SDK sebelum kontrak endpoint stabil dan terdokumentasi.
- Jangan masuk enterprise sebelum audit log, SSO, backup, retention, dan role
  permission matang.

Kesimpulan final: roadmap sudah mentok rata kanan untuk produk Nihongo Learn.
Pengembangan berikutnya bukan lagi wajib secara teknis, tetapi pilihan strategi:
individual learning app, school platform, certification platform, marketplace,
atau enterprise learning ecosystem.
