from django.contrib import admin
from .models import Location, Amenity, Vehicle, Booking


# =========================
# LOCATION
# =========================
@admin.register(Location)
class LocationAdmin(admin.ModelAdmin):
    list_display = ("id", "name", "name_en", "is_airport", "is_active")
    list_filter = ("is_airport", "is_active")
    search_fields = ("name", "name_en")
    ordering = ("name",)


# =========================
# AMENITY
# =========================
@admin.register(Amenity)
class AmenityAdmin(admin.ModelAdmin):
    list_display = ("id", "name", "icon")
    search_fields = ("name",)


# =========================
# VEHICLE (TAXI)
# =========================
@admin.register(Vehicle)
class VehicleAdmin(admin.ModelAdmin):
    list_display = (
        "id",
        "name",
        "category",
        "passenger_capacity",
        "luggage_capacity",
        "price",   # 🔥 нэмсэн
        "is_active",
    )
    list_filter = ("category", "is_active")
    search_fields = ("name",)
    filter_horizontal = ("amenities",)
    ordering = ("name",)


# =========================
# BOOKING
# =========================
@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = (
        "id",
        "contact_name",
        "contact_phone",
        "from_location",
        "to_location",
        "vehicle",
        "pickup_datetime",
        "total_price",
        "status",
    )
    list_filter = ("status", "from_location", "to_location")
    search_fields = ("contact_name", "contact_phone")
    readonly_fields = ("created_at", "updated_at", "can_cancel_before")
    ordering = ("-created_at",)

    list_select_related = ("vehicle", "from_location", "to_location")