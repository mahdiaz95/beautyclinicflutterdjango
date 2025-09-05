from django.conf import settings
from django.db import models
from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _
from decimal import Decimal
import uuid
from django.db.models.signals import pre_save
from django.core.exceptions import ObjectDoesNotExist
from django.core.exceptions import ValidationError
from django_ckeditor_5.fields import CKEditor5Field
def generate_referral_code():
    code = uuid.uuid4().hex[:10]
    return code
SEX_CHOICES = (
    ('male', _("مرد")),
    ('female', _("زن")),)
MARRIAGE_CHOICES = (
    ('married', _("متاهل")),
    ('single', _("مجرد")),)
class CustomUser(AbstractUser):
    codemeli=models.CharField(max_length=10, unique=True, verbose_name=_("کد ملی"))
    phone_number = models.CharField(max_length=15, unique=True, verbose_name=_("شماره تلفن"))
    parvande_number = models.CharField(max_length=15,blank=True, null=True,  verbose_name=_("شماره پرونده"))
    father_name=models.CharField(max_length=15,blank=True,null=True, verbose_name=_("اسم پدر"))
    nahve_ashnaii=models.CharField(max_length=15,blank=True, unique=False, verbose_name=_(" نحوه آشنایی"))
    phone_numbersecond = models.CharField(max_length=15,blank=True,  verbose_name=_("دوم شماره تلفن"))
    phone_numbersabet = models.CharField(max_length=15,blank=True,  verbose_name=_("شماره تلفن ثابت"))
    marriage=models.CharField(max_length=10, choices=MARRIAGE_CHOICES, blank=True, null=True, verbose_name=_("تاهل"))
    city=models.CharField(max_length=100, blank=True, null=True, verbose_name=_("شهر"))
    birth_date=models.DateField(blank=True, null=True, verbose_name=_("تاریخ تولد"))
    job=models.CharField(max_length=100, blank=True, null=True, verbose_name=_("شغل"))
    sex = models.CharField(max_length=10, choices=SEX_CHOICES, blank=True, null=True, verbose_name=_("جنسیت"))
    referral_code = models.CharField(max_length=10, unique=True, default=generate_referral_code, verbose_name=_("کد رفرال"))
    referrer = models.ForeignKey('self', on_delete=models.SET_NULL, null=True, blank=True, related_name="referrals", verbose_name=_("معرف"))
    
    def __str__(self):
        return self.username

    class Meta:
        verbose_name = _("کاربر")
        verbose_name_plural = _("کاربران")

class Wallet(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, verbose_name=_("کاربر"))
    balance = models.DecimalField(max_digits=12, decimal_places=0, default=0.00, verbose_name=_("موجودی"))

    def __str__(self):
        return f"کیف پول {self.user.username} - {format(self.balance, ',')} تومان"


    class Meta:
        verbose_name = _("کیف پول")
        verbose_name_plural = _("کیف پول‌ها")

@receiver(post_save, sender=CustomUser)
def create_user_wallet(sender, instance, created, **kwargs):
    if created:
        Wallet.objects.create(user=instance)

class Category(models.Model):
    name = models.CharField(max_length=100, unique=True, verbose_name=_("نام دسته‌بندی"))

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = _("دسته‌بندی خدمات")
        verbose_name_plural = _("دسته‌بندی‌های خدمات")

class Service(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, verbose_name=_("کاربر"))
    category = models.ForeignKey(Category, on_delete=models.CASCADE, verbose_name=_("دسته‌بندی"))
    price = models.DecimalField(max_digits=10, decimal_places=0, verbose_name=_("مبلغ خدمت"))
    commission_percent = models.DecimalField(
        max_digits=2, decimal_places=0, verbose_name=_("درصد پورسانت خدمت"),
        help_text=_("مثلاً 20 برای ۲۰٪")
    )
    description = models.TextField(blank=True, null=True, verbose_name=_("توضیحات"))
    created_at = models.DateTimeField(auto_now_add=True, verbose_name=_("تاریخ ثبت"))

    def __str__(self):
        return f"{self.category.name} برای {self.user.username} - {format(self.price, ',')} تومان"


    class Meta:
        verbose_name = _("خدمت")
        verbose_name_plural = _("خدمات")



class TransactionType(models.TextChoices):
    DEPOSIT = 'deposit', _("واریز")
    WITHDRAWAL = 'withdrawal', _("برداشت")


class Transaction(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, verbose_name=_("کاربر"))
    transaction_type = models.CharField(max_length=10, choices=TransactionType.choices, verbose_name=_("نوع تراکنش"))
    amount = models.DecimalField(max_digits=10, decimal_places=0, verbose_name=_("مبلغ"))
    description = models.TextField(blank=True, null=True, verbose_name=_("توضیحات"))
    created_at = models.DateTimeField(auto_now_add=True, verbose_name=_("تاریخ ایجاد"))

    def __str__(self):
        return f"{self.get_transaction_type_display()} - {format(self.amount, ',')} تومان برای {self.user.username}"


    class Meta:
        verbose_name = _("تراکنش مالی")
        verbose_name_plural = _("تراکنش‌های مالی")


@receiver(pre_save, sender=Transaction)
def cache_old_transaction_amount(sender, instance, **kwargs):
    if instance.pk:
        try:
            old_instance = Transaction.objects.get(pk=instance.pk)
            instance._old_amount = old_instance.amount
            instance._old_type = old_instance.transaction_type
        except ObjectDoesNotExist:
            instance._old_amount = None
            instance._old_type = None

@receiver(post_save, sender=Transaction)
def update_wallet_on_save(sender, instance, created, **kwargs):
    wallet = instance.user.wallet

    if created:
       
        if instance.transaction_type == TransactionType.DEPOSIT:
            wallet.balance += instance.amount
        elif instance.transaction_type == TransactionType.WITHDRAWAL:
            wallet.balance -= instance.amount

    else:
     
        old_amount = getattr(instance, '_old_amount', None)
        old_type = getattr(instance, '_old_type', None)

        if old_amount is not None:
           
            if old_type == TransactionType.DEPOSIT:
                wallet.balance -= old_amount
            elif old_type == TransactionType.WITHDRAWAL:
                wallet.balance += old_amount

            
            if instance.transaction_type == TransactionType.DEPOSIT:
                wallet.balance += instance.amount
            elif instance.transaction_type == TransactionType.WITHDRAWAL:
                wallet.balance -= instance.amount

    wallet.save()


@receiver(post_delete, sender=Transaction)
def update_wallet_on_delete(sender, instance, **kwargs):
    try:
        wallet = instance.user.wallet
        if instance.transaction_type == TransactionType.DEPOSIT:
            wallet.balance -= instance.amount
        elif instance.transaction_type == TransactionType.WITHDRAWAL:
            wallet.balance += instance.amount
        wallet.save()
    except ObjectDoesNotExist:
        return

    
@receiver(post_save, sender=Service)
def create_transactions_on_service_creation(sender, instance, created, **kwargs):
    if not created:
        return

    user = instance.user
    price = instance.price
    description = f"پرداخت بابت خدمت {instance.category.name}"


    Transaction.objects.create(
        user=user,
        transaction_type=TransactionType.WITHDRAWAL,
        amount=price,
        description=description
    )

   
    if user.referrer:
        service_rate = instance.commission_percent / 100 
        commission = price * service_rate

        if commission > 0:
            Transaction.objects.create(
                user=user.referrer,
                transaction_type=TransactionType.DEPOSIT,
                amount=commission,
                description=(
                    f"پورسانت {commission:.0f} تومان برای خدمت {instance.category.name} "
                    f"ثبت‌شده توسط {user.first_name} {user.last_name} "
                    f"درصد کمیسیون: {service_rate * 100:.0f}%"
                )
            )


def validate_media_file_size(file):
    valid_extensions = ['.jpg', '.jpeg', '.png', '.mp4']

    ext = os.path.splitext(file.name)[1].lower()
    if ext not in valid_extensions:
        raise ValidationError("فقط فایل‌های jpg، png و mp4 مجاز هستند.")

class Promotion(models.Model):
    MEDIA_TYPES = (
        ('image', 'تصویر'),
        ('video', 'ویدیو'),
    )

    media_type = models.CharField(max_length=10, choices=MEDIA_TYPES, verbose_name=_("نوع رسانه"))
    file = models.FileField(upload_to='promotions/', validators=[validate_media_file_size], verbose_name=_("فایل"))
    caption = models.TextField(blank=False,null=False,verbose_name=_("توضیحات"))
    created_at = models.DateTimeField(auto_now_add=True, verbose_name=_("تاریخ ایجاد"))

    def __str__(self):
        return f"{self.caption[:30]}..."

    class Meta:
        verbose_name = _("تخفیف")
        verbose_name_plural = _("تخفیف‌ها")
        ordering = ['-created_at']

import os
from django.core.exceptions import ValidationError

def validate_portfolio_file(file):
    valid_extensions = ['.jpg', '.jpeg', '.png', '.mp4']

    ext = os.path.splitext(file.name)[1].lower()
    if ext not in valid_extensions:
        raise ValidationError("فقط فایل‌های jpg، png و mp4 مجاز هستند.")


class Portfolio(models.Model):
    MEDIA_TYPES = (
        ('image', 'تصویر'),
        ('video', 'ویدیو'),
    )
    title = models.CharField(max_length=255, verbose_name=_("عنوان"))
    
    media_type = models.CharField(max_length=10, choices=MEDIA_TYPES, verbose_name=_("نوع رسانه"))
    description = models.TextField(blank=True, null=True, verbose_name=_("توضیحات"))
    media = models.FileField(upload_to='portfolio/', validators=[validate_portfolio_file], verbose_name=_("فایل نمونه‌کار"))
    created_at = models.DateTimeField(auto_now_add=True, verbose_name=_("تاریخ ثبت"))

    def __str__(self):
        return f"نمونه‌کار: {self.title}"

    class Meta:
        verbose_name = _("نمونه‌کار")
        verbose_name_plural = _("نمونه‌کارها")
    ordering = ['-created_at']



class Maghalat(models.Model):
    title = models.CharField(max_length=200, verbose_name=_("عنوان"))
    slug = models.SlugField(unique=True, blank=True, verbose_name=_("اسلاگ مقاله"))
    category = models.ForeignKey(Category, on_delete=models.CASCADE, verbose_name=_("دسته‌بندی"), related_name='articles')
    
    preview_text = models.TextField(verbose_name=_("خلاصه/پیش‌نمایش"))
    preview_image = models.ImageField(upload_to='maghalat/previews/', verbose_name=_("تصویر پیش‌نمایش"), null=True, blank=True)
    
    content = CKEditor5Field(config_name='default')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name=_("تاریخ ثبت"))

    class Meta:
        verbose_name = _("مقاله")
        verbose_name_plural = _("مقالات")
        ordering = ['-created_at']

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)

    def __str__(self):
        return self.title
class FAQCategory(models.Model):
    name = models.CharField(max_length=100, verbose_name=_("دسته‌بندی"))

    def __str__(self):
        return self.name
    class Meta:
        verbose_name = _(" دسته‌بندی سوالات متداول")
        verbose_name_plural = _("دسته‌بندی‌های سوالات متداول")
        
class FAQ(models.Model):
    category = models.ForeignKey(FAQCategory, on_delete=models.CASCADE, related_name='faqs', verbose_name=_("دسته‌بندی"))
    question = models.CharField(max_length=512, verbose_name=_("سؤال"))
    answer = models.TextField(verbose_name=_("پاسخ"))

    def __str__(self):
        return f"{self.question[:50]}"
    class Meta:
        verbose_name = _(" سوال متداول")
        verbose_name_plural = _("سوالات متداول")
class InviteRequest(models.Model):
    STATUS_CHOICES = [
        ('pending',   _('در انتظار')),
        ('rejected', _('ریجکت شده')),
        ('accepted', _('پذیرفته شده')),
    ]

    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False
    )
    inviter = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='invites',
        verbose_name=_("دعوت‌کننده")
    )

    first_name = models.CharField(
        max_length=30,
        verbose_name=_("نام")
    )
    last_name = models.CharField(
        max_length=30,
        verbose_name=_("نام خانوادگی")
    )
    email = models.EmailField(
        blank=True, null=True,
        verbose_name=_("ایمیل")
    )
    phone = models.CharField(
        max_length=15,
        verbose_name=_("شماره تلفن")
    )

    status = models.CharField(
        max_length=10,
        choices=STATUS_CHOICES,
        default='pending',
        verbose_name=_("وضعیت")
    )
    created_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name=_("ایجاد شده در")
    )

    class Meta:
        verbose_name = _("درخواست دعوت")
        verbose_name_plural = _("درخواست‌های دعوت")
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.inviter.username} → {self.first_name} {self.last_name} ({self.status})"
def validate_personnel_file(file):
    valid_extensions = ['.jpg', '.jpeg', '.png']

    ext = os.path.splitext(file.name)[1].lower()
    if ext not in valid_extensions:
        raise ValidationError("فقط فایل‌های jpg، png و mp4 مجاز هستند.")

    
class Personnel(models.Model):
    id = models.UUIDField(
        primary_key=True,
        default=uuid.uuid4,
        editable=False
    )
    name = models.CharField(
        max_length=100,
        verbose_name=_("نام و نام خانوادگی")
    )
    occupation = models.CharField(
        max_length=100,
        blank=True,
        verbose_name=_("عنوان شغلی")
    )
    photo = models.ImageField(
        upload_to='personnel_photos/',
     validators=[validate_personnel_file],
        blank=True,
        null=True,
        verbose_name=_("عکس پروفایل")
    )
    bio = models.TextField(
        blank=True,
        verbose_name=_("درباره")
    )
    email = models.EmailField(
        blank=True,
        null=True,
        verbose_name=_("ایمیل")
    )
    phone = models.CharField(
        max_length=20,
        blank=True,
        verbose_name=_("تلفن تماس")
    )
    priority = models.PositiveSmallIntegerField(
        default=0,
        verbose_name=_("اولویت نمایش"),
        help_text=_("ردیف نمایش: هرچه عدد کمتر باشد، زودتر نمایش داده می‌شود.")
    )
    created_at = models.DateTimeField(
        auto_now_add=True,
        verbose_name=_("ایجاد شده در")
    )
    updated_at = models.DateTimeField(
        auto_now=True,
        verbose_name=_("به‌روزرسانی شده در")
    )

    class Meta:
        verbose_name = _("پرسنل")
        verbose_name_plural = _("پرسنل‌ها")
        ordering = ['priority', '-created_at']

    def __str__(self):
        return f"{self.name} ({self.occupation or _('بدون عنوان')})"


def validate_ServiceAvaiable_file(file):
    
    valid_extensions = ['.jpg', '.jpeg', '.png']

    ext = os.path.splitext(file.name)[1].lower()
    if ext not in valid_extensions:
        raise ValidationError("فقط فایل‌های jpg، png و مجاز هستند.")


class ServiceAvaiable(models.Model):
    name = models.CharField(max_length=150, verbose_name=_("نام خدمت"))
    description = models.TextField(blank=True, null=True, verbose_name=_("توضیحات"))
    photo = models.ImageField(upload_to='services/',validators=[validate_ServiceAvaiable_file], verbose_name=_("عکس خدمت"))
    category = models.ForeignKey(
        Category,
        on_delete=models.CASCADE,
        related_name="available_services",
        verbose_name=_("دسته‌بندی")
    )
    is_active = models.BooleanField(default=True, verbose_name=_("فعال است"))
    created_at = models.DateTimeField(auto_now_add=True, verbose_name=_("تاریخ ایجاد"))

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = _("خدمت قابل ارائه")
        verbose_name_plural = _("خدمات قابل ارائه")
class ServiceAvaiabledetail(models.Model):
    name = models.CharField(max_length=150, verbose_name=_("نام خدمت"))
    description = models.TextField(blank=True, null=True, verbose_name=_("توضیحات"))
    photo = models.ImageField(upload_to='services/', null=True, blank=True,validators=[validate_ServiceAvaiable_file] ,verbose_name=_("عکس خدمت"))
    category = models.ForeignKey(
        ServiceAvaiable,
        on_delete=models.CASCADE,
        related_name="available_services",
        verbose_name=_("زیر دسته")
    )
    is_active = models.BooleanField(default=True, verbose_name=_("فعال است"))
    created_at = models.DateTimeField(auto_now_add=True, verbose_name=_("تاریخ ایجاد"))

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = _("خدمت قابل ارائه جزییات")
        verbose_name_plural = _("خدمات قابل ارائه جزییات")

