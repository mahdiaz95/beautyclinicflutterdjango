from rest_framework import serializers
from django.conf import settings
from django.contrib.auth import get_user_model
from crm.models import Promotion, Transaction
from .exceptions import UpgradeRequired
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import Maghalat, FAQ, FAQCategory,InviteRequest,ServiceAvaiable,Personnel,Portfolio,ServiceAvaiabledetail
APP_VERSION = settings.APP_VERSION
User = get_user_model()
class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        
        self.fields['version'] = serializers.CharField(required=True)

    def validate(self, attrs):
        
        version = attrs['version']
        
        if version != settings.APP_VERSION:
            raise UpgradeRequired()
        
        del attrs['version']
        return super().validate(attrs)

    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        token['version'] = settings.APP_VERSION
        return token
    
class UserSerializer(serializers.ModelSerializer):
    referrer = serializers.SerializerMethodField()
    referrals = serializers.SerializerMethodField()
    def get_referrer(self, obj):
        if obj.referrer:
            return f"{obj.referrer.first_name} {obj.referrer.last_name}"
        return None
    def get_referrals(self, obj):
        referrals = obj.referrals.all()
        return [ f"{referral.first_name} {referral.last_name}" for referral in referrals]
    class Meta:
        model = User
        fields = [
            'id', 'username', 'email', 'first_name', 'last_name',
            'is_active', 'is_staff', 'is_superuser', 'last_login', 'date_joined',
            'codemeli', 'phone_number', 'city', 'birth_date', 'job',
            'sex', 'referral_code', 'referrer', 'referrals'
        ]


class TransactionSerializer(serializers.ModelSerializer):
    transaction_type_display = serializers.CharField(source='get_transaction_type_display', read_only=True)

    class Meta:
        model = Transaction
        fields = [
            'id',
            'transaction_type',
            'transaction_type_display',
            'amount',
            'description',
            'created_at',
        ]

class WalletWithTransactionsSerializer(serializers.Serializer):
    balance = serializers.DecimalField(max_digits=12, decimal_places=0)
    transactions = TransactionSerializer(many=True)



from rest_framework import serializers
from .models import Service
class PromotionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Promotion
        fields = ['id', 'media_type', 'file', 'caption', 'created_at']
class PortfolioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Portfolio
        fields = ['id','title', 'media_type', 'media', 'description', 'created_at']
class ServiceSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.name', read_only=True)

    class Meta:
        model = Service
        fields = [
            'id',
            'user',
            'category',
            'category_name',
            'price',
            'description',
            'created_at',
        ]
class MaghalatPreviewSerializer(serializers.ModelSerializer):
    category = serializers.CharField(source='category.name')

    class Meta:
        model = Maghalat
        fields = ['id', 'title', 'category', 'created_at', 'preview_image', 'preview_text']


class MaghalatDetailSerializer(serializers.ModelSerializer):
    category = serializers.CharField(source='category.name')

    class Meta:
        model = Maghalat
        fields = ['id', 'title', 'category', 'created_at', 'content']

class FAQSerializer(serializers.ModelSerializer):
    class Meta:
        model = FAQ
        fields = ['id', 'question', 'answer']

class FAQCategorySerializer(serializers.ModelSerializer):
    faqs = FAQSerializer(many=True)

    class Meta:
        model = FAQCategory
        fields = ['id', 'name', 'faqs']
class InviteRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = InviteRequest
        fields = [
            'id', 'first_name', 'last_name', 'email',
            'phone', 'status', 'created_at'
        ]
        read_only_fields = ['status', 'created_at']

    def validate(self, attrs):
        user = self.context['request'].user
        pending_count = InviteRequest.objects.filter(
            inviter=user, status='pending'
        ).count()
        if pending_count >= 2:
            raise serializers.ValidationError(
                "شما هم‌اکنون دو دعوت در انتظار دارید. لطفاً تا تکمیل آن‌ها صبر کنید."
            )
        return attrs

    def create(self, validated_data):
        
        validated_data['inviter'] = self.context['request'].user
        return super().create(validated_data)

class PersonnelSerializer(serializers.ModelSerializer):
    class Meta:
        model = Personnel
        fields = [
            'id',
            'name',
            'occupation',
            'photo',
            'bio',
            'email',
            'phone',
            'priority',
            'created_at',
            'updated_at',
        ]
        read_only_fields = ['created_at', 'updated_at']

class ServiceAvaiableSerializer(serializers.ModelSerializer):
    class Meta:
        model = ServiceAvaiable
        fields = ['id', 'name', 'description', 'photo', 'category', 'is_active', 'created_at']
class ServiceAvaiableDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = ServiceAvaiabledetail
        fields = ['id', 'name', 'description', 'photo', 'category', 'is_active', 'created_at']