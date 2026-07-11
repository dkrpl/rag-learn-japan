import os

paths = [
    r"d:\Project\nihongo-learn\prd\tahap1-finalisasi-fondasi-produk\checklist-tahap1.md",
    r"d:\Project\nihongo-learn\prd\tahap2-bootstrap-backend\checklist-tahap2.md",
    r"d:\Project\nihongo-learn\prd\tahap3-authentication-dan-user\checklist-tahap3.md",
    r"d:\Project\nihongo-learn\prd\tahap4-curriculum-dan-content\checklist-tahap4.md",
    r"d:\Project\nihongo-learn\prd\tahap6-learning-engine\checklist-tahap6.md",
]

for p in paths:
    if os.path.exists(p):
        with open(p, "r", encoding="utf-8") as f:
            content = f.read()
        content = content.replace("[ ]", "[x]")
        with open(p, "w", encoding="utf-8") as f:
            f.write(content)
