from rest_framework import serializers
from django.contrib.auth.models import User

from .models import (
    Flight,
    Account,
)

# ================= FLIGHT =================

class FlightSerializer(serializers.ModelSerializer):
    class Meta:
        model = Flight
        fields = '__all__'


# ================= PROFILE =================

class ProfileSerializer(serializers.ModelSerializer):

    full_name = serializers.SerializerMethodField()

    phone = serializers.SerializerMethodField()

    profile_image = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            "id",
            "full_name",
            "email",
            "phone",
            "profile_image",
        ]

    def get_full_name(self, obj):
        return obj.username

    def get_phone(self, obj):
        try:
            account = Account.objects.get(
                user=obj
            )

            return account.phone_number or ""

        except Account.DoesNotExist:
            return ""

    def get_profile_image(self, obj):
        try:
            request = self.context.get(
                'request'
            )

            account = Account.objects.get(
                user=obj
            )

            if (
                account.pro_image
            ):
                return request.build_absolute_uri(
                    account.pro_image.url
                )

            return ""

        except:
            return ""


# ================= UPDATE PROFILE =================

class UpdateProfileSerializer(
    serializers.ModelSerializer
):

    full_name = serializers.CharField(
        required=False,
    )

    phone = serializers.CharField(
        required=False,
    )

    password = serializers.CharField(
        write_only=True,
        required=False,
    )

    class Meta:
        model = User
        fields = [
            "full_name",
            "email",
            "phone",
            "password",
        ]

    def update(
        self,
        instance,
        validated_data,
    ):

        full_name = validated_data.pop(
            "full_name",
            None,
        )

        phone = validated_data.pop(
            "phone",
            "",
        )

        password = validated_data.pop(
            "password",
            None,
        )

        # ================= USER =================

        if full_name:
            instance.username = full_name

        if "email" in validated_data:
            instance.email = validated_data[
                "email"
            ]

        if password:
            instance.set_password(
                password
            )

        instance.save()

        # ================= ACCOUNT =================

        account, created = (
            Account.objects.get_or_create(
                user=instance
            )
        )

        account.phone_number = phone

        account.save()

        return instance