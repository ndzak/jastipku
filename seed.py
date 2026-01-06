# seed.py
from app import create_app
from models import db, User, Jastipper, ProductRequest
from datetime import datetime

def seed_data():
    app = create_app()
    
    with app.app_context():
        # Hapus data lama (optional - hati-hati kalau ada data penting!)
        print("Menghapus data lama...")
        ProductRequest.query.delete()
        Jastipper.query.delete()
        # User.query.delete()  # Uncomment jika mau hapus user juga
        db.session.commit()
        
        print("Membuat data Jastipper...")
        
        # Buat 3 Jastipper - SESUAI MODEL (hanya name dan email)
        jastipper1 = Jastipper(
            name="Yuki Tanaka - Jastipper Jepang",
            email="yuki@jastip.com"
        )
        jastipper1.set_password("password123")
        
        jastipper2 = Jastipper(
            name="Kim Min-ji - Jastipper Korea",
            email="minji@jastip.com"
        )
        jastipper2.set_password("password123")
        
        jastipper3 = Jastipper(
            name="John Smith - Jastipper USA",
            email="john@jastip.com"
        )
        jastipper3.set_password("password123")
        
        db.session.add_all([jastipper1, jastipper2, jastipper3])
        db.session.commit()
        
        print(f"✓ Berhasil membuat {Jastipper.query.count()} Jastipper")
        
        print("Membuat data Product Request...")
        
        # Product Request dari Jepang
        products_japan = [
            {
                "item_name": "Nintendo Switch OLED",
                "description": "Console game Nintendo Switch versi OLED dengan layar lebih jernih dan storage 64GB. Brand new sealed!",
                "category": "Elektronik",
                "base_price": 4500000,
                "fee_percent": 15,
                "image_url": "",
                "jastipper_id": jastipper1.id
            },
            {
                "item_name": "Uniqlo Heattech Innerwear",
                "description": "Baju dalam Heattech dari Uniqlo yang super hangat dan nyaman. Cocok untuk musim dingin atau ruangan ber-AC.",
                "category": "Fashion",
                "base_price": 250000,
                "fee_percent": 10,
                "image_url": "",
                "jastipper_id": jastipper1.id
            },
            {
                "item_name": "Shiseido Perfect Whip Foam",
                "description": "Sabun wajah foam dari Shiseido yang lembut dan membersihkan sempurna. Best seller di Jepang!",
                "category": "Kosmetik",
                "base_price": 150000,
                "fee_percent": 12,
                "image_url": "",
                "jastipper_id": jastipper1.id
            },
            {
                "item_name": "Tokyo Banana Original",
                "description": "Oleh-oleh khas Tokyo yang terkenal! Kue lembut dengan isian krim pisang yang manis dan lezat.",
                "category": "Makanan",
                "base_price": 180000,
                "fee_percent": 20,
                "image_url": "",
                "jastipper_id": jastipper1.id
            }
        ]
        
        # Product Request dari Korea
        products_korea = [
            {
                "item_name": "Samsung Galaxy Buds Pro",
                "description": "Earbuds wireless premium dari Samsung dengan noise cancellation terbaik. Original product!",
                "category": "Elektronik",
                "base_price": 2800000,
                "fee_percent": 15,
                "image_url": "",
                "jastipper_id": jastipper2.id
            },
            {
                "item_name": "COSRX Snail Mucin Essence",
                "description": "Essence wajah dengan snail mucin 96% yang viral di seluruh dunia. Bikin kulit glowing dan lembab!",
                "category": "Kosmetik",
                "base_price": 180000,
                "fee_percent": 10,
                "image_url": "",
                "jastipper_id": jastipper2.id
            },
            {
                "item_name": "Korean Hanbok Modern",
                "description": "Hanbok modern style yang trendy dan comfortable. Perfect untuk photoshoot atau acara khusus!",
                "category": "Fashion",
                "base_price": 850000,
                "fee_percent": 18,
                "image_url": "",
                "jastipper_id": jastipper2.id
            },
            {
                "item_name": "Samyang Hot Chicken Ramen Bundle",
                "description": "Paket isi 10 bungkus mie pedas Samyang dengan berbagai varian rasa. Challenge accepted?",
                "category": "Makanan",
                "base_price": 120000,
                "fee_percent": 15,
                "image_url": "",
                "jastipper_id": jastipper2.id
            }
        ]
        
        # Product Request dari USA
        products_usa = [
            {
                "item_name": "Apple AirPods Pro 2",
                "description": "AirPods Pro generasi 2 dengan H2 chip dan USB-C charging. Noise cancellation terbaik dari Apple!",
                "category": "Elektronik",
                "base_price": 3500000,
                "fee_percent": 12,
                "image_url": "",
                "jastipper_id": jastipper3.id
            },
            {
                "item_name": "Levi's 501 Original Jeans",
                "description": "Celana jeans klasik Levi's 501 original fit. Timeless style yang tidak pernah ketinggalan zaman.",
                "category": "Fashion",
                "base_price": 1200000,
                "fee_percent": 15,
                "image_url": "",
                "jastipper_id": jastipper3.id
            },
            {
                "item_name": "Bath & Body Works Candle Set",
                "description": "Set 3 lilin aromaterapi dari Bath & Body Works dengan wangi yang tahan lama dan menenangkan.",
                "category": "Lainnya",
                "base_price": 450000,
                "fee_percent": 20,
                "image_url": "",
                "jastipper_id": jastipper3.id
            },
            {
                "item_name": "Hershey's Chocolate Gift Box",
                "description": "Gift box cokelat Hershey's dengan berbagai varian rasa. Perfect untuk hadiah atau cemilan!",
                "category": "Makanan",
                "base_price": 250000,
                "fee_percent": 18,
                "image_url": "",
                "jastipper_id": jastipper3.id
            }
        ]
        
        # Gabungkan semua products
        all_products = products_japan + products_korea + products_usa
        
        # Insert ke database
        for product_data in all_products:
            product = ProductRequest(**product_data)
            db.session.add(product)
        
        db.session.commit()
        
        print(f"✓ Berhasil membuat {ProductRequest.query.count()} Product Request")
        print("\n" + "="*50)
        print("SEEDING SELESAI!")
        print("="*50)
        print(f"Total Jastipper: {Jastipper.query.count()}")
        print(f"Total Product Request: {ProductRequest.query.count()}")
        print("\nAkun Jastipper untuk testing:")
        print("-" * 50)
        for j in Jastipper.query.all():
            print(f"Nama: {j.name}")
            print(f"Email: {j.email}")
            print(f"Password: password123")
            print("-" * 50)

if __name__ == "__main__":
    seed_data()
