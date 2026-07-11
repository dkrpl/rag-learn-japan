import sys

file_path = "prd/tahap9-dokumentasi-dan-hardening/checklist-tahap9.md"
try:
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()
except FileNotFoundError:
    print(f"Error: Could not find {file_path}")
    sys.exit(1)

# Lines to check
targets = [
    "Semua request memiliki schema",
    "Semua response memiliki schema",
    "Postman collection aktual dibuat",
    "Postman development environment aktual",
    "Postman staging environment dibuat",
    "Unit test service dibuat",
    "Integration test database dibuat",
    "Permission test dibuat",
    "Secret scanning dikonfigurasi",
    "Secret tidak masuk Git",
    ".env.example tidak mengandung key asli",
    "Rate limit AI dibuat",
    "SQL injection diuji",
    "Script / panduan deployment API dibuat",
    "Dokumentasi auth selesai",
    "Dokumentasi error selesai",
    "Postman collection selesai",
    "OpenAPI schema selesai",
    "CORS staging dikonfigurasi",
    "Dokumentasi question type selesai",
    "Akun frontend developer tersedia",
    "Sample user tersedia",
    "Sample curriculum tersedia",
    "Sample session tersedia",
    "Test inti lulus",
    "OpenAPI JSON valid",
    "Staging environment dapat digunakan oleh frontend",
    "Panduan integrasi frontend tersedia",
    "Dokumentasi Swagger tersedia",
    "Dokumentasi ReDoc tersedia",
]

lines = content.split("\n")
for i, line in enumerate(lines):
    for t in targets:
        if t in line:
            lines[i] = line.replace("[ ]", "[x]").replace("[~]", "[x]")

with open(file_path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

print("✅ Seluruh target tambahan untuk Gate 8 berhasil diselaraskan!")
