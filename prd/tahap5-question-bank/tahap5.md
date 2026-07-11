# Tahap 5 - Question Bank

Sumber tahap: Sprint 4 - Question bank.

## 1. Ringkasan Produk

Tahap ini membangun bank soal pusat untuk Nihongo Learning API. Semua latihan, review, exam mode, AI generated draft, dan simulasi JLPT bergantung pada bank soal yang tervalidasi.

Bank soal harus aman untuk learner. Kunci jawaban, flag `is_correct`, dan field internal tidak boleh bocor sebelum waktunya.

## 2. Tujuan Tahap

- Menyediakan model question dengan opsi berbasis JSON, review, status, skill, difficulty, dan versioning.
- Menyediakan CRUD soal manual.
- Menyediakan schema internal untuk admin/reviewer.
- Menyediakan schema learner tanpa answer key.
- Menyediakan review workflow.
- Menyediakan publish workflow.
- Menyiapkan soal agar dapat dipakai learning session dan simulasi JLPT.

## 3. Scope

- Question type enum.
- Skill enum.
- Question status enum.
- CRUD manual question.
- Filter lesson, skill, difficulty, status.
- Pagination.
- Submit review, approve, reject, request revision.
- Publish dan unpublish.
- Version history.
- Duplicate detection.
- Validasi answer key.
- Test kebocoran jawaban.

## 4. Non-Scope

- AI generation job.
- Learning session selection.
- Simulasi JLPT attempt.
- Frontend rendering tipe soal.

## 5. Functional Requirements

- FR-013: Bank soal.
- FR-014: Status soal.
- FR-017: Review soal.
- FR-018: Publikasi soal.

FR-015 dan FR-016 diselesaikan pada tahap AI generator, tetapi question bank harus siap menerima draft AI.

## 6. Tipe Soal MVP

| Identifier Canonical | Tampilan | Scoring Strategy |
|:---|:---|:---|
| `MULTIPLE_CHOICE` | Pilihan ganda | Satu option ID. |
| `CLOZE_MULTIPLE_CHOICE` | Cloze pilihan ganda | Satu option ID per blank. |
| `TRUE_FALSE` | Benar atau salah | Boolean canonical. |
| `MATCHING` | Mencocokkan | Set pasangan ID tanpa bergantung urutan tampilan. |
| `ORDERING` | Mengurutkan kata | Urutan ID exact. |
| `KANJI_READING` | Membaca kanji | Satu option ID atau normalized reading sesuai kontrak soal. |
| `READING_COMPREHENSION` | Pemahaman bacaan | Satu atau beberapa option ID sesuai prompt. |
| `LISTENING_MULTIPLE_CHOICE` | Mendengarkan pilihan ganda | Satu option ID dan audio asset wajib. |
| `LISTENING_TRUE_FALSE` | Mendengarkan benar atau salah | Boolean canonical dan audio asset wajib. |
| `LISTENING_WITH_IMAGE` | Mendengarkan dengan gambar | Satu image option ID dan audio asset wajib. |

Setiap tipe mempunyai kontrak `prompt_json`, `options`, `answer_key_json`, dan `explanation_json` yang didokumentasikan di `QUESTION_TYPES.md`. Payload learner tidak pernah memuat `answer_key_json`.

## 7. Status Soal

- `DRAFT`
- `AUTO_VALIDATED`
- `IN_REVIEW`
- `NEEDS_REVISION`
- `APPROVED`
- `PUBLISHED`
- `REJECTED`
- `ARCHIVED`

Hanya status `PUBLISHED` yang boleh diberikan kepada learner.

## 8. Data Model

- `questions`
- `question_reviews`
- `question_revisions`

Opsi, pasangan matching, urutan, dan pilihan jawaban disimpan pada objek `options` di `prompt_json`; tidak ada tabel `question_options` terpisah. Setiap opsi mempunyai ID stabil agar randomisasi tidak mengubah arti answer key. `question_revisions` menyimpan snapshot sebelum perubahan; `version_number` saja tidak dianggap sebagai version history.

Field penting:

- `lesson_id`
- `reading_id`
- `audio_asset_id`
- `type`
- `skill`
- `difficulty`
- `prompt_json`
- `answer_key_json`
- `explanation_json`
- `status`
- `is_ai_generated`
- `prompt_version`
- `version_number`
- `created_by`
- `reviewed_by`
- `published_at`

## 9. Endpoint Admin

- `GET /api/v1/admin/questions`
- `POST /api/v1/admin/questions`
- `GET /api/v1/admin/questions/{question_id}`
- `PATCH /api/v1/admin/questions/{question_id}`
- `POST /api/v1/admin/questions/{question_id}/submit-review`
- `POST /api/v1/admin/questions/{question_id}/approve`
- `POST /api/v1/admin/questions/{question_id}/reject`
- `POST /api/v1/admin/questions/{question_id}/request-revision`
- `POST /api/v1/admin/questions/{question_id}/publish`
- `POST /api/v1/admin/questions/{question_id}/unpublish`
- `POST /api/v1/admin/questions/{question_id}/archive`
- `GET /api/v1/admin/questions/{question_id}/history`

## 10. Aturan Bisnis

- Soal tidak dapat published tanpa approval.
- Soal published wajib memiliki lesson, prompt, answer key, explanation, dan status valid.
- Opsi tidak boleh duplikat.
- Jawaban benar harus sesuai tipe soal.
- Single choice hanya boleh memiliki satu jawaban benar.
- Soal AI tidak boleh auto-publish.
- Content editor tidak dapat approve atau publish soal buatannya sendiri.
- Endpoint review tidak dapat langsung mengatur status arbitrary.
- Learner schema tidak mengandung `answer_key_json` atau `is_correct`.
- Soal listening harus punya audio asset valid.

## 11. Deliverable

- Question bank API.
- Review workflow.
- Publish workflow.
- Schema learner aman.
- History perubahan.
- Validasi inti soal.

## 12. Acceptance Criteria

- Admin/content editor dapat membuat soal manual.
- Reviewer dapat approve/reject/request revision.
- Soal tidak valid tidak dapat dipublish.
- Soal unpublished tidak muncul ke learner.
- Kunci jawaban tidak bocor.
- Filter dan pagination berjalan.
- Test kebocoran jawaban lulus.
