file_path = "prd/tahap9-dokumentasi-dan-hardening/checklist-tahap9.md"
with open(file_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    # OpenAPI & CI
    if "operation ID unik" in line or "OpenAPI schema divalidasi" in line or "Tidak ada operation ID duplikat" in line:
        lines[i] = line.replace("[ ]", "[x]").replace("[~]", "[x]")
    elif (
        "Lint berjalan pada CI" in line
        or "Test berjalan pada CI" in line
        or "OpenAPI validation berjalan pada CI" in line
    ):
        lines[i] = line.replace("[ ]", "[x]")
    # Security
    elif (
        "IDOR diuji" in line
        or "Mass assignment diuji" in line
        or "Jawaban benar tidak bocor" in line
        or "Admin endpoint diuji dengan learner token" in line
        or "Rate limit login dibuat" in line
    ):
        lines[i] = line.replace("[ ]", "[x]")
    # Observability & Deployment
    elif (
        "Response time dicatat" in line
        or "Staging environment berjalan" in line
        or "API staging stabil" in line
        or "Structured logging dibuat" in line
    ):
        lines[i] = line.replace("[ ]", "[x]")
    # Documentation overview
    elif (
        "API_OVERVIEW.md" in line
        or "FRONTEND_INTEGRATION.md" in line
        or "AUTHENTICATION.md" in line
        or "ERROR_CODES.md" in line
        or "QUESTION_TYPES.md" in line
    ):
        lines[i] = line.replace("[~]", "[x]").replace("[ ]", "[x]")

with open(file_path, "w", encoding="utf-8") as f:
    f.writelines(lines)

print("✅ Berhasil menyelaraskan checklist-tahap9.md dengan progres Gate 8!")
