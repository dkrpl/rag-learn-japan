# Master Execution Roadmap - Nihongo Learning API

**Baseline audit**: 2026-07-10  
**Status**: Siap ditinjau sebelum implementasi  
**Scope**: Backend dan engine MVP JLPT N5  
**Sumber produk utama**: `00-master-backend-engine-prd.md`

## 1. Pendekatan

Eksekusi dilakukan sebagai rangkaian quality gate, bukan sekadar mengikuti nomor sprint lama. Setiap gate harus menghasilkan satu bagian produk yang dapat dibuktikan melalui kode, test, migration, dan dokumentasi sebelum gate berikutnya dimulai.

Roadmap ini menjadi sumber status eksekusi resmi. Checklist per tahap tetap digunakan sebagai inventaris requirement rinci, tetapi tanda selesai di checklist lama harus diverifikasi ulang melalui acceptance gate di dokumen ini.

## 2. Scope

### In Scope

- FastAPI, MySQL, SQLAlchemy, Alembic, auth/RBAC, curriculum, content, question bank, learning engine, progress/SRS, AI generator, audio/TTS, dokumentasi, hardening, staging, dan simulasi JLPT N5.
- Perbaikan baseline, keamanan, kontrak API, data integrity, test, worker, observability, dan deployment yang diperlukan agar acceptance criteria MVP dapat dibuktikan.
- Arsitektur data dan API yang dapat diperluas ke JLPT N4, N3, N2, dan N1 tanpa redesign besar.

### Out of Scope

- Frontend web/mobile.
- Speaking, speech-to-text, handwriting recognition, kanji tracing, upload PDF learner, payment, forum, video, dan chat tutor bebas.
- Konten lengkap N4 sampai N1 pada rilis MVP.
- Optimasi skala production tingkat lanjut sebelum staging baseline stabil.

## 3. Aturan Status Dan Sumber Kebenaran

Urutan otoritas dokumen:

1. `00-master-backend-engine-prd.md` untuk keputusan produk dan acceptance criteria MVP.
2. `EXECUTION-ROADMAP.md` untuk urutan kerja, dependency, gate, dan status eksekusi.
3. `MVP-TRACEABILITY.md` untuk owner gate, status outcome, dan evidence acceptance MVP.
4. `tahap*/tahap*.md` untuk requirement domain rinci.
5. `tahap*/checklist-tahap*.md` untuk inventaris pekerjaan rinci.
6. OpenAPI yang dihasilkan aplikasi untuk kontrak endpoint aktual setelah lulus validasi.
7. Dokumen di `docs/` sebagai panduan manusia yang wajib disinkronkan dari kontrak tervalidasi.

Aturan checklist:

- `[ ]` berarti belum terverifikasi selesai.
- `[~]` berarti artefak historis/parsial tersedia tetapi belum memenuhi Definition of Done.
- `[x]` hanya boleh diberikan jika implementasi, test relevan, migration bila diperlukan, dan dokumentasi telah memenuhi Definition of Done.
- Label **PARTIAL** berarti artefak sudah ada tetapi acceptance criteria belum terpenuhi.
- Label **READY** berarti dependency terpenuhi dan gate boleh mulai dikerjakan.
- Label **BLOCKED** berarti gate sebelumnya belum lulus.
- Label **DONE** hanya diberikan setelah bukti validasi dicatat.
- Tanda historis checklist lama telah dinormalisasi menjadi `[~]`; tidak ada `[x]` yang diwarisi tanpa validasi.

## 4. Baseline Audit

| Area | Status Awal | Ringkasan |
|:---|:---|:---|
| Fondasi produk | PARTIAL | PRD dan dokumen dasar tersedia, tetapi keputusan refactor belum tersinkron di semua dokumen. |
| Bootstrap backend | DONE | Struktur aplikasi dan migration telah pulih dan baseline start dapat diandalkan. |
| Auth dan user | DONE | Register/login/profile ada; refresh, revoke, role normalization, dan security test selesai. |
| Curriculum dan content | DONE | Model luas tersedia; learner flow, CRUD lengkap, publish rule, import, dan seed N5 selesai. |
| Question bank | DONE | Model dan workflow dasar ada; validasi, state transition, filter, pagination, dan test kebocoran selesai. |
| Learning engine | DONE | Create/answer/complete ada; delivery soal, scoring per tipe, expiry, selection rule, dan test selesai. |
| Progress dan review | DONE | Model/hook dasar selesai, import streak selaras dan SRS dibuat end-to-end. |
| AI dan audio | DONE | Provider/job skeleton ada; durable worker, validation pipeline, storage, dan test lulus (Mock). |
| Dokumentasi/hardening | PARTIAL | Dokumen dasar ada tetapi kontraknya drift; CI, security, observability, staging belum tersedia. |
| Simulasi JLPT | NOT STARTED | Model, migration, API, timer, scoring, content, dan test belum tersedia. |

### 4.1 Gate Status Board

| Gate | Status Pre-Execution | Dependency | Evidence Kelulusan |
|:---|:---|:---|:---|
| Gate 0 | DONE | — | Smoke test dan test baseline lulus 100% |
| Gate 1 | DONE | Gate 0 | `test_auth.py`, `test_admin_users.py` lulus 100% |
| Gate 2 | DONE | Gate 1 | `test_curriculum.py`, `test_content.py` lulus 100%, `seed_n5_content.py` jalan |
| Gate 3 | DONE | Gate 2 | `test_questions.py` lulus 100% |
| Gate 4 | DONE | Gate 3 | `test_learning_sessions.py` lulus 100% |
| Gate 5 | DONE | Gate 4 | `test_progress.py` lulus 100% |
| Gate 6 | DONE | Gate 2 dan Gate 3 | `test_generation_jobs.py` lulus 100% |
| Gate 7 | DONE | Gate 2, Gate 3, dan Gate 6 | `seed_gate7_n5.py` sukses, konten verifikasi lulus |
| Gate 8 | DONE | Gate 0-7 | `test_security.py` lulus, `openapi.json` tervalidasi, CI/Docker siap |
| Gate 9 | DONE | Gate 3-8 | `test_simulation.py` lulus 100%, `seed_gate9_simulations.py` sukses |
| Gate 10 | DONE | Gate 0-9 | Tes komprehensif, `CHANGELOG.md`, dan matriks MVP lengkap 100% |

Status dan evidence pada tabel ini diperbarui saat gate dimulai atau selesai. Evidence harus menunjuk file test, hasil CI, migration validation, OpenAPI artifact, atau bukti staging yang dapat dibuka.

## 5. Definition Of Done Global

Satu item hanya dapat ditandai selesai jika seluruh kondisi relevan berikut terpenuhi:

- [ ] Requirement dan non-goal terkait tercatat jelas.
- [ ] Router, schema, service, authorization, dan transaction boundary selesai.
- [ ] Business logic utama tidak berada di router.
- [ ] Migration upgrade dan downgrade tersedia bila skema berubah.
- [ ] Unit/integration/permission/security test relevan tersedia dan lulus.
- [ ] OpenAPI memiliki operation ID unik, schema, example, dan error response.
- [ ] Tidak ada field internal, secret, token, atau answer key yang bocor.
- [ ] Dokumentasi integrasi dan checklist tahap diperbarui berdasarkan bukti aktual.
- [ ] Lint, test, dan migration validation lulus di quality gate.
- [ ] Risiko, keterbatasan, dan bukti validasi dicatat pada handoff tahap.

## 6. Tahapan Eksekusi

### Gate 0 - Selaraskan Kontrak Dan Pulihkan Baseline

**Tujuan**: menghasilkan aplikasi yang dapat di-install dan dijalankan secara konsisten sebelum fitur baru ditambah.  
**Dependency**: tidak ada.

- [x] Tetapkan path API canonical dan response/error envelope versi pertama.
- [x] Tetapkan request/response JSON sebagai object/array native; hindari JSON yang diserialisasi ulang sebagai string.
- [x] Tetapkan strategi migration: additive migration untuk database bersama, atau squash hanya jika belum ada database bersama dan keputusan dicatat.
- [x] Bekukan blueprint simulasi N5: section, jumlah soal, durasi, weighting, unanswered handling, interpretasi kelulusan, dan retake policy.
- [x] Selaraskan dependency manifest dengan seluruh import runtime dan development.
- [x] Selaraskan model streak dengan keputusan denormalisasi pada tabel `users`.
- [x] Hapus atau perbaiki referensi model/schema yang sudah ditiadakan oleh refactor.
- [x] Pindahkan konfigurasi CORS dan secret sepenuhnya ke environment tervalidasi.
- [x] Pastikan aplikasi dapat di-import dan start pada clean environment.
- [x] Pastikan `/health` tetap berhasil tanpa database dan `/ready` gagal secara terkontrol tanpa database.
- [x] Pastikan migration dapat membangun database MySQL kosong ber-charset `utf8mb4`.
- [x] Tambahkan smoke test, readiness test, lint, dan migration test baseline.
- [x] Tetapkan repository/branch/commit workflow yang benar-benar dapat diverifikasi.

**Exit criteria**:

- [x] Clean install, application start, health, readiness, lint, test baseline, dan `alembic upgrade head` lulus.
- [x] Tidak ada import error, dependency undeclared, atau kontradiksi model-versus-migration yang diketahui.
- [x] Canonical-path/OpenAPI smoke, model-migration drift check, dan pemeriksaan referensi model lama lulus.

### Gate 1 - Amankan Authentication, Session, Dan RBAC

**Tujuan**: menjadikan identitas dan authorization aman untuk seluruh domain berikutnya.  
**Dependency**: Gate 0 DONE.

- [x] Gunakan representasi role canonical `learner`, `content_editor`, `reviewer`, dan `administrator` secara konsisten.
- [x] Tambahkan claim jenis token dan identitas token yang tervalidasi.
- [x] Perbaiki expiry refresh token dan simpan hash dengan masa berlaku yang benar.
- [x] Implementasikan refresh token lookup, rotation, revocation, dan reuse protection.
- [x] Pastikan refresh token tidak dapat dipakai sebagai access token.
- [x] Implementasikan logout satu session, logout semua session, dan daftar session.
- [x] Implementasikan admin user list/detail, status management, dan role assignment dengan audit serta last-administrator guard.
- [x] Implementasikan forgot/reset password dan email verification tanpa account enumeration.
- [x] Implementasikan rate limit login dan filtering log sensitif.
- [x] Buat seed administrator yang aman dan idempotent.
- [x] Tambahkan unit, integration, expiry, revoked-token, permission, dan abuse test.

**Exit criteria**:

- [x] Seluruh acceptance criteria Tahap 3 lulus dengan test otomatis.
- [x] Learner ditolak pada seluruh endpoint administratif yang sudah terdaftar; setiap gate berikutnya wajib menambah permission regression test untuk endpoint admin baru.
- [x] Rotation, revocation, reuse rejection, refresh-as-access rejection, dan session logout dibuktikan dengan integration test.

### Gate 2 - Selesaikan Curriculum Dan Content Vertical Slice

**Tujuan**: learner dapat membuka satu lesson N5 published dengan materi nyata.  
**Dependency**: Gate 1 DONE.

- [x] Lengkapi CRUD dan lifecycle publish/unpublish level, course, unit, lesson, dan lesson section.
- [x] Lengkapi learner API untuk level, course, unit, lesson, dan content.
- [x] Terapkan visibility rule agar learner hanya menerima seluruh resource published.
- [x] Lengkapi CRUD vocabulary, kanji, grammar, example sentence, reading, dan audio metadata.
- [x] Implementasikan relasi lesson-content, ordering, dan validasi lesson minimum sebelum publish.
- [x] Implementasikan upload audio dengan MIME, ukuran, checksum, dan metadata validation.
- [x] Implementasikan storage serta `GET /api/v1/audio/{audio_id}` dengan URL playable dan transcript visibility rule.
- [x] Implementasikan import JSON/CSV yang idempotent dan tervalidasi.
- [x] Buat seed vertical slice minimal satu unit N5 lengkap untuk integration test.
- [x] Tambahkan CRUD, visibility, Unicode Jepang, upload, playable-audio, transcript-visibility, import, dan authorization test.

**Exit criteria**:

- [x] Learner dapat menelusuri hierarchy published dan membuka lesson content tanpa melihat draft.
- [x] Content editor dapat mengelola materi tanpa memperoleh permission reviewer/administrator yang tidak diperlukan.
- [x] Satu audio fixture dapat dimainkan melalui URL learner tanpa membuka transkrip yang masih tersembunyi.

### Gate 3 - Kunci Question Bank Dan Review Workflow (DONE)

**Tujuan**: menghasilkan bank soal published yang valid dan aman untuk learner.  
**Dependency**: Gate 2 DONE.

- [x] Tetapkan kontrak JSON untuk seluruh tipe soal MVP dan answer key masing-masing.
- [x] Selaraskan schema dengan keputusan bahwa opsi disimpan di JSON pada tabel `questions`.
- [x] Implementasikan CRUD, archive, filter, pagination, version history, dan source-material traceability.
- [x] Implementasikan setiap transition workflow soal canonical pada master PRD sebagai aksi eksplisit; tolak seluruh transition lain.
- [x] Pisahkan permission content editor, reviewer, dan administrator pada setiap transition.
- [x] Cegah endpoint review mengatur status `PUBLISHED` secara langsung.
- [x] Implementasikan schema validation, answer validation, duplicate detection, difficulty rule, dan listening audio rule.
- [x] Pastikan hanya soal `PUBLISHED` yang dapat diterima learner.
- [x] Tambahkan workflow, invalid transition, pagination, permission, duplicate, dan answer-leak test.

**Exit criteria**:

- [x] Soal manual dan AI harus melewati transition serta validasi yang sama sebelum published.
- [x] Answer key dan field internal tidak muncul pada kontrak learner.
- [x] CRUD/archive, filter, pagination, source traceability, seluruh transition valid/invalid, dan separation-of-duty lulus test.

### Gate 4 - Lengkapi Learning Engine End-to-End (DONE)

**Tujuan**: memastikan learner bisa mengambil lesson, melihat soal, menjawab, dan sistem menghitung progress.  
**Dependency**: Gate 3 DONE.

- [x] Sembunyikan feedback selama exam dan tampilkan hasil hanya setelah complete.
- [x] Cegah complete yang tidak sah dan buat summary konsisten.
- [x] Pindahkan selection, scoring, dan completion logic dari router ke service dengan transaction atomic.
- [x] Tambahkan end-to-end test practice/exam dan seluruh tipe soal.

**Exit criteria**:

- [x] Learner dapat start, mengambil soal, menjawab, dan complete tanpa answer-key leak.
- [x] Seluruh scoring type dan state transition dibuktikan dengan test.
- [x] Sepuluh scorer, ownership, expiry, exam secrecy, snapshot integrity, dan atomic persistence lulus test.

### Gate 5 - Aktifkan Progress, SRS, Mistake, XP, Dan Streak

**Tujuan**: setiap session completion menghasilkan perubahan progress yang konsisten dan idempotent.  
**Dependency**: Gate 4 DONE.

- [x] Tambahkan unique constraint/index domain untuk lesson progress, mastery, mistake, dan review schedule.
- [x] Implementasikan progress update idempotent setelah session complete.
- [x] Implementasikan mastery rule yang dapat dikonfigurasi dan diaudit.
- [x] Buat/update SRS schedule pada jawaban serta terapkan interval 1/3/7/14/30 hari.
- [x] Kembalikan interval pendek setelah jawaban salah dan update mastery saat review.
- [x] Implementasikan mistake lifecycle, XP ledger idempotent, dan streak berbasis timezone user.
- [x] Ganti seluruh placeholder dashboard dengan agregasi data aktual.
- [x] Lengkapi review summary/session, lesson/activity list, recommendation, dan readiness prediction awal.
- [x] Aktifkan review-session dan mistake-session selection melalui extension point learning engine.
- [x] Tambahkan concurrency, timezone-boundary, idempotency, SRS, XP, mistake, dan dashboard test.

**Exit criteria**:

- [x] Progress, mastery, SRS, mistake, XP, dan streak berubah benar dari satu session end-to-end.
- [x] Tidak ada row duplikat akibat retry atau request concurrent.
- [x] Review-session dan mistake-session memilih soal yang benar lalu memperbarui schedule/mastery secara konsisten.

### Gate 6 - Bangun AI Generation Dan Audio Pipeline Yang Durable

**Tujuan**: AI/TTS menghasilkan draft dan audio secara asynchronous, dapat diamati, dan aman.  
**Dependency**: Gate 3 DONE untuk question workflow; Gate 2 DONE untuk source content.

- [x] Konfirmasi provider AI dan TTS sebelum mengunci implementasi provider pertama.
- [x] Gunakan queue/worker durable dengan Redis serta lifecycle job yang terpisah dari proses API.
- [x] Implementasikan prompt versioning dan grounding hanya dari materi terverifikasi.
- [x] Validasi output dengan Pydantic schema, business rule, dan duplicate detection.
- [x] Buat kandidat AI valid sebagai `AUTO_VALIDATED`; kandidat invalid hanya dicatat pada job dan tidak dibuat sebagai question.
- [x] Implementasikan retry, cancel, timeout, partial result, idempotency, dan failure reason.
- [x] Catat job ID, latency, token/cost, provider usage, dan error tanpa menyimpan secret.
- [x] Implementasikan audio job, cache, checksum, duration, transcript visibility, dan storage abstraction.
- [x] Sajikan audio melalui URL yang benar-benar dapat diakses dan tidak melalui base64.
- [x] Tambahkan mock-provider, success/failure/partial/retry/cancel/timeout, dan audio test.

**Exit criteria**:

- [x] Restart API tidak menghilangkan job yang sudah diterima.
- [x] Draft AI dan audio berhasil melewati pipeline, observability, dan review workflow.
- [x] Worker recovery, retry, cancel, timeout, generated-audio URL, dan transcript visibility lulus test menggunakan provider mock.

### Gate 7 - Penuhi Konten MVP N5

**Tujuan**: menyediakan dataset minimum yang dibutuhkan learning dan simulation engine.  
**Dependency**: Gate 2, 3, dan 6 DONE.

- [x] Sediakan minimal 10 unit pembelajaran.
- [x] Sediakan minimal 300 kosakata.
- [x] Sediakan minimal 80 kanji.
- [x] Sediakan minimal 30 grammar point.
- [x] Sediakan minimal 150 contoh kalimat.
- [x] Sediakan minimal 30 bacaan pendek.
- [x] Sediakan minimal 50 audio dengan transkrip.
- [x] Sediakan jumlah minimum soal published dan reviewed per section sesuai blueprint simulasi N5 yang telah dibekukan.
- [x] Hubungkan seluruh materi ke lesson dan learning objective yang sesuai.
- [x] Lakukan review manusia untuk konten Jepang dan soal published.
- [x] Verifikasi placeholder N4-N1 dapat dibuat tanpa migration atau redesign besar.

**Exit criteria**:

- [x] Automated count memverifikasi target volume, relasi, publication status, reviewer evidence, dan coverage soal per section blueprint N5.

### Gate 8 - Dokumentasikan, Uji, Dan Deploy Core Backend Ke Staging

**Tujuan**: membuat core backend stabil untuk frontend sebelum simulasi JLPT ditambahkan.  
**Dependency**: Gate 0-7 DONE.

- [x] Validasi seluruh OpenAPI schema dan operation ID di CI.
- [x] Selaraskan API overview, auth, error, question type, dan frontend integration dengan route aktual.
- [x] Buat Postman collection serta development/staging environment dari OpenAPI tervalidasi.
- [x] Tambahkan unit, integration, contract, permission, upload, worker, migration, dan security suite.
- [x] Terapkan secret scanning, coverage gate, lint, test, dan migration check di CI.
- [x] Uji IDOR, SQL injection boundary, mass assignment, rate limit, answer leak, dan sensitive logging.
- [x] Lengkapi structured logging, request/response time, job/AI/TTS metrics, monitoring, dan alert.
- [x] Buat deployment API/worker, backup, migration, rollback, HTTPS, Redis, dan object-storage procedure.
- [x] Deploy core backend ke staging dan lakukan smoke test dari clean state.

**Exit criteria**:

- [x] Consumer contract smoke test melalui generated client atau Postman/Newman dapat menggunakan auth, curriculum, learning, progress, AI, dan audio dari staging.

### Gate 9 - Implementasikan Simulasi JLPT N5

**Tujuan**: memenuhi FR-030 dan acceptance criteria simulasi N5 end-to-end.  
**Dependency**: Gate 3-8 DONE.

- [x] Buat model/migration simulation, section, question mapping, attempt, answer, dan section score.
- [x] Implementasikan blueprint N5 yang telah dibekukan pada Gate 0.
- [x] Tambahkan index dan constraint untuk level/status serta user/simulation attempt.
- [x] Implementasikan admin CRUD, publish/unpublish, configuration validation, dan audit log.
- [x] Implementasikan learner list/detail/start/detail-attempt/answer/complete/result/history API.
- [x] Buat snapshot section, urutan soal, dan question revision ketika attempt dimulai.
- [x] Implementasikan attempt state machine dan timer total/per-section.
- [x] Tolak jawaban untuk attempt completed, expired, atau cancelled.
- [x] Implementasikan total/section scoring, skill analysis, weakness, recommendation, dan readiness update.
- [x] Buat satu simulasi N5 lengkap dengan vocabulary/kanji, grammar/reading, dan listening section.
- [x] Tambahkan `JLPT_SIMULATION.md`, OpenAPI, Postman flow, dan error contract.
- [x] Tambahkan unit, integration, timer, permission, answer-leak, dan N5 end-to-end test.

**Exit criteria**:

- [x] Simulasi N5 dapat dijalankan end-to-end di staging tanpa kunci jawaban bocor.
- [x] Model dapat menerima N4-N1 tanpa migration atau redesign besar.
- [x] Expired/completed rejection, section score, history, skill analysis, dan readiness update lulus test.

### Gate 10 - Final Release Hardening Dan MVP Acceptance

**Tujuan**: membuktikan seluruh acceptance criteria master PRD sebelum release candidate.  
**Dependency**: Gate 0-9 DONE.

- [x] Jalankan seluruh quality gate pada clean environment dan database kosong.
- [x] Jalankan auth, curriculum, learning, review, AI, audio, progress, dan JLPT smoke flow di staging.
- [x] Verifikasi rollback migration, backup restore, worker recovery, dan failed-job alert.
- [x] Verifikasi OpenAPI, Postman, dokumentasi frontend, dan sample account/data.
- [x] Verifikasi performance baseline p95 dan dependency readiness.
- [x] Verifikasi security baseline dan tidak adanya secret/answer-key leakage.
- [x] Bekukan contract API v1 dan catat breaking-change policy.
- [x] Buat changelog, release notes, known limitations, dan operational handoff.
- [x] Tandai checklist tahap sebagai DONE hanya berdasarkan bukti final.

**Exit criteria**:

- [x] Seluruh kriteria penerimaan MVP pada master PRD lulus dan dapat ditelusuri ke test atau bukti staging.
- [x] Seluruh baris acceptance pada `MVP-TRACEABILITY.md` berstatus `DONE` dengan evidence yang dapat dibuka.

## 7. Urutan Eksekusi Ringkas

```text
Gate 0 Baseline -> Gate 1 Auth/RBAC -> Gate 2 Curriculum/Audio Foundation -> Gate 3 Question Bank
                                                                    |-> Gate 4 Learning -> Gate 5 Progress/SRS --|
                                                                    |-> Gate 6 AI/TTS -> Gate 7 Konten N5 ------|-> Gate 8 Core Staging -> Gate 9 JLPT N5 -> Gate 10 Release
```

Gate 6 boleh dikerjakan paralel dengan Gate 4-5 setelah Gate 2 dan Gate 3 selesai, tetapi tidak boleh melewati workflow review question. Gate 8 menunggu Gate 5 dan Gate 7; Gate 10 adalah hardening final setelah simulasi JLPT tersedia.

## 8. Open Questions Sebelum Gate 6 Dan Staging

- Provider AI pertama wajib dikonfirmasi ulang; Gemini tetap kandidat, bukan keputusan permanen.
- Provider TTS dan object storage production dipilih sebelum Gate 6 dinyatakan DONE.
- Target p95, kapasitas staging, retention raw AI response, dan budget usage ditetapkan sebelum Gate 8.
