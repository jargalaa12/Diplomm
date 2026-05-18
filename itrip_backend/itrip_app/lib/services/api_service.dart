import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // =====================================================
  // 🌍 BASE URL
  // =====================================================

  static const String baseUrl =
      "http://192.168.1.83:8000/api";

  static const String mediaBaseUrl =
      "http://192.168.1.83:8000";

  static String? token;

  // =====================================================
  // 🚀 INIT
  // =====================================================

  static Future<void> init() async {
    final prefs =
        await SharedPreferences.getInstance();

    token = prefs.getString("token");
  }

  // =====================================================
  // 🚪 LOGOUT
  // =====================================================

  static Future<void> logout() async {
    token = null;

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove("token");
  }

  // =====================================================
  // 🖼 IMAGE URL
  // =====================================================

  static String getImageUrl(
    String? imageUrl,
  ) {
    if (imageUrl == null ||
        imageUrl.isEmpty) {
      return "";
    }

    /// FULL URL
    if (imageUrl.startsWith("http")) {
      return imageUrl;
    }

    /// /media/...
    if (imageUrl.startsWith("/")) {
      return "$mediaBaseUrl$imageUrl";
    }

    /// media/...
    return "$mediaBaseUrl/$imageUrl";
  }

  // =====================================================
  // 🔐 LOGIN
  // =====================================================

  static Future<Map<String, dynamic>>
      loginUser(
    String email,
    String password,
  ) async {
    final url = Uri.parse(
      "$baseUrl/auth/login/",
    );

    final response = await _post(
      url,
      {
        "full_name": email,
        "password": password,
      },
    );

    token =
        response["access"] ??
        response["token"];

    if (token == null) {
      throw Exception(
        "Token ирсэнгүй ❌",
      );
    }

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      "token",
      token!,
    );

    return response;
  }

  // =====================================================
  // 📝 REGISTER
  // =====================================================

  static Future<Map<String, dynamic>>
      registerUser({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    final url = Uri.parse(
      "$baseUrl/auth/register/",
    );

    return await _post(
      url,
      {
        "full_name": fullName,
        "email": email,
        "password": password,
        "phone": phone,
      },
    );
  }

  // =====================================================
  // 👤 PROFILE
  // =====================================================

  static Future<Map<String, dynamic>>
      getProfile() async {
    final url = Uri.parse(
      "$baseUrl/auth/profile/",
    );

    final data = await _get(
      url,
      auth: true,
    );

    if (data is Map<String, dynamic>) {
      return data;
    }

    throw Exception(
      "Profile format буруу байна",
    );
  }

  // =====================================================
  // ✏️ UPDATE PROFILE
  // =====================================================

  static Future<Map<String, dynamic>>
      updateProfile({
    required String fullName,
    required String email,
    required String phone,
    String? password,
  }) async {
    final url = Uri.parse(
      "$baseUrl/auth/profile/",
    );

    final body = {
      "full_name": fullName,
      "email": email,
      "phone": phone,
    };

    if (password != null &&
        password.isNotEmpty) {
      body["password"] = password;
    }

    final response = await http.put(
      url,
      headers: await _headers(true),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // =====================================================
  // ✈️ FEATURED FLIGHTS
  // =====================================================

  static Future<List<dynamic>>
      getFeaturedFlights() async {
    final url = Uri.parse(
      "$baseUrl/flights/featured/",
    );

    final data = await _get(url);

    if (data is List) {
      return data;
    }

    throw Exception(
      "Flights format буруу байна",
    );
  }

  // =====================================================
  // 🔎 SEARCH FLIGHTS
  // =====================================================

  static Future<List<dynamic>>
      searchFlights({
    String? origin,
    String? destination,
    String? date,
  }) async {
    final params =
        <String, String>{};

    if (origin != null &&
        origin.isNotEmpty) {
      params["origin"] = origin;
    }

    if (destination != null &&
        destination.isNotEmpty) {
      params["destination"] =
          destination;
    }

    if (date != null &&
        date.isNotEmpty) {
      params["date"] = date;
    }

    final url = Uri.parse(
      "$baseUrl/flights/search/",
    ).replace(
      queryParameters:
          params.isNotEmpty
              ? params
              : null,
    );

    final data = await _get(url);

    if (data is List) {
      return data;
    }

    throw Exception(
      "Search flights format буруу байна",
    );
  }

  // =====================================================
  // 📅 TODAY FLIGHTS
  // =====================================================

  static Future<List<dynamic>>
      getTodayFlights() async {
    final url = Uri.parse(
      "$baseUrl/flights/today-schedule/",
    );

    final data = await _get(url);

    if (data is List) {
      return data;
    }

    throw Exception(
      "Today flights format буруу байна",
    );
  }

  // =====================================================
  // 🧳 TOURS
  // =====================================================

  static Future<List<dynamic>>
      getTours({
    String? location,
    String? date,
  }) async {
    final params =
        <String, String>{};

    if (location != null &&
        location.isNotEmpty) {
      params["location"] =
          location;
    }

    if (date != null &&
        date.isNotEmpty) {
      params["date"] = date;
    }

    final url = Uri.parse(
      "$baseUrl/trips/packages/",
    ).replace(
      queryParameters:
          params.isNotEmpty
              ? params
              : null,
    );

    final data = await _get(url);

    if (data is List) {
      return data;
    }

    throw Exception(
      "Tours format буруу байна",
    );
  }

  // =====================================================
  // 🧳 TOUR DETAIL
  // =====================================================

  static Future<Map<String, dynamic>>
      getTourDetail(
    int id,
  ) async {
    final url = Uri.parse(
      "$baseUrl/trips/packages/$id/",
    );

    final data = await _get(url);

    if (data is Map<String, dynamic>) {
      return data;
    }

    throw Exception(
      "Tour detail format буруу байна",
    );
  }

  // =====================================================
  // 📖 BOOKINGS
  // =====================================================

  static Future<List<dynamic>>
      getBookings() async {
    final url = Uri.parse(
      "$baseUrl/trips/bookings/",
    );

    final data = await _get(
      url,
      auth: true,
    );

    if (data is List) {
      return data;
    }

    throw Exception(
      "Bookings format буруу байна",
    );
  }

  // =====================================================
  // 🧾 CREATE TOUR BOOKING
  // =====================================================

  static Future<Map<String, dynamic>>
      createBooking({
    required int tourId,
    required int scheduleId,
    required int people,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    final url = Uri.parse(
      "$baseUrl/trips/bookings/",
    );

    return await _post(
      url,
      {
        "tour": tourId,
        "schedule": scheduleId,
        "people": people,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
      },
      auth: true,
    );
  }

  // =====================================================
  // ✈️ CREATE FLIGHT BOOKING
  // =====================================================

  static Future<Map<String, dynamic>>
      createFlightBooking({
    required int flightId,
    required String firstName,
    required String lastName,
    required String gender,
    required String nationality,
    required String birthDate,
    required String passportNumber,
    required String passportExpireDate,
    String email = "",
    String phone = "",
    int people = 1,
  }) async {
    final url = Uri.parse(
      "$baseUrl/trips/bookings/",
    );

    return await _post(
      url,
      {
        "flight": flightId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "birth_date": birthDate,
        "gender": gender,
        "nationality": nationality,
        "passport_number":
            passportNumber,
        "passport_expire_date":
            passportExpireDate,
        "people": people,
      },
      auth: true,
    );
  }

  // =====================================================
  // 🚕 TAXI
  // =====================================================

  static Future<List<dynamic>>
      getTaxi({
    String? location,
  }) async {
    final params =
        <String, String>{};

    if (location != null &&
        location.isNotEmpty) {
      params["location"] =
          location;
    }

    final url = Uri.parse(
      "$baseUrl/taxi/",
    ).replace(
      queryParameters:
          params.isNotEmpty
              ? params
              : null,
    );

    final data = await _get(url);

    if (data is List) {
      return data;
    }

    throw Exception(
      "Taxi format буруу байна",
    );
  }

  // =====================================================
  // 🚕 CREATE TAXI BOOKING
  // =====================================================

  static Future<Map<String, dynamic>>
      createTaxiBooking({
    required int taxiId,
    required String firstName,
    required String phone,
    required String email,
    required String district,
    required String khoroo,
    required String apartment,
    required String street,
    required String detailAddress,
    required String flightNumber,
    required String pickupDate,
    required String pickupTime,
    String note = "",
  }) async {
    final url = Uri.parse(
      "$baseUrl/trips/bookings/",
    );

    return await _post(
      url,
      {
        "taxi": taxiId,
        "first_name":
            firstName,
        "last_name": "Taxi",
        "phone": phone,
        "email": email,
        "flight_number":
            flightNumber,
        "pickup_date":
            pickupDate,
        "pickup_time":
            pickupTime,
        "district": district,
        "khoroo": khoroo,
        "apartment": apartment,
        "street": street,
        "detail_address":
            detailAddress,
        "people": 1,
        "note": note,
      },
      auth: true,
    );
  }

  // =====================================================
  // ❤️ FAVORITES
  // =====================================================

  static Future<List<dynamic>>
      getFavorites() async {
    final url = Uri.parse(
      "$baseUrl/trips/favorites/",
    );

    final data = await _get(
      url,
      auth: true,
    );

    if (data is List) {
      return data;
    }

    throw Exception(
      "Favorites format буруу байна",
    );
  }

  // =====================================================
  // ❤️ ADD FAVORITE
  // =====================================================

  static Future<Map<String, dynamic>>
      addFavorite(
    int tourId,
  ) async {
    final url = Uri.parse(
      "$baseUrl/trips/favorites/",
    );

    return await _post(
      url,
      {
        "tour": tourId,
      },
      auth: true,
    );
  }

  // =====================================================
  // ❤️ REMOVE FAVORITE
  // =====================================================

  static Future<void>
      removeFavorite(
    int favoriteId,
  ) async {
    final url = Uri.parse(
      "$baseUrl/trips/favorites/$favoriteId/",
    );

    final response = await http.delete(
      url,
      headers: await _headers(true),
    );

    if (response.statusCode != 204 &&
        response.statusCode != 200) {
      throw Exception(
        "Favorite устгаж чадсангүй ❌",
      );
    }
  }

  // =====================================================
  // 🌍 GET
  // =====================================================

  static Future<dynamic> _get(
    Uri url, {
    bool auth = false,
  }) async {
    print("GET URL => $url");

    final response = await http.get(
      url,
      headers: await _headers(auth),
    );

    return _handleResponse(response);
  }

  // =====================================================
  // 📤 POST
  // =====================================================

  static Future<Map<String, dynamic>>
      _post(
    Uri url,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    print("POST URL => $url");

    print("BODY => $body");

    final response = await http.post(
      url,
      headers: await _headers(auth),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // =====================================================
  // 📦 HEADERS
  // =====================================================

  static Future<Map<String, String>>
      _headers(
    bool auth,
  ) async {
    final headers = {
      "Content-Type":
          "application/json",
    };

    if (auth) {
      if (token == null) {
        final prefs =
            await SharedPreferences
                .getInstance();

        token =
            prefs.getString("token");
      }

      if (token == null) {
        throw Exception(
          "Та login хийгээгүй байна ❌",
        );
      }

      headers["Authorization"] =
          "Bearer $token";
    }

    return headers;
  }

  // =====================================================
  // 🔥 HANDLE RESPONSE
  // =====================================================

  static dynamic _handleResponse(
    http.Response response,
  ) {
    dynamic data;

    try {
      data = jsonDecode(
        response.body,
      );
    } catch (_) {
      throw Exception(
        "JSON parse error ❌",
      );
    }

    print(
      "STATUS CODE => ${response.statusCode}",
    );

    print(
      "RESPONSE => $data",
    );

    /// SUCCESS
    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return data;
    }

    /// 400
    if (response.statusCode == 400) {
      throw Exception(
        "400 Error => $data",
      );
    }

    /// 401
    if (response.statusCode == 401) {
      throw Exception(
        "Unauthorized ❌",
      );
    }

    /// 404
    if (response.statusCode == 404) {
      throw Exception(
        "API олдсонгүй ❌",
      );
    }

    throw Exception(
      data.toString(),
    );
  }
}