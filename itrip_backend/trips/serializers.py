from rest_framework import serializers

from .models import (
    TourPackage,
    TourSchedule,
    Booking,
)


# =========================================================
# TOUR SCHEDULE
# =========================================================

class TourScheduleSerializer(
    serializers.ModelSerializer
):

    duration_days = (
        serializers
        .SerializerMethodField()
    )

    class Meta:

        model = TourSchedule

        fields = [

            "id",

            "start_date",

            "end_date",

            "price",

            "available_seats",

            "duration_days",
        ]

    def get_duration_days(
        self,
        obj,
    ):

        return (
            obj.duration_days()
        )


# =========================================================
# TOUR PACKAGE
# =========================================================

class TourPackageSerializer(
    serializers.ModelSerializer
):

    image = (
        serializers
        .SerializerMethodField()
    )

    schedules = (
        TourScheduleSerializer(
            many=True,
            read_only=True,
        )
    )

    class Meta:

        model = TourPackage

        fields = "__all__"

    def get_image(
        self,
        obj,
    ):

        if not obj.image:
            return None

        request = (
            self.context.get(
                "request",
            )
        )

        try:

            url = obj.image.url

        except Exception:

            return None

        if request:

            return (
                request
                .build_absolute_uri(
                    url
                )
            )

        return url


# =========================================================
# BOOKING
# =========================================================

class BookingSerializer(
    serializers.ModelSerializer
):

    # =====================================================
    # 🌍 TOUR
    # =====================================================

    tour_name = (
        serializers.CharField(
            source="tour.name",
            read_only=True,
        )
    )

    date = (
        serializers.DateField(
            source=
            "schedule.start_date",

            read_only=True,
        )
    )

    duration = (
        serializers
        .SerializerMethodField()
    )

    # =====================================================
    # ✈ FLIGHT
    # =====================================================

    flight_number_display = (
        serializers.CharField(
            source=
            "flight.flight_number",

            read_only=True,
        )
    )

    origin = (
        serializers.CharField(
            source=
            "flight.origin.code",

            read_only=True,
        )
    )

    destination = (
        serializers.CharField(
            source=
            "flight.destination.code",

            read_only=True,
        )
    )

    departure_date = (
        serializers.DateTimeField(
            source=
            "flight.departure_date",

            read_only=True,
        )
    )

    arrival_date = (
        serializers.DateTimeField(
            source=
            "flight.arrival_date",

            read_only=True,
        )
    )

    # =====================================================
    # 🚕 TAXI
    # =====================================================

    taxi_name = (
        serializers.CharField(
            source="taxi.name",
            read_only=True,
        )
    )

    # =====================================================
    # 💰 PRICE
    # =====================================================

    total_price = (
        serializers.DecimalField(

            max_digits=12,

            decimal_places=2,

            read_only=True,
        )
    )

    class Meta:

        model = Booking

        fields = [

            # =================================================
            # ID
            # =================================================

            "id",

            # =================================================
            # 🌍 TOUR
            # =================================================

            "tour",

            "schedule",

            "tour_name",

            "date",

            "duration",

            # =================================================
            # ✈ FLIGHT
            # =================================================

            "flight",

            "flight_number_display",

            "origin",

            "destination",

            "departure_date",

            "arrival_date",

            # =================================================
            # 🚕 TAXI
            # =================================================

            "taxi",

            "taxi_name",

            "flight_number",

            "pickup_date",

            "pickup_time",

            # =================================================
            # 📍 ADDRESS
            # =================================================

            "district",

            "khoroo",

            "apartment",

            "street",

            "detail_address",

            # =================================================
            # 👤 PASSENGER
            # =================================================

            "first_name",

            "last_name",

            "email",

            "phone",

            "birth_date",

            "gender",

            "nationality",

            "passport_number",

            "passport_expire_date",

            # =================================================
            # 👥 PEOPLE
            # =================================================

            "people",

            # =================================================
            # 💰 PRICE
            # =================================================

            "total_price",

            # =================================================
            # 📌 STATUS
            # =================================================

            "status",

            # =================================================
            # 🕒 CREATED
            # =================================================

            "created_at",
        ]

        read_only_fields = [
            "created_at",
        ]

    # =====================================================
    # 🌍 TOUR DURATION
    # =====================================================

    def get_duration(
        self,
        obj,
    ):

        if obj.schedule:

            return (
                obj.schedule
                .duration_days()
            )

        return 0

    # =====================================================
    # ✅ VALIDATION
    # =====================================================

    def validate(
        self,
        data,
    ):

        # ❌ NOTHING SELECTED
        if (
            not data.get("tour")
            and
            not data.get("flight")
            and
            not data.get("taxi")
        ):

            raise (
                serializers
                .ValidationError(
                    "Аялал, "
                    "нислэг "
                    "эсвэл "
                    "такси "
                    "сонгоно уу"
                )
            )

        return data
    # =========================================================
# ❤️ FAVORITE TOUR
# =========================================================

from .models import FavoriteTour


class FavoriteTourSerializer(
    serializers.ModelSerializer
):

    tour_name = serializers.CharField(
        source="tour.name",
        read_only=True,
    )

    image = serializers.SerializerMethodField()

    location = serializers.CharField(
        source="tour.location",
        read_only=True,
    )

    price = serializers.DecimalField(
        source="tour.price",

        max_digits=10,

        decimal_places=2,

        read_only=True,
    )

    class Meta:

        model = FavoriteTour

        fields = [

            "id",

            "tour",

            "tour_name",

            "image",

            "location",

            "price",

            "created_at",
        ]

    def get_image(
        self,
        obj,
    ):

        if not obj.tour.image:
            return None

        request = self.context.get(
            "request"
        )

        try:

            url = obj.tour.image.url

        except Exception:

            return None

        if request:

            return (
                request
                .build_absolute_uri(
                    url
                )
            )

        return url