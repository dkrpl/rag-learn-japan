def test_admin_users_requires_authentication(client):
    response = client.get("/api/v1/admin/users")

    assert response.status_code == 401


def test_learner_cannot_access_admin_users(client):
    client.post(
        "/api/v1/auth/register",
        json={
            "email": "learner_admin_test@example.com",
            "password": "Password123",
            "name": "Learner",
        },
    )
    login_response = client.post(
        "/api/v1/auth/login",
        json={"email": "learner_admin_test@example.com", "password": "Password123"},
    )
    token = login_response.json()["access_token"]

    response = client.get(
        "/api/v1/admin/users",
        headers={"Authorization": f"Bearer {token}"},
    )

    assert response.status_code == 403
