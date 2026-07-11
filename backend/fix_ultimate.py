import os
import glob
import subprocess
import pymysql

def fix():
    print("Memulai perbaikan otomatis...")
    # 1. Hapus file migration yang rusak
    for f in glob.glob("alembic/versions/*_add_missing_columns.py"):
        os.remove(f)
        print(f"Menghapus file lama: {f}")
        
    # 2. Siapkan database agar tidak bentrok
    conn = pymysql.connect(host="127.0.0.1", user="root", password="", database="nihongo_db")
    cursor = conn.cursor()
    # Buat tabel bohongan agar perintah drop_table dari Alembic tidak error
    cursor.execute("CREATE TABLE IF NOT EXISTS refreshtokens (id INT PRIMARY KEY);")
    cursor.execute("CREATE TABLE IF NOT EXISTS passwordresettokens (id INT PRIMARY KEY);")
    
    # Hapus tabel baru yang setengah jadi
    cursor.execute("SET FOREIGN_KEY_CHECKS=0;")
    cursor.execute("DROP TABLE IF EXISTS refresh_tokens;")
    cursor.execute("DROP TABLE IF EXISTS password_reset_tokens;")
    cursor.execute("DROP TABLE IF EXISTS email_verification_tokens;")
    cursor.execute("SET FOREIGN_KEY_CHECKS=1;")
    conn.commit()
    conn.close()
    print("Database lokal siap!")
    
    # 3. Generate ulang migration yang bersih
    print("Membentuk ulang catatan Alembic (autogenerate)...")
    subprocess.run([r"venv\Scripts\alembic.exe", "revision", "--autogenerate", "-m", "Add missing columns"], check=True)
    
    # 4. Suntikkan nilai default (CURRENT_TIMESTAMP) agar data lama tidak error
    migration_files = glob.glob("alembic/versions/*_add_missing_columns.py")
    if not migration_files:
        return
    
    target = migration_files[0]
    with open(target, "r", encoding="utf-8") as f:
        content = f.read()
        
    replacements = {
        "sa.Column('expires_at', sa.DateTime(timezone=True), nullable=False)": "sa.Column('expires_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP'))",
        "sa.Column('sequence', sa.Integer(), nullable=False)": "sa.Column('sequence', sa.Integer(), nullable=False, server_default='0')",
        "sa.Column('is_published', sa.Boolean(), nullable=False)": "sa.Column('is_published', sa.Boolean(), nullable=False, server_default='0')"
    }
    for old, new in replacements.items():
        content = content.replace(old, new)
        
    with open(target, "w", encoding="utf-8") as f:
        f.write(content)
        
    print("\n✅ SELESAI! Silakan jalankan perintah ini di terminal:")
    print("alembic upgrade head")

if __name__ == "__main__":
    fix()
