import os
import sys

# Paksa aplikasi agar menggunakan database Railway, bukan lokal
os.environ["DATABASE_URL"] = "mysql+pymysql://root:ltGttAzbXkFYqGMMPNTKowpSYhRpjTQE@tokaido.proxy.rlwy.net:38718/railway"

# Masukkan folder saat ini agar bisa melakukan import app
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__))))

from app.db.session import SessionLocal
from app.core import security
from app.models.user import User, UserRole
import uuid

def main():
    db = SessionLocal()
    email = "admin@raglearn.com"
    password = "password123"
    
    user = db.query(User).filter(User.email == email).first()
    if not user:
        user = User(
            id=str(uuid.uuid4()),
            email=email,
            name="Admin RAG Learn",
            password_hash=security.get_password_hash(password),
            role=UserRole.ADMINISTRATOR,
            timezone="Asia/Jakarta",
            target_level="N5",
            is_active=True
        )
        db.add(user)
        db.commit()
        print(f"✅ Akun Admin berhasil dibuat di Railway!\nEmail: {email}\nPassword: {password}")
    else:
        user.password_hash = security.get_password_hash(password)
        db.commit()
        print(f"✅ Akun Admin berhasil diperbarui di Railway!\nEmail: {email}\nPassword: {password}")
    
    db.close()

if __name__ == "__main__":
    main()
