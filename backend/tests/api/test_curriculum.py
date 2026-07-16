def test_admin_curriculum_endpoints_are_removed_from_mvp(client, admin_token_headers, learner_token_headers):
    response = client.get("/api/v1/app/catalog", headers=learner_token_headers)
    assert response.status_code == 404

    response = client.post(
        "/api/v1/admin/curriculum/levels",
        json={"name": "JLPT N5", "sequence": 1},
        headers=admin_token_headers,
    )
    assert response.status_code == 404
