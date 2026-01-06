# Project Flask - JastipKu

Jastip Ku,Tugas Besar Pemrograman Berorientasi Objek
Anggota Kelompok :
- Noufal Dzaky (411232068)
- Setio Permadi (411232072)
- Dendi Cahya Lukito (411232067)

## 🚀 Features

- CRUD produk (Create, Read, Update, Delete)
- Autentikasi user (login/logout)
- Dashboard admin
- REST API endpoints
- Integrasi database MySQL

## 🛠️ Tech Stack

- **Backend:** Flask 3.0.0
- **Database:** MySQL
- **ORM:** SQLAlchemy
- **Frontend:** HTML, CSS, Bootstrap
- **Others:** Flask-Login, Flask-WTF

## 📋 Prerequisites

Pastikan sudah terinstall:

- Python 3.7+
- MySQL Server
- pip (Python package manager)

## ⚙️ Installation

### 1. Clone Repository

```bash
git clone https://github.com/ndzak/jastipku
cd project-flask

### 2. Buat Virtual Environment
# Windows
python -m venv venv
venv\Scripts\activate

# Mac/Linux
python3 -m venv venv
source venv/bin/activate

### 3. Install Dependencies
pip install -r requirements.txt

### 4. Setup Database
CREATE DATABASE jastip_app;

### 5. Konfigurasi Environment
DATABASE_URI=mysql+pymysql://root:password@localhost/jastip_app
SECRET_KEY=your-secret-key-here
DEBUG=True

### 6. Run Application
python app.py
