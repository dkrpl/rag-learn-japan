# Tahap 1 - Finalisasi Fondasi Produk

Sumber tahap: Sprint 0 - Finalisasi fondasi.

## 1. Ringkasan Produk

Nihongo Learning API adalah backend untuk platform belajar bahasa Jepang berbasis AI. Backend ini menyimpan kurikulum dan materi resmi platform, menyediakan API untuk learner dan admin, serta menyiapkan engine pembelajaran adaptif. AI hanya digunakan untuk membuat draft soal dari materi terverifikasi, bukan membuat kurikulum bebas.

Tahap ini memastikan fondasi produk, scope backend, aturan kerja, ERD, standar API, dan target MVP sudah jelas sebelum implementasi dimulai.

## 2. Tujuan Tahap

- Mengunci PRD backend dan engine berdasarkan `prd_belajar_bahasa_jepang.md`.
- Menentukan batas MVP dan target pengembangan N5 sampai N1.
- Menentukan role, hak akses, standar API, dan standar database.
- Menyiapkan arah arsitektur untuk auth, curriculum, content, question bank, learning engine, progress, AI, audio, simulasi JLPT, dan audit.
- Menentukan workflow repository, branch, environment, dan dokumentasi.

## 3. Scope

- Finalisasi PRD.
- Penentuan nama repository.
- Penyusunan ERD awal.
- Penentuan konvensi API.
- Penentuan response envelope, pagination, dan error format.
- Penentuan role dan hak akses.
- Penentuan environment: local, testing, staging, production.
- Penentuan branch strategy, commit convention, dan review process.
- Penentuan scope MVP dan out-of-scope.

## 4. Non-Scope

- Implementasi endpoint.
- Implementasi database migration.
- Implementasi AI provider.
- Implementasi frontend.
- Penyusunan konten lengkap N4 sampai N1.

## 5. Keputusan Produk

- Backend menggunakan Python, FastAPI, MySQL, dan REST JSON.
- Frontend belum ditentukan.
- Materi dikelola platform, bukan upload dari learner.
- AI membuat draft soal dari materi tersimpan.
- Soal AI wajib review sebelum published.
- Listening masuk MVP.
- Speaking, handwriting, kanji tracing, dan upload PDF pengguna tidak masuk MVP.
- MVP fokus dasar Bahasa Jepang dan JLPT N5.
- Arsitektur harus siap untuk JLPT N4, N3, N2, dan N1.
- Simulasi JLPT N5 masuk MVP backend.

## 6. Role Dan Hak Akses

- Learner: melihat materi, latihan, listening, review, progress, mistake book, dan simulasi JLPT.
- Content editor: mengelola materi, soal manual, audio, dan menjalankan generator AI.
- Reviewer: melihat draft soal, approve, reject, request revision, publish/unpublish, dan archive tanpa mengubah payload soal secara langsung.
- Administrator: mengelola user, role, konfigurasi, konten, soal, audit log, dan operasional.

## 7. Functional Requirements Terkait

- FR-001 sampai FR-003 sebagai dasar auth, user, dan role.
- FR-004 sampai FR-012 sebagai domain curriculum dan content.
- FR-013 sampai FR-018 sebagai domain question bank dan review.
- FR-019 sampai FR-029 sebagai learning, progress, dan adaptive learning.
- FR-030 sebagai simulasi JLPT.
- FR-031 sebagai audit log.

## 8. Data Dan ERD Awal

ERD awal harus mencakup domain:

- Auth: `users` dengan kolom role canonical, `refresh_tokens`, `password_reset_tokens`, dan `email_verification_tokens`.
- Curriculum: `levels`, `courses`, `units`, `lessons`, `lesson_sections`.
- Content: `vocabularies`, `kanjis`, `grammar_points`, `example_sentences`, `readings`, `audio_assets`.
- Question: `questions` dengan opsi berbasis JSON, `question_reviews`, `question_revisions`, dan `generation_jobs`.
- Learning: `learning_sessions` dan `learning_session_questions` yang sekaligus menyimpan jawaban serta skor learner.
- Progress: `user_lesson_progress`, `user_masteries`, `user_mistakes`, `review_schedules`, dan `xp_transactions`; data streak berada pada `users`.
- JLPT simulation: `jlpt_simulations`, `jlpt_simulation_sections`, `jlpt_simulation_questions`, `user_simulation_attempts`, `user_simulation_attempt_questions`, dan `user_simulation_section_scores`.
- System: `audit_logs`, `system_settings`.

Rancangan ERD atau dokumen lama yang masih menyebut tabel `roles`, `user_roles`, `question_options`, `user_answers`, atau `user_streaks` wajib diperbarui mengikuti keputusan denormalisasi pada master PRD.

## 9. Standar API

- Prefix API: `/api/v1`.
- Format data: JSON.
- Field naming: `snake_case`.
- Public ID menggunakan UUID.
- Waktu disimpan UTC.
- Tanggal response menggunakan ISO 8601.
- Daftar endpoint wajib punya schema request, schema response, contoh, hak akses, dan error response.

## 10. Risiko Dan Mitigasi

- Scope melebar ke frontend: dokumentasi boleh dibuat, frontend tidak diimplementasikan.
- AI menghasilkan soal salah: wajib ada validasi otomatis dan review.
- Sistem terkunci di N5: model level dan simulasi harus siap N4 sampai N1.
- Kunci jawaban bocor: schema learner harus dipisahkan sejak desain.

## 11. Deliverable

- PRD final dalam repository.
- ERD awal lintas domain.
- Dokumen standar API.
- Ringkasan role dan permission.
- Daftar out-of-scope MVP.
- Aturan repository dan environment.

## 12. Acceptance Criteria

- Scope backend dan engine disetujui.
- Out-of-scope MVP disetujui.
- Role dan permission awal jelas.
- ERD mencakup seluruh domain MVP.
- Standar API siap dipakai tahap implementasi.
- Target N5 sampai N1 tercermin di desain awal.
