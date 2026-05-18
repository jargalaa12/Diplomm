from rest_framework import serializers
from .models import Location, Amenity, Vehicle, Booking


# =========================
# LOCATION
# =========================
class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ["id", "name", "name_en", "is_airport"]


# =========================
# AMENITY
# =========================
class AmenitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Amenity
        fields = ["id", "name", "icon"]


# =========================
# VEHICLE
# =========================
class VehicleSerializer(serializers.ModelSerializer):
    amenities = AmenitySerializer(many=True, read_only=True)

    category_display = serializers.CharField(
        source="get_category_display",
        read_only=True
    )

    # 🔥 IMAGE FIX (маш чухал)
    image = serializers.SerializerMethodField()

    def get_image(self, obj):
        if obj.image:
            return obj.image.url
        return None

    class Meta:
        model = Vehicle
        fields = [
            "id",
            "name",
            "category",
            "category_display",
            "image",
            "passenger_capacity",
            "luggage_capacity",
            "amenities",
            "price",
        ]


# =========================
# VEHICLE SEARCH
# =========================
class VehicleSearchSerializer(serializers.ModelSerializer):
    amenities = AmenitySerializer(many=True, read_only=True)

    category_display = serializers.CharField(
        source="get_category_display",
        read_only=True
    )

    image = serializers.SerializerMethodField()

    def get_image(self, obj):
        if obj.image:
            return obj.image.url
        return None

    class Meta:
        model = Vehicle
        fields = [
            "id",
            "name",
            "category",
            "category_display",
            "image",
            "passenger_capacity",
            "luggage_capacity",
            "amenities",
            "price",
        ]


# =========================
# BOOKING CREATE
# =========================
class BookingCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Booking
        fields = [
            "vehicle",
            "from_location",
            "to_location",
            "passenger_count",
            "luggage_count",
            "pickup_datetime",
            "contact_name",
            "contact_phone",
            "notes",
        ]

    def validate(self, data):
        vehicle = data.get("vehicle")
        passengers = data.get("passenger_count", 1)

        if vehicle and passengers > vehicle.passenger_capacity:
            raise serializers.ValidationError(
                f"Энэ машинд хамгийн ихдээ {vehicle.passenger_capacity} зорчигч багтана."
            )

        if vehicle:
            data["total_price"] = vehicle.price

        return data

    def create(self, validated_data):
        request = self.context.get("request")
        user = request.user if request and request.user.is_authenticated else None

        validated_data["user"] = user
        return super().create(validated_data)


# =========================
# BOOKING RESPONSE
# =========================
class BookingSerializer(serializers.ModelSerializer):
    vehicle = VehicleSerializer(read_only=True)
    from_location = LocationSerializer(read_only=True)
    to_location = LocationSerializer(read_only=True)

    status_display = serializers.CharField(
        source="get_status_display",
        read_only=True
    )

    is_cancellable = serializers.BooleanField(read_only=True)

    class Meta:
        model = Booking
        fields = [
            "id",
            "vehicle",
            "from_location",
            "to_location",
            "passenger_count",
            "luggage_count",
            "pickup_datetime",
            "total_price",
            "status",
            "status_display",
            "is_cancellable",
            "contact_name",
            "contact_phone",
            "notes",
            "created_at",
        ]