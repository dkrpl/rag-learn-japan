# Pengelolaan Materi Dan Audio

Materi dan audio adalah data yang dikelola melalui endpoint administrator/content editor. File tidak ditanam permanen di kode aplikasi.

## Materi Yang Didukung

- Level, course, unit, lesson, dan lesson section.
- Vocabulary, kanji, grammar point, example sentence, dan reading.
- Audio asset dengan transcript, MIME type, ukuran, checksum, dan visibility.
- Question bank yang mengacu pada lesson/reading/audio.

## Lifecycle

1. Content editor membuat atau mengimpor materi sebagai draft.
2. Materi diperiksa dan dihubungkan ke lesson.
3. Lesson hanya dipublikasikan setelah mempunyai objective dan konten minimum.
4. Learner hanya menerima resource published/non-archived.
5. Resource yang sudah direferensikan diarsipkan, bukan dihapus dari history.

## Upload Audio

Gunakan endpoint admin audio di katalog endpoint. Backend memvalidasi MIME type dan ukuran, menghitung checksum, lalu menyimpan metadata. Client learner menerima URL; file audio tidak pernah dikirim sebagai base64 di JSON.

Untuk satu host, gunakan:

```env
AUDIO_STORAGE_PROVIDER=local
AUDIO_STORAGE_PATH=/app/data/uploads/audio
```

Untuk multi-instance, gunakan S3-compatible storage:

```env
AUDIO_STORAGE_PROVIDER=s3
S3_BUCKET_NAME=nihongo-audio
S3_ENDPOINT_URL=https://<account>.r2.cloudflarestorage.com
S3_REGION=auto
S3_ACCESS_KEY_ID=...
S3_SECRET_ACCESS_KEY=...
```

## Seed Materi

Seed production starter harus:

- Idempotent.
- Memakai teks Jepang UTF-8 yang valid.
- Tidak membuat kata/kanji sintetis dengan suffix angka.
- Tidak menandai materi sebagai reviewed tanpa pemeriksaan manusia.
- Menyimpan provenance dan versi dataset bila berasal dari sumber eksternal.

Audio dummy lama di `data/uploads/audio/mock_*` hanya fixture historis dan tidak boleh dipakai sebagai materi learner production. Audio production berasal dari upload berlisensi atau provider TTS yang dikonfigurasi.

## Hak Cipta Dan Lisensi

Jangan memasukkan audio, teks buku, soal ujian resmi, atau dataset pihak lain tanpa lisensi yang mengizinkan redistribusi. Simpan nama sumber, versi, lisensi, dan tanggal impor bersama manifest aset.
