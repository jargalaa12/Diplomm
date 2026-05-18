import 'dart:async';
import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _logoController;
  late AnimationController _textController;

  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    /// 🚀 LOGO ANIMATION
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    /// 🚀 TEXT ANIMATION
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 400), () {
      _textController.forward();
    });

    /// 🚀 NEXT PAGE
    Timer(const Duration(seconds: 8), () {

      /// 🔥 SPLASH -> ONBOARDING
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.onboarding,
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,

        /// 🌈 BACKGROUND
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xffFF7A00),
              Color(0xffFF9500),
              Color(0xffFFB347),
            ],
          ),
        ),

        child: Stack(
          children: [

            /// 🔥 TOP CIRCLE
            Positioned(
              top: -120,
              right: -80,
              child: Container(
                width: 260,
                height: 260,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            /// 🔥 BOTTOM CIRCLE
            Positioned(
              bottom: -140,
              left: -100,
              child: Container(
                width: 300,
                height: 300,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            /// 🚀 MAIN CONTENT
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    /// ✈️ AIR LOGO
                    ScaleTransition(
                      scale: _logoAnimation,

                      child: Container(
                        width: 170,
                        height: 170,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),

                        child: Center(
                          child: Container(
                            width: 110,
                            height: 110,

                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,

                                colors: [
                                  Color(0xffFF7A00),
                                  Color(0xffFFB347),
                                ],
                              ),

                              borderRadius: BorderRadius.circular(30),
                            ),

                            child: const Icon(
                              Icons.flight_takeoff_rounded,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// ✈️ TITLE
                    FadeTransition(
                      opacity: _textAnimation,

                      child: const Text(
                        'iTrip Mongolia',

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// ✈️ SUBTITLE
                    FadeTransition(
                      opacity: _textAnimation,

                      child: const Text(
                        'Explore • Discover • Travel',

                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 55),

                    /// ⏳ LOADING
                    Container(
                      width: 55,
                      height: 55,
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),

                      child: const CircularProgressIndicator(
                        strokeWidth: 3,

                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 📌 VERSION
            const Positioned(
              bottom: 25,
              left: 0,
              right: 0,

              child: Center(
                child: Text(
                  'Version 1.0.0',

                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}