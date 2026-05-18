from django.db import models


# ─────────────────────────────────────────────
# AIRPORT
# ─────────────────────────────────────────────

class Airport(models.Model):
    """Нисэх буудал"""

    code = models.CharField(
        max_length=3,
        unique=True,
        verbose_name='IATA код',
    )

    name = models.CharField(
        max_length=200,
        verbose_name='Нэр',
    )

    name_mn = models.CharField(
        max_length=200,
        blank=True,
        verbose_name='Монгол нэр',
    )

    city = models.CharField(
        max_length=100,
        verbose_name='Хот',
    )

    city_mn = models.CharField(
        max_length=100,
        blank=True,
        verbose_name='Хот (монгол)',
    )

    country = models.CharField(
        max_length=100,
        verbose_name='Улс',
    )

    country_mn = models.CharField(
        max_length=100,
        blank=True,
        verbose_name='Улс (монгол)',
    )

    is_active = models.BooleanField(
        default=True,
    )

    class Meta:
        verbose_name = 'Нисэх буудал'
        verbose_name_plural = 'Нисэх буудлууд'
        ordering = ['code']

    def __str__(self):
        return (
            f"{self.code} - "
            f"{self.city} ({self.name})"
        )


# ─────────────────────────────────────────────
# AIRLINE
# ─────────────────────────────────────────────

class Airline(models.Model):
    """Авиа компани"""

    code = models.CharField(
        max_length=3,
        unique=True,
        verbose_name='IATA код',
    )

    name = models.CharField(
        max_length=200,
        verbose_name='Нэр',
    )

    name_mn = models.CharField(
        max_length=200,
        blank=True,
        verbose_name='Монгол нэр',
    )

    logo = models.ImageField(
        upload_to='airlines/',
        blank=True,
        null=True,
        verbose_name='Лого',
    )

    is_active = models.BooleanField(
        default=True,
    )

    class Meta:
        verbose_name = 'Авиа компани'
        verbose_name_plural = 'Авиа компаниуд'

    def __str__(self):
        return (
            f"{self.code} - {self.name}"
        )


# ─────────────────────────────────────────────
# FLIGHT
# ─────────────────────────────────────────────

class Flight(models.Model):
    """Нислэг"""

    CLASS_CHOICES = [
        ('economy', 'Энгийн'),
        ('business', 'Бизнес'),
        ('first', '1-р анги'),
    ]

    STATUS_CHOICES = [
        ('scheduled', 'Хуваарьт'),
        ('delayed', 'Хойшлогдсон'),
        ('cancelled', 'Цуцлагдсан'),
        ('departed', 'Явсан'),
        ('arrived', 'Ирсэн'),
    ]

    flight_number = models.CharField(
        max_length=50,
        verbose_name='Нислэгийн дугаар',
    )

    airline = models.ForeignKey(
        Airline,
        on_delete=models.PROTECT,
        related_name='flights',
        verbose_name='Авиа компани',
    )

    origin = models.ForeignKey(
        Airport,
        on_delete=models.PROTECT,
        related_name='departures',
        verbose_name='Гарах буудал',
    )

    destination = models.ForeignKey(
        Airport,
        on_delete=models.PROTECT,
        related_name='arrivals',
        verbose_name='Очих буудал',
    )

    departure_date = models.DateTimeField(
        verbose_name='Явах огноо цаг',
    )

    arrival_date = models.DateTimeField(
        verbose_name='Ирэх огноо цаг',
    )

    return_date = models.DateField(
        null=True,
        blank=True,
        verbose_name='Буцах огноо',
    )

    total_seats = models.PositiveIntegerField(
        default=0,
        verbose_name='Нийт суудал',
    )

    available_seats = models.PositiveIntegerField(
        default=0,
        verbose_name='Сул суудал',
    )

    price = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        verbose_name='Үнэ (₮)',
    )

    flight_class = models.CharField(
        max_length=10,
        choices=CLASS_CHOICES,
        default='economy',
        verbose_name='Нислэгийн анги',
    )

    status = models.CharField(
        max_length=15,
        choices=STATUS_CHOICES,
        default='scheduled',
        verbose_name='Төлөв',
    )

    is_direct = models.BooleanField(
        default=True,
        verbose_name='Шууд нислэг',
    )

    stops = models.PositiveSmallIntegerField(
        default=0,
        verbose_name='Зогсолтын тоо',
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
    )

    updated_at = models.DateTimeField(
        auto_now=True,
    )

    class Meta:
        verbose_name = 'Нислэг'
        verbose_name_plural = 'Нислэгүүд'
        ordering = ['departure_date']

    def __str__(self):
        return (
            f"{self.flight_number}: "
            f"{self.origin.code} → "
            f"{self.destination.code}"
        )

    @property
    def duration_minutes(self):
        delta = (
            self.arrival_date -
            self.departure_date
        )

        return int(
            delta.total_seconds() / 60
        )

    @property
    def duration_display(self):
        h, m = divmod(
            self.duration_minutes,
            60,
        )

        return f"{h}ц {m}мин"

    @property
    def has_seats(self):
        return (
            self.available_seats > 0
        )

    @property
    def occupancy_rate(self):
        if self.total_seats == 0:
            return 0

        return round(
            (
                (
                    self.total_seats -
                    self.available_seats
                )
                / self.total_seats
            ) * 100,
            1,
        )


# ─────────────────────────────────────────────
# FEATURED FLIGHT
# ─────────────────────────────────────────────

class FeaturedFlight(models.Model):
    """Онцлох нислэг"""

    origin = models.ForeignKey(
        Airport,
        on_delete=models.CASCADE,
        related_name='featured_origins',
        verbose_name='Гарах буудал',
    )

    destination = models.ForeignKey(
        Airport,
        on_delete=models.CASCADE,
        related_name='featured_destinations',
        verbose_name='Очих буудал',
    )

    price = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        verbose_name='Эхлэх үнэ',
    )

    date_range_start = models.DateField(
        verbose_name='Явах огноо',
    )

    date_range_end = models.DateField(
        verbose_name='Ирэх огноо',
    )

    # 🔥 REAL TIME
    departure_time = models.TimeField(
        null=True,
        blank=True,
        verbose_name='Явах цаг',
    )

    arrival_time = models.TimeField(
        null=True,
        blank=True,
        verbose_name='Ирэх цаг',
    )

    image = models.ImageField(
        upload_to='featured/',
        blank=True,
        null=True,
        verbose_name='Зураг',
    )

    image_url = models.URLField(
        blank=True,
        verbose_name='Зургийн URL',
    )

    badge = models.CharField(
        max_length=20,
        default='2 талдаа',
        verbose_name='Тэмдэглэгээ',
    )

    is_active = models.BooleanField(
        default=True,
    )

    order = models.PositiveSmallIntegerField(
        default=0,
        verbose_name='Эрэмбэ',
    )

    class Meta:
        verbose_name = 'Онцлох нислэг'
        verbose_name_plural = 'Онцлох нислэгүүд'
        ordering = ['order']

    def __str__(self):
        return (
            f"{self.origin.code} → "
            f"{self.destination.code} "
            f"₮{self.price}"
        )

    @property
    def date_range_display(self):
        s = self.date_range_start
        e = self.date_range_end

        return (
            f"{s.month:02d}/{s.day:02d}"
            f" - "
            f"{e.month:02d}/{e.day:02d}"
        )

    @property
    def departure_datetime(self):
        """
        Flutter-д бүтэн datetime
        """

        if (
            self.date_range_start and
            self.departure_time
        ):
            from datetime import datetime

            return datetime.combine(
                self.date_range_start,
                self.departure_time,
            )

        return None

    @property
    def arrival_datetime(self):
        """
        Flutter-д бүтэн datetime
        """

        if (
            self.date_range_start and
            self.arrival_time
        ):
            from datetime import datetime

            return datetime.combine(
                self.date_range_start,
                self.arrival_time,
            )

        return None