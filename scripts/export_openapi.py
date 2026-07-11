import json
import os

from app.main import app

os.makedirs("docs", exist_ok=True)
with open("docs/openapi.json", "w", encoding="utf-8") as f:
    json.dump(app.openapi(), f, indent=2)

print("Berhasil mengekspor openapi.json")
