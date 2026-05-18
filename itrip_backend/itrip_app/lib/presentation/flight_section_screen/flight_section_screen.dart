import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../presentation/flight_section_screen/flight_detail_page.dart';
import '../../services/api_service.dart';

class FlightSectionScreen extends StatefulWidget {
  const FlightSectionScreen({super.key});

  @override
  State<FlightSectionScreen> createState() =>
      _FlightSectionScreenState();
}

class _FlightSectionScreenState
    extends State<FlightSectionScreen> {
  static const Color _orange =
      Color(0xFFFF6B00);

  static const Color _bg =
      Color(0xFFF4F6F8);

  int _selectedTab = 0;

  String _origin = "Ulaanbaatar";

  String _destination = "Сонгоно уу";

  String _departureDate = "";

  String _returnDate = "";

  List<dynamic> flights = [];

  bool isLoading = true;

  final List<String> destinations = [
    "Seoul",
    "Tokyo",
    "Beijing",
    "Bangkok",
    "Hong Kong",
    "Istanbul",
    "Dubai",
    "Paris",
    "London",
    "New York",
  ];

  @override
  void initState() {
    super.initState();
    fetchFlights();
  }

  /// ✈ FEATURED FLIGHTS
  Future<void> fetchFlights() async {
    try {
      final data =
          await ApiService.getFeaturedFlights();

      setState(() {
        flights = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("API ERROR: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  /// 🔄 SWAP
  void _swap() {
    setState(() {
      final temp = _origin;
      _origin = _destination;
      _destination = temp;
    });
  }

  /// 📅 PICK DATE
  Future<void> _pickDate(
    bool isDeparture,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      final date =
          "${picked.year}-${picked.month}-${picked.day}";

      setState(() {
        if (isDeparture) {
          _departureDate = date;
        } else {
          _returnDate = date;
        }
      });
    }
  }

  /// 🌍 SELECT DESTINATION
  Future<void> _selectDestination() async {
    final result =
        await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 15.w,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
              ),

              SizedBox(height: 2.h),

              Text(
                "Очих газар сонгох",
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 2.h),

              ...destinations.map(
                (city) => ListTile(
                  leading: const Icon(
                    Icons.flight_takeoff,
                    color: _orange,
                  ),

                  title: Text(
                    city,
                    style:
                        GoogleFonts.poppins(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  onTap: () {
                    Navigator.pop(
                      context,
                      city,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _destination = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,

      body: CustomScrollView(
        slivers: [
          /// ✈ HERO
          SliverToBoxAdapter(
            child: _buildHero(),
          ),

          /// 🔍 SEARCH CARD
          SliverToBoxAdapter(
            child: _buildSearchCard(),
          ),

          /// 🔥 TITLE
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 1.h,
              ),

              child: Text(
                "Онцлох нислэг",
                style: GoogleFonts.poppins(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          /// ⏳ LOADING
          if (isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              ),
            )

          /// ❌ EMPTY
          else if (flights.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Center(
                  child: Text(
                    "Нислэг олдсонгүй",
                    style:
                        GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )

          /// ✈ FLIGHTS
          else
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
              ),

              sliver: SliverGrid(
                delegate:
                    SliverChildBuilderDelegate(
                  (ctx, i) =>
                      _buildFlightCard(
                    flights[i]
                        as Map<String, dynamic>,
                  ),
                  childCount: flights.length,
                ),

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.66,
                ),
              ),
            ),

          SliverToBoxAdapter(
            child: SizedBox(height: 3.h),
          ),
        ],
      ),
    );
  }

  /// ✈ HERO
  Widget _buildHero() {
    return SizedBox(
      height: 24.h,

      child: Stack(
        fit: StackFit.expand,

        children: [
          Image.network(
            "https://images.pexels.com/photos/1004409/pexels-photo-1004409.jpeg",
            fit: BoxFit.cover,
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(
                    0.55,
                  ),
                  Colors.black.withOpacity(
                    0.2,
                  ),
                ],
                begin:
                    Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 2.w,
              ),

              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),

                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        "Нислэг",
                        style:
                            GoogleFonts.poppins(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔍 SEARCH CARD
  Widget _buildSearchCard() {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        children: [
          /// 🔥 TAB
          Row(
            children: [
              _tab("Хоёр талдаа", 0),
              _tab("Нэг талдаа", 1),
            ],
          ),

          SizedBox(height: 2.h),

          /// ✈ ROUTE
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),

            decoration: BoxDecoration(
              color: _bg,
              borderRadius:
                  BorderRadius.circular(16),
            ),

            child: Row(
              children: [
                /// 🛫 ORIGIN
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Хаанаас",
                        style:
                            GoogleFonts.poppins(
                          fontSize: 9.sp,
                          color: Colors.grey,
                        ),
                      ),

                      SizedBox(height: 0.5.h),

                      Text(
                        _origin,
                        style:
                            GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔄 SWAP
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                      50,
                    ),
                  ),

                  child: IconButton(
                    icon: const Icon(
                      Icons.swap_horiz,
                      color: _orange,
                    ),
                    onPressed: _swap,
                  ),
                ),

                /// 🛬 DESTINATION
                Expanded(
                  child: GestureDetector(
                    onTap:
                        _selectDestination,

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .end,

                      children: [
                        Text(
                          "Хаашаа",
                          style:
                              GoogleFonts
                                  .poppins(
                            fontSize: 9.sp,
                            color:
                                Colors.grey,
                          ),
                        ),

                        SizedBox(
                          height: 0.5.h,
                        ),

                        Text(
                          _destination,
                          textAlign:
                              TextAlign.end,
                          style:
                              GoogleFonts
                                  .poppins(
                            fontSize: 13.sp,
                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          /// 📅 DATE
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      _pickDate(true),

                  child: Container(
                    padding:
                        EdgeInsets.all(
                      3.5.w,
                    ),

                    decoration: BoxDecoration(
                      color: _bg,
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        Text(
                          "Явах огноо",
                          style:
                              GoogleFonts
                                  .poppins(
                            fontSize: 9.sp,
                            color:
                                Colors.grey,
                          ),
                        ),

                        SizedBox(
                          height: 0.5.h,
                        ),

                        Text(
                          _departureDate
                                  .isEmpty
                              ? "Сонгох"
                              : _departureDate,
                          style:
                              GoogleFonts
                                  .poppins(
                            fontSize: 11.sp,
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              if (_selectedTab == 0)
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        _pickDate(false),

                    child: Container(
                      padding:
                          EdgeInsets.all(
                        3.5.w,
                      ),

                      decoration: BoxDecoration(
                        color: _bg,
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            "Буцах огноо",
                            style:
                                GoogleFonts
                                    .poppins(
                              fontSize:
                                  9.sp,
                              color:
                                  Colors
                                      .grey,
                            ),
                          ),

                          SizedBox(
                            height: 0.5.h,
                          ),

                          Text(
                            _returnDate
                                    .isEmpty
                                ? "Сонгох"
                                : _returnDate,
                            style:
                                GoogleFonts
                                    .poppins(
                              fontSize:
                                  11.sp,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 2.5.h),

          /// 🔍 SEARCH BUTTON
          SizedBox(
            width: double.infinity,
            height: 6.h,

            child: ElevatedButton(
              onPressed: () async {
                /// ❌ DESTINATION
                if (_destination ==
                    "Сонгоно уу") {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Очих газраа сонгоно уу",
                        style:
                            GoogleFonts
                                .poppins(),
                      ),
                    ),
                  );

                  return;
                }

                /// ❌ DATE
                if (_departureDate
                    .isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Явах огноо сонгоно уу",
                        style:
                            GoogleFonts
                                .poppins(),
                      ),
                    ),
                  );

                  return;
                }

                setState(() {
                  isLoading = true;
                });

                try {
                  final data =
                      await ApiService
                          .searchFlights(
                    origin:
                        _origin.trim(),
                    destination:
                        _destination
                            .trim(),
                    date:
                        _departureDate
                            .trim(),
                  );

                  setState(() {
                    flights = data;
                    isLoading = false;
                  });

                  if (data.isEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Нислэг олдсонгүй",
                          style:
                              GoogleFonts
                                  .poppins(),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  debugPrint(
                    "SEARCH ERROR: $e",
                  );

                  setState(() {
                    isLoading = false;
                  });

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Алдаа гарлаа",
                        style:
                            GoogleFonts
                                .poppins(),
                      ),
                    ),
                  );
                }
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor: _orange,
                elevation: 0,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),

                  SizedBox(width: 2.w),

                  Text(
                    "Хайх",
                    style:
                        GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight:
                          FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 TAB
  Widget _tab(String text, int i) {
    final active = _selectedTab == i;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = i;
          });
        },

        child: Column(
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(
                color: active
                    ? _orange
                    : Colors.grey,
                fontWeight: active
                    ? FontWeight.w700
                    : FontWeight.w500,
                fontSize: 11.5.sp,
              ),
            ),

            SizedBox(height: 0.7.h),

            AnimatedContainer(
              duration: const Duration(
                milliseconds: 250,
              ),

              height: 3,

              width:
                  active ? 24.w : 0,

              decoration: BoxDecoration(
                color: _orange,
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✈ FLIGHT CARD
  Widget _buildFlightCard(
    Map<String, dynamic> flight,
  ) {
    final origin =
        flight["origin"] is Map
            ? flight["origin"]["city"]
            : flight["origin"];

    final airport =
        flight["destination"] is Map
            ? flight["destination"]["name"]
            : flight["destination"];

    final dateRange =
        "${flight["date_range_start"] ?? ""} - ${flight["date_range_end"] ?? ""}";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                FlightDetailPage(
              flight: flight,
            ),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(
                0.05,
              ),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            /// 🖼 IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),

                child: Image.network(
                  flight["image"] ?? "",
                  width: double.infinity,
                  fit: BoxFit.cover,

                  errorBuilder:
                      (_, __, ___) =>
                          Container(
                    color:
                        Colors.grey.shade200,

                    child: const Center(
                      child:
                          Icon(Icons.image),
                    ),
                  ),
                ),
              ),
            ),

            /// ✈ INFO
            Padding(
              padding: EdgeInsets.all(3.w),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    origin ?? "",
                    style:
                        GoogleFonts.poppins(
                      fontWeight:
                          FontWeight.w700,
                      fontSize: 12.5.sp,
                    ),
                  ),

                  SizedBox(height: 0.7.h),

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 15,
                        color: Colors.grey,
                      ),

                      SizedBox(width: 1.w),

                      Expanded(
                        child: Text(
                          dateRange,
                          maxLines: 1,
                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style:
                              GoogleFonts
                                  .poppins(
                            fontSize:
                                9.8.sp,
                            color: Colors
                                .grey
                                .shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 0.7.h),

                  Text(
                    airport ?? "",
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        GoogleFonts.poppins(
                      fontSize: 10.5.sp,
                      color: Colors
                          .grey
                          .shade700,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    "₮ ${flight["price"] ?? 0}",
                    style:
                        GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight:
                          FontWeight.w700,
                      color: _orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}