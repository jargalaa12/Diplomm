import 'package:flutter/material.dart';

/// 🌍 SCREENS
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';

import '../presentation/login_screen/login_screen.dart';
import '../presentation/login_screen/register_page.dart';

import '../presentation/home_screen/home_screen.dart';
import '../presentation/profile_page/profile_page.dart';

import '../presentation/taxi_section_screen/taxi_section_screen.dart';
import '../presentation/taxi_section_screen/taxi_booking_page.dart';

import '../presentation/featured_flights_screen/featured_flights_screen.dart';
import '../presentation/ontsgoii_screen/ontsgoii_screen.dart';
import '../presentation/flight_section_screen/flight_section_screen.dart';

import '../presentation/bookings_screen/bookings_screen.dart';

/// 🔥 TOUR SCREENS
import '../presentation/tours_section_screen/tours_section_screen.dart'
    as section;

import '../presentation/tours_detail_page/tours_detail_page.dart'
    as detail;

class AppRoutes {

  /// 🚀 INITIAL
  static const String initial = '/';

  /// 🚀 SPLASH
  static const String splashScreen = '/splash-screen';

  /// 🚀 ONBOARDING
  static const String onboarding = '/onboarding-flow';

  /// 🔐 AUTH
  static const String login = '/login-screen';
  static const String register = '/register-screen';

  /// 🏠 MAIN
  static const String home = '/home-screen';
  static const String profile = '/profile-page';

  /// 🚕 TAXI
  static const String taxi = '/taxi-section-screen';
  static const String taxiBooking = '/taxi-booking-page';

  /// ✈️ FLIGHT
  static const String featuredFlights = '/featured-flights-screen';
  static const String ontsgoii = '/ontsgoii-screen';
  static const String flightSection = '/flight-section-screen';

  /// 🧳 TOURS
  static const String toursSection = '/tours-section-screen';
  static const String toursDetail = '/tours-detail-page';
  static const String tripsScreen = '/trips-screen';

  /// 📖 BOOKINGS
  static const String bookingsScreen = '/bookings-screen';

  /// 💬 MESSAGE
  static const String messagesScreen = '/messages-screen';

  /// 🌍 ROUTES
  static Map<String, WidgetBuilder> routes = {

    /// 🚀 SPLASH
    splashScreen: (_) => const SplashScreen(),

    /// 🚀 ONBOARDING
    onboarding: (_) => const OnboardingFlow(),

    /// 🔐 AUTH
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterPage(),

    /// 🏠 MAIN
    home: (_) => const HomeScreen(),
    profile: (_) => const ProfilePage(),

    /// 🚕 TAXI
    taxi: (_) => const TaxiSectionScreen(),

    /// ✈️ FLIGHT
    featuredFlights: (_) => const FeaturedFlightsScreen(),
    ontsgoii: (_) => const OntsgoiiScreen(),
    flightSection: (_) => const FlightSectionScreen(),

    /// 📖 BOOKINGS
    bookingsScreen: (_) => const BookingsScreen(),

    /// 🧳 TOURS
    /// 🧳 TOURS
toursSection: (_) =>
    const section.ToursSectionScreen(),

tripsScreen: (_) =>
    const section.ToursSectionScreen(),
  };

  /// 🚀 GENERATE ROUTE
  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {

    switch (settings.name) {

      /// 🚀 SPLASH
      case splashScreen:
        return _route(
          const SplashScreen(),
        );

      /// 🚀 ONBOARDING
      case onboarding:
        return _route(
          const OnboardingFlow(),
        );

      /// 🔐 LOGIN
      case initial:
      case login:
        return _route(
          const LoginScreen(),
        );

      /// 🔐 REGISTER
      case register:
        return _route(
          const RegisterPage(),
        );

      /// 🏠 HOME
      case home:
        return _route(
          const HomeScreen(),
        );

      /// 👤 PROFILE
      case profile:
        return _route(
          const ProfilePage(),
        );

      /// 🚕 TAXI
      case taxi:
        return _route(
          const TaxiSectionScreen(),
        );

      /// 🚕 TAXI BOOKING
      case taxiBooking:
        final args = settings.arguments;

        if (args is Map<String, dynamic>) {
          return _route(
            TaxiBookingPage(
              taxi: args,
            ),
          );
        }

        return _errorRoute(
          "Taxi мэдээлэл буруу байна",
        );

      /// 🧳 TOURS
      case toursSection:
      case tripsScreen:
        return _route(
          const section.ToursSectionScreen(),
        );

      /// 🧳 TOUR DETAIL
      case toursDetail:
        final args = settings.arguments;

        if (args is int) {
          return _route(
            detail.ToursDetailPage(
              id: args,
            ),
          );
        }

        return _errorRoute(
          "Аяллын ID буруу байна",
        );

      /// ✈️ FEATURED FLIGHTS
      case featuredFlights:
        return _route(
          const FeaturedFlightsScreen(),
        );

      /// ✈️ ONTSGOII
      case ontsgoii:
        return _route(
          const OntsgoiiScreen(),
        );

      /// ✈️ FLIGHT SECTION
      case flightSection:
        return _route(
          const FlightSectionScreen(),
        );

      /// 📖 BOOKINGS
      case bookingsScreen:
        return _route(
          const BookingsScreen(),
        );

      /// 💬 MESSAGE
      case messagesScreen:
        return _route(
          const _ComingSoonScreen(
            title: 'Зурвас',
          ),
        );

      /// ❌ DEFAULT
      default:
        return _errorRoute(
          "Page not found",
        );
    }
  }

  /// 🎬 ROUTE
  static MaterialPageRoute _route(
    Widget page,
  ) {
    return MaterialPageRoute(
      builder: (_) => page,
    );
  }

  /// ❌ ERROR PAGE
  static MaterialPageRoute _errorRoute(
    String message,
  ) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        backgroundColor: Colors.white,

        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Icon(
                  Icons.error_outline_rounded,
                  size: 80,
                  color: Colors.orange.shade400,
                ),

                const SizedBox(height: 25),

                Text(
                  message,
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  "Something went wrong",

                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 35),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 15,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  },

                  child: const Text(
                    "Go Back",

                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ⏳ COMING SOON
class _ComingSoonScreen extends StatelessWidget {

  final String title;

  const _ComingSoonScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        centerTitle: true,

        title: Text(
          title,

          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.access_time_rounded,
              size: 90,
              color: Colors.orange.shade400,
            ),

            const SizedBox(height: 25),

            const Text(
              "Удахгүй нэмэгдэнэ",

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "This feature is coming soon",

              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}