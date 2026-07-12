# Endpoint Catalog

> Generated from `app.openapi()` by `python scripts/generate_api_docs.py`. Do not edit manually.

API version: **1.0.0**

Authentication uses `Authorization: Bearer <access_token>` unless an endpoint is marked Public.

## Auth

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `POST` | `/api/v1/auth/login` | Public | Create a login session |
| `POST` | `/api/v1/auth/logout` | Bearer | Revoke one login session |
| `POST` | `/api/v1/auth/refresh` | Public | Rotate a refresh token |
| `POST` | `/api/v1/auth/register` | Public | Register a learner account |

## Frontend

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/app/ai-question-jobs/{job_id}` | Bearer | Get an owned AI question job |
| `POST` | `/api/v1/app/ai-question-jobs/{job_id}/sessions` | Bearer | Start a session from questions created by an AI job |
| `GET` | `/api/v1/app/catalog` | Bearer | Get published course catalog |
| `GET` | `/api/v1/app/dashboard` | Bearer | Get learner MVP dashboard |
| `GET` | `/api/v1/app/leaderboard` | Bearer | Get XP leaderboard |
| `GET` | `/api/v1/app/lessons/{lesson_id}` | Bearer | Get one lesson with content |
| `GET` | `/api/v1/app/lessons/{lesson_id}/materials` | Bearer | Get PDFs uploaded by admin for a lesson |
| `POST` | `/api/v1/app/materials/{material_id}/ai-question-jobs` | Bearer | Generate questions from an admin-uploaded PDF |
| `GET` | `/api/v1/app/materials/{material_id}/file` | Bearer | Stream an admin-uploaded PDF for the lesson viewer |
| `GET` | `/api/v1/app/me` | Bearer | Get the signed-in user |
| `GET` | `/api/v1/app/sessions/{session_id}` | Bearer | Get an owned practice session |
| `POST` | `/api/v1/app/sessions/{session_id}/answers` | Bearer | Submit an answer |
| `POST` | `/api/v1/app/sessions/{session_id}/complete` | Bearer | Complete a fully answered session |
| `GET` | `/api/v1/app/sessions/{session_id}/questions` | Bearer | Get learner-safe session questions |
