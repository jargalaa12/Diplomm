from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.shortcuts import get_object_or_404

from .models import Location, Vehicle, Booking
from .serializers import (
    LocationSerializer,
    VehicleSearchSerializer,
    BookingCreateSerializer,
    BookingSerializer,
)


# =========================
# LOCATION LIST
# =========================
class LocationListView(generics.ListAPIView):
    queryset = Location.objects.filter(is_active=True)
    serializer_class = LocationSerializer


# =========================
# VEHICLE SEARCH
# =========================
class VehicleSearchView(APIView):
    def post(self, request):
        try:
            passengers = int(request.data.get("passenger_count", 1))
            luggage = int(request.data.get("luggage_count", 0))
        except ValueError:
            return Response(
                {"error": "Тоон утга буруу байна"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        vehicles = Vehicle.objects.filter(
            passenger_capacity__gte=passengers,
            luggage_capacity__gte=luggage,
            is_active=True,
        )

        serializer = VehicleSearchSerializer(vehicles, many=True)
        return Response(serializer.data)


# =========================
# TAXI LIST (🔥 FIXED)
# =========================
class TaxiListView(APIView):
    def get(self, request):
        taxis = Vehicle.objects.filter(is_active=True)

        data = []
        for t in taxis:
            data.append({
                "id": t.id,
                "name": t.name,
                "price": int(t.price) if t.price else 0,
                "location": "Улаанбаатар",

                # 🔥 IMAGE FIX
                "image": t.image.url if t.image else None,
            })

        return Response(data)


# =========================
# CREATE BOOKING
# =========================
class BookingCreateView(generics.CreateAPIView):
    serializer_class = BookingCreateSerializer

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context["request"] = self.request
        return context

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        booking = serializer.save()

        return Response(
            BookingSerializer(booking).data,
            status=status.HTTP_201_CREATED,
        )


# =========================
# BOOKING DETAIL
# =========================
class BookingDetailView(generics.RetrieveAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer


# =========================
# CANCEL BOOKING
# =========================
class BookingCancelView(APIView):
    def post(self, request, pk):
        booking = get_object_or_404(Booking, pk=pk)

        if not booking.is_cancellable:
            return Response(
                {"error": "Цуцлах хугацаа дууссан"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        if booking.status in ("completed", "cancelled"):
            return Response(
                {"error": "Цуцлах боломжгүй"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        booking.status = "cancelled"
        booking.save()

        return Response({"message": "Амжилттай цуцлагдлаа"})