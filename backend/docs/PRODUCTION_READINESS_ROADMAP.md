# Production Readiness Roadmap

Dokumen ini merangkum pengembangan agar Nihongo Learn siap dipakai production
dengan alur material-first.

## Tujuan Production

Produk harus stabil untuk alur:

```text
Admin upload PDF -> publish material -> user generate quiz -> submit -> pass/fail -> EXP -> leaderboard
```

Fitur yang tidak mendukung alur ini langsung dianggap post-MVP atau internal.

## Prioritas 1 - Alur Belajar Stabil

- Admin dapat upload, preview, publish, unpublish, dan archive PDF.
- User hanya melihat material published.
- Material pertama terbuka otomatis.
- Material berikutnya terbuka hanya setelah material sebelumnya lulus.
- Attempt gagal tetap tersimpan tetapi `earned_exp = 0`.
- EXP dan leaderboard hanya berubah dari attempt lulus.

## Prioritas 2 - Review Hasil Quiz

Status: sudah tersedia pada response submit/result dan frontend quiz page.

Setelah submit, frontend menampilkan:

- Status lulus/gagal.
- Score dan passing score.
- Correct answers.
- Earned EXP.
- Feedback per soal jika backend mengirimkannya.

Backend tidak boleh mengirim answer key sebelum submit.

## Prioritas 3 - Leaderboard Layak Production

Status: filter frontend dan query backend sudah tersedia.

Mode leaderboard:

- `all`
- `weekly`
- `monthly`

Leaderboard memakai total EXP valid, bukan jumlah attempt.

## Prioritas 4 - Admin Material Analytics

Status: endpoint backend dan halaman frontend admin sudah tersedia, termasuk
difficulty breakdown, score buckets, dan recent attempts.

Endpoint analytics admin:

```http
GET /api/v1/admin/materials/{material_id}/analytics
GET /api/v1/admin/materials/{material_id}/analytics.csv
```

Response target:

```json
{
  "material_id": "material_id",
  "total_attempts": 120,
  "completed_learners": 35,
  "average_score": 78,
  "pass_rate": 64,
  "most_used_difficulty": 2
}
```

Analytics ini sudah bisa dipakai frontend admin untuk membaca performa materi dan
mengekspor laporan CSV sederhana.

## Prioritas 5 - Anti EXP Farming

Status: kelulusan ulang tidak memberi EXP tambahan. Database juga memiliki
unique constraint per `user_id`, `material_id`, dan reason reward.

Aturan yang disarankan:

- EXP penuh diberikan pada kelulusan pertama material.
- Attempt ulang boleh memperbarui best score.
- Attempt ulang tidak boleh menggandakan EXP tanpa batas.
- Semua pemberian EXP harus tercatat di `xp_transactions`.

## Prioritas 6 - AI Quality Guard

Status: guard dasar sudah tersedia untuk JSON, opsi, duplikasi, correct option,
grounding sederhana, raw response audit, dan error ramah frontend.

AI generator harus:

- Memvalidasi format JSON.
- Menolak soal tanpa opsi.
- Menolak opsi jawaban duplikat.
- Menolak soal yang tidak berkaitan dengan PDF.
- Menyimpan raw response untuk audit.
- Memberi error ramah untuk frontend jika generate gagal.

## Prioritas 7 - Security Dan Deploy

- CORS dibatasi ke domain frontend.
- Rate limit login.
- Rate limit generate quiz.
- Validasi PDF berdasarkan MIME type dan ukuran.
- Admin endpoint memakai role guard.
- Audit log admin untuk perubahan material penting.
- Migration Alembic aman untuk database kosong Railway.
- `/health` dan `/ready` tetap tersedia untuk platform deploy.

## Prioritas 9 - Operasional Data

Status: script awal sudah tersedia.

- Backup logical database via `scripts/backup_database.py`.
- Retention cleanup untuk raw response AI via `scripts/retention_cleanup.py`.
- Export analytics CSV per material.
- Audit log admin untuk trace perubahan konten.

Script retention default berjalan dry-run. Set `APPLY_RETENTION=true` hanya setelah
hasil dry-run dicek.

## Prioritas 10 - CI/CD

Status: workflow GitHub Actions tersedia di `.github/workflows/ci.yml`.

Pipeline minimal:

- Backend install dependency dan menjalankan pytest.
- Frontend menjalankan lint dan build.
- Smoke test production tetap dijalankan setelah deploy Railway.

## Prioritas 8 - Test Minimum

Backend:

- Auth register/login.
- Admin upload PDF.
- Admin publish/unpublish/archive PDF.
- User list/open material.
- User generate quiz.
- User submit lulus.
- User submit gagal.
- EXP tidak masuk saat gagal.
- Leaderboard berubah hanya dari EXP valid.
- Learner ditolak dari endpoint admin.

Frontend:

- `npm run lint`.
- `npm run build`.
- Login/register smoke test.
- Dashboard user/admin smoke test.
- Generate quiz dan submit smoke test.

Script smoke test deploy tersedia:

```bash
python scripts/smoke_test.py
```
