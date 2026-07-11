import sys
import os

# Add parent dir to path so we can import app
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from sqlalchemy.orm import Session
from app.db.session import SessionLocal
from app.models.user import User, UserRole
from app.core import security

def seed_admin(email: str, password: str, name: str):
    db: Session = SessionLocal()
    try:
        user = db.query(User).filter(User.email == email).first()
        if user:
            print(f"User {email} exists. Updating to ADMINISTRATOR and resetting password.")
            user.role = UserRole.ADMINISTRATOR
            user.password_hash = security.get_password_hash(password)
            user.is_active = True
        else:
            print(f"Creating new ADMINISTRATOR: {email}")
            user = User(
                email=email,
                password_hash=security.get_password_hash(password),
                name=name,
                role=UserRole.ADMINISTRATOR,
                is_active=True
            )
            db.add(user)
        db.commit()
        print("Success!")
    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python seed_admin.py <email> <password> [name]")
        sys.exit(1)
    
    email = sys.argv[1]
    password = sys.argv[2]
    name = sys.argv[3] if len(sys.argv) > 3 else "Administrator"
    
    seed_admin(email, password, name)
