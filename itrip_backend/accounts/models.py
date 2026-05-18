from django.db import models
from django.contrib.auth.models import User


# ================= ACCOUNT =================

class Account(models.Model):
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name="account",
    )

    phone_number = models.CharField(
        max_length=15,
        blank=True,
        null=True,
    )

    pro_image = models.ImageField(
        upload_to='photos/accounts/',
        blank=True,
        null=True,
    )

    def __str__(self):
        return self.user.username


# ================= FLIGHT =================

class Flight(models.Model):
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="flights",
    )

    airline = models.CharField(
        max_length=100,
    )

    from_city = models.CharField(
        max_length=100,
    )

    to_city = models.CharField(
        max_length=100,
    )

    departure_time = models.DateTimeField()

    arrival_time = models.DateTimeField()

    price = models.FloatField()

    seats_available = models.IntegerField()

    created_at = models.DateTimeField(
        auto_now_add=True,
    )

    def __str__(self):
        return (
            f"{self.airline}: "
            f"{self.from_city} → "
            f"{self.to_city}"
        )