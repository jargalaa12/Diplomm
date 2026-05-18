from rest_framework.response import Response
from rest_framework.decorators import api_view

from rest_framework import (
    status,
    viewsets,
    permissions,
)

from rest_framework.exceptions import (
    ValidationError,
)

from .models import (
    TourPackage,
    Booking,
    FavoriteTour,
)

from .serializers import (
    TourPackageSerializer,
    BookingSerializer,
    FavoriteTourSerializer,
)


# =========================================================
# GET PACKAGES
# =========================================================

@api_view(['GET'])
def get_packages(request):

    try:

        packages = TourPackage.objects.all()

        # 🌍 LOCATION FILTER
        location = request.query_params.get(
            'location'
        )

        if location:

            packages = packages.filter(
                location__icontains=location
            )

        # 📅 DATE FILTER
        date = request.query_params.get(
            'date'
        )

        if date:

            packages = packages.filter(
                schedules__start_date__lte=date,
                schedules__end_date__gte=date,
            ).distinct()

        packages = packages.order_by(
            '-id'
        )

        serializer = TourPackageSerializer(
            packages,
            many=True,
            context={
                'request': request,
            },
        )

        return Response(
            serializer.data,
            status=status.HTTP_200_OK,
        )

    except Exception as e:

        return Response(
            {
                "error": str(e)
            },
            status=status.HTTP_500_INTERNAL_SERVER_ERROR,
        )


# =========================================================
# PACKAGE DETAIL
# =========================================================

@api_view(['GET'])
def get_package_detail(
    request,
    pk,
):

    try:

        package = TourPackage.objects.get(
            id=pk
        )

        serializer = TourPackageSerializer(
            package,
            context={
                'request': request,
            },
        )

        return Response(
            serializer.data,
            status=status.HTTP_200_OK,
        )

    except TourPackage.DoesNotExist:

        return Response(
            {
                "error": "Not found"
            },
            status=status.HTTP_404_NOT_FOUND,
        )

    except Exception as e:

        return Response(
            {
                "error": str(e)
            },
            status=status.HTTP_500_INTERNAL_SERVER_ERROR,
        )


# =========================================================
# BOOKING VIEWSET
# =========================================================

class BookingViewSet(
    viewsets.ModelViewSet
):

    queryset = Booking.objects.all()

    serializer_class = BookingSerializer

    permission_classes = [
        permissions.IsAuthenticated
    ]

    # =====================================================
    # USER BOOKINGS
    # =====================================================

    def get_queryset(
        self,
    ):

        return (
            Booking.objects
            .filter(
                user=self.request.user
            )
            .order_by('-id')
        )

    # =====================================================
    # CREATE BOOKING
    # =====================================================

    def perform_create(
        self,
        serializer,
    ):

        data = serializer.validated_data

        schedule = data.get(
            "schedule"
        )

        flight = data.get(
            "flight"
        )

        taxi = data.get(
            "taxi"
        )

        people = data.get(
            "people",
            1,
        )

        total_price = 0

        # =================================================
        # 🌍 TOUR BOOKING
        # =================================================

        if schedule and not taxi and not flight:

            if (
                schedule.available_seats
                < people
            ):

                raise ValidationError({
                    "error":
                    "Суудал хүрэлцэхгүй байна"
                })

            total_price = (
                schedule.price
                * people
            )

        # =================================================
        # ✈ FLIGHT BOOKING
        # =================================================

        elif flight and not taxi:

            if (
                flight.available_seats
                < people
            ):

                raise ValidationError({
                    "error":
                    "Нислэгийн суудал хүрэлцэхгүй байна"
                })

            total_price = (
                flight.price
                * people
            )

        # =================================================
        # 🚕 TAXI BOOKING
        # =================================================

        elif taxi:

            total_price = taxi.price

        # =================================================
        # ❌ NOTHING SELECTED
        # =================================================

        else:

            raise ValidationError({
                "error":
                "Аялал, нислэг эсвэл такси сонгоно уу"
            })

        # =================================================
        # ✅ SAVE
        # =================================================

        serializer.save(
            user=self.request.user,
            total_price=total_price,
            status=Booking.STATUS_PENDING,
        )


# =========================================================
# ❤️ FAVORITE TOUR VIEWSET
# =========================================================

class FavoriteTourViewSet(
    viewsets.ModelViewSet
):

    serializer_class = (
        FavoriteTourSerializer
    )

    permission_classes = [
        permissions.IsAuthenticated
    ]

    # =====================================================
    # USER FAVORITES
    # =====================================================

    def get_queryset(
        self,
    ):

        return (
            FavoriteTour.objects
            .filter(
                user=self.request.user
            )
            .order_by("-id")
        )

    # =====================================================
    # CREATE FAVORITE
    # =====================================================

    def perform_create(
        self,
        serializer,
    ):

        tour = serializer.validated_data.get(
            "tour"
        )

        favorite_exists = (
            FavoriteTour.objects.filter(
                user=self.request.user,
                tour=tour,
            ).exists()
        )

        # ❌ ALREADY EXISTS
        if favorite_exists:

            raise ValidationError({
                "error":
                "Энэ аялал өмнө нь хадгалагдсан байна"
            })

        # ✅ SAVE
        serializer.save(
            user=self.request.user,
        )