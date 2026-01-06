# models.py
from datetime import datetime
from enum import Enum
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import UserMixin
from flask_sqlalchemy import SQLAlchemy
from flask import session
import pytz


db = SQLAlchemy()

JAKARTA_TZ = pytz.timezone('Asia/Jakarta')

def jakarta_now():
    return datetime.now(JAKARTA_TZ)

class OrderStatus(Enum):
    PENDING = "Pending"
    PAID = "Paid"
    SHIPPED = "Shipped"
    COMPLETED = "Completed"
    CANCELLED = "Cancelled"

class AuthMixin:
    password_hash = db.Column(db.String(255), nullable=False)
    
    def set_password(self, raw_password):
        self.password_hash = generate_password_hash(raw_password)
    
    def check_password(self, raw_password):
        return check_password_hash(self.password_hash, raw_password)

class User(db.Model, UserMixin, AuthMixin):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    address = db.Column(db.Text, nullable=False) 
    phone = db.Column(db.String(20), nullable=True)
    created_at = db.Column(db.DateTime, default=jakarta_now)
    
    orders = db.relationship("Order", back_populates="buyer", lazy="dynamic")
    reviews = db.relationship("Review", back_populates="user", lazy="dynamic")
    
    role = db.Column(db.String(20), default="buyer")
    
    def __repr__(self):
        return f"<User {self.username}>"

class Jastipper(db.Model, UserMixin, AuthMixin):
    __tablename__ = "jastippers"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(150), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    created_at = db.Column(db.DateTime, default=jakarta_now)
    
    product_requests = db.relationship("ProductRequest", back_populates="jastipper", lazy="dynamic")
    reviews = db.relationship("Review", back_populates="jastipper", lazy="dynamic")
    
    def __repr__(self):
        return f"<Jastipper {self.name}>"

class ProductRequest(db.Model):
    __tablename__ = "product_requests"
    id = db.Column(db.Integer, primary_key=True)
    item_name = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text, nullable=True)
    category = db.Column(db.String(100), nullable=True)
    base_price = db.Column(db.Numeric(20, 2), nullable=False)
    image_url = db.Column(db.String(500), nullable=True)
    created_at = db.Column(db.DateTime, default=jakarta_now)
    fee_percent = db.Column(db.Integer, default=10, nullable=False)
    jastipper_id = db.Column(db.Integer, db.ForeignKey("jastippers.id"), nullable=False)

    jastipper = db.relationship("Jastipper", back_populates="product_requests")
    orders = db.relationship("Order", back_populates="product_request", lazy="dynamic")
    
    @property
    def fee_amount(self):
        return self.base_price * self.fee_percent / 100
    
    @property
    def total_price(self):
        return self.base_price + self.fee_amount
    
    @property
    def average_rating(self):
        reviews = Review.query.join(Order).filter(Order.product_request_id == self.id).all()
        if not reviews:
            return 0
        return sum([r.rating for r in reviews]) / len(reviews)
    
    @property
    def review_count(self):
        return Review.query.join(Order).filter(Order.product_request_id == self.id).count()
    
    def can_be_deleted(self):
        """Check if product can be deleted (no pending/active orders)"""
        active_orders = self.orders.filter(
            Order.status.in_(['Pending', 'Paid', 'Shipped'])
        ).count()
        return active_orders == 0
    
    def __repr__(self):
        return f"<ProductRequest {self.item_name}>"


class Order(db.Model):
    __tablename__ = "orders"
    id = db.Column(db.Integer, primary_key=True)
    buyer_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    product_request_id = db.Column(db.Integer, db.ForeignKey("product_requests.id"), nullable=False)
    quantity = db.Column(db.Integer, default=1, nullable=False)
    total = db.Column(db.Numeric(20, 2), nullable=False)
    status = db.Column(db.String(20), default="Pending", nullable=False)
    
    payment_proof_url = db.Column(db.String(500), nullable=True)
    payment_verified = db.Column(db.Boolean, default=False)
    payment_uploaded_at = db.Column(db.DateTime, nullable=True)
    
    cancel_reason = db.Column(db.Text, nullable=True)
    
    shipping_courier = db.Column(db.String(100), nullable=True)
    tracking_number = db.Column(db.String(100), nullable=True)
    
    reviewed = db.Column(db.Boolean, default=False)
    
    created_at = db.Column(db.DateTime, default=jakarta_now)
    updated_at = db.Column(db.DateTime, default=jakarta_now, onupdate=jakarta_now)
    
    buyer = db.relationship("User", back_populates="orders")
    product_request = db.relationship("ProductRequest", back_populates="orders")
    review = db.relationship("Review", back_populates="order", uselist=False)
    
    def __repr__(self):
        return f"<Order {self.id} - {self.status}>"


class Review(db.Model):
    __tablename__ = "reviews"
    id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.Integer, db.ForeignKey("orders.id"), nullable=False, unique=True)  # BARU
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    jastipper_id = db.Column(db.Integer, db.ForeignKey("jastippers.id"), nullable=False)
    rating = db.Column(db.Integer, nullable=False)
    comment = db.Column(db.Text, nullable=True)
    created_at = db.Column(db.DateTime, default=jakarta_now)
    
    # relasi
    order = db.relationship("Order", back_populates="review")
    user = db.relationship("User", back_populates="reviews")
    jastipper = db.relationship("Jastipper", back_populates="reviews")
    
    def __repr__(self):
        return f"<Review {self.rating} stars>"
