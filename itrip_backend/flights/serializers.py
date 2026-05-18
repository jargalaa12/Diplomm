from datetime import datetime

from rest_framework import serializers

from .models import (
    Airport,
    Airline,
    Flight,
    FeaturedFlight,
)


# ─────────────────────────────────────────────
# AIRPORT
# ─────────────────────────────────────────────

class AirportSerializer(
    serializers.ModelSerializer
):

    class Meta:
        model = Airport

        fields = [
            'id',

            'code',

            'name',
            'name_mn',

            'city',
            'city_mn',

            'country',
            'country_mn',
        ]


# ─────────────────────────────────────────────
# AIRLINE
# ─────────────────────────────────────────────

class AirlineSerializer(
    serializers.ModelSerializer
):

    class Meta:
        model = Airline

        fields = [
            'id',

            'code',

            'name',
            'name_mn',

            'logo',
        ]


# ─────────────────────────────────────────────
# FLIGHT READ
# ─────────────────────────────────────────────

class FlightSerializer(
    serializers.ModelSerializer
):

    origin = AirportSerializer(
        read_only=True,
    )

    destination = AirportSerializer(
        read_only=True,
    )

    airline = AirlineSerializer(
        read_only=True,
    )

    duration_display = serializers.ReadOnlyField()

    duration_minutes = serializers.ReadOnlyField()

    has_seats = serializers.ReadOnlyField()

    occupancy_rate = serializers.ReadOnlyField()

    flight_class_display = serializers.CharField(
        source='get_flight_class_display',
        read_only=True,
    )

    status_display = serializers.CharField(
        source='get_status_display',
        read_only=True,
    )

    class Meta:
        model = Flight

        fields = [
            'id',

            'flight_number',

            'airline',

            'origin',
            'destination',

            'departure_date',
            'arrival_date',

            'return_date',

            'duration_display',
            'duration_minutes',

            'flight_class',
            'flight_class_display',

            'status',
            'status_display',

            'total_seats',
            'available_seats',

            'has_seats',
            'occupancy_rate',

            'price',

            'is_direct',
            'stops',
        ]


# ─────────────────────────────────────────────
# FLIGHT WRITE
# ─────────────────────────────────────────────

class FlightWriteSerializer(
    serializers.ModelSerializer
):

    class Meta:
        model = Flight

        fields = [
            'id',

            'flight_number',

            'airline',

            'origin',
            'destination',

            'departure_date',
            'arrival_date',

            'return_date',

            'price',

            'total_seats',
            'available_seats',

            'flight_class',
            'status',

            'is_direct',
            'stops',
        ]

    def validate(self, data):

        dep = data.get(
            'departure_date',
        )

        arr = data.get(
            'arrival_date',
        )

        if dep and arr and arr <= dep:
            raise serializers.ValidationError({
                'arrival_date':
                    'Ирэх цаг явах цагаас '
                    'хойно байх ёстой'
            })

        ret = data.get(
            'return_date',
        )

        if (
            ret and
            dep and
            ret < dep.date()
        ):
            raise serializers.ValidationError({
                'return_date':
                    'Буцах огноо '
                    'буруу байна'
            })

        avail = data.get(
            'available_seats',
            0,
        )

        total = data.get(
            'total_seats',
            0,
        )

        if avail > total:
            raise serializers.ValidationError({
                'available_seats':
                    'Сул суудал '
                    'нийт суудлаас '
                    'их байж болохгүй'
            })

        return data


# ─────────────────────────────────────────────
# FEATURED FLIGHT
# ─────────────────────────────────────────────

class FeaturedFlightSerializer(
    serializers.ModelSerializer
):

    origin = AirportSerializer(
        read_only=True,
    )

    destination = AirportSerializer(
        read_only=True,
    )

    date_range_display = serializers.ReadOnlyField()

    # 🔥 REAL BACKEND TIME
    departure_date = serializers.SerializerMethodField()

    arrival_date = serializers.SerializerMethodField()

    duration_display = serializers.SerializerMethodField()

    airline = serializers.SerializerMethodField()

    is_direct = serializers.SerializerMethodField()

    stops = serializers.SerializerMethodField()

    class Meta:
        model = FeaturedFlight

        fields = [
            'id',

            'origin',
            'destination',

            'price',

            'date_range_display',

            'date_range_start',
            'date_range_end',

            'departure_time',
            'arrival_time',

            'departure_date',
            'arrival_date',

            'duration_display',

            'airline',

            'is_direct',
            'stops',

            'image',
            'image_url',

            'badge',
        ]

    # ✈ FULL DATETIME
    def get_departure_date(
        self,
        obj,
    ):

        if (
            obj.date_range_start and
            obj.departure_time
        ):

            dt = datetime.combine(
                obj.date_range_start,
                obj.departure_time,
            )

            return dt.isoformat()

        return None

    def get_arrival_date(
        self,
        obj,
    ):

        if (
            obj.date_range_start and
            obj.arrival_time
        ):

            dt = datetime.combine(
                obj.date_range_start,
                obj.arrival_time,
            )

            return dt.isoformat()

        return None

    # ✈ DURATION
    def get_duration_display(
        self,
        obj,
    ):

        if (
            obj.departure_time and
            obj.arrival_time
        ):

            dep = datetime.combine(
                obj.date_range_start,
                obj.departure_time,
            )

            arr = datetime.combine(
                obj.date_range_start,
                obj.arrival_time,
            )

            diff = arr - dep

            total_minutes = int(
                diff.total_seconds() / 60
            )

            hours = (
                total_minutes // 60
            )

            minutes = (
                total_minutes % 60
            )

            return (
                f"{hours}ц "
                f"{minutes}мин"
            )

        return ""

    # ✈ AIRLINE
    def get_airline(
        self,
        obj,
    ):
        return {
            "name": "MIAT"
        }

    # ✈ DIRECT
    def get_is_direct(
        self,
        obj,
    ):
        return True

    # ✈ STOPS
    def get_stops(
        self,
        obj,
    ):
        return 0


# ─────────────────────────────────────────────
# FLIGHT SEARCH
# ─────────────────────────────────────────────

class FlightSearchSerializer(
    serializers.Serializer
):

    origin = serializers.CharField(
        max_length=3,
    )

    destination = serializers.CharField(
        max_length=3,
    )

    departure_date = serializers.DateField()

    return_date = serializers.DateField(
        required=False,
        allow_null=True,
    )

    adults = serializers.IntegerField(
        default=1,
        min_value=1,
        max_value=9,
    )

    children = serializers.IntegerField(
        default=0,
        min_value=0,
        max_value=9,
    )

    infants = serializers.IntegerField(
        default=0,
        min_value=0,
        max_value=9,
    )

    flight_class = serializers.ChoiceField(
        choices=[
            'economy',
            'business',
            'first',
        ],
        default='economy',
    )

    def validate(self, data):

        if (
            data.get('return_date')
            and
            data['return_date']
            < data['departure_date']
        ):
            raise serializers.ValidationError({
                'return_date':
                    'Буцах огноо '
                    'буруу байна'
            })

        total = (
            data['adults']
            + data.get(
                'children',
                0,
            )
            + data.get(
                'infants',
                0,
            )
        )

        if total > 9:
            raise serializers.ValidationError(
                'Нийт зорчигч '
                '9-өөс их '
                'байж болохгүй'
            )

        return data