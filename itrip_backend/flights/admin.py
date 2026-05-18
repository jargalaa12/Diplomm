from django.contrib import admin
from .models import Airline, Airport, Flight, FeaturedFlight


@admin.register(Airline)
class AirlineAdmin(admin.ModelAdmin):
    list_display = ("code", "name", "is_active")
    search_fields = ("code", "name")


@admin.register(Airport)
class AirportAdmin(admin.ModelAdmin):
    list_display = ("code", "city", "country")
    search_fields = ("code", "city")


@admin.register(Flight)
class FlightAdmin(admin.ModelAdmin):
    list_display = (
        "flight_number",
        "origin",
        "destination",
        "departure_date",
        "price",
    )


@admin.register(FeaturedFlight)
class FeaturedFlightAdmin(admin.ModelAdmin):
    list_display = ("origin", "destination", "price")