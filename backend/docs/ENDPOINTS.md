# Endpoint Catalog

> Generated from `app.openapi()` by `python scripts/generate_api_docs.py`. Do not edit manually.

API version: **1.0.0**

Authentication uses `Authorization: Bearer <access_token>` unless an endpoint is marked Public.

## Admin Curriculum

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `POST` | `/api/v1/admin/curriculum/courses` | Bearer | Create Course |
| `GET` | `/api/v1/admin/curriculum/courses` | Bearer | List Courses |
| `GET` | `/api/v1/admin/curriculum/courses/{resource_id}` | Bearer | Get Course |
| `PUT` | `/api/v1/admin/curriculum/courses/{resource_id}` | Bearer | Replace Course |
| `PATCH` | `/api/v1/admin/curriculum/courses/{resource_id}` | Bearer | Update Course |
| `DELETE` | `/api/v1/admin/curriculum/courses/{resource_id}` | Bearer | Delete Archives Courses |
| `POST` | `/api/v1/admin/curriculum/courses/{resource_id}/archive` | Bearer | Archive Courses |
| `POST` | `/api/v1/admin/curriculum/courses/{resource_id}/publish` | Bearer | Publish Courses |
| `POST` | `/api/v1/admin/curriculum/courses/{resource_id}/restore` | Bearer | Restore Courses |
| `POST` | `/api/v1/admin/curriculum/courses/{resource_id}/unpublish` | Bearer | Unpublish Courses |
| `GET` | `/api/v1/admin/curriculum/lesson-sections` | Bearer | List Lesson Sections |
| `GET` | `/api/v1/admin/curriculum/lesson-sections/{resource_id}` | Bearer | Get Lesson Section |
| `PATCH` | `/api/v1/admin/curriculum/lesson-sections/{resource_id}` | Bearer | Update Lesson Section |
| `DELETE` | `/api/v1/admin/curriculum/lesson-sections/{resource_id}` | Bearer | Delete Archives Lesson-Sections |
| `POST` | `/api/v1/admin/curriculum/lesson-sections/{resource_id}/archive` | Bearer | Archive Lesson-Sections |
| `POST` | `/api/v1/admin/curriculum/lesson-sections/{resource_id}/publish` | Bearer | Publish Lesson-Sections |
| `POST` | `/api/v1/admin/curriculum/lesson-sections/{resource_id}/restore` | Bearer | Restore Lesson-Sections |
| `POST` | `/api/v1/admin/curriculum/lesson-sections/{resource_id}/unpublish` | Bearer | Unpublish Lesson-Sections |
| `POST` | `/api/v1/admin/curriculum/lessons` | Bearer | Create Lesson |
| `GET` | `/api/v1/admin/curriculum/lessons` | Bearer | List Lessons |
| `PUT` | `/api/v1/admin/curriculum/lessons/sections/{resource_id}` | Bearer | Replace Lesson Section |
| `POST` | `/api/v1/admin/curriculum/lessons/{lesson_id}/sections` | Bearer | Create Lesson Section |
| `GET` | `/api/v1/admin/curriculum/lessons/{resource_id}` | Bearer | Get Lesson |
| `PUT` | `/api/v1/admin/curriculum/lessons/{resource_id}` | Bearer | Replace Lesson |
| `PATCH` | `/api/v1/admin/curriculum/lessons/{resource_id}` | Bearer | Update Lesson |
| `DELETE` | `/api/v1/admin/curriculum/lessons/{resource_id}` | Bearer | Delete Archives Lessons |
| `POST` | `/api/v1/admin/curriculum/lessons/{resource_id}/archive` | Bearer | Archive Lessons |
| `POST` | `/api/v1/admin/curriculum/lessons/{resource_id}/publish` | Bearer | Publish Lessons |
| `POST` | `/api/v1/admin/curriculum/lessons/{resource_id}/restore` | Bearer | Restore Lessons |
| `POST` | `/api/v1/admin/curriculum/lessons/{resource_id}/unpublish` | Bearer | Unpublish Lessons |
| `POST` | `/api/v1/admin/curriculum/levels` | Bearer | Create Level |
| `GET` | `/api/v1/admin/curriculum/levels` | Bearer | List Levels |
| `GET` | `/api/v1/admin/curriculum/levels/{resource_id}` | Bearer | Get Level |
| `PUT` | `/api/v1/admin/curriculum/levels/{resource_id}` | Bearer | Replace Level |
| `PATCH` | `/api/v1/admin/curriculum/levels/{resource_id}` | Bearer | Update Level |
| `DELETE` | `/api/v1/admin/curriculum/levels/{resource_id}` | Bearer | Delete Archives Levels |
| `POST` | `/api/v1/admin/curriculum/levels/{resource_id}/archive` | Bearer | Archive Levels |
| `POST` | `/api/v1/admin/curriculum/levels/{resource_id}/publish` | Bearer | Publish Levels |
| `POST` | `/api/v1/admin/curriculum/levels/{resource_id}/restore` | Bearer | Restore Levels |
| `POST` | `/api/v1/admin/curriculum/levels/{resource_id}/unpublish` | Bearer | Unpublish Levels |
| `POST` | `/api/v1/admin/curriculum/units` | Bearer | Create Unit |
| `GET` | `/api/v1/admin/curriculum/units` | Bearer | List Units |
| `GET` | `/api/v1/admin/curriculum/units/{resource_id}` | Bearer | Get Unit |
| `PUT` | `/api/v1/admin/curriculum/units/{resource_id}` | Bearer | Replace Unit |
| `PATCH` | `/api/v1/admin/curriculum/units/{resource_id}` | Bearer | Update Unit |
| `DELETE` | `/api/v1/admin/curriculum/units/{resource_id}` | Bearer | Delete Archives Units |
| `POST` | `/api/v1/admin/curriculum/units/{resource_id}/archive` | Bearer | Archive Units |
| `POST` | `/api/v1/admin/curriculum/units/{resource_id}/publish` | Bearer | Publish Units |
| `POST` | `/api/v1/admin/curriculum/units/{resource_id}/restore` | Bearer | Restore Units |
| `POST` | `/api/v1/admin/curriculum/units/{resource_id}/unpublish` | Bearer | Unpublish Units |

## Admin Materials

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/admin/materials` | Bearer | List uploaded PDF source materials |
| `POST` | `/api/v1/admin/materials/pdf` | Bearer | Upload a PDF source material for a lesson |
| `GET` | `/api/v1/admin/materials/{material_id}` | Bearer | Get one uploaded source material |
| `GET` | `/api/v1/admin/materials/{material_id}/preview` | Bearer | Preview extracted PDF text before it is used by AI |
| `POST` | `/api/v1/admin/materials/{material_id}/publish` | Bearer | Publish a PDF material |
| `POST` | `/api/v1/admin/materials/{material_id}/question-jobs` | Bearer | Generate questions from an uploaded PDF material |
| `POST` | `/api/v1/admin/materials/{material_id}/unpublish` | Bearer | Unpublish a PDF material |

## Admin Users

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/admin/users` | Bearer | List users |
| `GET` | `/api/v1/admin/users/{user_id}` | Bearer | Get a user |
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
| `GET` | `/api/v1/app/ai-question-jobs/{job_id}` | Bearer | Get an owned AI question job |
| `POST` | `/api/v1/app/ai-question-jobs/{job_id}/regenerate` | Bearer | Regenerate questions from the same PDF material |
| `POST` | `/api/v1/app/ai-question-jobs/{job_id}/sessions` | Bearer | Start a session from questions created by an AI job |
| `GET` | `/api/v1/app/attempts` | Bearer | Get learner attempt history |
| `GET` | `/api/v1/app/catalog` | Bearer | Get published course catalog |
| `GET` | `/api/v1/app/dashboard` | Bearer | Get learner MVP dashboard |
| `GET` | `/api/v1/app/leaderboard` | Bearer | Get XP leaderboard |
| `GET` | `/api/v1/app/lessons/{lesson_id}` | Bearer | Get one lesson with content |
| `GET` | `/api/v1/app/lessons/{lesson_id}/materials` | Bearer | Get PDFs uploaded by admin for a lesson |
| `GET` | `/api/v1/app/lessons/{lesson_id}/progress` | Bearer | Get detailed progress for one lesson |
| `POST` | `/api/v1/app/materials/{material_id}/ai-question-jobs` | Bearer | Generate questions from an admin-uploaded PDF |
| `GET` | `/api/v1/app/materials/{material_id}/file` | Bearer | Stream an admin-uploaded PDF for the lesson viewer |
| `GET` | `/api/v1/app/me` | Bearer | Get the signed-in user |
| `GET` | `/api/v1/app/sessions/{session_id}` | Bearer | Get an owned practice session |
| `POST` | `/api/v1/app/sessions/{session_id}/answers` | Bearer | Submit an answer |
| `POST` | `/api/v1/app/sessions/{session_id}/complete` | Bearer | Complete a fully answered session |
| `GET` | `/api/v1/app/sessions/{session_id}/questions` | Bearer | Get learner-safe session questions |
