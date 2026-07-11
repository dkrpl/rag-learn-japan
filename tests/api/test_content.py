import io
import math
import struct
import uuid
import wave

from tests.api.test_curriculum import create_published_hierarchy


def wav_bytes(duration_seconds: float = 0.1, sample_rate: int = 8_000) -> bytes:
    buffer = io.BytesIO()
    with wave.open(buffer, "wb") as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        frames = bytearray()
        for index in range(int(duration_seconds * sample_rate)):
            sample = int(1_000 * math.sin(2 * math.pi * 440 * index / sample_rate))
            frames.extend(struct.pack("<h", sample))
        wav_file.writeframes(frames)
    return buffer.getvalue()


def test_admin_content_crud_publish_and_lesson_visibility(
    client,
    admin_token_headers,
    learner_token_headers,
):
    ids = create_published_hierarchy(client, admin_token_headers)
    suffix = uuid.uuid4().hex[:6]
    published = client.post(
        "/api/v1/admin/content/vocabularies",
        json={
            "word": f"猫{suffix}",
            "kana": "ねこ",
            "romaji": "neko",
            "meaning": "Kucing",
            "is_published": True,
        },
        headers=admin_token_headers,
    )
    draft = client.post(
        "/api/v1/admin/content/vocabularies",
        json={"word": f"秘密{suffix}", "kana": "ひみつ", "meaning": "Rahasia"},
        headers=admin_token_headers,
    )
    assert published.status_code == draft.status_code == 201

    for sequence, content_id in enumerate((published.json()["id"], draft.json()["id"]), start=1):
        linked = client.post(
            f"/api/v1/admin/curriculum/lessons/{ids['lesson_id']}/vocabularies/{content_id}",
            json={"sequence": sequence},
            headers=admin_token_headers,
        )
        assert linked.status_code == 200, linked.text

    content = client.get(
        f"/api/v1/curriculum/lessons/{ids['lesson_id']}/content",
        headers=learner_token_headers,
    )
    assert content.status_code == 200
    visible_ids = {item["id"] for item in content.json()["vocabularies"]}
    assert published.json()["id"] in visible_ids
    assert draft.json()["id"] not in visible_ids

    archived = client.delete(
        f"/api/v1/admin/content/vocabularies/{published.json()['id']}",
        headers=admin_token_headers,
    )
    assert archived.status_code == 200
    assert archived.json()["state"] == "archived"


def test_json_import_is_idempotent_and_unicode_safe(client, admin_token_headers):
    payload = {
        "vocabularies": [
            {"word": "日本語", "kana": "にほんご", "romaji": "nihongo", "meaning": "Bahasa Jepang"},
            {"word": "学校", "kana": "がっこう", "romaji": "gakkou", "meaning": "Sekolah"},
        ]
    }
    first = client.post("/api/v1/admin/content/imports/json", json=payload, headers=admin_token_headers)
    second = client.post("/api/v1/admin/content/imports/json", json=payload, headers=admin_token_headers)

    assert first.status_code == second.status_code == 200
    assert first.json()["created"]["vocabularies"] == 2
    assert second.json()["unchanged"]["vocabularies"] == 2


def test_csv_import_validates_and_is_idempotent(client, admin_token_headers):
    csv_data = "word,kana,romaji,meaning\r\n水,みず,mizu,Air\r\n火,ひ,hi,Api\r\n".encode()
    files = {"file": ("vocabulary.csv", io.BytesIO(csv_data), "text/csv")}
    form = {"content_type": "vocabulary", "dry_run": "false"}

    first = client.post(
        "/api/v1/admin/content/imports/csv",
        files=files,
        data=form,
        headers=admin_token_headers,
    )
    files = {"file": ("vocabulary.csv", io.BytesIO(csv_data), "text/csv")}
    second = client.post(
        "/api/v1/admin/content/imports/csv",
        files=files,
        data=form,
        headers=admin_token_headers,
    )

    assert first.status_code == second.status_code == 200
    assert first.json()["created"]["vocabularies"] == 2
    assert second.json()["unchanged"]["vocabularies"] == 2


def test_audio_upload_playback_and_transcript_visibility(
    client,
    admin_token_headers,
    learner_token_headers,
):
    files = {"file": ("greeting.wav", io.BytesIO(wav_bytes()), "audio/wav")}
    form = {
        "title": "Greeting fixture",
        "transcript": "こんにちは。",
        "translation": "Halo.",
        "transcript_visible": "false",
        "publish_immediately": "true",
    }
    uploaded = client.post(
        "/api/v1/admin/content/audio",
        files=files,
        data=form,
        headers=admin_token_headers,
    )
    assert uploaded.status_code == 201, uploaded.text
    asset = uploaded.json()
    assert asset["checksum"] and asset["file_size_bytes"] > 0
    assert asset["transcript"] == "こんにちは。"
    assert asset["file_url"] == f"/api/v1/audio/{asset['id']}"

    metadata = client.get(f"{asset['file_url']}/metadata", headers=learner_token_headers)
    playback = client.get(asset["file_url"], headers=learner_token_headers)
    assert metadata.status_code == playback.status_code == 200
    assert metadata.json()["transcript_available"] is True
    assert metadata.json()["transcript_visible"] is False
    assert metadata.json()["transcript"] is None
    assert playback.headers["content-type"].startswith("audio/wav")
    assert playback.content.startswith(b"RIFF")

    revealed = client.patch(
        f"/api/v1/admin/content/audio/{asset['id']}",
        json={"transcript_visible": True},
        headers=admin_token_headers,
    )
    assert revealed.status_code == 200, revealed.text
    metadata = client.get(f"{asset['file_url']}/metadata", headers=learner_token_headers)
    assert metadata.json()["transcript"] == "こんにちは。"


def test_audio_upload_rejects_mime_spoofing(client, admin_token_headers):
    invalid_mime = client.post(
        "/api/v1/admin/content/audio",
        files={"file": ("audio.txt", io.BytesIO(b"not audio"), "text/plain")},
        headers=admin_token_headers,
    )
    spoofed_mp3 = client.post(
        "/api/v1/admin/content/audio",
        files={"file": ("audio.mp3", io.BytesIO(b"not an mp3 stream"), "audio/mpeg")},
        headers=admin_token_headers,
    )
    assert invalid_mime.status_code == spoofed_mp3.status_code == 422

