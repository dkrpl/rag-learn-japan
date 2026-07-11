from datetime import timedelta

import pytest

from app.core import security


def test_password_hash_round_trip_and_invalid_hash() -> None:
    password_hash = security.get_password_hash("Password123")

    assert password_hash != "Password123"
    assert security.verify_password("Password123", password_hash) is True
    assert security.verify_password("wrong-password", password_hash) is False
    assert security.verify_password("Password123", "not-a-password-hash") is False


def test_access_and_refresh_tokens_are_not_interchangeable() -> None:
    access_token = security.create_access_token("user-1", session_id="session-1")
    refresh_token = security.create_refresh_token(
        "user-1",
        token_id="session-1",
        family_id="family-1",
    )

    access_payload = security.decode_token(access_token, expected_type="access")
    refresh_payload = security.decode_token(refresh_token, expected_type="refresh")

    assert access_payload["sub"] == "user-1"
    assert access_payload["sid"] == "session-1"
    assert access_payload["token_type"] == "access"
    assert refresh_payload["jti"] == "session-1"
    assert refresh_payload["family_id"] == "family-1"
    assert refresh_payload["token_type"] == "refresh"

    with pytest.raises(security.TokenValidationError):
        security.decode_token(refresh_token, expected_type="access")
    with pytest.raises(security.TokenValidationError):
        security.decode_token(access_token, expected_type="refresh")


def test_expired_access_token_is_rejected() -> None:
    token = security.create_access_token("user-1", expires_delta=timedelta(seconds=-1))

    with pytest.raises(security.TokenValidationError):
        security.decode_token(token, expected_type="access")
