from app.models.progress import XPTransaction
from app.models.user import User


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


def _upload_material(client, headers, *, title: str, sequence: int, text: str):
    return client.post(
        "/api/v1/admin/materials/pdf",
        headers=headers,
        data={
            "title": title,
            "description": f"Demo {title}",
            "level": "N5",
            "category": "demo",
            "sequence": str(sequence),
            "passing_score": "70",
            "is_published": "true",
        },
        files={"file": (f"{title}.pdf", _text_pdf_bytes(text), "application/pdf")},
    )


def test_admin_uploads_and_manages_material_without_course(client, admin_token_headers):
    upload = _upload_material(
        client,
        admin_token_headers,
        title="PDF Salam",
        sequence=1,
        text="Konnichiwa means hello during the day.",
    )

    assert upload.status_code == 201, upload.text
    material = upload.json()
    assert material["lesson_id"] is None
    assert material["level"] == "N5"
    assert material["sequence"] == 1
    assert material["passing_score"] == 70
    assert material["file_url"] == f"/api/v1/app/materials/{material['id']}/file"
    assert "Konnichiwa" in material["extracted_text_preview"]

    audit = client.get(
        f"/api/v1/admin/audit-logs?entity_name=MaterialDocument&entity_id={material['id']}",
        headers=admin_token_headers,
    )
    assert audit.status_code == 200, audit.text
    assert audit.json()[0]["action"] == "material.upload"

    patched = client.patch(
        f"/api/v1/admin/materials/{material['id']}",
        headers=admin_token_headers,
        json={"title": "PDF Salam Update", "sequence": 2, "passing_score": 80},
    )
    assert patched.status_code == 200, patched.text
    assert patched.json()["title"] == "PDF Salam Update"
    assert patched.json()["passing_score"] == 80

    preview = client.get(f"/api/v1/admin/materials/{material['id']}/preview", headers=admin_token_headers)
    assert preview.status_code == 200, preview.text
    assert "Konnichiwa" in preview.json()["extracted_text"]

    unpublished = client.post(f"/api/v1/admin/materials/{material['id']}/unpublish", headers=admin_token_headers)
    assert unpublished.status_code == 200, unpublished.text
    assert unpublished.json()["is_published"] is False

    published = client.post(f"/api/v1/admin/materials/{material['id']}/publish", headers=admin_token_headers)
    assert published.status_code == 200, published.text
    assert published.json()["is_published"] is True

    audit_after = client.get(
        f"/api/v1/admin/audit-logs?entity_name=MaterialDocument&entity_id={material['id']}",
        headers=admin_token_headers,
    ).json()
    assert {row["action"] for row in audit_after} >= {
        "material.upload",
        "material.update",
        "material.unpublish",
        "material.publish",
    }


def test_material_quiz_pass_unlocks_next_material_and_awards_exp(
    client,
    admin_token_headers,
    learner_token_headers,
):
    first = _upload_material(
        client,
        admin_token_headers,
        title="Salam",
        sequence=1,
        text="Konnichiwa berarti halo. Ohayou berarti selamat pagi. Arigatou berarti terima kasih.",
    ).json()
    _upload_material(
        client,
        admin_token_headers,
        title="Partikel",
        sequence=2,
        text="Partikel wa menandai topik kalimat.",
    )

    materials = client.get("/api/v1/app/materials", headers=learner_token_headers)
    assert materials.status_code == 200, materials.text
    assert [item["status"] for item in materials.json()] == ["unlocked", "locked"]

    generated = client.post(
        f"/api/v1/app/materials/{first['id']}/generate-quiz",
        headers=learner_token_headers,
        json={"difficulty": "easy", "question_count": 1},
    )
    assert generated.status_code == 201, generated.text
    session_id = generated.json()["session_id"]

    questions = client.get(f"/api/v1/app/quiz-sessions/{session_id}/questions", headers=learner_token_headers)
    assert questions.status_code == 200, questions.text
    session_question = questions.json()[0]
    assert "correct_answer_json" not in session_question
    assert "answer_key_json" not in session_question["question"]

    result = client.post(
        f"/api/v1/app/quiz-sessions/{session_id}/submit",
        headers=learner_token_headers,
        json={
            "answers": [
                {
                    "session_question_id": session_question["id"],
                    "answer_json": {"selected_option_id": "a"},
                }
            ]
        },
    )
    assert result.status_code == 200, result.text
    assert result.json()["is_passed"] is True
    assert result.json()["earned_exp"] == 100
    assert result.json()["review"][0]["is_correct"] is True
    assert result.json()["review"][0]["correct_answer_json"]["correct_option_id"] == "a"

    materials_after = client.get("/api/v1/app/materials", headers=learner_token_headers)
    assert [item["status"] for item in materials_after.json()] == ["completed", "unlocked"]

    dashboard = client.get("/api/v1/app/dashboard", headers=learner_token_headers)
    assert dashboard.status_code == 200, dashboard.text
    assert dashboard.json()["materials_completed"] == 1
    assert dashboard.json()["material_progress_percentage"] == 50

    analytics = client.get(f"/api/v1/admin/materials/{first['id']}/analytics", headers=admin_token_headers)
    assert analytics.status_code == 200, analytics.text
    assert analytics.json()["total_attempts"] == 1
    assert analytics.json()["passed_attempts"] == 1
    assert analytics.json()["pass_rate"] == 100
    assert analytics.json()["difficulty_breakdown"] == [{"label": "easy", "count": 1, "percentage": 100}]
    assert analytics.json()["score_buckets"][-1]["label"] == "85-100"
    assert analytics.json()["score_buckets"][-1]["count"] == 1
    assert analytics.json()["recent_attempts"][0]["is_passed"] is True

    csv_response = client.get(f"/api/v1/admin/materials/{first['id']}/analytics.csv", headers=admin_token_headers)
    assert csv_response.status_code == 200, csv_response.text
    assert "total_attempts,1" in csv_response.text
    assert "score_bucket,count,percentage" in csv_response.text


def test_material_quiz_fail_keeps_next_material_locked_and_exp_zero(
    client,
    db,
    admin_token_headers,
    learner_token_headers,
):
    first = _upload_material(
        client,
        admin_token_headers,
        title="Salam",
        sequence=1,
        text="Konnichiwa berarti halo. Ohayou berarti selamat pagi. Arigatou berarti terima kasih.",
    ).json()
    _upload_material(
        client,
        admin_token_headers,
        title="Partikel",
        sequence=2,
        text="Partikel wa menandai topik kalimat.",
    )

    generated = client.post(
        f"/api/v1/app/materials/{first['id']}/generate-quiz",
        headers=learner_token_headers,
        json={"difficulty": "easy", "question_count": 1},
    )
    session_id = generated.json()["session_id"]
    session_question = client.get(
        f"/api/v1/app/quiz-sessions/{session_id}/questions",
        headers=learner_token_headers,
    ).json()[0]
    result = client.post(
        f"/api/v1/app/quiz-sessions/{session_id}/submit",
        headers=learner_token_headers,
        json={
            "answers": [
                {
                    "session_question_id": session_question["id"],
                    "answer_json": {"selected_option_id": "b"},
                }
            ]
        },
    )
    assert result.status_code == 200, result.text
    assert result.json()["is_passed"] is False
    assert result.json()["earned_exp"] == 0
    assert result.json()["review"][0]["is_correct"] is False

    materials = client.get("/api/v1/app/materials", headers=learner_token_headers).json()
    assert [item["status"] for item in materials] == ["unlocked", "locked"]

    learner = db.query(User).filter(User.email == "learner_test_fixture@example.com").one()
    assert db.query(XPTransaction).filter(XPTransaction.user_id == learner.id).count() == 0

    analytics = client.get(f"/api/v1/admin/materials/{first['id']}/analytics", headers=admin_token_headers)
    assert analytics.status_code == 200, analytics.text
    assert analytics.json()["total_attempts"] == 1
    assert analytics.json()["failed_attempts"] == 1
    assert analytics.json()["pass_rate"] == 0
    assert analytics.json()["score_buckets"][0]["count"] == 1
    assert analytics.json()["recent_attempts"][0]["is_passed"] is False


def test_repeating_passed_material_does_not_farm_exp(client, db, admin_token_headers, learner_token_headers):
    material = _upload_material(
        client,
        admin_token_headers,
        title="Anti Farming",
        sequence=1,
        text="Konnichiwa berarti halo. Ohayou berarti selamat pagi.",
    ).json()

    earned_values = []
    for _ in range(2):
        generated = client.post(
            f"/api/v1/app/materials/{material['id']}/generate-quiz",
            headers=learner_token_headers,
            json={"difficulty": "easy", "question_count": 1},
        )
        assert generated.status_code == 201, generated.text
        session_id = generated.json()["session_id"]
        session_question = client.get(
            f"/api/v1/app/quiz-sessions/{session_id}/questions",
            headers=learner_token_headers,
        ).json()[0]
        result = client.post(
            f"/api/v1/app/quiz-sessions/{session_id}/submit",
            headers=learner_token_headers,
            json={
                "answers": [
                    {
                        "session_question_id": session_question["id"],
                        "answer_json": {"selected_option_id": "a"},
                    }
                ]
            },
        )
        assert result.status_code == 200, result.text
        earned_values.append(result.json()["earned_exp"])

    assert earned_values == [100, 0]
    learner = db.query(User).filter(User.email == "learner_test_fixture@example.com").one()
    xp_rows = db.query(XPTransaction).filter(XPTransaction.user_id == learner.id).all()
    assert len(xp_rows) == 1
    assert xp_rows[0].material_id == material["id"]
    assert xp_rows[0].amount == 100


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
