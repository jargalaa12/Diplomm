import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../services/api_service.dart';

class HomeScreenInitialPage extends StatefulWidget {

  const HomeScreenInitialPage({
    super.key,
  });

  @override
  State<HomeScreenInitialPage> createState() =>
      _HomeScreenInitialPageState();
}

class _HomeScreenInitialPageState
    extends State<HomeScreenInitialPage> {

  final GlobalKey<ScaffoldState>
      _scaffoldKey =
      GlobalKey<ScaffoldState>();

  final PageController
      _bannerController =
      PageController();

  Timer? _bannerTimer;

  int _currentBannerIndex = 0;

  // =====================================================
  // DATA
  // =====================================================

  List<dynamic> _featuredTours = [];

  List<dynamic> _banners = [];

  bool _isToursLoading = true;

  bool _isBannerLoading = true;

  // =====================================================
  // SERVICES
  // =====================================================

  final List<Map<String, dynamic>>
      _services = [

    {
      "title": "Нислэг",
      "icon": Icons.flight_rounded,
      "route":
          "/flight-section-screen",
    },

    {
      "title": "Аялал",
      "icon": Icons.explore_rounded,
      "route":
          "/tours-section-screen",
    },

    {
      "title": "Такси",
      "icon": Icons.local_taxi_rounded,
      "route":
          "/taxi-section-screen",
    },
  ];

  // =====================================================
  // INIT
  // =====================================================

  @override
  void initState() {

    super.initState();

    _loadFeaturedTours();

    _loadBanners();

  }

  @override
  void dispose() {

    _bannerTimer?.cancel();

    _bannerController.dispose();

    super.dispose();
  }

  // =====================================================
  // AUTO SLIDE
  // =====================================================

  void _startBannerAutoSlide() {

    _bannerTimer?.cancel();

    _bannerTimer = Timer.periodic(

      const Duration(seconds: 5),

      (timer) {

        if (_banners.isEmpty) return;

        if (!_bannerController.hasClients) {
          return;
        }

        int nextPage =
            _currentBannerIndex + 1;

        if (nextPage >=
            _banners.length) {

          nextPage = 0;
        }
          _currentBannerIndex =
            nextPage;
        _bannerController.animateToPage(

          nextPage,

          duration: const Duration(
            milliseconds: 700,
          ),

          curve: Curves.easeInOut,
        );
      },
    );
  }

  // =====================================================
  // LOAD TOURS
  // =====================================================

  Future<void>
      _loadFeaturedTours() async {

    try {

      final data =
          await ApiService.getTours();

      if (mounted) {

        setState(() {

          _featuredTours = data;

          _isToursLoading = false;
        });
      }

    } catch (e) {

      print(
        "❌ TOUR ERROR => $e",
      );

      if (mounted) {

        setState(() {

          _isToursLoading = false;
        });
      }
    }
  }

  // =====================================================
  // LOAD BANNERS
  // =====================================================

  Future<void> _loadBanners() async {

    try {

      final data =
          await ApiService.getTours();

      if (mounted) {

        setState(() {

          _banners =
              data.take(5).toList();

          _isBannerLoading = false;
          
        });

        _startBannerAutoSlide();
      }

    } catch (e) {

      print(
        "❌ BANNER ERROR => $e",
      );

      if (mounted) {

        setState(() {

          _isBannerLoading = false;
        });
      }
    }
  }

  // =====================================================
  // NAVIGATION
  // =====================================================

  void _navigateToService(
    String route,
  ) {

   Navigator.of(
  context,
  rootNavigator: true,
).pushNamed(route);
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      key: _scaffoldKey,

      backgroundColor:
          const Color(0xFFF7F8FA),

      drawer: _buildDrawer(),

      body: SafeArea(

        child: Column(

          children: [

            _buildTopBar(),

            Expanded(

              child:
                  SingleChildScrollView(

                physics:
                    const BouncingScrollPhysics(),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    SizedBox(
                      height: 1.5.h,
                    ),

                    _buildWelcomeSection(),

                    SizedBox(
                      height: 2.h,
                    ),

                    _buildServicesGrid(),

                    SizedBox(
                      height: 2.h,
                    ),

                    _buildBannerCarousel(),

                    SizedBox(
                      height: 2.5.h,
                    ),

                    _buildFeaturedTours(),

                    SizedBox(
                      height: 3.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // TOP BAR
  // =====================================================

  Widget _buildTopBar() {

    return Padding(

      padding:
          EdgeInsets.symmetric(
        horizontal: 5.w,
        vertical: 1.h,
      ),

      child: Row(

        children: [

          GestureDetector(

            onTap: () {

              _scaffoldKey
                  .currentState
                  ?.openDrawer();
            },

            child: Container(

              padding:
                  const EdgeInsets.all(
                9,
              ),

              decoration:
                  BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),

                boxShadow: [

                  BoxShadow(

                    color:
                        Colors.black
                            .withOpacity(
                      0.04,
                    ),

                    blurRadius: 10,
                  ),
                ],
              ),

              child: const Icon(

                Icons.menu_rounded,

                size: 0,

                color:
                    Color(0xFF111827),
              ),
            ),
          ),

          const Spacer(),

          Container(

            padding:
                const EdgeInsets.all(
              9,
            ),

            decoration:
                BoxDecoration(

              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                14,
              ),

              boxShadow: [

                BoxShadow(

                  color:
                      Colors.black
                          .withOpacity(
                    0.04,
                  ),

                  blurRadius: 10,
                ),
              ],
            ),

            child: const Icon(

              Icons.notifications_none_rounded,

              size: 1,

              color:
                  Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // WELCOME
  // =====================================================

  Widget _buildWelcomeSection() {

    return Padding(

      padding:
          EdgeInsets.symmetric(
        horizontal: 5.w,
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(

            "Сайн байна уу 👋",

            style:
                GoogleFonts.dmSans(

              fontSize: 10.sp,

              fontWeight:
                  FontWeight.w500,

              color:
                  Colors.grey.shade600,
            ),
          ),

          SizedBox(height: 0.3.h),

          Text(

            "Аяллаа эхлүүлээрэй",

            style:
                GoogleFonts.dmSans(

              fontSize: 16.sp,

              fontWeight:
                  FontWeight.bold,

              color:
                  const Color(
                0xFF111827,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // SERVICES
  // =====================================================

  Widget _buildServicesGrid() {

    return Padding(

      padding:
          EdgeInsets.symmetric(
        horizontal: 5.w,
      ),

      child: Row(

        children: _services.map((service) {

          return Expanded(

            child: GestureDetector(

              onTap: () {

                _navigateToService(
                  service["route"],
                );
              },

              child: Container(

                margin:
                    EdgeInsets.only(
                  right:
                      service !=
                              _services.last
                          ? 2.5.w
                          : 0,
                ),

                padding:
                    EdgeInsets.symmetric(
                  vertical: 1.6.h,
                ),

                decoration:
                    BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),

                  boxShadow: [

                    BoxShadow(

                      color:
                          Colors.black
                              .withOpacity(
                        0.04,
                      ),

                      blurRadius: 12,
                    ),
                  ],
                ),

                child: Column(

                  children: [

                    Container(

                      width: 11.w,

                      height: 11.w,

                      decoration:
                          BoxDecoration(

                        color:
                            const Color(
                          0xFFFFF4EB,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: Icon(

                        service["icon"],

                        color:
                            const Color(
                          0xFFFF7A00,
                        ),

                        size: 20,
                      ),
                    ),

                    SizedBox(height: 0.8.h),

                    Text(

                      service["title"],

                      style:
                          GoogleFonts.dmSans(

                        fontSize: 9.8.sp,

                        fontWeight:
                            FontWeight.w700,

                        color:
                            const Color(
                          0xFF111827,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // =====================================================
  // BANNER
  // =====================================================

  Widget _buildBannerCarousel() {

    if (_isBannerLoading) {

      return SizedBox(

        height: 22.h,

        child: const Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (_banners.isEmpty) {

      return const SizedBox();
    }

    return Column(

      children: [

        SizedBox(

          height: 22.h,

          child: PageView.builder(

            controller:
                _bannerController,

            itemCount:
                _banners.length,

            onPageChanged: (index) {

              setState(() {

                _currentBannerIndex =
                    index;
              });
            },

            itemBuilder:
                (context, index) {

              final banner =
                  _banners[index];

              final imageUrl =
                  banner["image"]
                          ?.toString() ??
                      "";

              return Padding(

                padding:
                    EdgeInsets.symmetric(
                  horizontal: 5.w,
                ),

                child: GestureDetector(

                  onTap: () {

                    final int? tourId =

                        banner["id"] is int

                            ? banner["id"]

                            : int.tryParse(
                                banner["id"]
                                    .toString(),
                              );

                    if (tourId != null) {
    Navigator.of(
  context,
  rootNavigator: true,
).pushNamed(

  "/tours-detail-page",

  arguments: tourId,
);;
                    }
                  },

                  child: ClipRRect(

                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),

                    child: Stack(

                      fit: StackFit.expand,

                      children: [

                        Image.network(

                          imageUrl,

                          fit: BoxFit.cover,

                          errorBuilder: (

                            context,
                            error,
                            stackTrace,

                          ) {

                            return Container(

                              color:
                                  Colors.grey
                                      .shade300,

                              child:
                                  const Center(

                                child: Icon(

                                  Icons
                                      .broken_image_rounded,

                                  size: 55,

                                  color:
                                      Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),

                        Container(

                          decoration:
                              BoxDecoration(

                            gradient:
                                LinearGradient(

                              begin:
                                  Alignment
                                      .bottomCenter,

                              end:
                                  Alignment
                                      .topCenter,

                              colors: [

                                Colors.black
                                    .withOpacity(
                                  0.65,
                                ),

                                Colors.black
                                    .withOpacity(
                                  0.05,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Positioned(

                          left: 20,
                          right: 20,
                          bottom: 20,

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(

                                banner["name"]
                                        ?.toString() ??
                                    "Онцлох аялал",

                                style:
                                    GoogleFonts
                                        .dmSans(

                                  color:
                                      Colors.white,

                                  fontSize:
                                      14.sp,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              SizedBox(
                                height: 0.5.h,
                              ),

                              Text(

                                banner["location"]
                                        ?.toString() ??
                                    "Монгол улс",

                                style:
                                    GoogleFonts
                                        .dmSans(

                                  color:
                                      Colors.white70,

                                  fontSize:
                                      9.5.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 1.2.h),

        Row(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: List.generate(

            _banners.length,

            (index) {

              return AnimatedContainer(

                duration:
                    const Duration(
                  milliseconds: 300,
                ),

                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 4,
                ),

                width:
                    _currentBannerIndex ==
                            index
                        ? 24
                        : 8,

                height: 8,

                decoration:
                    BoxDecoration(

                  color:
                      _currentBannerIndex ==
                              index

                          ? Colors.orange

                          : Colors.orange
                              .shade100,

                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // =====================================================
  // FEATURED TOURS
  // =====================================================

  Widget _buildFeaturedTours() {

    if (_isToursLoading) {

      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    if (_featuredTours.isEmpty) {

      return const SizedBox();
    }

    return Padding(

      padding:
          EdgeInsets.symmetric(
        horizontal: 5.w,
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(

            "Онцлох аялал",

            style:
                GoogleFonts.dmSans(

              fontSize: 13.sp,

              fontWeight:
                  FontWeight.bold,

              color:
                  const Color(
                0xFF111827,
              ),
            ),
          ),

          SizedBox(height: 1.5.h),

          SizedBox(

            height: 31.h,

            child: ListView.builder(

              scrollDirection:
                  Axis.horizontal,

              itemCount:
                  _featuredTours.length,

              itemBuilder:
                  (context, index) {

                final tour =
                    _featuredTours[index];

                final imageUrl =
                    tour["image"]
                            ?.toString() ??
                        "";

                return GestureDetector(

                  onTap: () {

                    final int? tourId =

                        tour["id"] is int

                            ? tour["id"]

                            : int.tryParse(
                                tour["id"]
                                    .toString(),
                              );

                    if (tourId != null) {

                     Navigator.of(
  context,
  rootNavigator: true,
).pushNamed(

  "/tours-detail-page",

  arguments: tourId,
);

                       
                    }
                  },

                  child: Container(

                    width: 55.w,

                    margin:
                        EdgeInsets.only(
                      right: 4.w,
                    ),

                    decoration:
                        BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),

                      boxShadow: [

                        BoxShadow(

                          color:
                              Colors.black
                                  .withOpacity(
                            0.05,
                          ),

                          blurRadius: 10,
                        ),
                      ],
                    ),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        ClipRRect(

                          borderRadius:
                              const BorderRadius.only(

                            topLeft:
                                Radius.circular(
                              24,
                            ),

                            topRight:
                                Radius.circular(
                              24,
                            ),
                          ),

                          child: Image.network(

                            imageUrl,

                            height: 18.h,

                            width:
                                double.infinity,

                            fit: BoxFit.cover,

                            errorBuilder: (

                              context,
                              error,
                              stackTrace,

                            ) {

                              return Container(

                                height: 18.h,

                                color:
                                    Colors.grey
                                        .shade300,

                                child:
                                    const Center(

                                  child: Icon(

                                    Icons
                                        .broken_image_rounded,

                                    size: 50,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        Expanded(

                          child: Padding(

                            padding:
                                EdgeInsets.all(
                              3.w,
                            ),

                            child: Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(

                                  tour["name"]
                                          ?.toString() ??
                                      "",

                                  maxLines: 1,

                                  overflow:
                                      TextOverflow
                                          .ellipsis,

                                  style:
                                      GoogleFonts
                                          .dmSans(

                                    fontSize:
                                        11.sp,

                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                SizedBox(
                                  height: 0.5.h,
                                ),

                                Text(

                                  tour["location"]
                                          ?.toString() ??
                                      "",

                                  maxLines: 1,

                                  overflow:
                                      TextOverflow
                                          .ellipsis,

                                  style:
                                      GoogleFonts
                                          .dmSans(

                                    fontSize:
                                        9.sp,

                                    color:
                                        Colors
                                            .grey
                                            .shade600,
                                  ),
                                ),

                                const Spacer(),

                                Text(

                                  "${tour["price"]?.toString() ?? "0"}₮",

                                  style:
                                      GoogleFonts
                                          .dmSans(

                                    fontSize:
                                        12.sp,

                                    fontWeight:
                                        FontWeight
                                            .bold,

                                    color:
                                        Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // DRAWER
  // =====================================================

  Widget _buildDrawer() {

    return Drawer(

      child: SafeArea(

        child: Column(

          children: [

            SizedBox(height: 4.h),

            CircleAvatar(

              radius: 34,

              backgroundColor:
                  Colors.orange
                      .shade100,

              child: const Icon(

                Icons.person,

                size: 36,

                color: Colors.orange,
              ),
            ),

            SizedBox(height: 1.5.h),

            Text(

              "iTrip Mongolia",

              style:
                  GoogleFonts.dmSans(

                fontSize: 13.sp,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            SizedBox(height: 4.h),

            ListTile(

              leading: const Icon(
                Icons.home_rounded,
              ),

              title: const Text(
                "Нүүр",
              ),

              onTap: () {

                Navigator.pop(context);
              },
            ),

            ListTile(

              leading: const Icon(
                Icons.explore_rounded,
              ),

              title: const Text(
                "Аялал",
              ),

              onTap: () {

                Navigator.pushNamed(

                  context,

                  "/tours-section-screen",
                );
              },
            ),

            ListTile(

              leading: const Icon(
                Icons.flight_rounded,
              ),

              title: const Text(
                "Нислэг",
              ),

              onTap: () {

                Navigator.pushNamed(

                  context,

                  "/flight-section-screen",
                );
              },
            ),

            ListTile(

              leading: const Icon(
                Icons.local_taxi_rounded,
              ),

              title: const Text(
                "Такси",
              ),

              onTap: () {

                Navigator.pushNamed(

                  context,

                  "/taxi-section-screen",
                );
              },
            ),

            const Spacer(),

            ListTile(

              leading: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
              ),

              title: const Text(
                "Гарах",
              ),

              onTap: () async {

                await ApiService.logout();

                if (mounted) {

                  Navigator.pushNamedAndRemoveUntil(

                    context,

                    "/login-screen",

                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}