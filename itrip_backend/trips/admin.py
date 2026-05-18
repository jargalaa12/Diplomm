from django.contrib import admin
from .models import TourPackage, TourSchedule, Booking


# ================= TOUR SCHEDULE INLINE =================
class TourScheduleInline(admin.TabularInline):
    model = TourSchedule
    extra = 1


# ================= TOUR PACKAGE =================
@admin.register(TourPackage)
class TourPackageAdmin(admin.ModelAdmin):
    list_display = ("name", "location", "price", "max_people")
    search_fields = ("name", "location")
    inlines = [TourScheduleInline]


# ================= TOUR SCHEDULE =================
@admin.register(TourSchedule)
class TourScheduleAdmin(admin.ModelAdmin):
    list_display = ("tour", "start_date", "end_date", "price", "available_seats")
    list_filter = ("start_date",)
    search_fields = ("tour__name",)


# ================= BOOKING ADMIN 🔥 =================
@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = (
        "id",
        "user",
        "tour",
        "schedule",
        "people",
        "total_price",
        "status",
        "created_at",
    )

    list_filter = ("status", "created_at")

    search_fields = (
        "user__username",
        "tour__name",
        "email",
        "phone",
    )

    ordering = ("-created_at",)