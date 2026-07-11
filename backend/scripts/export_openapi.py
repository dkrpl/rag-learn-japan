import json
import os
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from app.main import app  # noqa: E402

os.makedirs(PROJECT_ROOT / "docs", exist_ok=True)
with open(PROJECT_ROOT / "docs" / "openapi.json", "w", encoding="utf-8") as f:
    json.dump(app.openapi(), f, indent=2)

print("Berhasil mengekspor openapi.json")
