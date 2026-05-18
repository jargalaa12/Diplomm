from datetime import datetime, timedelta

from django.utils import timezone
from django_filters.rest_framework import DjangoFilterBackend

from rest_framework import (
    generics,
    status,
    permissions,
)

from rest_framework.filters import (
    SearchFilter,
    OrderingFilter,
)

from rest_framework.response import Response
from rest_framework.views import APIView

from .models import (
    Airport,
    Flight,
    FeaturedFlight,
)

from .serializers import (
    AirportSerializer,
    FlightSerializer,
    FlightWriteSerializer,
    FeaturedFlightSerializer,
    FlightSearchSerializer,
)


# ─────────────────────────────────────────────────────────────
# ✈️ AIRPORT LIST
# ─────────────────────────────────────────────────────────────

class AirportListView(generics.ListAPIView):

    serializer_class = AirportSerializer

    permission_classes = [
        permissions.AllowAny
    ]

    filter_backends = [
        SearchFilter
    ]

    search_fields = [
        'code',
        'name',
        'name_mn',
        'city',
        'city_mn',
        'country',
    ]

    def get_queryset(self):

        return (
            Airport.objects
            .filter(is_active=True)
        )


# ─────────────────────────────────────────────────────────────
# ✈️ FLIGHT LIST
# ─────────────────────────────────────────────────────────────

class FlightListCreateView(
    generics.ListCreateAPIView
):

    permission_classes = [
        permissions.IsAuthenticatedOrReadOnly
    ]

    filter_backends = [
        DjangoFilterBackend,
        SearchFilter,
        OrderingFilter,
    ]

    filterset_fields = [
        'flight_class',
        'status',
        'is_direct',
    ]

    search_fields = [
        'flight_number',
        'origin__code',
        'destination__code',
    ]

    ordering_fields = [
        'price',
        'departure_date',
        'available_seats',
    ]

    ordering = [
        'departure_date'
    ]

    def get_serializer_class(self):

        if self.request.method == 'POST':
            return FlightWriteSerializer

        return FlightSerializer

    def get_queryset(self):

        return (
            Flight.objects
            .select_related(
                'origin',
                'destination',
                'airline',
            )
            .all()
        )


# ─────────────────────────────────────────────────────────────
# ✈️ FLIGHT DETAIL
# ─────────────────────────────────────────────────────────────

class FlightDetailView(
    generics.RetrieveUpdateDestroyAPIView
):

    permission_classes = [
        permissions.IsAuthenticatedOrReadOnly
    ]

    def get_serializer_class(self):

        if self.request.method in (
            'PUT',
            'PATCH',
        ):

            return FlightWriteSerializer

        return FlightSerializer

    def get_queryset(self):

        return (
            Flight.objects
            .select_related(
                'origin',
                'destination',
                'airline',
            )
            .all()
        )


# ─────────────────────────────────────────────────────────────
# 🔎 SEARCH FLIGHTS
# ─────────────────────────────────────────────────────────────

class FlightSearchView(APIView):

    permission_classes = [
        permissions.AllowAny
    ]

    def post(self, request):

        serializer = FlightSearchSerializer(
            data=request.data,
        )

        if not serializer.is_valid():

            return Response(
                serializer.errors,
                status=status.HTTP_400_BAD_REQUEST,
            )

        data = serializer.validated_data

        total_passengers = (
            data['adults'] +
            data.get('children', 0)
        )

        outbound = self._search(

            origin=data['origin'].upper(),

            destination=data[
                'destination'
            ].upper(),

            date=data['departure_date'],

            flight_class=data[
                'flight_class'
            ],

            passengers=total_passengers,
        )

        return_flights = []

        if data.get('return_date'):

            return_flights = self._search(

                origin=data[
                    'destination'
                ].upper(),

                destination=data[
                    'origin'
                ].upper(),

                date=data['return_date'],

                flight_class=data[
                    'flight_class'
                ],

                passengers=total_passengers,
            )

        return Response({

            'outbound_flights':

                FlightSerializer(
                    outbound,
                    many=True,
                ).data,

            'return_flights':

                FlightSerializer(
                    return_flights,
                    many=True,
                ).data,

            'total_outbound':
                outbound.count(),

            'total_return':

                len(return_flights)

                if isinstance(
                    return_flights,
                    list,
                )

                else return_flights.count(),

            'search_params':
                data,
        })

    # ─────────────────────────────────────────────
    # 🔍 INTERNAL SEARCH
    # ─────────────────────────────────────────────

    def _search(

        self,

        origin,
        destination,
        date,
        flight_class,
        passengers,

    ):

        day_start = datetime.combine(
            date,
            datetime.min.time(),
        )

        day_end = (
            day_start +
            timedelta(days=1)
        )

        return (

            Flight.objects

            .filter(

                origin__code=origin,

                destination__code=
                    destination,

                departure_date__gte=
                    day_start,

                departure_date__lt=
                    day_end,

                flight_class=
                    flight_class,

                available_seats__gte=
                    passengers,

                status__in=[
                    'scheduled',
                    'delayed',
                ],
            )

            .select_related(
                'origin',
                'destination',
                'airline',
            )

            .order_by(
                'departure_date',
                'price',
            )
        )


# ─────────────────────────────────────────────────────────────
# 📅 TODAY SCHEDULE
# ─────────────────────────────────────────────────────────────

class TodayScheduleView(APIView):

    permission_classes = [
        permissions.AllowAny
    ]

    def get(self, request):

        airport_code = request.query_params.get(
            'airport',
            'UBN',
        ).upper()

        now = timezone.now()

        today_start = now.replace(

            hour=0,
            minute=0,
            second=0,
            microsecond=0,
        )

        today_end = (
            today_start +
            timedelta(days=1)
        )

        qs_base = (

            Flight.objects

            .select_related(
                'origin',
                'destination',
                'airline',
            )
        )

        departures = (

            qs_base

            .filter(

                origin__code=
                    airport_code,

                departure_date__gte=
                    today_start,

                departure_date__lt=
                    today_end,

                status__in=[
                    'scheduled',
                    'delayed',
                    'departed',
                ],
            )

            .order_by(
                'departure_date'
            )
        )

        arrivals = (

            qs_base

            .filter(

                destination__code=
                    airport_code,

                arrival_date__gte=
                    today_start,

                arrival_date__lt=
                    today_end,

                status__in=[
                    'scheduled',
                    'delayed',
                    'arrived',
                ],
            )

            .order_by(
                'arrival_date'
            )
        )

        return Response({

            'airport':
                airport_code,

            'date':
                today_start.strftime(
                    '%Y-%m-%d'
                ),

            'departures':

                FlightSerializer(
                    departures,
                    many=True,
                ).data,

            'arrivals':

                FlightSerializer(
                    arrivals,
                    many=True,
                ).data,
        })


# ─────────────────────────────────────────────────────────────
# 🔥 FEATURED FLIGHTS
# ─────────────────────────────────────────────────────────────

class FeaturedFlightListView(
    generics.ListAPIView
):

    serializer_class = (
        FeaturedFlightSerializer
    )

    permission_classes = [
        permissions.AllowAny
    ]

    def get_queryset(self):

        return (

            FeaturedFlight.objects

            .filter(
                is_active=True
            )

            .select_related(
                'origin',
                'destination',
            )
        )