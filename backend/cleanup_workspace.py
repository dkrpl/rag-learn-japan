import os
import shutil


def move_file(src, dest):
    if os.path.exists(src):
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        shutil.move(src, dest)
        print(f"Moved: {src} -> {dest}")


def delete_file(src):
    if os.path.exists(src):
        os.remove(src)
        print(f"Deleted: {src}")


# Move PRD main doc to prd/
move_file(
    "prd_belajar_bahasa_jepang.md", "prd/00-master-backend-engine-prd.md"
)  # Wait, 00-master already exists, let's just overwrite or move it as old
if os.path.exists("prd/00-master-backend-engine-prd.md") and os.path.exists("prd_belajar_bahasa_jepang.md"):
    delete_file("prd_belajar_bahasa_jepang.md")  # it's a duplicate of 00-master

# Move dev scripts to scripts/dev/
dev_scripts = ["clean.py", "debug_auth.py", "reset_db.py", "setup_db.py"]
for script in dev_scripts:
    move_file(script, f"scripts/dev/{script}")

# Move export_openapi.py to scripts/
move_file("export_openapi.py", "scripts/export_openapi.py")

# Move other sync scripts inside scripts/ to scripts/dev/
sync_scripts = ["sync_checklists.py", "sync_tahap9.py", "sync_tahap9_final.py"]
for script in sync_scripts:
    move_file(f"scripts/{script}", f"scripts/dev/{script}")

# Delete redundant test runner scripts
delete_file("run_tests.bat")
delete_file("run_tests.py")

print("Cleanup completed.")
