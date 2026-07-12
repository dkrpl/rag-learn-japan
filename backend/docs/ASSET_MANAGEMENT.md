# Pengelolaan Materi PDF

Materi utama MVP adalah PDF yang di-upload oleh admin/content editor ke lesson. User tidak meng-upload materi; user hanya memilih PDF yang tersedia, meminta AI membuat soal dari PDF tersebut, lalu mengerjakan sesi soal.

## Materi Yang Didukung

- Level, course, unit, lesson, dan lesson section.
- PDF lesson melalui `MaterialDocument`.
- Soal pilihan ganda reading yang dibuat AI dari teks PDF.
- Progress lesson, XP, dan leaderboard.

## Lifecycle

1. Admin membuat struktur kursus.
2. Admin upload PDF ke lesson.
3. Backend menyimpan file PDF, mengekstrak teks, dan menyimpan metadata material.
4. Lesson dipublish jika sudah punya objective dan section atau PDF material.
5. User membuka PDF, generate soal, mengerjakan, lalu mendapatkan XP jika lulus KKM.

## Storage

Untuk production, gunakan volume persisten atau object storage yang dipasang ke path material:

```env
MATERIAL_STORAGE_PATH=/app/data/uploads/materials
```

Jangan memakai filesystem container ephemeral untuk file PDF production jika API/worker bisa direstart atau berjalan multi-instance.

## Hak Cipta Dan Lisensi

Jangan memasukkan PDF buku, soal ujian resmi, atau dataset pihak lain tanpa izin redistribusi. Simpan informasi sumber dan lisensi di proses operasional admin.
