from unittest.mock import patch

from app.models.ai_jobs import JobStatus, JobType


def test_create_question_generation_job(client, admin_token_headers):
    payload = {
        "lesson_id": "test-lesson-id",
        "question_type": "MULTIPLE_CHOICE",
        "skill": "GRAMMAR",
        "count": 5,
        "difficulty": 1,
    }
    with patch("app.api.v1.admin.ai_jobs.generate_questions_task.delay") as mock_delay:
        response = client.post("/api/v1/admin/generation-jobs/", headers=admin_token_headers, json=payload)
        assert mock_delay.called

    assert response.status_code == 200
    data = response.json()
    assert data["job_type"] == JobType.QUESTION_GENERATION.value
    assert data["status"] == JobStatus.PENDING.value
    assert data["id"] is not None


def test_create_audio_generation_job(client, admin_token_headers):
    payload = {"transcript": "こんにちは", "lesson_id": "test-lesson-id"}
    with patch("app.api.v1.admin.ai_jobs.generate_tts_task.delay") as mock_delay:
        response = client.post("/api/v1/admin/generation-jobs/audio", headers=admin_token_headers, json=payload)
        assert mock_delay.called

    assert response.status_code == 200
    data = response.json()
    assert data["job_type"] == JobType.TTS_GENERATION.value
    assert data["status"] == JobStatus.PENDING.value
    assert data["id"] is not None


def test_get_generation_job(client, admin_token_headers):
    # Create first
    payload = {"transcript": "テスト", "lesson_id": "test-lesson-id"}
    with patch("app.api.v1.admin.ai_jobs.generate_tts_task.delay"):
        create_resp = client.post("/api/v1/admin/generation-jobs/audio", headers=admin_token_headers, json=payload)
    job_id = create_resp.json()["id"]

    # Get Job
    get_resp = client.get(f"/api/v1/admin/generation-jobs/{job_id}", headers=admin_token_headers)
    assert get_resp.status_code == 200
    data = get_resp.json()
    assert data["id"] == job_id
    assert data["status"] == JobStatus.PENDING.value


def test_cancel_generation_job(client, admin_token_headers):
    # Create first
    payload = {"transcript": "キャンセル", "lesson_id": "test-lesson-id"}
    with patch("app.api.v1.admin.ai_jobs.generate_tts_task.delay"):
        create_resp = client.post("/api/v1/admin/generation-jobs/audio", headers=admin_token_headers, json=payload)
    job_id = create_resp.json()["id"]

    # Cancel Job
    del_resp = client.delete(f"/api/v1/admin/generation-jobs/{job_id}", headers=admin_token_headers)
    assert del_resp.status_code == 204

    # Verify Cancelled
    get_resp = client.get(f"/api/v1/admin/generation-jobs/{job_id}", headers=admin_token_headers)
    assert get_resp.json()["status"] == JobStatus.CANCELLED.value
