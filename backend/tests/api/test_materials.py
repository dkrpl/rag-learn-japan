import json
from unittest.mock import patch

from app.models.ai_jobs import GenerationJob, JobStatus, JobType
from app.models.progress import XPTransaction
from app.models.question import Question, QuestionStatus, QuestionType, SkillType
from app.models.user import User
from tests.api.test_curriculum import create_published_hierarchy


def _text_pdf_bytes(text: str) -> bytes:
    stream = f"BT /F1 12 Tf 72 720 Td ({text}) Tj ET".encode()
    objects = [
        b"<< /Type /Catalog /Pages 2 0 R >>",
        b"<< /Type /Pages /Kids [3 0 R] /Count 1 >>",
        b"<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] "
        b"/Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>",
        b"<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>",
        b"<< /Length %d >>\nstream\n" % len(stream) + stream + b"\nendstream",
    ]
    output = bytearray(b"%PDF-1.4\n")
    offsets = [0]
    for index, obj in enumerate(objects, start=1):
        offsets.append(len(output))
        output.extend(f"{index} 0 obj\n".encode() + obj + b"\nendobj\n")
    xref_offset = len(output)
    output.extend(f"xref\n0 {len(objects) + 1}\n".encode())
    output.extend(b"0000000000 65535 f \n")
    for offset in offsets[1:]:
        output.extend(f"{offset:010d} 00000 n \n".encode())
    output.extend(
        f"trailer\n<< /Size {len(objects) + 1} /Root 1 0 R >>\nstartxref\n{xref_offset}\n%%EOF\n".encode()
    )
    return bytes(output)


def test_admin_uploads_pdf_material_and_creates_question_job(client, admin_token_headers):
    ids = create_published_hierarchy(client, admin_token_headers)
    pdf = _text_pdf_bytes("Konnichiwa means hello during the day.")

    upload = client.post(
        "/api/v1/admin/materials/pdf",
        headers=admin_token_headers,
        data={"lesson_id": ids["lesson_id"], "title": "PDF Salam"},
        files={"file": ("salam.pdf", pdf, "application/pdf")},
    )

    assert upload.status_code == 201, upload.text
    material = upload.json()
    assert material["lesson_id"] == ids["lesson_id"]
    assert material["page_count"] == 1
    assert material["file_url"] == f"/api/v1/app/materials/{material['id']}/file"
    assert "Konnichiwa" in material["extracted_text_preview"]

    with (
        patch("app.api.v1.admin.materials._can_dispatch_ai_worker", return_value=(True, None)),
        patch("app.api.v1.admin.materials.generate_questions_task.delay") as delay,
    ):
        job_response = client.post(
            f"/api/v1/admin/materials/{material['id']}/question-jobs",
            headers=admin_token_headers,
            json={"question_count": 3, "question_type": "MULTIPLE_CHOICE", "skill": "READING"},
        )

    assert job_response.status_code == 202, job_response.text
    assert delay.called
    job = job_response.json()
    assert job["job_type"] == JobType.QUESTION_GENERATION.value
    assert job["status"] == JobStatus.PENDING.value
    prompt = json.loads(job["prompt_json"])
    assert prompt["material_id"] == material["id"]
    assert "Konnichiwa" in prompt["source_material"]


def test_frontend_flow_generates_session_from_admin_pdf_material(
    client,
    db,
    admin_token_headers,
    learner_token_headers,
):
    ids = create_published_hierarchy(client, admin_token_headers)
    pdf = _text_pdf_bytes("Konnichiwa means hello during the day.")

    upload = client.post(
        "/api/v1/admin/materials/pdf",
        headers=admin_token_headers,
        data={"lesson_id": ids["lesson_id"], "title": "PDF Salam"},
        files={"file": ("salam.pdf", pdf, "application/pdf")},
    )
    assert upload.status_code == 201, upload.text
    material = upload.json()

    visible = client.get(
        f"/api/v1/app/lessons/{ids['lesson_id']}/materials",
        headers=learner_token_headers,
    )
    assert visible.status_code == 200, visible.text
    assert visible.json()[0]["id"] == material["id"]
    assert visible.json()[0]["file_url"] == f"/api/v1/app/materials/{material['id']}/file"

    pdf_file = client.get(visible.json()[0]["file_url"], headers=learner_token_headers)
    assert pdf_file.status_code == 200, pdf_file.text
    assert pdf_file.headers["content-type"].startswith("application/pdf")

    with (
        patch("app.api.v1.frontend._can_dispatch_ai_worker", return_value=(True, None)),
        patch("app.api.v1.frontend.generate_questions_task.delay") as delay,
    ):
        job_response = client.post(
            f"/api/v1/app/materials/{material['id']}/ai-question-jobs",
            headers=learner_token_headers,
            json={"question_count": 1, "difficulty": 1},
        )
    assert job_response.status_code == 202, job_response.text
    assert delay.called
    job = job_response.json()
    prompt = json.loads(job["prompt_json"])
    assert prompt["private_to_user"] is True
    assert "auto_publish" not in prompt
    assert prompt["skill"] == "READING"
    assert prompt["material_id"] == material["id"]
    assert "Konnichiwa" in prompt["source_material"]

    learner = db.query(User).filter(User.email == "learner_test_fixture@example.com").one()
    question = Question(
        lesson_id=ids["lesson_id"],
        question_type=QuestionType.MULTIPLE_CHOICE,
        skill=SkillType.READING,
        difficulty=1,
        prompt_json={
            "text": "What does Konnichiwa mean?",
            "options": [{"id": "a", "text": "Hello"}, {"id": "b", "text": "Good night"}],
        },
        answer_key_json={"correct_option_id": "a"},
        explanation_json={"text": "The uploaded material says Konnichiwa means hello during the day."},
        status=QuestionStatus.AUTO_VALIDATED,
        is_ai_generated=True,
        created_by=learner.id,
    )
    db.add(question)
    db.flush()
    stored_job = db.query(GenerationJob).filter(GenerationJob.id == job["id"]).one()
    stored_job.status = JobStatus.COMPLETED
    stored_job.raw_response = json.dumps({"created_question_ids": [question.id]})
    db.commit()

    session_response = client.post(
        f"/api/v1/app/ai-question-jobs/{job['id']}/sessions",
        headers=learner_token_headers,
        json={"mode": "PRACTICE"},
    )
    assert session_response.status_code == 201, session_response.text
    session = session_response.json()
    assert session["lesson_id"] == ids["lesson_id"]
    assert session["total_questions"] == 1

    questions = client.get(
        f"/api/v1/app/sessions/{session['id']}/questions",
        headers=learner_token_headers,
    )
    assert questions.status_code == 200, questions.text
    session_question = questions.json()[0]
    assert session_question["question"]["prompt_json"]["text"] == "What does Konnichiwa mean?"

    answer = client.post(
        f"/api/v1/app/sessions/{session['id']}/answers",
        headers=learner_token_headers,
        json={
            "session_question_id": session_question["id"],
            "answer_json": {"selected_option_id": "a"},
        },
    )
    assert answer.status_code == 200, answer.text
    assert answer.json()["is_correct"] is True

    completed = client.post(
        f"/api/v1/app/sessions/{session['id']}/complete",
        headers=learner_token_headers,
    )
    assert completed.status_code == 200, completed.text
    assert completed.json()["correct_answers"] == 1

    leaderboard = client.get("/api/v1/app/leaderboard", headers=learner_token_headers)
    assert leaderboard.status_code == 200, leaderboard.text
    assert leaderboard.json()[0]["user_id"] == learner.id
    assert leaderboard.json()[0]["total_xp"] == 60

    dashboard = client.get("/api/v1/app/dashboard", headers=learner_token_headers)
    assert dashboard.status_code == 200, dashboard.text
    assert dashboard.json()["course_progress_percentage"] == 100
    assert "reviews_due" not in dashboard.json()
    assert "unresolved_mistakes" not in dashboard.json()


def test_frontend_leaderboard_orders_by_total_xp(client, db, learner_token_headers):
    learner = db.query(User).filter(User.email == "learner_test_fixture@example.com").one()
    other = User(
        email="other_leaderboard@example.com",
        password_hash="not-used",
        name="Other Learner",
        is_active=True,
    )
    db.add(other)
    db.flush()
    db.add_all(
        [
            XPTransaction(user_id=learner.id, amount=30, reason="test"),
            XPTransaction(user_id=other.id, amount=70, reason="test"),
        ]
    )
    db.commit()

    response = client.get("/api/v1/app/leaderboard?limit=2", headers=learner_token_headers)
    assert response.status_code == 200, response.text
    rows = response.json()
    assert [row["user_id"] for row in rows] == [other.id, learner.id]
    assert [row["rank"] for row in rows] == [1, 2]


def test_frontend_catalog_marks_later_lessons_locked(client, admin_token_headers, learner_token_headers):
    ids = create_published_hierarchy(client, admin_token_headers)
    second = client.post(
        "/api/v1/admin/curriculum/lessons",
        json={
            "unit_id": ids["unit_id"],
            "title": "Pelajaran Kedua",
            "learning_objective": "Lanjutan setelah lesson pertama.",
            "sequence": 2,
        },
        headers=admin_token_headers,
    )
    assert second.status_code == 201, second.text
    second_id = second.json()["id"]
    section = client.post(
        f"/api/v1/admin/curriculum/lessons/{second_id}/sections",
        json={
            "title": "Materi Kedua",
            "content": "Materi lanjutan.",
            "sequence": 1,
            "is_published": True,
        },
        headers=admin_token_headers,
    )
    assert section.status_code == 201, section.text
    publish = client.post(
        f"/api/v1/admin/curriculum/lessons/{second_id}/publish",
        headers=admin_token_headers,
    )
    assert publish.status_code == 200, publish.text

    catalog = client.get("/api/v1/app/catalog", headers=learner_token_headers)
    assert catalog.status_code == 200, catalog.text
    lessons = catalog.json()["courses"][0]["units"][0]["lessons"]
    assert [(lesson["id"], lesson["status"]) for lesson in lessons] == [
        (ids["lesson_id"], "unlocked"),
        (second_id, "locked"),
    ]
    assert "level_id" not in catalog.json()

    locked = client.get(f"/api/v1/app/lessons/{second_id}", headers=learner_token_headers)
    assert locked.status_code == 423
