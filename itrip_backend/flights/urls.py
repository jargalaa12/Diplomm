from django.urls import path
from . import views

app_name = "flights"  # 🔥 namespace нэмсэн (future-д хэрэгтэй)

urlpatterns = [
    # =========================
    # AIRPORTS
    # =========================
    path(
        'airports/',
        views.AirportListView.as_view(),
        name='airport-list'
    ),

    # =========================
    # SEARCH FLIGHTS
    # =========================
    path(
        'search/',
        views.FlightSearchView.as_view(),
        name='flight-search'
    ),

    # =========================
    # TODAY SCHEDULE
    # =========================
    path(
        'today-schedule/',
        views.TodayScheduleView.as_view(),
        name='today-schedule'
    ),

    # =========================
    # FEATURED FLIGHTS
    # =========================
    path(
        'featured/',
        views.FeaturedFlightListView.as_view(),
        name='featured-flights'
    ),

    # =========================
    # FLIGHT LIST + CREATE
    # =========================
    path(
        '',
        views.FlightListCreateView.as_view(),
        name='flight-list'
    ),

    # =========================
    # FLIGHT DETAIL / UPDATE / DELETE
    # =========================
    path(
        '<int:pk>/',
        views.FlightDetailView.as_view(),
        name='flight-detail'
    ),
]