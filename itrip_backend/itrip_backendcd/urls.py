from django.contrib import admin
from django.urls import (
    path,
    include,
)

from django.conf import settings
from django.conf.urls.static import static


urlpatterns = [

    # ================= ADMIN =================

    path(
        'admin/',
        admin.site.urls,
    ),

    # ================= TRIPS API =================

    path(
        'api/trips/',
        include('trips.urls'),
    ),

    # ================= FLIGHTS API =================

    path(
        'api/flights/',
        include('flights.urls'),
    ),

    # ================= AUTH / PROFILE API =================

    path(
        'api/auth/',
        include('accounts.urls'),
    ),

    # ================= TAXI API =================

    path(
        'api/',
        include('taxi.urls'),
    ),
]


# ================= MEDIA FILES =================

if settings.DEBUG:

    urlpatterns += static(
        settings.MEDIA_URL,
        document_root=settings.MEDIA_ROOT,
    )