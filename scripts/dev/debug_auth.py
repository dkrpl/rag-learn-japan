import sys
import os
import traceback
sys.path.insert(0, os.path.abspath(os.path.dirname(__file__)))

from sqlalchemy.orm import Session
from app.db.session import SessionLocal
from app.schemas.user import UserCreate
from app.api.v1.auth import register, login
from app.schemas.auth import LoginRequest
import logging

db = SessionLocal()
try:
    print("Testing register...")
    user_data = UserCreate(email="debug@example.com", password="password123", name="Debug")
    print("UserCreate password type:", type(user_data.password))
    print("UserCreate password secret value:", user_data.password.get_secret_value())
    print("Length:", len(user_data.password.get_secret_value()))
    
    register(user_data, db)
    print("Register successful")
    
    login_data = LoginRequest(email="debug@example.com", password="password123")
    # need mock request
    class MockRequest:
        class Client:
            host = "127.0.0.1"
        client = Client()
    login(login_data, MockRequest(), db)
    print("Login successful")
    
except Exception as e:
    print("Exception occurred:")
    traceback.print_exc()
finally:
    db.close()
