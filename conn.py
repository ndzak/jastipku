import pymysql

ports = [3306, 3307, 3308]

for port in ports:
    try:
        conn = pymysql.connect(
            host='127.0.0.1',
            user='root',
            password='',
            database='jastip_app',
            port=port
        )
        print(f"✅ BERHASIL connect di port {port}!")
        conn.close()
        break
    except Exception as e:
        print(f"❌ Port {port} gagal: {e}")
