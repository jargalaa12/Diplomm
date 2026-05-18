import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'passenger_info_page.dart';

class FlightDetailPage extends StatelessWidget {
  final Map<String, dynamic> flight;

  const FlightDetailPage({
    super.key,
    required this.flight,
  });

  static const Color orange =
      Color(0xFFFF6B00);

  static const Color bg =
      Color(0xFFF4F6F8);

  @override
  Widget build(BuildContext context) {
    /// ✈ ORIGIN
    final origin =
        flight["origin"] is Map
            ? (
                flight["origin"]["city"] ??
                flight["origin"]["code"] ??
                ""
              ).toString()
            : flight["origin"]
                    ?.toString() ??
                "";

    /// ✈ DESTINATION
    final destination =
        flight["destination"] is Map
            ? (
                flight["destination"]["city"] ??
                flight["destination"]["code"] ??
                ""
              ).toString()
            : flight["destination"]
                    ?.toString() ??
                "";

    /// 🔥 DATETIME
    final departureString =
        flight["departure_date"]
                ?.toString() ??
            "";

    final arrivalString =
        flight["arrival_date"]
                ?.toString() ??
            "";

    final departure =
        departureString.isNotEmpty
            ? DateTime.tryParse(
                departureString,
              )
            : null;

    final arrival =
        arrivalString.isNotEmpty
            ? DateTime.tryParse(
                arrivalString,
              )
            : null;

    /// 🕒 TIME
    final depTime =
        departure != null
            ? "${departure.hour.toString().padLeft(2, '0')}:${departure.minute.toString().padLeft(2, '0')}"
            : "--:--";

    final arrTime =
        arrival != null
            ? "${arrival.hour.toString().padLeft(2, '0')}:${arrival.minute.toString().padLeft(2, '0')}"
            : "--:--";

    /// 📅 DATE
    final depDate =
        departure != null
            ? "${departure.year}-${departure.month.toString().padLeft(2, '0')}-${departure.day.toString().padLeft(2, '0')}"
            : "";

    /// ✈ EXTRA
    final duration =
        flight["duration_display"]
                ?.toString() ??
            "";

    final airline =
        flight["airline"]?["name"]
                ?.toString() ??
            "MIAT";

    final isDirect =
        flight["is_direct"] ?? true;

    final stops =
        flight["stops"] ?? 0;

    final price =
        _getPrice(flight);

    return Scaffold(
      backgroundColor: bg,

      /// 🔥 BOTTOM BUTTON
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          4.w,
          1.h,
          4.w,
          3.h,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SizedBox(
          height: 6.3.h,
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(
              backgroundColor: orange,
              elevation: 0,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
            ),

           onPressed: () {

  Navigator.push(

    context,

    MaterialPageRoute(

      builder: (_) =>

          PassengerInfoPage(

        flightId:
            flight['id'],
      ),
    ),
  );
},

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  "Үргэлжлүүлэх",
                  style:
                      GoogleFonts.poppins(
                    fontSize: 12.5.sp,
                    fontWeight:
                        FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                SizedBox(width: 2.w),

                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 15.sp,
                ),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// 🔙 APPBAR
            Padding(
              padding:
                  EdgeInsets.symmetric(
                horizontal: 2.w,
                vertical: 1.h,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () =>
                        Navigator.pop(
                      context,
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Text(
                        "Нислэгийн мэдээлэл",
                        style:
                            GoogleFonts.poppins(
                          fontSize: 15.5.sp,
                          fontWeight:
                              FontWeight
                                  .w700,
                          color: Colors
                              .black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 48,
                  ),
                ],
              ),
            ),

            /// 🔥 BODY
            Expanded(
              child: ListView(
                padding:
                    EdgeInsets.only(
                  bottom: 2.h,
                ),
                children: [
                  /// ✈ FLIGHT CARD
                  Container(
                    margin:
                        EdgeInsets.symmetric(
                      horizontal: 4.w,
                    ),
                    padding:
                        EdgeInsets.all(5.w),
                    decoration:
                        BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .black
                              .withOpacity(
                            0.04,
                          ),
                          blurRadius: 16,
                          offset:
                              const Offset(
                            0,
                            6,
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        /// ✈ AIRLINE
                        Row(
                          children: [
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration:
                                  BoxDecoration(
                                color: orange
                                    .withOpacity(
                                  0.08,
                                ),
                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                              ),
                              child: Icon(
                                Icons.flight,
                                color:
                                    orange,
                                size: 22.sp,
                              ),
                            ),

                            SizedBox(
                              width: 3.w,
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    airline,
                                    style:
                                        GoogleFonts.poppins(
                                      fontSize:
                                          12.5.sp,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),

                                  SizedBox(
                                    height:
                                        0.3.h,
                                  ),

                                  Text(
                                    isDirect
                                        ? "Шууд нислэг"
                                        : "$stops зогсолттой",
                                    style:
                                        GoogleFonts.poppins(
                                      fontSize:
                                          10.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 3.h,
                        ),

                        _timelineRow(
                          depTime,
                          origin,
                          arrTime,
                          destination,
                          duration,
                          depDate,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  /// ℹ NOTICE
                  _infoCard(),

                  SizedBox(height: 2.h),

                  /// 💰 PRICE
                  _priceCard(price),

                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✈ TIMELINE
  Widget _timelineRow(
    String depTime,
    String depCity,
    String arrTime,
    String arrCity,
    String duration,
    String date,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        /// 🕒 TIME
        Column(
          children: [
            Text(
              depTime,
              style:
                  GoogleFonts.poppins(
                fontWeight:
                    FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              arrTime,
              style:
                  GoogleFonts.poppins(
                fontWeight:
                    FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),

        SizedBox(width: 4.w),

        /// ✈ LINE
        Column(
          children: [
            Container(
              width: 11,
              height: 11,
              decoration:
                  const BoxDecoration(
                color: orange,
                shape: BoxShape.circle,
              ),
            ),

            Container(
              width: 2,
              height: 6.h,
              color:
                  Colors.grey.shade300,
            ),

            Container(
              padding:
                  EdgeInsets.all(
                1.8.w,
              ),
              decoration:
                  BoxDecoration(
                color: orange
                    .withOpacity(
                  0.1,
                ),
                shape:
                    BoxShape.circle,
              ),
              child: Icon(
                Icons.flight,
                size: 16.sp,
                color: orange,
              ),
            ),

            Container(
              width: 2,
              height: 6.h,
              color:
                  Colors.grey.shade300,
            ),

            Container(
              width: 11,
              height: 11,
              decoration:
                  const BoxDecoration(
                color: orange,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),

        SizedBox(width: 4.w),

        /// ✈ INFO
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Text(
                depCity,
                style:
                    GoogleFonts.poppins(
                  fontWeight:
                      FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),

              SizedBox(height: 0.5.h),

              Text(
                date,
                style:
                    GoogleFonts.poppins(
                  fontSize: 10.sp,
                  color:
                      Colors.grey.shade600,
                ),
              ),

              SizedBox(height: 1.4.h),

              if (duration.isNotEmpty)
                _badge(duration),

              SizedBox(height: 2.3.h),

              Text(
                arrCity,
                style:
                    GoogleFonts.poppins(
                  fontWeight:
                      FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 0.8.h,
      ),
      decoration: BoxDecoration(
        color:
            orange.withOpacity(0.08),
        borderRadius:
            BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style:
            GoogleFonts.poppins(
          fontSize: 9.5.sp,
          fontWeight:
              FontWeight.w600,
          color: orange,
        ),
      ),
    );
  }

  Widget _infoCard() {
    final notices = [
      "Зорчигчийн мэдээллээ үнэн зөв бөглөсөн эсэхээ шалгана уу.",
      "Паспортын хүчинтэй хугацаа 6 сараас дээш байна.",
      "Нислэгээс 3-4 цагийн өмнө бүртгэлээ хийнэ үү.",
      "Шатамхай болон тэсрэх бодис авч явахыг хориглоно.",
      "Очих улсын визний шаардлагыг шалгана уу.",
    ];

    return Container(
      margin:
          EdgeInsets.symmetric(
        horizontal: 4.w,
      ),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),
            blurRadius: 16,
            offset:
                const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.all(
                  2.w,
                ),
                decoration:
                    BoxDecoration(
                  color: orange
                      .withOpacity(
                    0.1,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: orange,
                  size: 18.sp,
                ),
              ),

              SizedBox(width: 3.w),

              Text(
                "Нислэгийн санамж",
                style:
                    GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.5.h),

          ...List.generate(
            notices.length,
            (index) {
              return Padding(
                padding:
                    EdgeInsets.only(
                  bottom: 1.8.h,
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.only(
                        top: 0.9.h,
                      ),
                      width: 7,
                      height: 7,
                      decoration:
                          const BoxDecoration(
                        color: orange,
                        shape:
                            BoxShape.circle,
                      ),
                    ),

                    SizedBox(width: 3.w),

                    Expanded(
                      child: Text(
                        notices[index],
                        style:
                            GoogleFonts.poppins(
                          fontSize:
                              10.5.sp,
                          height: 1.7,
                          color: Colors
                              .grey
                              .shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _priceCard(
    int price,
  ) {
    return Container(
      margin:
          EdgeInsets.symmetric(
        horizontal: 4.w,
      ),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),
            blurRadius: 16,
            offset:
                const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Text(
                "Нийт төлбөр",
                style:
                    GoogleFonts.poppins(
                  fontSize: 11.sp,
                  color:
                      Colors.grey.shade600,
                ),
              ),

              SizedBox(height: 0.5.h),

              Text(
                "1 том хүн",
                style:
                    GoogleFonts.poppins(
                  fontSize: 10.sp,
                  color:
                      Colors.grey.shade500,
                ),
              ),
            ],
          ),

          Text(
            "₮ ${_formatPrice(price)}",
            style:
                GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight:
                  FontWeight.w700,
              color: orange,
            ),
          ),
        ],
      ),
    );
  }

  int _getPrice(
    Map<String, dynamic> flight,
  ) {
    final raw = flight["price"];

    if (raw == null) {
      return 0;
    }

    return double.tryParse(
              raw.toString(),
            )?.toInt() ??
        0;
  }

  String _formatPrice(int price) {
    final s = price.toString();

    final buf = StringBuffer();

    for (
      int i = 0;
      i < s.length;
      i++
    ) {
      if (
          i > 0 &&
          (s.length - i) % 3 == 0) {
        buf.write("'");
      }

      buf.write(s[i]);
    }

    return buf.toString();
  }
}