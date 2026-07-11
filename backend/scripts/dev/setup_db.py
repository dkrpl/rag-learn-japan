import pymysql

try:
    conn = pymysql.connect(host="127.0.0.1", user="root", password="", port=3306)
    cursor = conn.cursor()
    cursor.execute("CREATE DATABASE IF NOT EXISTS nihongo_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci")
    print("Database nihongo_db ensured.")
    conn.close()
except Exception as e:
    print(f"Error creating database: {e}")
