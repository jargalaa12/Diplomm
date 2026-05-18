from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone
from datetime import timedelta


# =========================
# БАЙРШИЛ
# =========================
class Location(models.Model):
    name = models.CharField(max_length=255, verbose_name="Нэр")
    name_en = models.CharField(max_length=255, blank=True, verbose_name="Англи нэр")
    is_airport = models.BooleanField(default=False, verbose_name="Нисэх буудал эсэх")
    is_active = models.BooleanField(default=True, verbose_name="Идэвхтэй эсэх")

    class Meta:
        verbose_name = "Байршил"
        verbose_name_plural = "Байршлууд"

    def __str__(self):
        return self.name or "Байршил"


# =========================
# НЭМЭЛТ ҮЙЛЧИЛГЭЭ
# =========================
class Amenity(models.Model):
    name = models.CharField(max_length=100, verbose_name="Нэр")
    icon = models.CharField(max_length=100, blank=True, verbose_name="Icon")

    class Meta:
        verbose_name = "Нэмэлт үйлчилгээ"
        verbose_name_plural = "Нэмэлт үйлчилгээнүүд"

    def __str__(self):
        return self.name or "Amenity"


# =========================
# ТЭЭВРИЙН ХЭРЭГСЭЛ
# =========================
class Vehicle(models.Model):

    CATEGORY_CHOICES = [
        ('economy', 'Эдийн засгийн'),
        ('comfort', 'Тав тухтай'),
        ('luxury', 'Тансаг'),
        ('minibus', 'Микро автобус'),
    ]

    name = models.CharField(max_length=255, verbose_name="Нэр")

    category = models.CharField(
        max_length=20,
        choices=CATEGORY_CHOICES,
        default='economy',
        verbose_name="Төрөл"
    )

    price = models.DecimalField(
        max_digits=10,
        decimal_places=0,
        default=0,
        verbose_name="Үнэ (₮)"
    )

    passenger_capacity = models.PositiveIntegerField(
        default=3,
        verbose_name="Хэдэн хүн суух"
    )

    luggage_capacity = models.PositiveIntegerField(
        default=2,
        verbose_name="Ачааны тоо"
    )

    image = models.ImageField(
        upload_to='vehicles/',
        null=True,
        blank=True,
        verbose_name="Зураг"
    )

    amenities = models.ManyToManyField(
        Amenity,
        blank=True,
        verbose_name="Нэмэлт үйлчилгээ"
    )

    is_active = models.BooleanField(default=True, verbose_name="Идэвхтэй эсэх")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Үүсгэсэн огноо")

    class Meta:
        verbose_name = "Тээврийн хэрэгсэл"
        verbose_name_plural = "Тээврийн хэрэгслүүд"

    def __str__(self):
        return f"{self.name} - ₮{self.price}"


# =========================
# ЗАХИАЛГА
# =========================
class Booking(models.Model):

    STATUS_CHOICES = [
        ('pending', 'Хүлээгдэж байна'),
        ('confirmed', 'Баталгаажсан'),
        ('in_progress', 'Явж байна'),
        ('completed', 'Дууссан'),
        ('cancelled', 'Цуцлагдсан'),
    ]

    user = models.ForeignKey(
        User,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='taxi_bookings',
        verbose_name="Хэрэглэгч"
    )

    vehicle = models.ForeignKey(
        Vehicle,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='taxi_bookings',
        verbose_name="Тээврийн хэрэгсэл"
    )

    from_location = models.ForeignKey(
        Location,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='taxi_from',
        verbose_name="Хаанаас"
    )

    to_location = models.ForeignKey(
        Location,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='taxi_to',
        verbose_name="Хаашаа"
    )

    passenger_count = models.PositiveIntegerField(default=1, verbose_name="Зорчигчийн тоо")
    luggage_count = models.PositiveIntegerField(default=0, verbose_name="Ачааны тоо")

    pickup_datetime = models.DateTimeField(verbose_name="Авах цаг")

    total_price = models.DecimalField(
        max_digits=10,
        decimal_places=0,
        default=0,
        verbose_name="Нийт үнэ (₮)"
    )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='pending',
        verbose_name="Төлөв"
    )

    contact_name = models.CharField(max_length=255, verbose_name="Нэр")
    contact_phone = models.CharField(max_length=20, verbose_name="Утас")

    notes = models.TextField(blank=True, verbose_name="Тэмдэглэл")

    can_cancel_before = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name="Цуцлах хугацаа"
    )

    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Үүсгэсэн")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Шинэчилсэн")

    class Meta:
        verbose_name = "Захиалга"
        verbose_name_plural = "Захиалгууд"
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.contact_name or 'Хэрэглэгч'} | {self.from_location} → {self.to_location}"

    def save(self, *args, **kwargs):
        if self.pickup_datetime and not self.can_cancel_before:
            self.can_cancel_before = self.pickup_datetime - timedelta(hours=24)
        super().save(*args, **kwargs)

    @property
    def is_cancellable(self):
        return self.can_cancel_before and timezone.now() < self.can_cancel_before