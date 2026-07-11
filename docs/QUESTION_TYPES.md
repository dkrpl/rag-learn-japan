# Question Types Schema

Di database, struktur JSON yang dikembalikan untuk pertanyaan bervariasi bergantung pada tipe pertanyaannya. Frontend harus merender komponen yang berbeda (UI) untuk setiap tipe.

## 1. MULTIPLE_CHOICE
```json
{
  "text": "Apa arti kata ini?",
  "options": [
    {"id": "A", "text": "Kucing"},
    {"id": "B", "text": "Anjing"}
  ]
}
```

## 2. TRUE_FALSE
```json
{
  "text": "Kanji ini dibaca 'Inu'.",
  "options": [
    {"id": "TRUE", "text": "Benar"},
    {"id": "FALSE", "text": "Salah"}
  ]
}
```

## 3. MATCHING
```json
{
  "text": "Cocokkan pasangan berikut",
  "pairs_left": [{"id": "L1", "text": "Kucing"}],
  "pairs_right": [{"id": "R1", "text": "Neko"}]
}
```

## Note Security
Kunci jawaban (`answer_key_json`) akan selalu disensor dari objek pertanyaan saat direquest oleh `Learner` di endpoint `GET /learning-sessions/.../questions`. Frontend tidak boleh mengandalkan validasi di browser/client-side. Validasi mutlak terjadi di backend pada saat submit POST `answers`.
