from django.urls import path

from .views import (
    register,
    login,
    profile_view,
    flight_list,
    create_flight,
    flight_detail,
)

urlpatterns = [

    # ================= AUTH =================

    path(
        'register/',
        register,
    ),

    path(
        'login/',
        login,
    ),

    path(
        'profile/',
        profile_view,
    ),

    # ================= FLIGHT =================

    path(
        'flights/',
        flight_list,
    ),

    path(
        'flights/create/',
        create_flight,
    ),

    path(
        'flights/<int:pk>/',
        flight_detail,
    ),
]