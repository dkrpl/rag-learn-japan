# Endpoint Catalog

> Generated from `app.openapi()` by `python scripts/generate_api_docs.py`. Do not edit manually.

API version: **1.0.0**

Authentication uses `Authorization: Bearer <access_token>` unless an endpoint is marked Public.

## Admin AI Jobs

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/admin/generation-jobs/` | Bearer | Get Jobs |
| `POST` | `/api/v1/admin/generation-jobs/` | Bearer | Create Generation Job |
| `POST` | `/api/v1/admin/generation-jobs/audio` | Bearer | Create Audio Job |
| `GET` | `/api/v1/admin/generation-jobs/{job_id}` | Bearer | Get Job |
| `DELETE` | `/api/v1/admin/generation-jobs/{job_id}` | Bearer | Cancel Job |

## Admin Content

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `POST` | `/api/v1/admin/content/audio` | Bearer | Upload Audio |
| `GET` | `/api/v1/admin/content/audio` | Bearer | List Audio Assets |
| `GET` | `/api/v1/admin/content/audio/{audio_id}` | Bearer | Get Audio Asset |
| `PATCH` | `/api/v1/admin/content/audio/{audio_id}` | Bearer | Update Audio Asset |
| `POST` | `/api/v1/admin/content/audio/{resource_id}/archive` | Bearer | Archive Audio |
| `POST` | `/api/v1/admin/content/audio/{resource_id}/publish` | Bearer | Publish Audio |
| `POST` | `/api/v1/admin/content/audio/{resource_id}/restore` | Bearer | Restore Audio |
| `POST` | `/api/v1/admin/content/audio/{resource_id}/unpublish` | Bearer | Unpublish Audio |
| `POST` | `/api/v1/admin/content/example-sentences` | Bearer | Create Example Sentences |
| `GET` | `/api/v1/admin/content/example-sentences` | Bearer | List Example Sentences |
| `GET` | `/api/v1/admin/content/example-sentences/{resource_id}` | Bearer | Get Example Sentences |
| `PATCH` | `/api/v1/admin/content/example-sentences/{resource_id}` | Bearer | Update Example Sentences |
| `POST` | `/api/v1/admin/content/example-sentences/{resource_id}/archive` | Bearer | Archive Example-Sentences |
| `POST` | `/api/v1/admin/content/example-sentences/{resource_id}/publish` | Bearer | Publish Example-Sentences |
| `POST` | `/api/v1/admin/content/example-sentences/{resource_id}/restore` | Bearer | Restore Example-Sentences |
| `POST` | `/api/v1/admin/content/example-sentences/{resource_id}/unpublish` | Bearer | Unpublish Example-Sentences |
| `POST` | `/api/v1/admin/content/grammar-points` | Bearer | Create Grammar Points |
| `GET` | `/api/v1/admin/content/grammar-points` | Bearer | List Grammar Points |
| `GET` | `/api/v1/admin/content/grammar-points/{resource_id}` | Bearer | Get Grammar Points |
| `PATCH` | `/api/v1/admin/content/grammar-points/{resource_id}` | Bearer | Update Grammar Points |
| `POST` | `/api/v1/admin/content/grammar-points/{resource_id}/archive` | Bearer | Archive Grammar-Points |
| `POST` | `/api/v1/admin/content/grammar-points/{resource_id}/publish` | Bearer | Publish Grammar-Points |
| `POST` | `/api/v1/admin/content/grammar-points/{resource_id}/restore` | Bearer | Restore Grammar-Points |
| `POST` | `/api/v1/admin/content/grammar-points/{resource_id}/unpublish` | Bearer | Unpublish Grammar-Points |
| `POST` | `/api/v1/admin/content/imports/csv` | Bearer | Import Content Csv |
| `POST` | `/api/v1/admin/content/imports/json` | Bearer | Import Content Json |
| `POST` | `/api/v1/admin/content/kanjis` | Bearer | Create Kanjis |
| `GET` | `/api/v1/admin/content/kanjis` | Bearer | List Kanjis |
| `GET` | `/api/v1/admin/content/kanjis/{resource_id}` | Bearer | Get Kanjis |
| `PATCH` | `/api/v1/admin/content/kanjis/{resource_id}` | Bearer | Update Kanjis |
| `POST` | `/api/v1/admin/content/kanjis/{resource_id}/archive` | Bearer | Archive Kanjis |
| `POST` | `/api/v1/admin/content/kanjis/{resource_id}/publish` | Bearer | Publish Kanjis |
| `POST` | `/api/v1/admin/content/kanjis/{resource_id}/restore` | Bearer | Restore Kanjis |
| `POST` | `/api/v1/admin/content/kanjis/{resource_id}/unpublish` | Bearer | Unpublish Kanjis |
| `POST` | `/api/v1/admin/content/readings` | Bearer | Create Readings |
| `GET` | `/api/v1/admin/content/readings` | Bearer | List Readings |
| `GET` | `/api/v1/admin/content/readings/{resource_id}` | Bearer | Get Readings |
| `PATCH` | `/api/v1/admin/content/readings/{resource_id}` | Bearer | Update Readings |
| `POST` | `/api/v1/admin/content/readings/{resource_id}/archive` | Bearer | Archive Readings |
| `POST` | `/api/v1/admin/content/readings/{resource_id}/publish` | Bearer | Publish Readings |
| `POST` | `/api/v1/admin/content/readings/{resource_id}/restore` | Bearer | Restore Readings |
| `POST` | `/api/v1/admin/content/readings/{resource_id}/unpublish` | Bearer | Unpublish Readings |
| `POST` | `/api/v1/admin/content/vocabularies` | Bearer | Create Vocabularies |
| `GET` | `/api/v1/admin/content/vocabularies` | Bearer | List Vocabularies |
| `GET` | `/api/v1/admin/content/vocabularies/{resource_id}` | Bearer | Get Vocabularies |
| `PATCH` | `/api/v1/admin/content/vocabularies/{resource_id}` | Bearer | Update Vocabularies |
| `POST` | `/api/v1/admin/content/vocabularies/{resource_id}/archive` | Bearer | Archive Vocabularies |
| `POST` | `/api/v1/admin/content/vocabularies/{resource_id}/publish` | Bearer | Publish Vocabularies |
| `POST` | `/api/v1/admin/content/vocabularies/{resource_id}/restore` | Bearer | Restore Vocabularies |
| `POST` | `/api/v1/admin/content/vocabularies/{resource_id}/unpublish` | Bearer | Unpublish Vocabularies |

## Admin Curriculum

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `POST` | `/api/v1/admin/curriculum/courses` | Bearer | Create Course |
| `GET` | `/api/v1/admin/curriculum/courses` | Bearer | List Courses |
| `GET` | `/api/v1/admin/curriculum/courses/{resource_id}` | Bearer | Get Course |
| `PATCH` | `/api/v1/admin/curriculum/courses/{resource_id}` | Bearer | Update Course |
| `POST` | `/api/v1/admin/curriculum/courses/{resource_id}/archive` | Bearer | Archive Courses |
| `POST` | `/api/v1/admin/curriculum/courses/{resource_id}/publish` | Bearer | Publish Courses |
| `POST` | `/api/v1/admin/curriculum/courses/{resource_id}/restore` | Bearer | Restore Courses |
| `POST` | `/api/v1/admin/curriculum/courses/{resource_id}/unpublish` | Bearer | Unpublish Courses |
| `GET` | `/api/v1/admin/curriculum/lesson-sections` | Bearer | List Lesson Sections |
| `GET` | `/api/v1/admin/curriculum/lesson-sections/{resource_id}` | Bearer | Get Lesson Section |
| `PATCH` | `/api/v1/admin/curriculum/lesson-sections/{resource_id}` | Bearer | Update Lesson Section |
| `POST` | `/api/v1/admin/curriculum/lesson-sections/{resource_id}/archive` | Bearer | Archive Lesson-Sections |
| `POST` | `/api/v1/admin/curriculum/lesson-sections/{resource_id}/publish` | Bearer | Publish Lesson-Sections |
| `POST` | `/api/v1/admin/curriculum/lesson-sections/{resource_id}/restore` | Bearer | Restore Lesson-Sections |
| `POST` | `/api/v1/admin/curriculum/lesson-sections/{resource_id}/unpublish` | Bearer | Unpublish Lesson-Sections |
| `POST` | `/api/v1/admin/curriculum/lessons` | Bearer | Create Lesson |
| `GET` | `/api/v1/admin/curriculum/lessons` | Bearer | List Lessons |
| `POST` | `/api/v1/admin/curriculum/lessons/{lesson_id}/grammar-points/{content_id}` | Bearer | Link Lesson Grammar-Points |
| `DELETE` | `/api/v1/admin/curriculum/lessons/{lesson_id}/grammar-points/{content_id}` | Bearer | Unlink Lesson Grammar-Points |
| `POST` | `/api/v1/admin/curriculum/lessons/{lesson_id}/kanjis/{content_id}` | Bearer | Link Lesson Kanjis |
| `DELETE` | `/api/v1/admin/curriculum/lessons/{lesson_id}/kanjis/{content_id}` | Bearer | Unlink Lesson Kanjis |
| `POST` | `/api/v1/admin/curriculum/lessons/{lesson_id}/readings/{reading_id}` | Bearer | Link Reading |
| `DELETE` | `/api/v1/admin/curriculum/lessons/{lesson_id}/readings/{reading_id}` | Bearer | Unlink Reading |
| `POST` | `/api/v1/admin/curriculum/lessons/{lesson_id}/sections` | Bearer | Create Lesson Section |
| `POST` | `/api/v1/admin/curriculum/lessons/{lesson_id}/vocabularies/{content_id}` | Bearer | Link Lesson Vocabularies |
| `DELETE` | `/api/v1/admin/curriculum/lessons/{lesson_id}/vocabularies/{content_id}` | Bearer | Unlink Lesson Vocabularies |
| `GET` | `/api/v1/admin/curriculum/lessons/{resource_id}` | Bearer | Get Lesson |
| `PATCH` | `/api/v1/admin/curriculum/lessons/{resource_id}` | Bearer | Update Lesson |
| `POST` | `/api/v1/admin/curriculum/lessons/{resource_id}/archive` | Bearer | Archive Lessons |
| `POST` | `/api/v1/admin/curriculum/lessons/{resource_id}/publish` | Bearer | Publish Lessons |
| `POST` | `/api/v1/admin/curriculum/lessons/{resource_id}/restore` | Bearer | Restore Lessons |
| `POST` | `/api/v1/admin/curriculum/lessons/{resource_id}/unpublish` | Bearer | Unpublish Lessons |
| `POST` | `/api/v1/admin/curriculum/levels` | Bearer | Create Level |
| `GET` | `/api/v1/admin/curriculum/levels` | Bearer | List Levels |
| `GET` | `/api/v1/admin/curriculum/levels/{resource_id}` | Bearer | Get Level |
| `PATCH` | `/api/v1/admin/curriculum/levels/{resource_id}` | Bearer | Update Level |
| `POST` | `/api/v1/admin/curriculum/levels/{resource_id}/archive` | Bearer | Archive Levels |
| `POST` | `/api/v1/admin/curriculum/levels/{resource_id}/publish` | Bearer | Publish Levels |
| `POST` | `/api/v1/admin/curriculum/levels/{resource_id}/restore` | Bearer | Restore Levels |
| `POST` | `/api/v1/admin/curriculum/levels/{resource_id}/unpublish` | Bearer | Unpublish Levels |
| `POST` | `/api/v1/admin/curriculum/units` | Bearer | Create Unit |
| `GET` | `/api/v1/admin/curriculum/units` | Bearer | List Units |
| `GET` | `/api/v1/admin/curriculum/units/{resource_id}` | Bearer | Get Unit |
| `PATCH` | `/api/v1/admin/curriculum/units/{resource_id}` | Bearer | Update Unit |
| `POST` | `/api/v1/admin/curriculum/units/{resource_id}/archive` | Bearer | Archive Units |
| `POST` | `/api/v1/admin/curriculum/units/{resource_id}/publish` | Bearer | Publish Units |
| `POST` | `/api/v1/admin/curriculum/units/{resource_id}/restore` | Bearer | Restore Units |
| `POST` | `/api/v1/admin/curriculum/units/{resource_id}/unpublish` | Bearer | Unpublish Units |

## Admin JLPT Simulations

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/admin/jlpt-simulations` | Bearer | List Simulations |
| `POST` | `/api/v1/admin/jlpt-simulations` | Bearer | Create Simulation |
| `GET` | `/api/v1/admin/jlpt-simulations/{simulation_id}` | Bearer | Get Simulation |
| `PATCH` | `/api/v1/admin/jlpt-simulations/{simulation_id}` | Bearer | Update Simulation |
| `DELETE` | `/api/v1/admin/jlpt-simulations/{simulation_id}` | Bearer | Archive Simulation |
| `GET` | `/api/v1/admin/jlpt-simulations/{simulation_id}/analytics` | Bearer | Get Simulation Analytics |
| `POST` | `/api/v1/admin/jlpt-simulations/{simulation_id}/publish` | Bearer | Publish Simulation |
| `POST` | `/api/v1/admin/jlpt-simulations/{simulation_id}/unpublish` | Bearer | Unpublish Simulation |

## Admin Questions

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `POST` | `/api/v1/admin/questions` | Bearer | Create a manual question draft |
| `GET` | `/api/v1/admin/questions` | Bearer | Filter and paginate the question bank |
| `GET` | `/api/v1/admin/questions/{question_id}` | Bearer | Get one question including internal review fields |
| `PATCH` | `/api/v1/admin/questions/{question_id}` | Bearer | Update an editable question and create a revision |
| `POST` | `/api/v1/admin/questions/{question_id}/approve` | Bearer | Approve a question under review |
| `POST` | `/api/v1/admin/questions/{question_id}/archive` | Bearer | Archive an unpublished question without deleting history |
| `POST` | `/api/v1/admin/questions/{question_id}/auto-validate` | Bearer | Run deterministic validation and move a draft to AUTO_VALIDATED |
| `GET` | `/api/v1/admin/questions/{question_id}/history` | Bearer | Get immutable question revisions |
| `POST` | `/api/v1/admin/questions/{question_id}/publish` | Bearer | Publish an approved, valid question |
| `POST` | `/api/v1/admin/questions/{question_id}/reject` | Bearer | Reject a question under review |
| `POST` | `/api/v1/admin/questions/{question_id}/request-revision` | Bearer | Return a question to its editor with required notes |
| `POST` | `/api/v1/admin/questions/{question_id}/submit-review` | Bearer | Move an AUTO_VALIDATED question to IN_REVIEW |
| `POST` | `/api/v1/admin/questions/{question_id}/unpublish` | Bearer | Remove a published question from learner selection |

## Admin Users

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/admin/users` | Bearer | List users |
| `GET` | `/api/v1/admin/users/{user_id}` | Bearer | Get a user |
| `PATCH` | `/api/v1/admin/users/{user_id}/role` | Bearer | Assign a user role |
| `PATCH` | `/api/v1/admin/users/{user_id}/status` | Bearer | Change a user account status |

## Audio

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/audio/{audio_id}` | Bearer | Stream Audio |
| `GET` | `/api/v1/audio/{audio_id}/metadata` | Bearer | Get Audio Metadata |

## Auth

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `POST` | `/api/v1/auth/forgot-password` | Public | Request a password reset |
| `POST` | `/api/v1/auth/login` | Public | Create a login session |
| `POST` | `/api/v1/auth/logout` | Bearer | Revoke one login session |
| `POST` | `/api/v1/auth/logout-all` | Bearer | Revoke all login sessions |
| `POST` | `/api/v1/auth/refresh` | Public | Rotate a refresh token |
| `POST` | `/api/v1/auth/register` | Public | Register a learner account |
| `POST` | `/api/v1/auth/resend-verification` | Public | Request another verification email |
| `POST` | `/api/v1/auth/reset-password` | Public | Reset a password |
| `POST` | `/api/v1/auth/verify-email` | Public | Verify an email address |

## Curriculum

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/curriculum/courses/{course_id}` | Bearer | Get Published Course |
| `GET` | `/api/v1/curriculum/courses/{course_id}/units` | Bearer | List Published Units |
| `GET` | `/api/v1/curriculum/lessons/{lesson_id}` | Bearer | Get Published Lesson |
| `GET` | `/api/v1/curriculum/lessons/{lesson_id}/content` | Bearer | Get Published Lesson Content |
| `GET` | `/api/v1/curriculum/levels` | Bearer | List Published Levels |
| `GET` | `/api/v1/curriculum/levels/{level_id}` | Bearer | Get Published Level |
| `GET` | `/api/v1/curriculum/levels/{level_id}/courses` | Bearer | List Published Courses |
| `GET` | `/api/v1/curriculum/units/{unit_id}` | Bearer | Get Published Unit |
| `GET` | `/api/v1/curriculum/units/{unit_id}/lessons` | Bearer | List Published Lessons |

## JLPT Simulations

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/jlpt-simulation-attempts/history` | Bearer | List Simulation Attempts |
| `GET` | `/api/v1/jlpt-simulation-attempts/{attempt_id}` | Bearer | Get Simulation Attempt |
| `DELETE` | `/api/v1/jlpt-simulation-attempts/{attempt_id}` | Bearer | Cancel Simulation Attempt |
| `POST` | `/api/v1/jlpt-simulation-attempts/{attempt_id}/answers` | Bearer | Submit Answer |
| `POST` | `/api/v1/jlpt-simulation-attempts/{attempt_id}/complete` | Bearer | Complete Simulation |
| `POST` | `/api/v1/jlpt-simulation-attempts/{attempt_id}/complete-section` | Bearer | Complete Current Section |
| `GET` | `/api/v1/jlpt-simulation-attempts/{attempt_id}/result` | Bearer | Get Simulation Result |
| `POST` | `/api/v1/jlpt-simulation-attempts/{attempt_id}/start-section` | Bearer | Start Current Section |
| `GET` | `/api/v1/jlpt-simulations` | Bearer | List Published Simulations |
| `GET` | `/api/v1/jlpt-simulations/{simulation_id}` | Bearer | Get Simulation Details |
| `POST` | `/api/v1/jlpt-simulations/{simulation_id}/attempts` | Bearer | Start Simulation Attempt |

## Learning Sessions

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `POST` | `/api/v1/learning-sessions` | Bearer | Start a lesson practice or exam session |
| `GET` | `/api/v1/learning-sessions/{session_id}` | Bearer | Get an owned learning session |
| `POST` | `/api/v1/learning-sessions/{session_id}/answers` | Bearer | Submit one deterministic answer by session-question ID |
| `POST` | `/api/v1/learning-sessions/{session_id}/cancel` | Bearer | Idempotently cancel an active session |
| `POST` | `/api/v1/learning-sessions/{session_id}/complete` | Bearer | Atomically complete a fully answered session |
| `GET` | `/api/v1/learning-sessions/{session_id}/questions` | Bearer | Deliver randomized learner-safe session questions |

## Progress

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/progress/activity` | Bearer | Paginate the immutable XP ledger |
| `GET` | `/api/v1/progress/lessons` | Bearer | List learner lesson progress |
| `GET` | `/api/v1/progress/mastery` | Bearer | List mastery by skill |
| `GET` | `/api/v1/progress/mistakes` | Bearer | Paginate unresolved mistake-book entries |
| `GET` | `/api/v1/progress/overview` | Bearer | Get aggregates computed from completed learning activity |
| `GET` | `/api/v1/progress/readiness` | Bearer | Get a transparent early readiness estimate |
| `GET` | `/api/v1/progress/recommendations` | Bearer | Get deterministic next-study recommendations |

## Reviews

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/reviews/due` | Bearer | Paginate due SRS items that are still published |
| `POST` | `/api/v1/reviews/mistake-sessions` | Bearer | Start a practice session from unresolved published mistakes |
| `POST` | `/api/v1/reviews/sessions` | Bearer | Start a practice session from due SRS items |
| `GET` | `/api/v1/reviews/summary` | Bearer | Get current and near-term SRS counts |

## System

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/health` | Public | Check API health |
| `GET` | `/api/v1/meta` | Public | Get application metadata |
| `GET` | `/api/v1/ready` | Public | Check database readiness |

## Users

| Method | Path | Auth | Summary |
|:---|:---|:---|:---|
| `GET` | `/api/v1/users/me` | Bearer | Get the current user profile |
| `DELETE` | `/api/v1/users/me` | Bearer | Deactivate the current account |
| `PATCH` | `/api/v1/users/me` | Bearer | Update the current user profile |
| `PATCH` | `/api/v1/users/me/password` | Bearer | Change the current user password |
| `GET` | `/api/v1/users/me/sessions` | Bearer | List active login sessions |
| `DELETE` | `/api/v1/users/me/sessions` | Bearer | Revoke all login sessions |
| `DELETE` | `/api/v1/users/me/sessions/{session_id}` | Bearer | Revoke one login session |
