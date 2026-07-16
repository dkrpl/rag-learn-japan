"""Production smoke test for the material-first MVP.

Required environment:
  API_BASE_URL=http://127.0.0.1:8000
  ADMIN_EMAIL=admin@example.com
  ADMIN_PASSWORD=Password123
  LEARNER_EMAIL=learner@example.com
  LEARNER_PASSWORD=Password123

Optional:
  SMOKE_PDF_PATH=./sample.pdf

Run:
  python scripts/smoke_test.py
"""

from __future__ import annotations

import os
import sys
from pathlib import Path

import httpx


BASE_URL = os.getenv("API_BASE_URL", "http://127.0.0.1:8000").rstrip("/")


def require_env(name: str) -> str:
    value = os.getenv(name)
    if not value:
        raise RuntimeError(f"{name} is required")
    return value


def login(client: httpx.Client, *, email: str, password: str) -> str:
    response = client.post(
        f"{BASE_URL}/api/v1/auth/login",
        json={"email": email, "password": password, "device_name": "Smoke Test"},
    )
    response.raise_for_status()
    return response.json()["access_token"]


def auth(token: str) -> dict[str, str]:
    return {"Authorization": f"Bearer {token}"}


def main() -> int:
    admin_email = require_env("ADMIN_EMAIL")
    admin_password = require_env("ADMIN_PASSWORD")
    learner_email = require_env("LEARNER_EMAIL")
    learner_password = require_env("LEARNER_PASSWORD")
    pdf_path = os.getenv("SMOKE_PDF_PATH")

    with httpx.Client(timeout=30) as client:
        for path in ["/health", "/ready"]:
            response = client.get(f"{BASE_URL}{path}")
            response.raise_for_status()
            print(f"OK {path}")

        admin_token = login(client, email=admin_email, password=admin_password)
        learner_token = login(client, email=learner_email, password=learner_password)
        print("OK auth login")

        response = client.get(f"{BASE_URL}/api/v1/app/me", headers=auth(learner_token))
        response.raise_for_status()
        print("OK app me")

        if pdf_path:
            path = Path(pdf_path)
            if not path.is_file():
                raise RuntimeError(f"SMOKE_PDF_PATH not found: {path}")
            with path.open("rb") as pdf:
                response = client.post(
                    f"{BASE_URL}/api/v1/admin/materials/pdf",
                    headers=auth(admin_token),
                    data={
                        "title": "Smoke Test PDF",
                        "level": "N5",
                        "category": "smoke",
                        "sequence": "9999",
                        "passing_score": "70",
                        "is_published": "true",
                    },
                    files={"file": (path.name, pdf, "application/pdf")},
                )
            response.raise_for_status()
            print("OK admin upload pdf")

        for path in ["/api/v1/app/dashboard", "/api/v1/app/materials", "/api/v1/app/leaderboard?period=all"]:
            response = client.get(f"{BASE_URL}{path}", headers=auth(learner_token))
            response.raise_for_status()
            print(f"OK {path}")

        response = client.get(f"{BASE_URL}/api/v1/admin/materials", headers=auth(admin_token))
        response.raise_for_status()
        materials = response.json()
        print("OK admin materials")
        if materials:
            material_id = materials[0]["id"]
            response = client.get(f"{BASE_URL}/api/v1/admin/materials/{material_id}/analytics", headers=auth(admin_token))
            response.raise_for_status()
            print("OK admin material analytics")

    print("Smoke test completed")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"Smoke test failed: {exc}", file=sys.stderr)
        raise SystemExit(1)
