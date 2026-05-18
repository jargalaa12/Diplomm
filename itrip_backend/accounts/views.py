from django.contrib.auth.models import User
from django.contrib.auth import authenticate

from rest_framework.decorators import (
    api_view,
    permission_classes,
)

from rest_framework.permissions import (
    IsAuthenticated,
)

from rest_framework.response import Response

from rest_framework_simplejwt.tokens import (
    RefreshToken,
)

from .models import (
    Flight,
    Account,
)

from .serializers import (
    FlightSerializer,
)

# ================= REGISTER =================

@api_view(['POST'])
def register(request):

    full_name = request.data.get(
        'full_name',
        ''
    ).strip()

    email = request.data.get(
        'email',
        ''
    ).strip()

    password = request.data.get(
        'password',
        ''
    ).strip()

    phone = request.data.get(
        'phone',
        ''
    ).strip()

    if not full_name or not password:

        return Response(
            {
                "error":
                    "Full name and password required"
            },
            status=400,
        )

    if User.objects.filter(
        username=full_name
    ).exists():

        return Response(
            {
                "error":
                    "User already exists"
            },
            status=400,
        )

    try:

        user = User.objects.create_user(
            username=full_name,
            email=email,
            password=password,
        )

        Account.objects.create(
            user=user,
            phone_number=phone,
        )

        return Response({

            "message":
                "User created successfully",

            "username":
                user.username,

            "email":
                user.email,

            "phone":
                phone,
        })

    except Exception as e:

        return Response(
            {
                "error": str(e)
            },
            status=500,
        )

# ================= LOGIN =================

@api_view(['POST'])
def login(request):

    full_name = request.data.get(
        'full_name',
        ''
    ).strip()

    password = request.data.get(
        'password',
        ''
    ).strip()

    if not full_name or not password:

        return Response(
            {
                "error":
                    "Missing credentials"
            },
            status=400,
        )

    user = authenticate(
        username=full_name,
        password=password,
    )

    if user is None:

        return Response(
            {
                "error":
                    "Invalid credentials"
            },
            status=400,
        )

    account = Account.objects.filter(
        user=user
    ).first()

    refresh = RefreshToken.for_user(
        user
    )

    return Response({

        "access":
            str(refresh.access_token),

        "refresh":
            str(refresh),

        "username":
            user.username,

        "email":
            user.email,

        "phone":
            account.phone_number
            if account and account.phone_number
            else "",
    })

# ================= PROFILE =================

@api_view(['GET', 'PUT'])
@permission_classes([IsAuthenticated])
def profile_view(request):

    account, created = (
        Account.objects.get_or_create(
            user=request.user
        )
    )

    # ================= GET =================

    if request.method == 'GET':

        return Response({

            "id":
                request.user.id,

            "username":
                request.user.username,

            "full_name":
                request.user.username,

            "email":
                request.user.email,

            "phone":
                account.phone_number
                if account.phone_number
                else "",

            "profile_image":
                request.build_absolute_uri(
                    account.pro_image.url
                )
                if account.pro_image
                else "",
        })

    # ================= UPDATE =================

    if request.method == 'PUT':

        full_name = request.data.get(
            'full_name',
            ''
        ).strip()

        email = request.data.get(
            'email',
            ''
        ).strip()

        phone = request.data.get(
            'phone',
            ''
        ).strip()

        password = request.data.get(
            'password',
            ''
        ).strip()

        # ================= USER UPDATE =================

        if full_name:
            request.user.username = (
                full_name
            )

        if email:
            request.user.email = email

        if password:
            request.user.set_password(
                password
            )

        request.user.save()

        # ================= ACCOUNT UPDATE =================

        if phone:
            account.phone_number = phone

        account.save()

        return Response({

            "message":
                "Profile updated successfully",

            "full_name":
                request.user.username,

            "email":
                request.user.email,

            "phone":
                account.phone_number,
        })

# ================= FLIGHT LIST =================

@api_view(['GET'])
def flight_list(request):

    flights = Flight.objects.all(
    ).order_by('-created_at')

    serializer = FlightSerializer(
        flights,
        many=True,
    )

    return Response(
        serializer.data
    )

# ================= CREATE FLIGHT =================

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_flight(request):

    data = request.data.copy()

    data['user'] = request.user.id

    serializer = FlightSerializer(
        data=data
    )

    if serializer.is_valid():

        serializer.save()

        return Response(
            serializer.data
        )

    return Response(
        serializer.errors,
        status=400,
    )

# ================= FLIGHT DETAIL =================

@api_view(['GET'])
def flight_detail(request, pk):

    try:

        flight = Flight.objects.get(
            id=pk
        )

    except Flight.DoesNotExist:

        return Response(
            {
                "error":
                    "Not found"
            },
            status=404,
        )

    serializer = FlightSerializer(
        flight
    )

    return Response(
        serializer.data
    )