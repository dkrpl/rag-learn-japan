import glob

def main():
    print("Memperbaiki file migration lagi...")
    migration_files = glob.glob("alembic/versions/*_add_missing_columns.py")
    if not migration_files:
        print("File migration tidak ditemukan!")
        return
        
    target_file = migration_files[0]
    with open(target_file, "r", encoding="utf-8") as f:
        lines = f.readlines()

    new_lines = []
    for line in lines:
        if "refreshtokens" in line or "passwordresettokens" in line:
            continue
        new_lines.append(line)
        
    with open(target_file, "w", encoding="utf-8") as f:
        f.writelines(new_lines)
        
    print("Selesai! Sekarang silakan jalankan: alembic upgrade head")

if __name__ == "__main__":
    main()
