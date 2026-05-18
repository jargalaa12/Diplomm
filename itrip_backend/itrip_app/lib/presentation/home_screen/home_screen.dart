import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_bar.dart';
import './home_screen_initial_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  int currentIndex = 0;

  // ✅ BottomBar-тай таарсан route order
  final List<String> routes = [
    '/home-screen',       // 0 → Нүүр
    '/bookings-screen',   // 1 → Захиалга
    '/ontsgoii-screen',   // 2 → Онцгой
    '/profile-page',      // 3 → Профайл
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        initialRoute: '/home-screen',
        onGenerateRoute: (RouteSettings settings) {
          final String routeName = settings.name ?? '/home-screen';

          switch (routeName) {
            case '/':
            case '/home-screen':
              return MaterialPageRoute(
                builder: (context) => const HomeScreenInitialPage(),
                settings: settings,
              );

            default:
              if (AppRoutes.routes.containsKey(routeName)) {
                return MaterialPageRoute(
                  builder: AppRoutes.routes[routeName]!,
                  settings: settings,
                );
              }

              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(
                    child: Text('Page not found'),
                  ),
                ),
              );
          }
        },
      ),

      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          final String route = routes[index];

          if (!AppRoutes.routes.containsKey(route)) return;

          if (currentIndex != index) {
            setState(() => currentIndex = index);

            navigatorKey.currentState
                ?.pushReplacementNamed(route);
          }
        },
      ),
    );
  }
}