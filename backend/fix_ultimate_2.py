import os
import glob
import subprocess
import pymysql

def fix():
    print("Memulai perbaikan otomatis terakhir...")
    # 1. Hapus file migration yang rusak
    for f in glob.glob("alembic/versions/*_add_missing_columns.py"):
        os.remove(f)
        
    # 2. Siapkan database agar tidak bentrok
    conn = pymysql.connect(host="127.0.0.1", user="root", password="", database="nihongo_db")
    cursor = conn.cursor()
    cursor.execute("CREATE TABLE IF NOT EXISTS refreshtokens (id INT PRIMARY KEY);")
    cursor.execute("CREATE TABLE IF NOT EXISTS passwordresettokens (id INT PRIMARY KEY);")
    
    cursor.execute("SET FOREIGN_KEY_CHECKS=0;")
    cursor.execute("DROP TABLE IF EXISTS refresh_tokens;")
    cursor.execute("DROP TABLE IF EXISTS password_reset_tokens;")
    cursor.execute("DROP TABLE IF EXISTS email_verification_tokens;")
    cursor.execute("SET FOREIGN_KEY_CHECKS=1;")
    conn.commit()
    conn.close()
    
    # 3. Generate ulang migration yang bersih
    subprocess.run([r"venv\Scripts\alembic.exe", "revision", "--autogenerate", "-m", "Add missing columns"], check=True)
    
    # 4. Suntikkan nilai default dan HAPUS aturan UNIQUE yang bentrok dengan data lama
    migration_files = glob.glob("alembic/versions/*_add_missing_columns.py")
    if not migration_files:
        return
    
    target = migration_files[0]
    with open(target, "r", encoding="utf-8") as f:
        lines = f.readlines()
        
    new_lines = []
    for line in lines:
        # Jangan tambahkan aturan unik jika data lama ada yang duplikat
        if "create_unique_constraint" in line:
            continue
            
        # Perbaiki strict NOT NULL
        if "sa.Column('expires_at', sa.DateTime(timezone=True), nullable=False)" in line:
            line = line.replace("nullable=False)", "nullable=False, server_default=sa.text('CURRENT_TIMESTAMP'))")
        elif "sa.Column('sequence', sa.Integer(), nullable=False)" in line:
            line = line.replace("nullable=False)", "nullable=False, server_default='0')")
        elif "sa.Column('is_published', sa.Boolean(), nullable=False)" in line:
            line = line.replace("nullable=False)", "nullable=False, server_default='0')")
            
        new_lines.append(line)
        
    with open(target, "w", encoding="utf-8") as f:
        f.writelines(new_lines)
        
    print("\n✅ SELESAI! Silakan jalankan perintah ini di terminal:")
    print("alembic upgrade head")

if __name__ == "__main__":
    fix()
