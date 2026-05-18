import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../services/api_service.dart';

import './widgets/booking_bottom_sheet_widget.dart';
import './widgets/tour_description_widget.dart';
import './widgets/tour_header_widget.dart';
import './widgets/tour_info_widget.dart';
import './widgets/tour_itinerary_widget.dart';
import './widgets/tour_reviews_widget.dart';

class ToursDetailPage extends StatefulWidget {

  final int id;

  const ToursDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<ToursDetailPage> createState() =>
      _ToursDetailPageState();
}

class _ToursDetailPageState
    extends State<ToursDetailPage> {

  Map<String, dynamic>? tourData;

  bool isLoading = true;

  String? error;

  // ❤️ FAVORITE
  bool isFavorite = false;

  int? favoriteId;

  @override
  void initState() {

    super.initState();

    fetchTour();

    checkFavorite();
  }

  // =====================================================
  // CHECK FAVORITE
  // =====================================================

  Future<void> checkFavorite() async {

    try {

      final favorites =
          await ApiService.getFavorites();

      for (var item in favorites) {

        if (item["tour"] == widget.id) {

          setState(() {

            isFavorite = true;

            favoriteId = item["id"];
          });

          break;
        }
      }

    } catch (e) {

      print(e);
    }
  }

  // =====================================================
  // TOGGLE FAVORITE
  // =====================================================

  Future<void> toggleFavorite() async {

    try {

      // ❤️ ADD FAVORITE
      if (!isFavorite) {

        final response =
            await ApiService.addFavorite(
          widget.id,
        );

        setState(() {

          isFavorite = true;

          favoriteId =
              response["id"];
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            backgroundColor:
                Colors.orange,

            content: Text(
              "❤️ Дуртай аялалд нэмэгдлээ",
            ),
          ),
        );
      }

      // 💔 REMOVE FAVORITE
      else {

        await ApiService.removeFavorite(
          favoriteId!,
        );

        setState(() {

          isFavorite = false;

          favoriteId = null;
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            backgroundColor:
                Colors.orange,

            content: Text(
              "💔 Дуртай аяллаас хасагдлаа",
            ),
          ),
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          backgroundColor: Colors.red,
          content: Text("$e"),
        ),
      );
    }
  }

  // =====================================================
  // FETCH TOUR
  // =====================================================

  Future<void> fetchTour() async {

    try {

      final data =
          await ApiService.getTourDetail(
        widget.id,
      );

      setState(() {

        tourData = data;

        isLoading = false;
      });

    } catch (e) {

      setState(() {

        error = "Алдаа: ${e.toString()}";

        isLoading = false;
      });
    }
  }

  // =====================================================
  // PARSE LIST
  // =====================================================

  List<String> parseToList(
    dynamic value,
  ) {

    if (value == null) return [];

    if (value is List) {
      return List<String>.from(value);
    }

    if (value is String) {

      return value
          .split(RegExp(r'\r?\n'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return [];
  }

  // =====================================================
  // PARSE MAP LIST
  // =====================================================

  List<Map<String, dynamic>>
      parseToMapList(
    dynamic value,
  ) {

    if (value is List) {

      return List<Map<String, dynamic>>
          .from(value);
    }

    return [];
  }

  // =====================================================
  // BOOKING
  // =====================================================

  void _showBookingSheet() {

    if (tourData == null) return;

    final schedules =
        tourData!["schedules"] ?? [];

    if (schedules.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Огноо байхгүй байна",
          ),
        ),
      );

      return;
    }

    showModalBottomSheet(

      context: context,

      isScrollControlled: true,

      backgroundColor:
          Colors.transparent,

      builder: (context) =>
          BookingBottomSheetWidget(

        tourTitle:
            tourData!["name"] ?? "Tour",

        schedules: schedules,

        tourId: widget.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      );
    }

    if (error != null) {

      return Scaffold(
        body: Center(
          child: Text(error!),
        ),
      );
    }

    if (tourData == null) {

      return const Scaffold(
        body: Center(
          child: Text(
            "Мэдээлэл олдсонгүй",
          ),
        ),
      );
    }

    final imageUrl =
        tourData!["image"] != null

            ? ApiService.getImageUrl(
                tourData!["image"],
              )

            : null;

    return Theme(

      data: Theme.of(context).copyWith(

        colorScheme:
            ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),
      ),

      child: Scaffold(

        backgroundColor:
            const Color(0xFFF7F7F7),

        body: Stack(
          children: [

            CustomScrollView(
              slivers: [

                // =================================================
                // APPBAR
                // =================================================

                SliverAppBar(

                  expandedHeight: 35.h,

                  pinned: true,

                  backgroundColor:
                      Colors.orange,

                  iconTheme:
                      const IconThemeData(
                    color: Colors.white,
                  ),

                  actions: [

                    Padding(

                      padding:
                          EdgeInsets.only(
                        right: 4.w,
                      ),

                      child: GestureDetector(

                        onTap:
                            toggleFavorite,

                        child: Container(

                          padding:
                              const EdgeInsets
                                  .all(10),

                          decoration:
                              BoxDecoration(

                            color: Colors.black
                                .withOpacity(
                              0.3,
                            ),

                            shape:
                                BoxShape.circle,
                          ),

                          child: Icon(

                            isFavorite
                                ? Icons.favorite
                                : Icons
                                    .favorite_border,

                            color: isFavorite
                                ? Colors.red
                                : Colors.white,

                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],

                  flexibleSpace:
                      FlexibleSpaceBar(

                    background: Stack(

                      fit: StackFit.expand,

                      children: [

                        imageUrl == null

                            ? const Center(
                                child: Icon(
                                  Icons.image,
                                ),
                              )

                            : Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),

                        Container(

                          decoration:
                              BoxDecoration(

                            gradient:
                                LinearGradient(

                              begin:
                                  Alignment
                                      .topCenter,

                              end:
                                  Alignment
                                      .bottomCenter,

                              colors: [

                                Colors.orange
                                    .withOpacity(
                                  0.2,
                                ),

                                Colors.black
                                    .withOpacity(
                                  0.5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // =================================================
                // BODY
                // =================================================

                SliverToBoxAdapter(

                  child: Padding(

                    padding:
                        EdgeInsets.all(4.w),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        // =========================================
                        // HEADER
                        // =========================================

                        Container(

                          padding:
                              EdgeInsets.all(
                            4.w,
                          ),

                          decoration:
                              BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),

                            boxShadow: const [

                              BoxShadow(
                                color:
                                    Colors
                                        .black12,

                                blurRadius: 10,
                              ),
                            ],
                          ),

                          child:
                              TourHeaderWidget(

                            title:
                                tourData![
                                        "name"] ??
                                    "",

                            rating:
                                (tourData![
                                            "rating"] ??
                                        0)
                                    .toDouble(),

                            reviewCount:
                                tourData![
                                        "reviewCount"] ??
                                    0,

                            price:
                                tourData![
                                            "price"]
                                        ?.toString() ??
                                    "0",

                            duration:
                                tourData![
                                            "duration"]
                                        ?.toString() ??
                                    "",
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // =========================================
                        // INFO
                        // =========================================

                        Container(

                          padding:
                              EdgeInsets.all(
                            4.w,
                          ),

                          decoration:
                              BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),

                            boxShadow: const [

                              BoxShadow(
                                color:
                                    Colors
                                        .black12,

                                blurRadius: 10,
                              ),
                            ],
                          ),

                          child:
                              TourInfoWidget(

                            groupSize:
                                tourData![
                                            "max_people"]
                                        ?.toString() ??
                                    "",

                            difficulty:
                                tourData![
                                        "difficulty"] ??
                                    "",

                            bestSeason:
                                tourData![
                                        "bestSeason"] ??
                                    "",
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // =========================================
                        // DESCRIPTION
                        // =========================================

                        Container(

                          padding:
                              EdgeInsets.all(
                            4.w,
                          ),

                          decoration:
                              BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),

                            boxShadow: const [

                              BoxShadow(
                                color:
                                    Colors
                                        .black12,

                                blurRadius: 10,
                              ),
                            ],
                          ),

                          child:
                              TourDescriptionWidget(

                            description:
                                tourData![
                                        "description"] ??
                                    "",

                            included:
                                parseToList(
                              tourData![
                                  "included"],
                            ),

                            notIncluded:
                                parseToList(
                              tourData![
                                  "notIncluded"],
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // =========================================
                        // ITINERARY
                        // =========================================

                        Container(

                          padding:
                              EdgeInsets.all(
                            4.w,
                          ),

                          decoration:
                              BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),

                            boxShadow: const [

                              BoxShadow(
                                color:
                                    Colors
                                        .black12,

                                blurRadius: 10,
                              ),
                            ],
                          ),

                          child:
                              TourItineraryWidget(

                            itinerary:
                                parseToMapList(
                              tourData![
                                  "itinerary"],
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // =========================================
                        // REVIEWS
                        // =========================================

                        Container(

                          padding:
                              EdgeInsets.all(
                            4.w,
                          ),

                          decoration:
                              BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),

                            boxShadow: const [

                              BoxShadow(
                                color:
                                    Colors
                                        .black12,

                                blurRadius: 10,
                              ),
                            ],
                          ),

                          child:
                              TourReviewsWidget(

                            reviews:
                                parseToMapList(
                              tourData![
                                  "reviews"],
                            ),

                            averageRating:
                                (tourData![
                                            "rating"] ??
                                        0)
                                    .toDouble(),

                            totalReviews:
                                tourData![
                                        "reviewCount"] ??
                                    0,
                          ),
                        ),

                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // =================================================
            // BOTTOM BAR
            // =================================================

            Positioned(

              bottom: 0,

              left: 0,

              right: 0,

              child: Container(

                decoration:
                    const BoxDecoration(

                  color: Colors.white,

                  boxShadow: [

                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                    ),
                  ],
                ),

                child: SafeArea(

                  child: Padding(

                    padding:
                        EdgeInsets.all(4.w),

                    child: Row(
                      children: [

                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              const Text(
                                "Үнэ",

                                style: TextStyle(
                                  color:
                                      Colors.grey,
                                ),
                              ),

                              SizedBox(
                                height: 0.5.h,
                              ),

                              Text(

                                "₮${tourData!["price"] ?? "0"}",

                                style:
                                    const TextStyle(

                                  fontSize: 24,

                                  fontWeight:
                                      FontWeight.bold,

                                  color:
                                      Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ElevatedButton(

                          onPressed:
                              _showBookingSheet,

                          style:
                              ElevatedButton
                                  .styleFrom(

                            backgroundColor:
                                Colors.orange,

                            foregroundColor:
                                Colors.white,

                            padding:
                                EdgeInsets.symmetric(

                              horizontal: 8.w,

                              vertical: 1.8.h,
                            ),

                            elevation: 0,

                            shape:
                                RoundedRectangleBorder(

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                16,
                              ),
                            ),
                          ),

                          child: const Text(

                            "Захиалах",

                            style: TextStyle(

                              fontWeight:
                                  FontWeight.bold,

                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
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