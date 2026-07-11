# Tahap 4 - Curriculum Dan Content

Sumber tahap: Sprint 3 - Curriculum dan content.

## 1. Ringkasan Produk

Tahap ini membangun backend untuk kurikulum dan materi pembelajaran. Nihongo Learning API tidak menerima upload PDF dari learner. Semua materi dimasukkan dan dikelola oleh platform melalui admin atau content editor.

Kurikulum awal berfokus pada dasar Bahasa Jepang dan JLPT N5, tetapi struktur level harus siap untuk N4, N3, N2, dan N1.

## 2. Tujuan Tahap

- Menyediakan struktur level, course, unit, lesson, dan lesson section.
- Menyediakan CRUD admin untuk kurikulum.
- Menyediakan endpoint learner untuk melihat kurikulum published.
- Menyediakan manajemen kosakata, kanji, grammar, example sentence, reading, dan audio metadata.
- Menyediakan relasi materi ke lesson.
- Menyiapkan konten sebagai sumber question bank, AI generator, listening, learning engine, dan simulasi JLPT.

## 3. Scope

- CRUD level, course, unit, lesson.
- Publish dan unpublish lesson.
- Lesson content untuk learner.
- CRUD vocabulary, kanji, grammar point, reading, dan audio metadata.
- Upload audio dengan validasi.
- Import content JSON atau CSV.
- Status draft/published.
- Ordering konten.
- Seed curriculum dasar.

## 4. Non-Scope

- Pembuatan soal.
- AI generator.
- TTS generation worker.
- Learning session.
- Simulasi JLPT attempt.
- Konten lengkap N4 sampai N1.

## 5. Functional Requirements

- FR-004: Manajemen level.
- FR-005: Manajemen course.
- FR-006: Manajemen unit.
- FR-007: Manajemen lesson.
- FR-008: Materi kosakata.
- FR-009: Materi kanji.
- FR-010: Materi tata bahasa.
- FR-011: Materi membaca.
- FR-012: Materi mendengarkan.

## 6. Target Konten MVP

- 10 unit pembelajaran.
- 300 kosakata.
- 80 kanji.
- 30 grammar point.
- 150 contoh kalimat.
- 30 bacaan pendek.
- 50 materi audio.

Target tersebut adalah target awal. Struktur data tidak boleh mengunci sistem hanya pada N5.

## 7. Data Model

- `levels`
- `courses`
- `units`
- `lessons`
- `lesson_sections`
- `vocabularies`
- `kanjis`
- `grammar_points`
- `example_sentences`
- `readings`
- `audio_assets`
- `lesson_vocabularies`
- `lesson_kanjis`
- `lesson_grammar_points`

## 8. Endpoint Learner

- `GET /api/v1/curriculum/levels`
- `GET /api/v1/curriculum/levels/{level_id}`
- `GET /api/v1/curriculum/levels/{level_id}/courses`
- `GET /api/v1/curriculum/courses/{course_id}`
- `GET /api/v1/curriculum/courses/{course_id}/units`
- `GET /api/v1/curriculum/units/{unit_id}`
- `GET /api/v1/curriculum/units/{unit_id}/lessons`
- `GET /api/v1/curriculum/lessons/{lesson_id}`
- `GET /api/v1/curriculum/lessons/{lesson_id}/content`
- `GET /api/v1/audio/{audio_id}`

## 9. Endpoint Admin

- `/api/v1/admin/curriculum/levels`
- `/api/v1/admin/curriculum/courses`
- `/api/v1/admin/curriculum/units`
- `/api/v1/admin/curriculum/lessons`
- `/api/v1/admin/curriculum/lesson-sections`
- `/api/v1/admin/content/vocabularies`
- `/api/v1/admin/content/kanjis`
- `/api/v1/admin/content/grammar-points`
- `/api/v1/admin/content/example-sentences`
- `/api/v1/admin/content/readings`
- `/api/v1/admin/content/audio`

## 10. Aturan Bisnis

- Learner hanya melihat data published.
- Admin dan content editor dapat mengelola draft.
- Content editor atau administrator wajib memverifikasi materi sebelum lesson dipublish; role reviewer pada MVP berfokus pada workflow soal.
- Lesson tidak boleh dipublish jika konten minimum belum terpenuhi.
- Teks Jepang harus tersimpan benar dengan `utf8mb4`.
- Audio response berisi metadata dan URL, bukan base64 file.
- Transkrip audio dapat disembunyikan sampai learner selesai menjawab.
- Audio foundation, storage, dan learner URL dimiliki tahap ini; Tahap 8 menambahkan generation melalui TTS worker pada model audio yang sama.

## 11. Deliverable

- API curriculum admin dan learner.
- API content admin.
- Import content.
- Seed curriculum dasar.
- Audio metadata dan upload.
- Struktur level siap N5 sampai N1.

## 12. Acceptance Criteria

- Learner dapat melihat kurikulum published.
- Draft tidak muncul pada learner.
- Admin dapat membuat level, course, unit, lesson, dan materi.
- Lesson content menggabungkan section dan materi terkait.
- Audio metadata tersimpan dan dapat diakses.
- Konten Jepang tersimpan tanpa rusak.
