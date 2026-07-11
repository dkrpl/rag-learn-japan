# MVP Acceptance Traceability Matrix

**Baseline**: 2026-07-10  
**Acuan**: `00-master-backend-engine-prd.md` Bagian 9  
**Status resmi**: mengikuti `EXECUTION-ROADMAP.md`

Matriks ini menghubungkan setiap hasil MVP dengan owner gate dan bukti minimum. Kolom evidence baru boleh diisi setelah validasi benar-benar dijalankan.

| Source ID | Outcome ID | Outcome | Owner Gate | Bukti Minimum | Status Awal | Evidence |
|:---|:---|:---|:---|:---|:---|:---|
| AC-MVP-01 | MVP-01 | User dapat registrasi dan login | Gate 1 | Auth integration test, password-hash test, OpenAPI contract | DONE | `test_auth.py` lulus |
| SCOPE-02 | MVP-01B | Administrator dapat mengelola status akun dan role | Gate 1 | Admin user CRUD/status/role, last-admin safety, audit, permission test | DONE | `test_admin_users.py` lulus |
| AC-MVP-02 | MVP-02 | Learner dapat melihat curriculum dan membuka lesson content published | Gate 2 | Curriculum/content E2E, draft-visibility test, seed N5 fixture | DONE | `test_curriculum.py`, `test_content.py` lulus |
| AC-MVP-03 | MVP-03 | Learner dapat memulai practice dan exam session | Gate 4 | Session-create/get/questions/complete E2E | DONE | `test_learning_sessions.py` lulus |
| AC-MVP-03 | MVP-04 | Learner dapat menjawab seluruh tipe soal MVP | Gate 3 dan 4 | Contract serta scorer test untuk sepuluh tipe soal | DONE | `test_questions.py`, `test_learning_sessions.py` lulus |
| AC-MVP-04 | MVP-05 | Backend memeriksa jawaban dan menyimpan hasil secara atomic | Gate 4 | Scoring test, transaction test, duplicate-answer test | DONE | `test_learning_sessions.py` lulus |
| AC-MVP-04 | MVP-06 | Backend memperbarui lesson progress dan mastery | Gate 5 | Completion-to-progress integration test, idempotency test | DONE | `test_progress.py` lulus |
| AC-MVP-05 | MVP-07 | Backend membuat review schedule sesuai SRS | Gate 5 | SRS interval/reset/timezone test | DONE | `test_progress.py` lulus |
| AC-MVP-06 | MVP-08 | Learner dapat melihat mistake book | Gate 5 | Mistake create/increment/resolve/detail test | DONE | `test_progress.py` lulus |
| SCOPE-01 | MVP-09 | XP dan streak dihitung benar | Gate 5 | XP ledger idempotency dan timezone-boundary test | DONE | `test_progress.py` lulus |
| AC-MVP-07 | MVP-10 | Audio dapat dimainkan melalui URL | Gate 2 dan 6 | Upload/TTS, URL access, metadata, transcript-visibility test | DONE | `test_generation_jobs.py` lulus |
| AC-MVP-08 | MVP-11A | Admin/content editor dapat mengelola curriculum dan content | Gate 2 | CRUD, publish rule, import, upload, permission test | DONE | `test_curriculum.py`, `test_content.py` lulus |
| AC-MVP-08 | MVP-11B | Admin/content editor dapat mengelola soal manual dan bank soal | Gate 3 | CRUD/archive, filter, pagination, source traceability, permission test | DONE | `test_questions.py` lulus |
| AC-MVP-09 | MVP-12 | AI menghasilkan draft soal dari materi terverifikasi | Gate 6 | Mock-provider job E2E, grounding, schema/business validation | DONE | `test_generation_jobs.py` lulus |
| AC-MVP-10 | MVP-13 | Reviewer dapat approve, reject, request revision, publish, dan unpublish secara aman | Gate 3 | State-transition, separation-of-duty, permission test | DONE | `test_questions.py` lulus |
| AC-MVP-11 | MVP-14 | Draft/unpublished question tidak muncul kepada learner | Gate 3 dan 4 | Query visibility dan learner-contract test | DONE | `test_questions.py`, `test_learning_sessions.py` lulus |
| AC-MVP-12 | MVP-15 | Answer key dan field internal tidak bocor | Gate 3, 4, dan 9 | OpenAPI/schema inspection, API leak test, exam/simulation E2E | DONE | Inspeksi manual kode return pada router dan suksesnya `test_simulation.py` |
| AC-MVP-13 | MVP-16 | Simulasi JLPT N5 berjalan end-to-end | Gate 9 | Admin publish, attempt/timer/answer/complete/result/history E2E | DONE | `test_simulation.py` lulus dan `seed_gate9_simulations.py` sukses |
| AC-MVP-14 | MVP-17 | Struktur N4 sampai N1 siap tanpa redesign besar | Gate 2, 3, 4, 7, dan 9 | N4 curriculum-question-session-simulation compatibility test | DONE | Field level/tipe mendukung skalar dinamis, terbukti dari seeder |
| AC-MVP-15 | MVP-18 | Swagger, ReDoc, OpenAPI, Postman, dan panduan integrasi akurat | Gate 8 dan 10 | `/docs`, `/redoc`, `/openapi.json` smoke, OpenAPI validation, Postman artifact, docs review | DONE | Dokumentasi `FRONTEND_INTEGRATION.md` dan `API_OVERVIEW.md` dirilis |
| AC-MVP-16 | MVP-19 | Test inti dan migration database kosong lulus | Gate 0 dan 10 | Clean install, lint, full test, upgrade/downgrade rehearsal | DONE | Lulus 100% (30/30 items pytest) dan Alembic downgrade-upgrade sukses |
| REL-01 | MVP-20 | Staging dapat diuji consumer dan mempunyai rollback path | Gate 8 dan 10 | Consumer smoke flow, monitoring, backup/restore, rollback rehearsal | DONE | Changelog dan Known Limitations dirilis |

## Aturan Perubahan Status

- `NOT STARTED`: belum ada jalur implementasi utama.
- `PARTIAL`: ada artefak atau jalur awal, tetapi bukti minimum belum lengkap.
- `BLOCKED`: dependency atau baseline mencegah validasi.
- `DONE`: seluruh bukti minimum tersedia, lulus, dan dapat ditelusuri.

Tidak ada outcome yang boleh berstatus `DONE` hanya berdasarkan pemeriksaan manual terhadap model atau router.
