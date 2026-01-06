# ================================================
# ROUTES.PY - JASTIPKU APPLICATION (FIXED)
# ================================================

from flask import Blueprint, render_template, redirect, url_for, request, flash, jsonify
from flask_login import login_user, logout_user, login_required, current_user
from werkzeug.utils import secure_filename
from sqlalchemy import or_, and_
from flask import session
import os
from datetime import datetime

from models import db, User, Jastipper, ProductRequest, Order, Review, jakarta_now
from utils import print_sql_query, debug_query, enable_sql_logging



# ================================================
# BLUEPRINT & CONFIGURATION
# ================================================

main = Blueprint("main", __name__)

# Upload folders
UPLOAD_FOLDER = 'static/uploads'
PAYMENT_FOLDER = 'static/payments'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(PAYMENT_FOLDER, exist_ok=True)

ALLOWED_EXTENSIONS = {
    'png',
    'jpg',
    'jpeg',
    'gif',
    'webp',
    'bmp'
}


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


# ================================================
# PUBLIC ROUTES
# ================================================

@main.route("/")
def index():
    """Homepage dengan produk populer"""
    popular = ProductRequest.query.limit(6).all()
    return render_template("index.html", popular=popular)


@main.route("/search")
def search():
    """Search produk berdasarkan nama atau kategori"""
    q = request.args.get("q", "").strip()
    cat = request.args.get("category", "").strip()
    
    query = ProductRequest.query
    if q:
        query = query.filter(ProductRequest.item_name.ilike(f"%{q}%"))
    if cat:
        query = query.filter(ProductRequest.category == cat)
    
    results = query.order_by(ProductRequest.created_at.desc()).all()
    return render_template("search_results.html", results=results, q=q, cat=cat)


@main.route("/product/<int:product_id>")
def product_detail(product_id):
    product = ProductRequest.query.get_or_404(product_id)
    
    reviews = Review.query.join(Order).filter(Order.product_request_id == product.id).order_by(Review.created_at.desc()).limit(5).all()
    
    avg_rating = product.average_rating
    
    return render_template("product_detail.html", 
                         product=product, 
                         reviews=reviews,
                         avg_rating=round(avg_rating, 1))


# ================================================
# AUTHENTICATION ROUTES
# ================================================

@main.route("/register", methods=["GET", "POST"])
def register():
    """Register untuk Buyer atau Jastipper"""
    if request.method == "POST":
        role = request.form.get("role")
        email = request.form.get("email")
        password = request.form.get("password")
        
        if role not in ['buyer', 'jastipper']:
            flash("Pilihan role tidak valid", "danger")
            return redirect(url_for("main.register"))
        
        if User.query.filter_by(email=email).first() or Jastipper.query.filter_by(email=email).first():
            flash("Email sudah terdaftar", "danger")
            return redirect(url_for("main.register"))
        
        if role == 'buyer':
            username = request.form.get("username")
            address = request.form.get("address")
            phone = request.form.get("phone")
            
            if not address or not address.strip():
                flash("Alamat harus diisi", "danger")
                return redirect(url_for("main.register"))
            
            if not username or not username.strip():
                flash("Username harus diisi", "danger")
                return redirect(url_for("main.register"))
            
            if User.query.filter_by(username=username).first():
                flash("Username sudah dipakai", "danger")
                return redirect(url_for("main.register"))
            
            user = User(username=username, email=email, address=address.strip(), phone=phone)
            user.set_password(password)
            db.session.add(user)
            db.session.commit()
            flash("Registrasi berhasil! Silakan login sebagai Buyer.", "success")
        
        elif role == 'jastipper':
            name = request.form.get("name")
            
            if not name or not name.strip():
                flash("Nama lengkap harus diisi untuk Jastipper", "danger")
                return redirect(url_for("main.register"))
            
            jastipper = Jastipper(name=name.strip(), email=email)
            jastipper.set_password(password)
            db.session.add(jastipper)
            db.session.commit()
            flash("Registrasi berhasil! Silakan login sebagai Jastipper.", "success")
        
        return redirect(url_for("main.login"))
    
    return render_template("register.html")


@main.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        logout_user()  # bersihkan session lama
        print("LOGIN_AS:", request.form.get("login_as"))
        print("FORM DATA:", request.form)

        login_as = request.form.get("login_as")
        email_or_username = request.form.get("email_or_username")
        password = request.form.get("password")

        # VALIDASI ROLE
        if login_as == "jastipper":
            print("➡️ MASUK BLOK JASTIPPER")

            jastipper = Jastipper.query.filter_by(email=email_or_username).first()
            print("JASTIPPER FOUND:", jastipper)

            if jastipper and jastipper.check_password(password):
                print("✅ PASSWORD JASTIPPER BENAR")

                login_user(jastipper)
                session["user_type"] = "jastipper"
                print("LOGIN_USER CALLED WITH:", type(jastipper), jastipper.get_id())

                flash(f"Selamat datang, {jastipper.name}!", "success")
                return redirect(url_for("main.jastipper_dashboard"))

        elif login_as == "user":
            print("➡️ MASUK BLOK USER")

            user = User.query.filter(
                or_(
                    User.email == email_or_username,
                    User.username == email_or_username
                )
            ).first()
            print("USER FOUND:", user)

            if user and user.check_password(password):
                print("✅ PASSWORD USER BENAR")

                login_user(user)
                session["user_type"] = "user"
                print("LOGIN_USER CALLED WITH:", type(user), user.get_id())

                flash(f"Selamat datang, {user.username}!", "success")
                return redirect(url_for("main.index"))

            # GAGAL LOGIN
            flash("Email / Username atau password salah", "danger")

    return render_template("login.html")



@main.route("/logout")
@login_required
def logout():
    """Logout user"""
    logout_user()
    flash("Anda telah logout.", "info")
    return redirect(url_for("main.index"))


# ================================================
# BUYER ROUTES
# ================================================

@main.route("/profile", methods=["GET", "POST"])
@login_required
def profile():
    """Edit profile buyer (alamat & phone)"""
    if hasattr(current_user, "product_requests"):
        flash("Fitur ini hanya untuk buyer.", "danger")
        return redirect(url_for("main.jastipper_dashboard"))
    
    if request.method == "POST":
        current_user.address = request.form.get("address")
        current_user.phone = request.form.get("phone")
        db.session.commit()
        flash("Profil berhasil diupdate!", "success")
        return redirect(url_for("main.profile"))
    
    return render_template("profile.html", user=current_user)


@main.route("/order/<int:request_id>", methods=["GET", "POST"])
@login_required
def order(request_id):
    """Form order produk oleh buyer"""
    if hasattr(current_user, "product_requests"):
        flash("Jastipper tidak bisa memesan produk.", "danger")
        return redirect(url_for("main.index"))
    
    product = ProductRequest.query.get_or_404(request_id)
    
    if request.method == "POST":
        quantity = int(request.form.get("quantity", 1))
        total = product.total_price * quantity
        
        new_order = Order(
            buyer_id=current_user.id,
            product_request_id=product.id,
            quantity=quantity,
            total=total,
            status="Pending"
        )
        db.session.add(new_order)
        db.session.commit()
        
        flash("Pesanan berhasil dibuat! Silakan upload bukti pembayaran.", "success")
        return redirect(url_for("main.my_orders"))
    
    return render_template("order_form.html", product=product, user=current_user)


@main.route("/my_orders")
@login_required
def my_orders():
    """Daftar pesanan buyer dengan filter status"""
    if hasattr(current_user, "product_requests"):
        flash("Fitur ini hanya untuk buyer.", "danger")
        return redirect(url_for("main.jastipper_dashboard"))
    
    status_filter = request.args.get("status", "all")
    query = current_user.orders.order_by(Order.created_at.desc())
    
    if status_filter != "all":
        query = query.filter_by(status=status_filter)
    
    orders = query.all()
    return render_template("my_orders.html", orders=orders, current_filter=status_filter)


@main.route("/order/upload_payment/<int:order_id>", methods=["POST"])
@login_required
def upload_payment(order_id):
    """Upload bukti bayar oleh buyer"""
    order = Order.query.get_or_404(order_id)
    
    if order.buyer_id != current_user.id:
        flash("Anda tidak memiliki akses untuk order ini.", "danger")
        return redirect(url_for("main.my_orders"))
    
    if order.status != "Pending":
        flash("Bukti pembayaran hanya bisa diupload untuk pesanan Pending.", "warning")
        return redirect(url_for("main.my_orders"))
    
    if 'payment_proof' in request.files:
        file = request.files['payment_proof']
        if file and file.filename != '' and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S_')
            filename = f"payment_{order.id}_{timestamp}{filename}"
            filepath = os.path.join(PAYMENT_FOLDER, filename)
            file.save(filepath)
            
            order.payment_proof_url = f'/static/payments/{filename}'
            order.payment_uploaded_at = jakarta_now()
            db.session.commit()
            
            flash("Bukti pembayaran berhasil diupload! Menunggu verifikasi.", "success")
        else:
            flash("File tidak valid. Gunakan JPG, PNG, atau GIF.", "danger")
    else:
        flash("Tidak ada file yang diupload.", "danger")
    
    return redirect(url_for("main.my_orders"))


@main.route("/order/review/<int:order_id>", methods=["POST"])
@login_required
def submit_review(order_id):
    """Submit review setelah order completed"""
    order = Order.query.get_or_404(order_id)
    
    if order.buyer_id != current_user.id:
        flash("Anda tidak memiliki akses untuk order ini.", "danger")
        return redirect(url_for("main.my_orders"))
    
    if order.status != "Completed":
        flash("Review hanya bisa diberikan untuk pesanan yang sudah selesai.", "warning")
        return redirect(url_for("main.my_orders"))
    
    if order.reviewed:
        flash("Anda sudah memberikan review untuk pesanan ini.", "warning")
        return redirect(url_for("main.my_orders"))
    
    rating = int(request.form.get("rating"))
    comment = request.form.get("comment")
    
    review = Review(
        order_id=order.id,
        user_id=current_user.id,
        jastipper_id=order.product_request.jastipper_id,
        rating=rating,
        comment=comment
    )
    order.reviewed = True
    
    db.session.add(review)
    db.session.commit()
    
    flash("Terima kasih atas review Anda!", "success")
    return redirect(url_for("main.my_orders"))


# ================================================
# JASTIPPER ROUTES - Dashboard
# ================================================

@main.route("/jastipper/dashboard")
@login_required
def jastipper_dashboard():
    """Dashboard jastipper dengan statistik"""
    if not hasattr(current_user, "product_requests"):
        flash("Hanya jastipper yang dapat mengakses halaman ini.", "danger")
        return redirect(url_for("main.index"))
    
    total_products = current_user.product_requests.count()
    
    jastipper_orders = Order.query.join(ProductRequest).filter(
        ProductRequest.jastipper_id == current_user.id
    ).order_by(Order.created_at.desc()).all()
    
    total_orders = len(jastipper_orders)
    pending_orders = len([o for o in jastipper_orders if o.status == 'Pending'])
    completed_orders = len([o for o in jastipper_orders if o.status == 'Completed'])
    unverified_payments = len([o for o in jastipper_orders if o.payment_proof_url and not o.payment_verified and o.status == 'Pending'])
    

    
    total_revenue = sum([o.total for o in jastipper_orders if o.status in ['Completed', 'Shipped']])
    
    stats = {
        'total_products': total_products,
        'total_orders': total_orders,
        'pending_orders': pending_orders,
        'completed_orders': completed_orders,
        'total_revenue': total_revenue,
        'unverified_payments': unverified_payments
    }
    
    recent_products = current_user.product_requests.order_by(ProductRequest.created_at.desc()).limit(5).all()
    
    return render_template("jastipper_dashboard.html",
                         stats=stats,
                         recent_products=recent_products,
                         recent_orders=jastipper_orders[:5])


# ================================================
# JASTIPPER ROUTES - Product Management
# ================================================

@main.route("/jastipper/products")
@login_required
def jastipper_products():
    """Daftar produk milik jastipper"""
    if not hasattr(current_user, "product_requests"):
        flash("Hanya jastipper yang dapat mengakses halaman ini.", "danger")
        return redirect(url_for("main.index"))
    
    products = current_user.product_requests.order_by(ProductRequest.created_at.desc()).all()
    return render_template("jastipper_products.html", products=products)


@main.route("/jastipper/create_request", methods=["GET", "POST"])
@login_required
def create_request():
    """Tambah produk baru"""
    if not hasattr(current_user, "product_requests"):
        flash("Hanya jastipper yang dapat mengunggah permintaan.", "danger")
        return redirect(url_for("main.index"))
    
    if request.method == "POST":
        item_name = request.form.get("item_name")
        desc = request.form.get("description")
        category = request.form.get("category")
        base_price = request.form.get("base_price")
        fee_percent = int(request.form.get("fee_percent", 10))
        
        image_url = None
        if 'image' in request.files:
            file = request.files['image']
            if file and file.filename != '' and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                timestamp = datetime.now().strftime('%Y%m%d_%H%M%S_')
                filename = timestamp + filename
                filepath = os.path.join(UPLOAD_FOLDER, filename)
                file.save(filepath)
                image_url = f'/static/uploads/{filename}'
        
        pr = ProductRequest(
            item_name=item_name,
            description=desc,
            category=category,
            base_price=base_price,
            fee_percent=fee_percent,
            image_url=image_url,
            jastipper_id=current_user.id
        )
        
        db.session.add(pr)
        db.session.commit()
        
        flash("Product request berhasil dibuat.", "success")
        return redirect(url_for("main.jastipper_products"))
    
    return render_template("create_request.html")


@main.route("/jastipper/product/edit/<int:product_id>", methods=["GET", "POST"])
@login_required
def edit_product(product_id):
    """Edit produk"""
    if not hasattr(current_user, "product_requests"):
        flash("Hanya jastipper yang dapat mengakses halaman ini.", "danger")
        return redirect(url_for("main.index"))
    
    product = ProductRequest.query.get_or_404(product_id)
    
    if product.jastipper_id != current_user.id:
        flash("Anda tidak memiliki akses untuk mengedit produk ini.", "danger")
        return redirect(url_for("main.jastipper_products"))
    
    if request.method == "POST":
        product.item_name = request.form.get("item_name")
        product.description = request.form.get("description")
        product.category = request.form.get("category")
        product.base_price = request.form.get("base_price")
        product.fee_percent = int(request.form.get("fee_percent", 10))
        
        if 'image' in request.files:
            file = request.files['image']
            if file and file.filename != '' and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                timestamp = datetime.now().strftime('%Y%m%d_%H%M%S_')
                filename = timestamp + filename
                filepath = os.path.join(UPLOAD_FOLDER, filename)
                file.save(filepath)
                product.image_url = f'/static/uploads/{filename}'
        
        db.session.commit()
        flash("Produk berhasil diupdate!", "success")
        return redirect(url_for("main.jastipper_products"))
    
    return render_template("edit_product.html", product=product)


@main.route("/jastipper/product/delete/<int:product_id>", methods=["POST"])
@login_required
def delete_product(product_id):
    """Delete produk"""
    if not hasattr(current_user, "product_requests"):
        flash("Hanya jastipper yang dapat mengakses halaman ini.", "danger")
        return redirect(url_for("main.index"))
    
    product = ProductRequest.query.get_or_404(product_id)
    
    if product.jastipper_id != current_user.id:
        flash("Anda tidak memiliki akses untuk menghapus produk ini.", "danger")
        return redirect(url_for("main.jastipper_products"))
    
    active_orders = Order.query.filter_by(product_request_id=product_id).filter(
        Order.status.notin_(['Completed', 'Cancelled'])
    ).count()
    
    if active_orders > 0:
        flash(f"Produk tidak dapat dihapus karena masih ada {active_orders} pesanan aktif!", "danger")
        return redirect(url_for("main.jastipper_products"))
    
    db.session.delete(product)
    db.session.commit()
    
    flash("Produk berhasil dihapus!", "success")
    return redirect(url_for("main.jastipper_products"))


# ================================================
# JASTIPPER ROUTES - Order Management
# ================================================

@main.route("/jastipper/orders")
@login_required
def jastipper_orders():
    """Kelola pesanan dengan filter"""
    if not hasattr(current_user, "product_requests"):
        flash("Hanya jastipper yang dapat mengakses halaman ini.", "danger")
        return redirect(url_for("main.index"))
    
    status_filter = request.args.get("status", "all")
    payment_filter = request.args.get("payment", "all")
    
    orders = Order.query.join(ProductRequest).filter(
        ProductRequest.jastipper_id == current_user.id
    ).order_by(Order.created_at.desc())
    
    if status_filter != "all":
        orders = orders.filter(Order.status == status_filter)
    
    if payment_filter == "unverified":
        orders = orders.filter(
            Order.payment_proof_url.isnot(None),
            Order.payment_verified == False,
            Order.status == 'Pending'
        )
    
    orders = orders.all()
    
    return render_template("jastipper_orders.html",
                         orders=orders,
                         status_filter=status_filter,
                         payment_filter=payment_filter)


@main.route("/jastipper/order/verify_payment/<int:order_id>", methods=["POST"])
@login_required
def verify_payment(order_id):
    """Verifikasi bukti pembayaran"""
    if not hasattr(current_user, "product_requests"):
        flash("Hanya jastipper yang dapat mengakses halaman ini.", "danger")
        return redirect(url_for("main.index"))
    
    order = Order.query.get_or_404(order_id)
    
    if order.product_request.jastipper_id != current_user.id:
        flash("Anda tidak memiliki akses untuk order ini.", "danger")
        return redirect(url_for("main.jastipper_orders"))
    
    if not order.payment_proof_url:
        flash("Belum ada bukti pembayaran yang diupload.", "warning")
        return redirect(url_for("main.jastipper_orders"))
    
    order.payment_verified = True
    order.status = "Paid"
    order.updated_at = jakarta_now()
    db.session.commit()
    
    flash(f"Pembayaran order #{order.id} berhasil diverifikasi!", "success")
    return redirect(url_for("main.jastipper_orders"))


@main.route("/jastipper/order/reject_payment/<int:order_id>", methods=["POST"])
@login_required
def reject_payment(order_id):
    """Tolak bukti pembayaran"""
    if not hasattr(current_user, "product_requests"):
        flash("Hanya jastipper yang dapat mengakses halaman ini.", "danger")
        return redirect(url_for("main.index"))
    
    order = Order.query.get_or_404(order_id)
    
    if order.product_request.jastipper_id != current_user.id:
        flash("Anda tidak memiliki akses untuk order ini.", "danger")
        return redirect(url_for("main.jastipper_orders"))
    
    order.payment_proof_url = None
    order.payment_verified = False
    order.payment_uploaded_at = None
    order.updated_at = jakarta_now()
    db.session.commit()
    
    flash(f"Bukti pembayaran order #{order.id} ditolak. Buyer harus upload ulang.", "info")
    return redirect(url_for("main.jastipper_orders"))


@main.route("/jastipper/order/update/<int:order_id>", methods=["POST"])
@login_required
def update_order_status(order_id):
    """Update status order dengan shipping info"""
    if not hasattr(current_user, "product_requests"):
        flash("Hanya jastipper yang dapat mengakses halaman ini.", "danger")
        return redirect(url_for("main.index"))
    
    order = Order.query.get_or_404(order_id)
    
    if order.product_request.jastipper_id != current_user.id:
        flash("Anda tidak memiliki akses untuk order ini.", "danger")
        return redirect(url_for("main.jastipper_orders"))
    
    new_status = request.form.get("status")
    
    if new_status == "Cancelled":
        cancel_reason = request.form.get("cancel_reason")
        if not cancel_reason:
            flash("Alasan pembatalan harus diisi!", "danger")
            return redirect(url_for("main.jastipper_orders"))
        order.cancel_reason = cancel_reason
    
    elif new_status == "Shipped":
        courier = request.form.get("courier")
        tracking_number = request.form.get("tracking_number")
        if not courier or not tracking_number:
            flash("Nama kurir dan nomor resi harus diisi untuk status Shipped!", "danger")
            return redirect(url_for("main.jastipper_orders"))
        order.shipping_courier = courier
        order.tracking_number = tracking_number
    
    order.status = new_status
    order.updated_at = jakarta_now()
    db.session.commit()
    
    flash(f"Status order #{order.id} berhasil diupdate menjadi {new_status}!", "success")
    return redirect(url_for("main.jastipper_orders"))

