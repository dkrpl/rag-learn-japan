# Deployment Backend

Dokumen ini menjelaskan deployment API, Celery worker, MySQL, Redis, dan storage PDF material. Frontend tidak termasuk deployment ini.

## Topologi Minimum

- API FastAPI: container `api`.
- Worker durable: container `worker`.
- Database: MySQL 8.4 dengan `utf8mb4`.
- Broker/result backend: Redis 7.4 dengan persistence.
- PDF material: volume persisten yang dipakai API dan worker.
- Reverse proxy/load balancer: TLS termination, request limit, dan rate limiting perimeter.

## Persiapan Environment

1. Salin `.env.example` menjadi file environment yang dikelola secret manager.
2. Ganti `SECRET_KEY`, password MySQL, password Redis, CORS origin, dan allowed host.
3. Set `MATERIAL_STORAGE_PATH` ke volume persisten.
4. Biarkan `AI_PROVIDER=disabled` sampai credential provider tersedia.
5. Jangan menyimpan file environment production di repository.

Secret dapat dibuat dengan:

```bash
python -c "import secrets; print(secrets.token_urlsafe(64))"
```

## Menjalankan Production Compose

```bash
docker compose --env-file .env.production -f docker-compose.production.yml build
docker compose --env-file .env.production -f docker-compose.production.yml up -d db redis
docker compose --env-file .env.production -f docker-compose.production.yml run --rm migrate
docker compose --env-file .env.production -f docker-compose.production.yml up -d api worker
```

API dipublikasikan ke `127.0.0.1:8000` secara default. Letakkan Nginx, Caddy, Traefik, atau load balancer cloud di depannya untuk HTTPS.

## Health Dan Observability

- `GET /health`: proses API hidup; tidak memerlukan database.
- `GET /ready`: MySQL dan Redis dapat diakses.
- `GET /metrics`: metrik Prometheus; batasi aksesnya pada jaringan internal.
- Header `X-Request-ID`: korelasi response dengan structured log.

## Migration

Migration dijalankan sebagai one-off job sebelum API/worker versi baru menerima traffic:

```bash
docker compose --env-file .env.production -f docker-compose.production.yml run --rm migrate
```

Jangan menjalankan Alembic secara paralel dari setiap replica API. Lakukan backup sebelum migration yang mengubah atau menghapus data.

## Backup Dan Restore

Contoh backup logical:

```bash
docker compose -f docker-compose.production.yml exec -T db \
  mysqldump -unihongo -p nihongo > backup-$(date +%Y%m%d-%H%M%S).sql
```

Backup wajib dienkripsi, mempunyai retention policy, dan diuji melalui restore rehearsal berkala. Volume material PDF harus dibackup terpisah.

## Rollback

1. Hentikan traffic ke image baru.
2. Jalankan image aplikasi sebelumnya.
3. Gunakan `alembic downgrade <revision>` hanya jika migration tersebut secara eksplisit dinyatakan reversible dan backup tersedia.
4. Restore backup jika rollback schema tidak aman.
5. Verifikasi `/health`, `/ready`, auth, curriculum, material PDF, learning, dan leaderboard sebelum membuka traffic.

## Scaling

- Tambah replica API di belakang load balancer.
- Tambah worker Celery berdasarkan panjang queue dan latency job.
- Gunakan object storage ketika API/worker berjalan pada lebih dari satu host.
- Jangan menggunakan filesystem container ephemeral untuk material PDF production.
