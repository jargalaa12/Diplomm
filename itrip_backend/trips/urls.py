from django.urls import (
    path,
    include,
)

from django.conf import settings

from django.conf.urls.static import (
    static,
)

from rest_framework.routers import (
    DefaultRouter,
)

from .views import (

    # 🌍 TOUR
    get_packages,
    get_package_detail,

    # 📦 BOOKING
    BookingViewSet,

    # ❤️ FAVORITE
    FavoriteTourViewSet,
)


# =========================================================
# ROUTER
# =========================================================

router = DefaultRouter()

# ================= BOOKING =================

router.register(

    r"bookings",

    BookingViewSet,

    basename="booking",
)

# ================= FAVORITE =================

router.register(

    r"favorites",

    FavoriteTourViewSet,

    basename="favorite",
)


# =========================================================
# URL PATTERNS
# =========================================================

urlpatterns = [

    # =====================================================
    # 🌍 TOUR PACKAGE API
    # =====================================================

    path(

        "packages/",

        get_packages,

        name="get_packages",
    ),

    path(

        "packages/<int:pk>/",

        get_package_detail,

        name="get_package_detail",
    ),

    # =====================================================
    # 📦 API ROUTER
    # =====================================================

    path(

        "",

        include(
            router.urls,
        ),
    ),
]


# =========================================================
# MEDIA FILES
# =========================================================

if settings.DEBUG:

    urlpatterns += static(

        settings.MEDIA_URL,

        document_root=
        settings.MEDIA_ROOT,
    )