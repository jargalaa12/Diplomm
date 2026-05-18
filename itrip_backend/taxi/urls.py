from django.urls import path
from .views import (
    LocationListView,
    VehicleSearchView,
    BookingCreateView,
    BookingDetailView,
    BookingCancelView,
    TaxiListView,  # 🔥 нэмсэн
)

urlpatterns = [
    # =========================
    # TAXI LIST (🔥 Flutter-д хэрэгтэй)
    # =========================
    path(
        "taxi/",
        TaxiListView.as_view(),
        name="taxi-list",
    ),

    # =========================
    # БАЙРШИЛ
    # =========================
    path(
        "locations/",
        LocationListView.as_view(),
        name="location-list",
    ),

    # =========================
    # МАШИН ХАЙХ
    # =========================
    path(
        "vehicles/search/",
        VehicleSearchView.as_view(),
        name="vehicle-search",
    ),

    # =========================
    # ЗАХИАЛГА
    # =========================
    path(
        "bookings/",
        BookingCreateView.as_view(),
        name="booking-create",
    ),
    path(
        "bookings/<int:pk>/",
        BookingDetailView.as_view(),
        name="booking-detail",
    ),
    path(
        "bookings/<int:pk>/cancel/",
        BookingCancelView.as_view(),
        name="booking-cancel",
    ),
]