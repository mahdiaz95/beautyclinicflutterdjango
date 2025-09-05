from pathlib import Path
from datetime import timedelta
from django.utils.translation import gettext_lazy as _
from botocore.client import Config
from PIL import Image
import os
from decouple import config, Csv
BASE_DIR = Path(__file__).resolve().parent.parent
SECRET_KEY = config('SECRET_KEY')
DEBUG = config('DEBUG', default=False, cast=bool)
APP_VERSION = config('APP_VERSION')

ALLOWED_HOSTS = config('ALLOWED_HOSTS', cast=Csv())

MINIO_SERVER_URL = config("MINIO_SERVER_URL")
MINIO_ACCESS_KEY = config("MINIO_ACCESS_KEY")
MINIO_SECRET_KEY = config("MINIO_SECRET_KEY")
MINIO_BUCKET_NAME = config("MINIO_BUCKET_NAME")

AWS_ACCESS_KEY_ID = MINIO_ACCESS_KEY 
AWS_SECRET_ACCESS_KEY = MINIO_SECRET_KEY
AWS_STORAGE_BUCKET_NAME = MINIO_BUCKET_NAME
AWS_S3_ENDPOINT_URL = MINIO_SERVER_URL


UPGRADE_REQUIRED_MESSAGE=_('https://www.google.com/parla/v2')


ALGORITHM = 'HS256'  

DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'

INSTALLED_APPS = [    
    'admin_interface',
    'colorfield',
    'django_dynamic_admin_forms',
    'nested_admin',
    "django_admin_contexts",
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'jalali_date',
    'rest_framework',
    'rest_framework.authtoken',
    'djoser',
    'storages',
    'rest_framework_simplejwt', 
    'django_ckeditor_5',
    'crm',    
]


MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'django.middleware.locale.LocaleMiddleware',
    "django.middleware.common.CommonMiddleware",
    
]
CKEDITOR_UPLOAD_PATH = "uploads/"
CKEDITOR_RESTRICT_BY_USER = True
CKEDITOR_IMAGE_BACKEND = "pillow"
CKEDITOR_ALLOW_NONIMAGE_FILES = False

DATA_UPLOAD_MAX_MEMORY_SIZE = 2 * 1024 * 1024  
FILE_UPLOAD_MAX_MEMORY_SIZE = 2 * 1024 * 1024  
STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')

CKEDITOR_5_CONFIGS = {
    'default': {
        'toolbar': [
            'heading', '|',
            'bold', 'italic', 'link', 'bulletedList', 'numberedList', '|',
            'outdent', 'indent', '|',
            'blockQuote', 'insertTable', 'mediaEmbed', '|',
            'undo', 'redo', '|',
            'imageUpload', 'fileUpload', 
        ],
        'image': {
            'toolbar': [
                'imageTextAlternative', 'imageStyle:full', 'imageStyle:side',
                'imageStyle:alignLeft', 'imageStyle:alignCenter', 'imageStyle:alignRight'
            ],
            'styles': ['full', 'side', 'alignLeft', 'alignRight', 'alignCenter']
        },
        'table': {
            'contentToolbar': [
                'tableColumn', 'tableRow', 'mergeTableCells'
            ]
        },
        'language': 'fa',
        'height': 300,
        'width': '100%',
    }
}


CKEDITOR_5_FILE_UPLOAD_PERMISSION = 'authenticated'  
CKEDITOR_5_ALLOW_ALL_FILE_TYPES = False

MEDIA_URL = "https://storage.parlabeautyclinic.ir/"



ROOT_URLCONF = 'atlas.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'atlas.wsgi.application'
AUTH_USER_MODEL = 'crm.CustomUser'




DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': config("DATABASE_NAME"),
        'USER': config("DATABASE_USER"),
        'PASSWORD': config("DATABASE_PASSWORD"),
        'HOST': config("DATABASE_HOST"),
        'PORT': config("DATABASE_PORT", cast=int),
    }
}



AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]






DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
INTERNAL_IPS=[
    '127.0.0.1'
]
LANGUAGES = [
    ('fa', 'Persian'),
    
]
LANGUAGE_CODE = 'fa'
STATIC_URL = '/static/'
TIME_ZONE = 'Asia/Tehran'
USE_I18N = True
USE_TZ = True
USE_L10N = True

REST_FRAMEWORK = {
    'DEFAULT_RENDERER_CLASSES': [
        'rest_framework.renderers.JSONRenderer',
        'rest_framework.renderers.BrowsableAPIRenderer',
    ],
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'crm.authentication.AppVersionJWTAuthentication',
    ],
    'DEFAULT_THROTTLE_CLASSES': [
        'rest_framework.throttling.AnonRateThrottle',
    ],
    'DEFAULT_THROTTLE_RATES': {
        'anon': '5/hour',
        'promotion': '10/hour',  
        'transaction': '10/hour',
        'service': '10/hour',
        'maghalat': '10/hour',
        'invite': '10/hour',
        'personnel':'10/hour',
        'faq':'10/hour',
        'Portfolio':'10/hour',
        'servicesavailable':'10/hour',
    }
}


CKEDITOR_5_FILE_STORAGE = "storages.backends.s3boto3.S3Boto3Storage"



STORAGES = {
    "default": {
        "BACKEND": "storages.backends.s3boto3.S3Boto3Storage",
        "OPTIONS": {
            "access_key": MINIO_ACCESS_KEY,
            "secret_key": MINIO_SECRET_KEY,
            "endpoint_url": MINIO_SERVER_URL, 
            "bucket_name": MINIO_BUCKET_NAME,
             "querystring_auth": False, 
             
        },
    },
    "staticfiles": {
        "BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage",
    },
}


SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(days=1),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=1),
    'ALGORITHM': 'HS256',
    'SIGNING_KEY': SECRET_KEY,
    'AUTH_HEADER_TYPES': ('Bearer',),
    'TOKEN_OBTAIN_SERIALIZER': 'crm.serializers.MyTokenObtainPairSerializer',
}
JALALI_SETTINGS = {
    "ADMIN_JS_STATIC_FILES": [
        "admin/jquery.ui.datepicker.jalali/scripts/jquery-1.10.2.min.js",
        "admin/jquery.ui.datepicker.jalali/scripts/jquery.ui.core.js",
        "admin/jquery.ui.datepicker.jalali/scripts/jquery.ui.datepicker-cc.js",
        "admin/jquery.ui.datepicker.jalali/scripts/calendar.js",
        "admin/jquery.ui.datepicker.jalali/scripts/jquery.ui.datepicker-cc-fa.js",
        "admin/main.js",
    ],

    "ADMIN_CSS_STATIC_FILES": {
        "all": [
            "admin/jquery.ui.datepicker.jalali/themes/base/jquery-ui.min.css",
            "admin/css/main.css",
        ]
    },
}
JALALI_DATE_DEFAULTS = {
    'LIST_DISPLAY_AUTO_CONVERT': True,  
    'Strftime': {
        'date': '%y/%m/%d', 
        'datetime': '%y/%m/%d %H:%M:%S', 
    },
}
