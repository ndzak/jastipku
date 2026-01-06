# config.py
import os

class Config:
    SECRET_KEY = "PaKGiriPbo"
    
    SQLALCHEMY_DATABASE_URI = "mysql+pymysql://root:@127.0.0.1:3306/jastip_app"
    
    SQLALCHEMY_TRACK_MODIFICATIONS = False
