from django.contrib import admin
from django.utils.html import format_html
from .models import (
    CustomUser, Wallet, Category, Service,
    Transaction, Promotion, Portfolio
)
from django.contrib import admin
from .models import Maghalat , FAQCategory, FAQ, InviteRequest,Personnel, ServiceAvaiable,ServiceAvaiabledetail
from django.core.exceptions import ObjectDoesNotExist
from .models import CustomUser
from django.contrib.auth.admin import UserAdmin
from django.utils.translation import gettext_lazy as _
from django.contrib import admin, messages
@admin.action(description=_("ایجاد کیف پول برای کاربران انتخاب شده"))
def create_wallets(modeladmin, request, queryset):
    created_count = 0
    for user in queryset:
        try:
            _ = user.wallet  
        except ObjectDoesNotExist:
            Wallet.objects.create(user=user)
            created_count += 1
    if created_count:
        messages.success(request, _("%d تعداد ولت ایجاد شد" % created_count))
    else:
        messages.info(request, _("کاربران انتخاب شده قبلا ولت دارند."))
@admin.register(CustomUser)
class CustomUserAdmin(UserAdmin):
    list_display = [
        'username', 'phone_number', 'codemeli', 'referral_code', 'referrer', 'sex', 'marriage', 'city', 'birth_date', 'job'
    ]
    list_filter = ['sex', 'city', 'marriage']
    search_fields = ['username', 'first_name', 'last_name', 'codemeli', 'phone_number', 'referral_code']
    readonly_fields = ['referral_code']

    fieldsets = (
        (None, {
            'fields': ('username', 'password')
        }),
        (_('اطلاعات شخصی'), {
            'fields': ('first_name', 'last_name', 'codemeli', 'phone_number', 'father_name', 'phone_numbersecond', 'phone_numbersabet', 'birth_date', 'job', 'sex', 'city', 'marriage', 'nahve_ashnaii')
        }),
        (_('ارجاع'), {
            'fields': ('referral_code', 'referrer')
        }),
        (_('دسترسی‌ها'), {
            'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')
        }),
    )

    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'phone_number', 'codemeli', 'password1', 'password2'),
        }),
    )

    
    form = UserAdmin.form
    add_form = UserAdmin.add_form
    actions = [create_wallets]


@admin.register(Wallet)
class WalletAdmin(admin.ModelAdmin):
    list_display = ['user', 'balance']
    search_fields = ['user__username', 'user__phone_number']
    readonly_fields = ['user']

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name']
    search_fields = ['name']

@admin.register(Service)
class ServiceAdmin(admin.ModelAdmin):
    list_display = ['user_full_name', 'category', 'price', 'commission_percent', 'description', 'created_at']
    list_filter = ['category', 'created_at']
    search_fields = ['user__username', 'user__first_name', 'user__last_name', 'category__name']
    readonly_fields = ['created_at']
    autocomplete_fields = ['user']

    @admin.display(ordering='user__first_name', description='User Full Name')
    def user_full_name(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}"

@admin.register(Transaction)
class TransactionAdmin(admin.ModelAdmin):
    list_display = ['user_full_name', 'transaction_type', 'amount', 'created_at', 'description']
    list_filter = ['transaction_type', 'created_at']
    search_fields = ['user__username', 'user__first_name', 'user__last_name', 'description']
    readonly_fields = ['created_at']
    autocomplete_fields = ['user']

    @admin.display(ordering='user__first_name', description='User Full Name')
    def user_full_name(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}"

@admin.register(Promotion)
class PromotionAdmin(admin.ModelAdmin):
    list_display = ['media_type', 'caption_snippet', 'created_at']
    search_fields = ['caption']
    readonly_fields = ['created_at']

    def caption_snippet(self, obj):
        return obj.caption[:40]
    caption_snippet.short_description = "پیش‌نمایش توضیح"

@admin.register(Portfolio)
class PortfolioAdmin(admin.ModelAdmin):
    list_display = ['title', 'created_at', 'preview_media']
    search_fields = ['title', 'description']
    readonly_fields = ['created_at']

    def preview_media(self, obj):
        if obj.media.name.lower().endswith(('.jpg', '.jpeg', '.png')):
            return format_html('<img src="{}" width="100" />', obj.media.url)
        elif obj.media.name.lower().endswith('.mp4'):
            return "ویدیو"
        return "نامشخص"
    preview_media.short_description = "پیش‌نمایش"
@admin.register(Maghalat)
class ArticleAdmin(admin.ModelAdmin):
    list_display = ('title',) 
    search_fields = ('title', 'content')  
    list_filter = ('title',)  

@admin.register(FAQCategory)
class FAQCategoryAdmin(admin.ModelAdmin):
    list_display = ['id', 'name']

@admin.register(FAQ)
class FAQAdmin(admin.ModelAdmin):
    list_display = ['id', 'question', 'category']
    search_fields = ['question', 'answer']
    list_filter = ['category']

@admin.register(InviteRequest)
class InviteRequestAdmin(admin.ModelAdmin):
    list_display = (
        'inviter',
        'first_name',
        'last_name',
        'email',
        'phone',
        'status',
        'created_at',
    )
    list_filter = (
        'status',
        'created_at',
    )
    search_fields = (
        'inviter__username',
        'first_name',
        'last_name',
        'email',
        'phone',
    )
    readonly_fields = (
        'created_at',
    )
    fieldsets = (
        (None, {
            'fields': (
                'inviter',
                ('first_name', 'last_name'),
                'email',
                'phone',
                'status',
            )
        }),
        ('Metadata', {
            'fields': ('created_at',),
            'classes': ('collapse',),
        }),
    )
    ordering = ('-created_at',)

@admin.register(Personnel)
class PersonnelAdmin(admin.ModelAdmin):
    list_display = ('name', 'priority', 'occupation', 'email', 'phone', 'created_at')
    list_display_links = ('name',) 
    list_editable = ('priority',) 
    list_filter = ('occupation',)
    search_fields = ('name', 'occupation', 'email', 'phone')
    readonly_fields = ('created_at', 'updated_at')

    fieldsets = (
        (None, {
            'fields': (
                'priority',
                'name',
                'occupation',
                'photo',
                'bio',
            )
        }),
        ("اطلاعات تماس", {
            'fields': ('email', 'phone'),
            'classes': ('collapse',),
        }),
        ("تاریخ‌ها", {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',),
        }),
    )

    ordering = ('priority', '-created_at')

@admin.register(ServiceAvaiable)
class ServiceAvaiableAdmin(admin.ModelAdmin):
    list_display = ['name', 'category', 'is_active', 'created_at']
    list_filter = ['is_active', 'category']
    search_fields = ['name', 'description']
@admin.register(ServiceAvaiabledetail)
class ServiceAvaiabledetailAdmin(admin.ModelAdmin):
    list_display = ['name','category', 'is_active', 'created_at']
    list_filter = ['is_active', 'category']
