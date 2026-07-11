import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from app.main import app
OPENAPI_PATH = ROOT / "docs" / "openapi.json"
ENDPOINTS_PATH = ROOT / "docs" / "ENDPOINTS.md"
HTTP_METHODS = {"get", "post", "put", "patch", "delete", "options", "head"}


def render_endpoint_catalog(schema: dict) -> str:
    grouped: dict[str, list[tuple[str, str, dict]]] = {}
    operation_ids: set[str] = set()
    for path, path_item in sorted(schema.get("paths", {}).items()):
        for method, operation in path_item.items():
            if method.lower() not in HTTP_METHODS:
                continue
            operation_id = operation.get("operationId")
            if not operation_id:
                raise RuntimeError(f"Missing operationId for {method.upper()} {path}")
            if operation_id in operation_ids:
                raise RuntimeError(f"Duplicate operationId: {operation_id}")
            operation_ids.add(operation_id)
            tags = operation.get("tags") or ["Other"]
            grouped.setdefault(tags[0], []).append((method.upper(), path, operation))

    lines = [
        "# Endpoint Catalog",
        "",
        "> Generated from `app.openapi()` by `python scripts/generate_api_docs.py`. Do not edit manually.",
        "",
        f"API version: **{schema.get('info', {}).get('version', 'unknown')}**",
        "",
        "Authentication uses `Authorization: Bearer <access_token>` unless an endpoint is marked Public.",
        "",
    ]
    for tag, operations in sorted(grouped.items()):
        lines.extend([f"## {tag}", "", "| Method | Path | Auth | Summary |", "|:---|:---|:---|:---|"])
        for method, path, operation in operations:
            auth = "Bearer" if operation.get("security") else "Public"
            summary = (operation.get("summary") or operation.get("operationId") or "").replace("|", "\\|")
            lines.append(f"| `{method}` | `{path}` | {auth} | {summary} |")
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def generated_outputs() -> tuple[str, str]:
    schema = app.openapi()
    openapi_text = json.dumps(schema, ensure_ascii=False, indent=2, sort_keys=True) + "\n"
    endpoint_text = render_endpoint_catalog(schema)
    return openapi_text, endpoint_text


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate or validate API documentation artifacts")
    parser.add_argument("--check", action="store_true", help="Fail if committed artifacts are stale")
    args = parser.parse_args()
    openapi_text, endpoint_text = generated_outputs()

    if args.check:
        stale = []
        if not OPENAPI_PATH.exists() or OPENAPI_PATH.read_text(encoding="utf-8") != openapi_text:
            stale.append(str(OPENAPI_PATH.relative_to(ROOT)))
        if not ENDPOINTS_PATH.exists() or ENDPOINTS_PATH.read_text(encoding="utf-8") != endpoint_text:
            stale.append(str(ENDPOINTS_PATH.relative_to(ROOT)))
        if stale:
            raise SystemExit(f"API documentation is stale: {', '.join(stale)}")
        return 0

    OPENAPI_PATH.parent.mkdir(parents=True, exist_ok=True)
    OPENAPI_PATH.write_text(openapi_text, encoding="utf-8")
    ENDPOINTS_PATH.write_text(endpoint_text, encoding="utf-8")
    print(f"Generated {OPENAPI_PATH.relative_to(ROOT)} and {ENDPOINTS_PATH.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
