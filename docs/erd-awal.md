# Rancangan ERD Awal - Nihongo Learning API

Diagram ini menunjukkan rancangan skema Entity Relationship awal berdasarkan scope di `tahap1.md`.
Tabel-tabel ini akan dibuat secara bertahap selama pengembangan proyek.

## Mermaid ER Diagram

```mermaid
erDiagram
    %% Auth Domain
    USERS {
        uuid id PK
        string email
        string hashed_password
        boolean is_active
        datetime created_at
    }
    ROLES {
        int id PK
        string name "e.g., admin, learner, reviewer"
    }
    USER_ROLES {
        uuid user_id FK
        int role_id FK
    }
    REFRESH_TOKENS {
        uuid id PK
        uuid user_id FK
        string token
        datetime expires_at
    }

    %% Curriculum Domain
    LEVELS {
        int id PK
        string name "e.g., N5, N4"
    }
    COURSES {
        uuid id PK
        int level_id FK
        string title
        string description
    }
    UNITS {
        uuid id PK
        uuid course_id FK
        string title
        int sequence
    }
    LESSONS {
        uuid id PK
        uuid unit_id FK
        string title
        int sequence
    }

    %% Content Domain
    VOCABULARIES {
        uuid id PK
        uuid lesson_id FK
        string word
        string kana
        string meaning
    }
    GRAMMAR_POINTS {
        uuid id PK
        uuid lesson_id FK
        string title
        string structure
        string meaning
    }
    EXAMPLE_SENTENCES {
        uuid id PK
        uuid vocabulary_id FK
        uuid grammar_point_id FK
        string japanese
        string romaji
        string indonesian
    }

    %% Question Domain
    QUESTIONS {
        uuid id PK
        string question_type "e.g., multiple_choice"
        string content
        boolean is_published
        uuid vocabulary_id FK
        uuid grammar_point_id FK
    }
    QUESTION_OPTIONS {
        uuid id PK
        uuid question_id FK
        string content
        boolean is_correct
    }

    %% Learning & Progress Domain
    LEARNING_SESSIONS {
        uuid id PK
        uuid user_id FK
        uuid lesson_id FK
        datetime started_at
        datetime ended_at
    }
    USER_ANSWERS {
        uuid id PK
        uuid session_id FK
        uuid question_id FK
        uuid option_id FK
        boolean is_correct
    }
    USER_MASTERIES {
        uuid id PK
        uuid user_id FK
        string item_type "vocabulary or grammar"
        uuid item_id "ID of vocabulary/grammar"
        int srs_level
        datetime next_review_at
    }

    %% Relationships
    USERS ||--o{ USER_ROLES : has
    ROLES ||--o{ USER_ROLES : mapped_to
    USERS ||--o{ REFRESH_TOKENS : owns

    LEVELS ||--o{ COURSES : contains
    COURSES ||--o{ UNITS : contains
    UNITS ||--o{ LESSONS : contains

    LESSONS ||--o{ VOCABULARIES : teaches
    LESSONS ||--o{ GRAMMAR_POINTS : teaches
    VOCABULARIES ||--o{ EXAMPLE_SENTENCES : uses
    GRAMMAR_POINTS ||--o{ EXAMPLE_SENTENCES : uses

    VOCABULARIES ||--o{ QUESTIONS : tested_in
    GRAMMAR_POINTS ||--o{ QUESTIONS : tested_in
    QUESTIONS ||--o{ QUESTION_OPTIONS : has

    USERS ||--o{ LEARNING_SESSIONS : takes
    LESSONS ||--o{ LEARNING_SESSIONS : based_on
    LEARNING_SESSIONS ||--o{ USER_ANSWERS : contains
    QUESTIONS ||--o{ USER_ANSWERS : receives
    QUESTION_OPTIONS ||--o{ USER_ANSWERS : selected
    USERS ||--o{ USER_MASTERIES : achieves
```

## Deskripsi Domain Utama
1. **Auth**: Berisi user, role, relasi user dengan role (RBAC), serta token refresh.
2. **Curriculum**: Menggambarkan level bahasa (seperti N5), ke kursus, unit, sampai pecahan pelajaran terkecil (lesson).
3. **Content**: Menyimpan *vocabulary* dan *grammar point* yang direlasikan ke lesson, serta kalimat contoh (example_sentences).
4. **Question**: Tabel soal-soal latihan (baik dibuat manual atau dari AI generator).
5. **Learning & Progress**: Menyimpan sesi belajar *user* (`learning_sessions`), *user answers* (jawaban per soal), dan *mastery* (tingkat penguasaan berbasis interval pengulangan/SRS).
6. *(Untuk domain yang lebih kompleks seperti JLPT Simulation dan Job Queue AI, tabelnya akan ditambahkan kemudian pada sprint bersangkutan)*.
