# Operations Runbook

## Service Checks

| Kondisi | Pemeriksaan | Tindakan Awal |
|:---|:---|:---|
| API tidak responsif | `/health`, container log, CPU/memory | Restart satu replica dan periksa exception terakhir. |
| API belum ready | `/ready`, koneksi MySQL/Redis | Periksa credential, DNS, pool, dan health dependency. |
| Job tertahan | Celery worker log dan status Redis | Pastikan worker hidup; retry hanya job yang idempotent. |
| Audio 404 | Metadata asset, storage key, volume/bucket | Verifikasi object tersedia dan URL belum kedaluwarsa. |
| Login gagal massal | auth audit log, rate limiter, waktu host | Periksa secret/token config tanpa mencetak token. |
| Latency naik | `/metrics`, query lambat, pool saturation | Cari endpoint/query dominan dan tambah kapasitas bila perlu. |

## Structured Logs

Log API ditulis sebagai JSON ke stdout dengan timestamp UTC, level, logger, request ID, path, status, dan durasi. Password, bearer token, refresh token, provider key, dan answer key tidak boleh dicatat.

## Alert Minimum

- Readiness gagal lebih dari 2 menit.
- HTTP 5xx melebihi 2% selama 5 menit.
- p95 endpoint biasa melebihi 500 ms selama 10 menit.
- Celery queue terus bertambah atau job failure melebihi 5%.
- MySQL disk/pool mendekati batas.
- Redis memory atau eviction meningkat.
- Backup harian gagal.

## Incident Handling

1. Catat waktu, dampak, versi image, dan request/job ID terkait.
2. Kurangi dampak: rollback, disable AI/TTS, atau hentikan endpoint administratif yang bermasalah.
3. Pertahankan bukti log tanpa mengekspos data sensitif.
4. Pulihkan service dan jalankan smoke test.
5. Buat postmortem serta regression test sebelum deploy ulang.
