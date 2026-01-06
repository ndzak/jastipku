# app.py
from flask import Flask
from config import Config
from models import db, User, Jastipper
from flask_login import LoginManager
from flask import session


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # init extensions
    db.init_app(app)
    login_manager = LoginManager()
    login_manager.login_view = "main.login"
    login_manager.init_app(app)

    # user loader: coba cari user di tabel users dan jastippers
    @login_manager.user_loader
    def load_user(user_id):
        try:
            uid = int(user_id)
        except Exception:
            return None

        user_type = session.get("user_type")

        if user_type == "jastipper":
            return db.session.get(Jastipper, uid)

        return db.session.get(User, uid)

    # register blueprints or routes
    from routes import main as main_blueprint
    app.register_blueprint(main_blueprint)

    return app


if __name__ == "__main__":
    app = create_app()
    
    # Error handling untuk db.create_all()
    try:
        with app.app_context():
            db.create_all()
            print("✅ Database tables created successfully!")
    except Exception as e:
        print(f"❌ Error creating tables: {e}")
        print("⚠️  App will still run, but check your database connection!")
    
    print("🚀 Starting Flask app...")
    # app.run(debug=True, host='127.0.0.1', port=5000)
    app.run(debug=True, host="0.0.0.0", port=5000)

