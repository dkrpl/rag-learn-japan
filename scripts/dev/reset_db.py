import pymysql
try:
    conn = pymysql.connect(host='127.0.0.1', user='root', password='', port=3306)
    cursor = conn.cursor()
    cursor.execute('DROP DATABASE IF EXISTS nihongo_db')
    cursor.execute('CREATE DATABASE nihongo_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci')
    print('DB Reset')
except Exception as e:
    print('Error:', e)
