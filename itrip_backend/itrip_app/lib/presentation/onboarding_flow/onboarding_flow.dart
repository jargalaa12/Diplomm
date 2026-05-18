import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../routes/app_routes.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {

  final PageController _pageController = PageController();

  int _currentPage = 0;

  /// 🇲🇳 ITRIP MONGOLIA PAGES
  final List<Map<String, dynamic>> _pages = [

    {
      "title": "Аяллаа Хялбараар Төлөвлө",

      "description":
          "iTrip Mongolia ашиглан дотоод болон гадаад аяллын шилдэг газруудыг олж, аяллаа хялбар төлөвлөөрэй.",

      "icon": Icons.travel_explore_rounded,
    },

    {
      "title": "Нислэг Ба Аяллаа Захиалах",

      "description":
          "Нислэг, аяллын багц болон үйлчилгээний мэдээллийг нэг дороос хурдан бөгөөд аюулгүй захиалах боломжтой.",

      "icon": Icons.flight_takeoff_rounded,
    },

    {
      "title": "Такси Ба Аяллын Үйлчилгээ",

      "description":
          "Такси дуудах, захиалгаа удирдах, аяллын бүх үйлчилгээг ухаалаг системээр хялбар ашиглаарай.",

      "icon": Icons.local_taxi_rounded,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 🚀 PAGE CHANGE
  void _onPageChanged(int page) {

    setState(() {
      _currentPage = page;
    });

    HapticFeedback.selectionClick();
  }

  /// 🚀 NEXT
  void _handleNext() {

    if (_currentPage < _pages.length - 1) {

      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

    } else {

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.login,
      );
    }
  }

  /// 🚀 SKIP
  void _handleSkip() {

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            /// 🔥 SKIP
            if (_currentPage != _pages.length - 1)

              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  right: 20,
                ),

                child: Align(
                  alignment: Alignment.topRight,

                  child: TextButton(
                    onPressed: _handleSkip,

                    child: const Text(
                      "Алгасах",

                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )

            else
              const SizedBox(height: 50),

            /// 🚀 PAGE VIEW
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: _onPageChanged,

                itemBuilder: (context, index) {

                  final item = _pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        /// ✈️ ICON BOX
                        Container(
                          width: 230,
                          height: 230,

                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,

                              colors: [
                                Color(0xffFF7A00),
                                Color(0xffFFB347),
                              ],
                            ),

                            borderRadius: BorderRadius.circular(50),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.25),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),

                          child: Icon(
                            item["icon"],
                            color: Colors.white,
                            size: 120,
                          ),
                        ),

                        const SizedBox(height: 60),

                        /// ✈️ TITLE
                        Text(
                          item["title"],
                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 31,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// ✈️ DESCRIPTION
                        Text(
                          item["description"],
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// 🚀 INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: List.generate(
                _pages.length,

                (index) {

                  return AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 300,
                    ),

                    margin: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),

                    width: _currentPage == index ? 28 : 10,
                    height: 10,

                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.orange
                          : Colors.orange.shade100,

                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 35),

            /// 🚀 BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  onPressed: _handleNext,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        _currentPage == _pages.length - 1
                            ? "Эхлэх"
                            : "Дараах",

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      if (_currentPage != _pages.length - 1) ...[

                        const SizedBox(width: 8),

                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}