import pymysql
from pymysql.constants import CLIENT
import sys

def main():
    print("Menghubungkan ke database Railway...")
    try:
        connection = pymysql.connect(
            host="tokaido.proxy.rlwy.net",
            port=38718,
            user="root",
            password="ltGttAzbXkFYqGMMPNTKowpSYhRpjTQE",
            database="railway",
            client_flag=CLIENT.MULTI_STATEMENTS,
            autocommit=True
        )
    except Exception as e:
        print(f"Gagal terhubung ke database: {e}")
        sys.exit(1)

    print("Koneksi berhasil! Membaca file SQL...")
    try:
        with open("d:\\Project\\nihongo-learn\\backend\\nihongo_db.sql", "r", encoding="utf-8") as f:
            sql = f.read()
    except Exception as e:
        print(f"Gagal membaca file SQL: {e}")
        sys.exit(1)

    print("Membersihkan tabel lama dan memasukkan data baru (ini mungkin memakan waktu beberapa detik)...")
    try:
        with connection.cursor() as cursor:
            # Matikan pengecekan Foreign Key sementara
            cursor.execute("SET FOREIGN_KEY_CHECKS = 0;")
            
            # Hapus semua tabel yang sudah ada agar tidak bentrok
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()
            for table in tables:
                cursor.execute(f"DROP TABLE IF EXISTS `{table[0]}`")
            
            # Eksekusi seluruh isi file SQL
            cursor.execute(sql)
            
            # Nyalakan kembali pengecekan Foreign Key
            cursor.execute("SET FOREIGN_KEY_CHECKS = 1;")
            
        print("\n✅ SELESAI! Seluruh data berhasil di-import ke Railway!")
    except Exception as e:
        print(f"\n❌ Terjadi kesalahan saat import data: {e}")
    finally:
        connection.close()

if __name__ == "__main__":
    main()
