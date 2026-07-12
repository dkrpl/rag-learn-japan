# Question Type Schema

MVP hanya mendukung soal reading pilihan ganda dari PDF.

## MULTIPLE_CHOICE

Payload learner:

```json
{
  "text": "Apa arti kalimat ini?",
  "options": [
    {"id": "a", "text": "Selamat pagi"},
    {"id": "b", "text": "Selamat malam"}
  ]
}
```

Payload submit jawaban:

```json
{
  "answer_json": {
    "selected_option_id": "a"
  }
}
```

`answer_key_json` dan `explanation_json` tidak dikirim sebelum user submit jawaban. Validasi selalu dilakukan di backend.
