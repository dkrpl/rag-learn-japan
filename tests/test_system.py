from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_health_check():
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    assert response.json()["status"] == "success"
    assert response.json()["data"]["status"] == "ok"

def test_readiness_check():
    # It might return 200 if DB is up, or 503 if DB is down. 
    # The requirement is that it fails gracefully (503) without 500 error if DB is down.
    response = client.get("/api/v1/ready")
    assert response.status_code in [200, 503]
    if response.status_code == 200:
        assert response.json()["status"] == "success"
    elif response.status_code == 503:
        assert response.json()["detail"] == "Database is not available"
