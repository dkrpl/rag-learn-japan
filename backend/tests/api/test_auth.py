from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_register_and_login():
    # Register
    register_data = {"email": "testauth@example.com", "password": "password123", "name": "Test User"}
    response = client.post("/api/v1/auth/register", json=register_data)
    assert response.status_code == 201

    # Login
    login_data = {"email": "testauth@example.com", "password": "password123"}
    response = client.post("/api/v1/auth/login", json=login_data)
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert "refresh_token" in data
    assert data["token_type"] == "bearer"

    return data


def test_refresh_token():
    tokens = test_register_and_login()
    refresh_token = tokens["refresh_token"]

    response = client.post("/api/v1/auth/refresh", json={"refresh_token": refresh_token})
    assert response.status_code == 200
    new_data = response.json()
    assert "access_token" in new_data
    assert "refresh_token" in new_data

    # Try using the old refresh token (Reuse attack!)
    reuse_response = client.post("/api/v1/auth/refresh", json={"refresh_token": refresh_token})
    assert reuse_response.status_code == 401

    # Try using the new refresh token (Should be revoked because of reuse detection!)
    new_refresh_token = new_data["refresh_token"]
    revoked_response = client.post("/api/v1/auth/refresh", json={"refresh_token": new_refresh_token})
    assert revoked_response.status_code == 401


def test_login_rate_limit():
    login_data = {"email": "wrong@example.com", "password": "wrongpassword"}

    # Attempt 5 times
    for _ in range(5):
        client.post("/api/v1/auth/login", json=login_data)

    # 6th attempt should be 429
    response = client.post("/api/v1/auth/login", json=login_data)
    assert response.status_code == 429
