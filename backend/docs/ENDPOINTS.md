# Endpoint Catalog

> Generated from `app.openapi()` by `python scripts/generate_api_docs.py`. Do not edit manually.

API version: **1.0.0**

Authentication uses `Authorization: Bearer <access_token>` unless an endpoint is marked Public.

## Admin Audit

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/admin/audit-logs` | Bearer | List admin audit logs |

## Admin Materials

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/admin/materials` | Bearer | List uploaded PDF source materials |
| `POST` | `/api/v1/admin/materials/pdf` | Bearer | Upload a PDF source material |
| `GET` | `/api/v1/admin/materials/{material_id}` | Bearer | Get one uploaded source material |
| `PATCH` | `/api/v1/admin/materials/{material_id}` | Bearer | Edit material metadata |
| `DELETE` | `/api/v1/admin/materials/{material_id}` | Bearer | Archive a PDF material |
| `GET` | `/api/v1/admin/materials/{material_id}/analytics` | Bearer | Get production analytics for one PDF material |
| `GET` | `/api/v1/admin/materials/{material_id}/analytics.csv` | Bearer | Export production analytics for one PDF material as CSV |
| `GET` | `/api/v1/admin/materials/{material_id}/preview` | Bearer | Preview extracted PDF text before it is used by AI |
| `POST` | `/api/v1/admin/materials/{material_id}/publish` | Bearer | Publish a PDF material |
| `POST` | `/api/v1/admin/materials/{material_id}/unpublish` | Bearer | Unpublish a PDF material |

## Admin Users

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/admin/users` | Bearer | List users |
| `POST` | `/api/v1/admin/users` | Bearer | Create a user |
| `GET` | `/api/v1/admin/users/{user_id}` | Bearer | Get a user |
| `PATCH` | `/api/v1/admin/users/{user_id}` | Bearer | Update a user |
| `DELETE` | `/api/v1/admin/users/{user_id}` | Bearer | Deactivate a user |
| `PATCH` | `/api/v1/admin/users/{user_id}/role` | Bearer | Assign a user role |
| `PATCH` | `/api/v1/admin/users/{user_id}/status` | Bearer | Change a user account status |

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
| `GET` | `/api/v1/app/attempts` | Bearer | Get learner attempt history |
| `GET` | `/api/v1/app/dashboard` | Bearer | Get learner dashboard |
| `GET` | `/api/v1/app/leaderboard` | Bearer | Get XP leaderboard |
| `GET` | `/api/v1/app/materials` | Bearer | Get published materials |
| `GET` | `/api/v1/app/materials/{material_id}` | Bearer | Get one material |
| `GET` | `/api/v1/app/materials/{material_id}/file` | Bearer | Stream an admin-uploaded PDF |
| `POST` | `/api/v1/app/materials/{material_id}/generate-quiz` | Bearer | Generate a quiz from a PDF material |
| `GET` | `/api/v1/app/me` | Bearer | Get the signed-in user |
| `GET` | `/api/v1/app/quiz-sessions/{session_id}/questions` | Bearer | Get learner-safe quiz questions |
| `GET` | `/api/v1/app/quiz-sessions/{session_id}/result` | Bearer | Get quiz result |
| `GET` | `/api/v1/app/quiz-sessions/{session_id}/status` | Bearer | Get quiz session status |
| `POST` | `/api/v1/app/quiz-sessions/{session_id}/submit` | Bearer | Submit quiz answers and calculate result |
