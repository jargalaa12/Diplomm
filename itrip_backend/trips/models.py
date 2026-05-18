from django.db import models
from django.contrib.auth import get_user_model
from django.core.exceptions import ValidationError

User = get_user_model()


# =========================================================
# TOUR PACKAGE
# =========================================================

class TourPackage(models.Model):

    name = models.CharField(
        "Аяллын нэр",
        max_length=200,
    )

    location = models.CharField(
        "Байршил",
        max_length=200,
    )

    duration = models.PositiveIntegerField(
        "Хугацаа (өдөр)",
    )

    max_people = models.PositiveIntegerField(
        "Хүний дээд тоо",
    )

    guide = models.CharField(
        "Хөтөч",
        max_length=100,
    )

    accommodation = models.CharField(
        "Буудал",
        max_length=200,
    )

    transportation = models.CharField(
        "Тээвэр",
        max_length=200,
    )

    description = models.TextField(
        "Дэлгэрэнгүй мэдээлэл",
    )

    included = models.TextField(
        "Багцад багтсан зүйлс",
    )

    price = models.DecimalField(
        "Суурь үнэ",
        max_digits=10,
        decimal_places=2,
    )

    image = models.ImageField(
        "Зураг",
        upload_to="tour_images/",
        blank=True,
        null=True,
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
    )

    updated_at = models.DateTimeField(
        auto_now=True,
    )

    class Meta:

        verbose_name = "Аялал"

        verbose_name_plural = "Аяллууд"

        ordering = ["-created_at"]

    def __str__(self):

        return (
            f"{self.name} - "
            f"{self.location}"
        )


# =========================================================
# TOUR SCHEDULE
# =========================================================

class TourSchedule(models.Model):

    tour = models.ForeignKey(
        TourPackage,

        on_delete=models.CASCADE,

        related_name="schedules",

        verbose_name="Аялал",
    )

    start_date = models.DateField(
        "Эхлэх огноо",
    )

    end_date = models.DateField(
        "Дуусах огноо",
    )

    price = models.DecimalField(
        "Нэг хүний үнэ",

        max_digits=10,

        decimal_places=2,
    )

    available_seats = (
        models.PositiveIntegerField(
            "Үлдсэн суудал",
            default=0,
        )
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
    )

    class Meta:

        ordering = ["start_date"]

        verbose_name = (
            "Аяллын хуваарь"
        )

        verbose_name_plural = (
            "Аяллын хуваарь"
        )

    def __str__(self):

        return (
            f"{self.tour.name} "
            f"({self.start_date} - "
            f"{self.end_date})"
        )

    def clean(self):

        if (
            self.end_date <
            self.start_date
        ):

            raise ValidationError(
                "Дуусах огноо "
                "эхлэх огнооноос "
                "өмнө байж болохгүй"
            )

        if self.price <= 0:

            raise ValidationError(
                "Үнэ 0-ээс "
                "их байх ёстой"
            )

    def duration_days(self):

        return (
            self.end_date -
            self.start_date
        ).days


# =========================================================
# BOOKING
# =========================================================

class Booking(models.Model):

    # =====================================================
    # STATUS
    # =====================================================

    STATUS_PENDING = "pending"

    STATUS_CONFIRMED = "confirmed"

    STATUS_CANCELLED = "cancelled"

    STATUS_CHOICES = (

        (
            STATUS_PENDING,
            "Хүлээгдэж буй",
        ),

        (
            STATUS_CONFIRMED,
            "Баталгаажсан",
        ),

        (
            STATUS_CANCELLED,
            "Цуцлагдсан",
        ),
    )

    # =====================================================
    # 👤 USER
    # =====================================================

    user = models.ForeignKey(

        User,

        on_delete=models.CASCADE,

        related_name="bookings",

        verbose_name="Хэрэглэгч",
    )

    # =====================================================
    # 🌍 TOUR BOOKING
    # =====================================================

    tour = models.ForeignKey(

        TourPackage,

        on_delete=models.CASCADE,

        related_name="bookings",

        verbose_name="Аялал",

        null=True,
        blank=True,
    )

    schedule = models.ForeignKey(

        TourSchedule,

        on_delete=models.CASCADE,

        related_name="bookings",

        verbose_name="Хуваарь",

        null=True,
        blank=True,
    )

    # =====================================================
    # ✈ FLIGHT BOOKING
    # =====================================================

    flight = models.ForeignKey(

        "flights.Flight",

        on_delete=models.CASCADE,

        related_name="bookings",

        verbose_name="Нислэг",

        null=True,
        blank=True,
    )

    # =====================================================
    # 🚕 TAXI BOOKING
    # =====================================================

    taxi = models.ForeignKey(

        "taxi.Vehicle",

        on_delete=models.CASCADE,

        related_name="bookings",

        verbose_name="Такси",

        null=True,
        blank=True,
    )

    # =====================================================
    # 👤 PASSENGER INFO
    # =====================================================

    first_name = models.CharField(
        "Нэр",
        max_length=100,
    )

    last_name = models.CharField(
        "Овог",
        max_length=100,
    )

    email = models.EmailField(
        "Имэйл",
        blank=True,
    )

    phone = models.CharField(
        "Утас",
        max_length=20,
        blank=True,
    )

    # =====================================================
    # ✈ FLIGHT INFO
    # =====================================================

    birth_date = models.DateField(
        "Төрсөн огноо",
        null=True,
        blank=True,
    )

    gender = models.CharField(
        "Хүйс",
        max_length=20,
        blank=True,
    )

    nationality = models.CharField(
        "Иргэншил",
        max_length=100,
        blank=True,
    )

    passport_number = models.CharField(
        "Паспорт дугаар",
        max_length=50,
        blank=True,
    )

    passport_expire_date = (
        models.DateField(
            "Паспорт дуусах хугацаа",
            null=True,
            blank=True,
        )
    )

    # =====================================================
    # 🚕 TAXI INFO
    # =====================================================

    flight_number = models.CharField(
        "Нислэгийн дугаар",
        max_length=100,
        blank=True,
    )

    pickup_date = models.DateField(
        "Тосох огноо",
        null=True,
        blank=True,
    )

    pickup_time = models.TimeField(
        "Тосох цаг",
        null=True,
        blank=True,
    )

    # =====================================================
    # 📍 ADDRESS
    # =====================================================

    district = models.CharField(
        "Дүүрэг",
        max_length=255,
        blank=True,
    )

    khoroo = models.CharField(
        "Хороо",
        max_length=255,
        blank=True,
    )

    apartment = models.CharField(
        "Хороолол / Байр",
        max_length=255,
        blank=True,
    )

    street = models.CharField(
        "Гудамж",
        max_length=255,
        blank=True,
    )

    detail_address = models.TextField(
        "Дэлгэрэнгүй хаяг",
        blank=True,
    )

    # =====================================================
    # 👥 PEOPLE
    # =====================================================

    people = models.PositiveIntegerField(
        "Хүний тоо",
        default=1,
    )

    # =====================================================
    # 💰 PRICE
    # =====================================================

    total_price = models.DecimalField(

        "Нийт үнэ",

        max_digits=12,

        decimal_places=2,

        default=0,
    )

    # =====================================================
    # 📌 STATUS
    # =====================================================

    status = models.CharField(

        "Төлөв",

        max_length=20,

        choices=STATUS_CHOICES,

        default=STATUS_PENDING,
    )

    created_at = models.DateTimeField(
        "Үүсгэсэн огноо",
        auto_now_add=True,
    )

    # =====================================================
    # META
    # =====================================================

    class Meta:

        verbose_name = "Захиалга"

        verbose_name_plural = (
            "Захиалгууд"
        )

        ordering = ["-created_at"]

    # =====================================================
    # STRING
    # =====================================================

    def __str__(self):

        # 🚕 TAXI
        if self.taxi:

            return (
                f"{self.first_name} "
                f"{self.last_name} - "
                f"{self.taxi}"
            )

        # ✈ FLIGHT
        if self.flight:

            return (
                f"{self.first_name} "
                f"{self.last_name} - "
                f"{self.flight}"
            )

        # 🌍 TOUR
        if self.tour:

            return (
                f"{self.first_name} "
                f"{self.last_name} - "
                f"{self.tour.name}"
            )

        return (
            f"{self.first_name} "
            f"{self.last_name}"
        )

    # =====================================================
    # VALIDATION
    # =====================================================

    def clean(self):

        # ❌ NOTHING SELECTED
        if (
            not self.flight and
            not self.tour and
            not self.taxi
        ):

            raise ValidationError(
                "Аялал, нислэг "
                "эсвэл такси "
                "сонгоно уу"
            )

        # 🌍 TOUR VALIDATION
        if (
            self.tour and
            self.schedule
        ):

            if self.people <= 0:

                raise ValidationError(
                    "Хүний тоо "
                    "1-ээс их "
                    "байх ёстой"
                )

            if (
                self.schedule
                .available_seats
                < self.people
            ):

                raise ValidationError(
                    "Суудал "
                    "хүрэлцэхгүй байна"
                )

    # =====================================================
    # SAVE
    # =====================================================

    def save(self, *args, **kwargs):

        is_new = (
            self.pk is None
        )

        if not is_new:

            old = (
                Booking.objects
                .filter(pk=self.pk)
                .first()
            )

            old_status = (
                old.status
                if old else None
            )

        else:

            old_status = None

        super().save(
            *args,
            **kwargs,
        )

        # 🌍 TOUR SEAT DECREASE
        if (

            self.schedule and

            old_status ==
            self.STATUS_PENDING and

            self.status ==
            self.STATUS_CONFIRMED
        ):

            from django.db.models import F

            TourSchedule.objects.filter(
                pk=self.schedule.pk
            ).update(

                available_seats=

                F("available_seats")
                - self.people
            )

        # 🌍 TOUR SEAT RESTORE
        elif (

            self.schedule and

            old_status ==
            self.STATUS_CONFIRMED and

            self.status ==
            self.STATUS_CANCELLED
        ):

            from django.db.models import F

            TourSchedule.objects.filter(
                pk=self.schedule.pk
            ).update(

                available_seats=

                F("available_seats")
                + self.people
            )
            # ❤️ FAVORITE TOUR
# =========================================================

class FavoriteTour(models.Model):

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="favorite_tours",
        verbose_name="Хэрэглэгч",
    )

    tour = models.ForeignKey(
        TourPackage,
        on_delete=models.CASCADE,
        related_name="favorited_by",
        verbose_name="Аялал",
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
    )

    class Meta:

        verbose_name = "Дуртай аялал"

        verbose_name_plural = "Дуртай аяллууд"

        unique_together = (
            "user",
            "tour",
        )

        ordering = ["-created_at"]

    def __str__(self):

        return (
            f"{self.user} ❤️ "
            f"{self.tour.name}"
        )