import os
import glob
import pymysql
from dotenv import load_dotenv

load_dotenv()

def main():
    # 1. Drop partially created tables so Alembic can retry
    db_url = os.getenv("DATABASE_URL")
    if not db_url:
        print("DATABASE_URL not found")
        return
        
    # Extract host, user, pass, db from mysql+pymysql://root:@127.0.0.1:3306/nihongo_db
    # Simplified parsing for local default
    print("Menghapus tabel sisa yang membuat error...")
    try:
        conn = pymysql.connect(host="127.0.0.1", user="root", password="", database="nihongo_db", port=3306)
        with conn.cursor() as cursor:
            cursor.execute("SET FOREIGN_KEY_CHECKS = 0;")
            cursor.execute("DROP TABLE IF EXISTS email_verification_tokens;")
            cursor.execute("DROP TABLE IF EXISTS password_reset_tokens;")
            cursor.execute("DROP TABLE IF EXISTS refresh_tokens;")
            cursor.execute("SET FOREIGN_KEY_CHECKS = 1;")
        conn.commit()
        conn.close()
    except Exception as e:
        print(f"Warning: {e}")

    # 2. Fix the migration script to handle DATETIME NOT NULL on existing rows
    print("Memperbaiki file migration...")
    migration_files = glob.glob("alembic/versions/*_add_missing_columns.py")
    if not migration_files:
        print("File migration tidak ditemukan!")
        return
        
    target_file = migration_files[0]
    with open(target_file, "r", encoding="utf-8") as f:
        content = f.read()

    # Replace strict NOT NULL with a default for existing rows
    replacements = {
        "sa.Column('expires_at', sa.DateTime(timezone=True), nullable=False)": "sa.Column('expires_at', sa.DateTime(timezone=True), nullable=False, server_default=sa.text('CURRENT_TIMESTAMP'))",
        "sa.Column('sequence', sa.Integer(), nullable=False)": "sa.Column('sequence', sa.Integer(), nullable=False, server_default='0')",
        "sa.Column('is_published', sa.Boolean(), nullable=False)": "sa.Column('is_published', sa.Boolean(), nullable=False, server_default='0')"
    }
    
    for old, new in replacements.items():
        content = content.replace(old, new)
        
    with open(target_file, "w", encoding="utf-8") as f:
        f.write(content)
        
    print("Selesai! Sekarang silakan jalankan: alembic upgrade head")

if __name__ == "__main__":
    main()
