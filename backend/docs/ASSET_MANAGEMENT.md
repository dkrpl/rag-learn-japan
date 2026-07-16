# Pengelolaan Materi PDF

Materi utama MVP adalah PDF yang di-upload oleh admin/content editor.
User tidak meng-upload materi.

## Materi Yang Didukung

- PDF material berbasis teks.
- Metadata material: title, description, level, category, sequence, passing score.
- Preview hasil ekstraksi teks PDF.
- Soal pilihan ganda reading yang dibuat AI dari teks PDF.
- Progress material, EXP, attempt history, dan leaderboard.

## Lifecycle

1. Admin upload PDF material.
2. Backend menyimpan file PDF.
3. Backend mengekstrak teks PDF.
4. Admin preview hasil ekstraksi.
5. Admin publish material.
6. User membuka material dan PDF.
7. User memilih difficulty lalu generate quiz.
8. User submit jawaban.
9. Jika score memenuhi passing score, user mendapat EXP dan material berikutnya terbuka.
10. Jika score kurang, EXP tetap 0 dan user harus mengulang.

## Storage

Untuk production, gunakan volume persisten atau object storage yang dipasang ke path material:

```env
MATERIAL_STORAGE_PATH=/app/data/uploads/materials
```

Jangan memakai filesystem container ephemeral untuk file PDF production jika API/worker bisa direstart atau berjalan multi-instance.

## Hak Cipta Dan Lisensi

Jangan memasukkan PDF buku, soal ujian resmi, atau dataset pihak lain tanpa izin redistribusi.
Simpan informasi sumber dan lisensi di proses operasional admin.
