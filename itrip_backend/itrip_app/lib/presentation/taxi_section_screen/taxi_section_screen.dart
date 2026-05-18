import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../services/api_service.dart';
import '../taxi_section_screen/taxi_booking_page.dart';

class TaxiSectionScreen extends StatefulWidget {
  const TaxiSectionScreen({super.key});

  @override
  State<TaxiSectionScreen> createState() =>
      _TaxiSectionScreenState();
}

class _TaxiSectionScreenState
    extends State<TaxiSectionScreen> {

  static const Color _orange =
      Color(0xFFFF6B00);

  static const Color _bg =
      Color(0xFFF4F6F8);

  late Future<List<dynamic>>
      _taxiFuture;

  List<dynamic> _allTaxi = [];

  String? _selectedLocation;

  bool _isSearching = false;

  bool _isFiltered = false;

  @override
  void initState() {

    super.initState();

    _taxiFuture =
        ApiService.getTaxi();
  }

  Future<void> _refresh() async {

    setState(() {

      _taxiFuture =
          ApiService.getTaxi();

      _selectedLocation =
          null;

      _isFiltered = false;
    });
  }

  void _clearSearch() {

    setState(() {

      _selectedLocation =
          null;

      _taxiFuture =
          Future.value(
        _allTaxi,
      );

      _isFiltered = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      backgroundColor: _bg,

      body: RefreshIndicator(

        onRefresh: _refresh,

        child:
            FutureBuilder<List<dynamic>>(

          future: _taxiFuture,

          builder:
              (context, snapshot) {

            if (snapshot
                    .connectionState ==
                ConnectionState
                    .waiting) {

              return const Center(

                child:
                    CircularProgressIndicator(
                  color: _orange,
                ),
              );
            }

            if (snapshot.hasError) {

              return Center(

                child: Text(
                  "Алдаа гарлаа",
                ),
              );
            }

            final taxis =
                snapshot.data ?? [];

            if (_allTaxi.isEmpty &&
                taxis.isNotEmpty) {

              _allTaxi = taxis;
            }

            return CustomScrollView(

              physics:
                  const BouncingScrollPhysics(),

              slivers: [

                // =====================================
                // HERO
                // =====================================

                SliverToBoxAdapter(
                  child: _buildHero(),
                ),

                // =====================================
                // SEARCH
                // =====================================

               

                // =====================================
                // TITLE
                // =====================================

                SliverToBoxAdapter(

                  child: Padding(

                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),

                    child: Row(

                      children: [

                        Text(

                          "Онцлох такси",

                          style:
                              GoogleFonts.inter(

                            fontSize:
                                15.sp,

                            fontWeight:
                                FontWeight
                                    .bold,

                            color:
                                const Color(
                              0xFF111827,
                            ),
                          ),
                        ),

                        const Spacer(),

                        if (_isFiltered)

                          GestureDetector(

                            onTap:
                                _clearSearch,

                            child:
                                Container(

                              padding:
                                  EdgeInsets.symmetric(

                                horizontal:
                                    3.w,

                                vertical:
                                    0.7.h,
                              ),

                              decoration:
                                  BoxDecoration(

                                color:
                                    _orange
                                        .withOpacity(
                                  0.1,
                                ),

                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),

                              child: Row(

                                children: [

                                  Icon(

                                    Icons.close,

                                    size:
                                        12.sp,

                                    color:
                                        _orange,
                                  ),

                                  SizedBox(
                                    width:
                                        1.w,
                                  ),

                                  Text(

                                    "Арилгах",

                                    style:
                                        GoogleFonts.inter(

                                      fontSize:
                                          9.5.sp,

                                      fontWeight:
                                          FontWeight.w600,

                                      color:
                                          _orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // =====================================
                // EMPTY
                // =====================================

                taxis.isEmpty

                    ? SliverToBoxAdapter(

                        child: Padding(

                          padding:
                              EdgeInsets.only(
                            top: 10.h,
                          ),

                          child: Column(

                            children: [

                              Icon(

                                Icons
                                    .local_taxi,

                                size:
                                    40.sp,

                                color:
                                    Colors.grey
                                        .shade400,
                              ),

                              SizedBox(
                                height:
                                    1.h,
                              ),

                              Text(

                                "Такси олдсонгүй",

                                style:
                                    GoogleFonts.inter(

                                  color:
                                      Colors.grey
                                          .shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )

                    // =====================================
                    // LIST
                    // =====================================

                    : SliverPadding(

                        padding:
                            EdgeInsets.symmetric(
                          horizontal:
                              4.w,
                          vertical:
                              1.h,
                        ),

                        sliver: SliverList(

                          delegate:
                              SliverChildBuilderDelegate(

                            (ctx, i) {

                              return _buildTaxiCard(
                                taxis[i],
                              );
                            },

                            childCount:
                                taxis.length,
                          ),
                        ),
                      ),

                SliverToBoxAdapter(
                  child:
                      SizedBox(height: 3.h),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // =====================================
  // HERO
  // =====================================

  Widget _buildHero() {

    return SizedBox(

      height: 22.h,

      child: Stack(

        fit: StackFit.expand,

        children: [

          Image.network(

            "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg",

            fit: BoxFit.cover,
          ),

          Container(

            color:
                Colors.black
                    .withOpacity(
              0.4,
            ),
          ),

          Positioned(

            top: 1.h,

            left: 3.w,

            child: SafeArea(

              child:
                  GestureDetector(

                onTap: () {

                  Navigator.pop(
                    context,
                  );
                },

                child: Container(

                  padding:
                      const EdgeInsets.all(
                    8,
                  ),

                  decoration:
                      BoxDecoration(

                    color:
                        Colors.white
                            .withOpacity(
                      0.2,
                    ),

                    shape:
                        BoxShape.circle,
                  ),

                  child:
                      const Icon(

                    Icons
                        .arrow_back_ios_new,

                    color:
                        Colors.white,

                    size: 18,
                  ),
                ),
              ),
            ),
          ),

          Center(

            child: Text(

              "Такси",

              style:
                  GoogleFonts.inter(

                fontSize: 18.sp,

                color:
                    Colors.white,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // SEARCH CARD
  // =====================================

  Widget _buildSearchCard() {

    final locations = _allTaxi

        .map(
          (t) =>
              t['location']
                  ?.toString() ??
              '',
        )

        .where(
          (l) => l.isNotEmpty,
        )

        .toSet()

        .toList();

    return Container(

      margin: EdgeInsets.all(
        4.w,
      ),

      padding: EdgeInsets.all(
        4.w,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        boxShadow: [

          BoxShadow(

            color:
                Colors.black
                    .withOpacity(
              0.06,
            ),

            blurRadius: 12,

            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [

          

          SizedBox(
            height: 0.8.h,
          ),

          Container(

            padding:
                EdgeInsets.symmetric(
              horizontal: 3.w,
            ),

            decoration:
                BoxDecoration(

              border: Border.all(
                color:
                    Colors.grey
                        .shade300,
              ),

              borderRadius:
                  BorderRadius.circular(
                10,
              ),
            ),

            child:
                DropdownButtonHideUnderline(

              child:
                  DropdownButton<String>(

                isExpanded: true,

                hint: Text(

                  "Байршил сонгох",

                  style:
                      TextStyle(

                    color:
                        Colors.grey
                            .shade500,

                    fontSize:
                        12.sp,
                  ),
                ),

                value:
                    _selectedLocation,

                items:
                    locations.map((loc) {

                  return DropdownMenuItem(

                    value: loc,

                    child: Text(
                      loc,
                    ),
                  );
                }).toList(),

                onChanged: (v) async {

                  setState(() {

                    _selectedLocation =
                        v;

                    _isSearching = true;
                  });

                  try {

                    final result =
                        await ApiService.getTaxi(

                      location:
                          _selectedLocation,
                    );

                    setState(() {

                      _taxiFuture =
                          Future.value(
                        result,
                      );

                      _isSearching =
                          false;

                      _isFiltered =
                          true;
                    });

                  } catch (e) {

                    setState(() {

                      _isSearching =
                          false;
                    });
                  }
                },

                icon:
                    const Icon(

                  Icons
                      .keyboard_arrow_down,

                  color:
                      _orange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // LABEL
  // =====================================

  Widget _buildLabel(
    String text,
  ) {

    return Text(

      text,

      style:
          GoogleFonts.inter(

        fontSize: 11.sp,

        fontWeight:
            FontWeight.w600,

        color:
            Colors.grey
                .shade600,
      ),
    );
  }

  // =====================================
  // TAXI CARD
  // =====================================

  Widget _buildTaxiCard(
    Map<String, dynamic> taxi,
  ) {

    final imageUrl =
        ApiService.getImageUrl(
      taxi["image"],
    );

    String categoryText =
        "Төрөлгүй";

    switch (taxi["category"]) {

      case "economy":
        categoryText =
            "Эдийн засгийн";
        break;

      case "comfort":
        categoryText =
            "Тав тухтай";
        break;

      case "luxury":
        categoryText =
            "Тансаг";
        break;

      case "minibus":
        categoryText =
            "Микро автобус";
        break;
    }

    return GestureDetector(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) =>
                TaxiBookingPage(
              taxi: taxi,
            ),
          ),
        );
      },

      child: Container(

        margin:
            EdgeInsets.only(
          bottom: 2.h,
        ),

        decoration:
            BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            16,
          ),

          boxShadow: [

            BoxShadow(

              color:
                  Colors.black
                      .withOpacity(
                0.06,
              ),

              blurRadius: 10,

              offset:
                  const Offset(
                0,
                3,
              ),
            ),
          ],
        ),

        clipBehavior:
            Clip.antiAlias,

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          children: [

            SizedBox(

              height: 20.h,

              width:
                  double.infinity,

              child:
                  imageUrl.isEmpty

                      ? Container(

                          color:
                              Colors.grey
                                  .shade300,

                          child:
                              const Icon(
                            Icons.image,
                            size: 40,
                          ),
                        )

                      : Image.network(

                          imageUrl,

                          fit:
                              BoxFit.cover,
                        ),
            ),

            Padding(

              padding:
                  EdgeInsets.all(
                3.5.w,
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(

                    taxi["name"] ??
                        "",

                    maxLines: 1,

                    overflow:
                        TextOverflow
                            .ellipsis,

                    style:
                        GoogleFonts.inter(

                      fontWeight:
                          FontWeight
                              .bold,

                      fontSize:
                          13.sp,

                      color:
                          const Color(
                        0xFF111827,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 0.8.h,
                  ),

                  Container(

                    padding:
                        EdgeInsets.symmetric(

                      horizontal:
                          3.w,

                      vertical:
                          0.7.h,
                    ),

                    decoration:
                        BoxDecoration(

                      color:
                          _orange
                              .withOpacity(
                        0.1,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Text(

                      categoryText,

                      style:
                          GoogleFonts.inter(

                        fontSize:
                            9.5.sp,

                        fontWeight:
                            FontWeight.w600,

                        color:
                            _orange,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 1.2.h,
                  ),

                  Row(

                    children: [

                      Icon(

                        Icons
                            .location_on_outlined,

                        size:
                            14.sp,

                        color:
                            Colors.grey
                                .shade600,
                      ),

                      SizedBox(
                        width: 1.w,
                      ),

                      Expanded(

                        child: Text(

                          taxi["location"]
                                  ?.toString() ??
                              "Ulaanbaatar",

                          maxLines: 1,

                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style:
                              GoogleFonts.inter(

                            fontSize:
                                10.sp,

                            color:
                                Colors.grey
                                    .shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 1.5.h,
                  ),

                  Row(

                    children: [

                      Text(

                        "₮ ${taxi["price"] ?? "0"}",

                        style:
                            GoogleFonts.inter(

                          fontWeight:
                              FontWeight
                                  .bold,

                          fontSize:
                              13.sp,

                          color:
                              _orange,
                        ),
                      ),

                      const Spacer(),

                      ElevatedButton(

                        onPressed: () {

                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                                  TaxiBookingPage(
                                taxi:
                                    taxi,
                              ),
                            ),
                          );
                        },

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              _orange,

                          elevation:
                              0,

                          padding:
                              EdgeInsets.symmetric(

                            horizontal:
                                5.w,

                            vertical:
                                1.2.h,
                          ),

                          shape:
                              RoundedRectangleBorder(

                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),

                        child: Text(

                          "Захиалах",

                          style:
                              GoogleFonts.inter(

                            color:
                                Colors.white,

                            fontSize:
                                10.sp,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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