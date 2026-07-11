from datetime import datetime, timezone

from app.models.user import User
from app.services.progress import next_srs_interval, update_streak


class FakeSession:
    def add(self, _value):
        return None


def test_srs_intervals_advance_and_cap_deterministically():
    assert next_srs_interval(0, True) == 1
    assert next_srs_interval(1, True) == 3
    assert next_srs_interval(3, True) == 7
    assert next_srs_interval(14, True) == 30
    assert next_srs_interval(30, True) == 30
    assert next_srs_interval(30, False) == 1


def test_streak_uses_user_timezone_and_is_idempotent_per_local_day():
    user = User(
        id="user-1",
        email="learner@example.test",
        password_hash="x",
        timezone="Asia/Jakarta",
        current_streak=0,
        longest_streak=0,
    )
    db = FakeSession()
    update_streak(db, user, now=datetime(2026, 7, 10, 16, 30, tzinfo=timezone.utc))  # 23:30 Jakarta
    assert user.current_streak == 1
    update_streak(db, user, now=datetime(2026, 7, 10, 16, 59, tzinfo=timezone.utc))
    assert user.current_streak == 1
    update_streak(db, user, now=datetime(2026, 7, 10, 17, 1, tzinfo=timezone.utc))  # next local date
    assert user.current_streak == 2
    assert user.longest_streak == 2


def test_invalid_timezone_safely_falls_back_to_utc():
    user = User(
        id="user-2",
        email="learner2@example.test",
        password_hash="x",
        timezone="Not/AZone",
        current_streak=0,
        longest_streak=0,
    )
    update_streak(FakeSession(), user, now=datetime(2026, 7, 10, 23, 59, tzinfo=timezone.utc))
    assert user.last_activity_date.isoformat() == "2026-07-10"
