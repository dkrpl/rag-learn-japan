import uuid


def create_published_hierarchy(client, admin_headers, *, lesson_title="Salam Dasar"):
    suffix = uuid.uuid4().hex[:8]
    level = client.post(
        "/api/v1/admin/curriculum/levels",
        json={"code": f"T{suffix}", "name": f"Test Level {suffix}", "sequence": 1},
        headers=admin_headers,
    )
    assert level.status_code == 201, level.text
    level_id = level.json()["id"]
    assert (
        client.post(
            f"/api/v1/admin/curriculum/levels/{level_id}/publish",
            headers=admin_headers,
        ).status_code
        == 200
    )

    course = client.post(
        "/api/v1/admin/curriculum/courses",
        json={"level_id": level_id, "title": f"Course {suffix}", "sequence": 1},
        headers=admin_headers,
    )
    assert course.status_code == 201, course.text
    course_id = course.json()["id"]
    assert (
        client.post(
            f"/api/v1/admin/curriculum/courses/{course_id}/publish",
            headers=admin_headers,
        ).status_code
        == 200
    )

    unit = client.post(
        "/api/v1/admin/curriculum/units",
        json={"course_id": course_id, "title": f"Unit {suffix}", "sequence": 1},
        headers=admin_headers,
    )
    assert unit.status_code == 201, unit.text
    unit_id = unit.json()["id"]
    assert (
        client.post(
            f"/api/v1/admin/curriculum/units/{unit_id}/publish",
            headers=admin_headers,
        ).status_code
        == 200
    )

    lesson = client.post(
        "/api/v1/admin/curriculum/lessons",
        json={
            "unit_id": unit_id,
            "title": lesson_title,
            "learning_objective": "Pemelajar dapat menggunakan salam dasar.",
            "sequence": 1,
        },
        headers=admin_headers,
    )
    assert lesson.status_code == 201, lesson.text
    lesson_id = lesson.json()["id"]
    section = client.post(
        f"/api/v1/admin/curriculum/lessons/{lesson_id}/sections",
        json={
            "title": "Pengantar",
            "content": "「こんにちは」は salam yang digunakan pada siang hari.",
            "sequence": 1,
            "is_published": True,
        },
        headers=admin_headers,
    )
    assert section.status_code == 201, section.text
    assert (
        client.post(
            f"/api/v1/admin/curriculum/lessons/{lesson_id}/publish",
            headers=admin_headers,
        ).status_code
        == 200
    )
    return {
        "level_id": level_id,
        "course_id": course_id,
        "unit_id": unit_id,
        "lesson_id": lesson_id,
        "section_id": section.json()["id"],
    }


def test_admin_can_create_publish_and_learner_can_traverse_curriculum(
    client,
    admin_token_headers,
    learner_token_headers,
):
    ids = create_published_hierarchy(client, admin_token_headers)

    catalog = client.get("/api/v1/app/catalog", headers=learner_token_headers)
    detail = client.get(f"/api/v1/app/lessons/{ids['lesson_id']}", headers=learner_token_headers)

    assert catalog.status_code == 200, catalog.text
    lessons = catalog.json()["courses"][0]["units"][0]["lessons"]
    assert ids["lesson_id"] in {lesson["id"] for lesson in lessons}
    assert detail.status_code == 200, detail.text
    assert detail.json()["lesson"]["id"] == ids["lesson_id"]
    assert detail.json()["sections"][0]["content"].startswith("「こんにちは」")


def test_learner_cannot_access_curriculum_admin(client, learner_token_headers):
    response = client.post(
        "/api/v1/admin/curriculum/levels",
        json={"name": "Forbidden", "sequence": 1},
        headers=learner_token_headers,
    )
    assert response.status_code == 403


def test_draft_and_archived_resources_are_not_disclosed_to_learner(
    client,
    admin_token_headers,
    learner_token_headers,
):
    ids = create_published_hierarchy(client, admin_token_headers)
    draft = client.post(
        "/api/v1/admin/curriculum/lessons",
        json={
            "unit_id": ids["unit_id"],
            "title": "Draft Rahasia",
            "learning_objective": "Draft",
            "sequence": 2,
        },
        headers=admin_token_headers,
    )
    assert draft.status_code == 201

    listed = client.get("/api/v1/app/catalog", headers=learner_token_headers)
    lessons = listed.json()["courses"][0]["units"][0]["lessons"]
    assert draft.json()["id"] not in {item["id"] for item in lessons}

    archived = client.post(
        f"/api/v1/admin/curriculum/levels/{ids['level_id']}/archive",
        headers=admin_token_headers,
    )
    assert archived.status_code == 200
    hidden = client.get(f"/api/v1/app/lessons/{ids['lesson_id']}", headers=learner_token_headers)
    assert hidden.status_code == 404


def test_cannot_publish_empty_lesson(client, admin_token_headers):
    suffix = uuid.uuid4().hex[:8]
    level = client.post(
        "/api/v1/admin/curriculum/levels",
        json={"name": f"Level {suffix}", "is_published": True},
        headers=admin_token_headers,
    ).json()
    course = client.post(
        "/api/v1/admin/curriculum/courses",
        json={"level_id": level["id"], "title": f"Course {suffix}", "is_published": True},
        headers=admin_token_headers,
    ).json()
    unit = client.post(
        "/api/v1/admin/curriculum/units",
        json={"course_id": course["id"], "title": f"Unit {suffix}", "is_published": True},
        headers=admin_token_headers,
    ).json()
    lesson = client.post(
        "/api/v1/admin/curriculum/lessons",
        json={
            "unit_id": unit["id"],
            "title": "Empty Lesson",
            "learning_objective": "Objective exists but content does not.",
        },
        headers=admin_token_headers,
    ).json()

    response = client.post(
        f"/api/v1/admin/curriculum/lessons/{lesson['id']}/publish",
        headers=admin_token_headers,
    )
    assert response.status_code == 422
    assert "published content" in response.json()["error"]["message"]
