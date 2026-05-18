import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../services/api_service.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({
    super.key,
  });

  @override
  State<BookingsScreen> createState() =>
      _BookingsScreenState();
}

class _BookingsScreenState
    extends State<BookingsScreen> {

  static const Color primary =
      Color(0xFFFF6B00);

  static const Color bgColor =
      Color(0xFFF5F7FA);

  List<dynamic> _bookings = [];

  bool _isLoading = true;

  String? _error;

  Timer? _timer;

  @override
  void initState() {

    super.initState();

    _initialFetch();

    _timer = Timer.periodic(

      const Duration(seconds: 5),

      (_) => _fetchData(
        isSilent: true,
      ),
    );
  }

  @override
  void dispose() {

    _timer?.cancel();

    super.dispose();
  }

  // =====================================================
  // FETCH
  // =====================================================

  Future<void> _initialFetch() async {

    setState(() {

      _isLoading = true;
    });

    await _fetchData(
      isSilent: false,
    );

    if (mounted) {

      setState(() {

        _isLoading = false;
      });
    }
  }

  Future<void> _fetchData({

    required bool isSilent,

  }) async {

    try {

      final data =
          await ApiService.getBookings();

      if (mounted) {

        setState(() {

          _bookings = data;

          _error = null;
        });
      }

    } catch (e) {

      if (mounted &&
          _bookings.isEmpty &&
          !isSilent) {

        setState(() {

          _error =
              "Мэдээлэл татахад алдаа гарлаа";
        });
      }
    }
  }

  // =====================================================
  // STATUS
  // =====================================================

  Color _getStatusColor(
    String? status,
  ) {

    final s =
        status
            ?.trim()
            .toLowerCase() ??
        '';

    if (s == 'confirmed') {
      return Colors.green;
    }

    if (s == 'cancelled') {
      return Colors.red;
    }

    return Colors.orange;
  }

  String _getStatusText(
    String? status,
  ) {

    final s =
        status
            ?.trim()
            .toLowerCase() ??
        '';

    if (s == 'confirmed') {
      return 'Баталгаажсан';
    }

    if (s == 'cancelled') {
      return 'Цуцлагдсан';
    }

    return 'Хүлээгдэж буй';
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      backgroundColor: bgColor,

      body: SafeArea(

        child: Column(

          children: [

            _buildHeader(),

            Expanded(

              child:
                  RefreshIndicator(

                color: primary,

                onRefresh:
                    _initialFetch,

                child:
                    _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // HEADER
  // =====================================================

  Widget _buildHeader() {

    return Container(

      width: double.infinity,

      padding:
          EdgeInsets.symmetric(

        horizontal: 5.w,

        vertical: 2.5.h,
      ),

      decoration:
          const BoxDecoration(

        gradient: LinearGradient(

          colors: [

            Color(0xFFFF8C42),

            Color(0xFFFF6B00),
          ],
        ),

        borderRadius:
            BorderRadius.only(

          bottomLeft:
              Radius.circular(28),

          bottomRight:
              Radius.circular(28),
        ),
      ),

      child: Row(

        children: [

          Container(

            padding:
                EdgeInsets.all(2.w),

            decoration:
                BoxDecoration(

              color:
                  Colors.white
                      .withOpacity(0.2),

              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),

            child: const Icon(

              Icons.receipt_long,

              color: Colors.white,

              size: 28,
            ),
          ),

          SizedBox(width: 3.w),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(

                  "Миний захиалгууд",

                  style:
                      GoogleFonts.poppins(

                    fontSize: 17.sp,

                    fontWeight:
                        FontWeight.w700,

                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 0.2.h),

                Text(

                  "Flight • Tour • Taxi",

                  style:
                      GoogleFonts.poppins(

                    fontSize: 10.sp,

                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // CONTENT
  // =====================================================

  Widget _buildContent() {

    if (_isLoading &&
        _bookings.isEmpty) {

      return const Center(

        child:
            CircularProgressIndicator(),
      );
    }

    if (_bookings.isEmpty) {

      return ListView(

        children: [

          SizedBox(height: 30.h),

          Center(

            child: Text(

              "Захиалга олдсонгүй",

              style:
                  GoogleFonts.poppins(

                fontSize: 12.sp,

                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(

      padding: EdgeInsets.all(4.w),

      itemCount:
          _bookings.length,

      itemBuilder:
          (context, index) {

        return _buildBookingCard(
          _bookings[index],
        );
      },
    );
  }

  // =====================================================
  // BOOKING CARD
  // =====================================================

  Widget _buildBookingCard(
    dynamic booking,
  ) {

    final status =
        booking['status']
                ?.toString() ??
            'pending';

    final statusColor =
        _getStatusColor(status);

    final tourName =
        booking['tour_name']
                ?.toString() ??
            '';

    final flightNumber =
        booking['flight_number']
                ?.toString() ??
            '';

    final origin =
        booking['origin']
                ?.toString() ??
            'UBN';

    final destination =
        booking['destination']
                ?.toString() ??
            'UBN';

    final district =
        booking['district']
                ?.toString() ??
            '';

    final khoroo =
        booking['khoroo']
                ?.toString() ??
            '';

    final street =
        booking['street']
                ?.toString() ??
            '';

    final apartment =
        booking['apartment']
                ?.toString() ??
            '';

    final detailAddress =
        booking['detail_address']
                ?.toString() ??
            '';

    final phone =
        booking['phone']
                ?.toString() ??
            '-';

    final email =
        booking['email']
                ?.toString() ??
            '-';

    final isTaxi =
        district.isNotEmpty ||
        khoroo.isNotEmpty ||
        street.isNotEmpty;

    final isFlight =
        flightNumber.isNotEmpty &&
        !isTaxi;

    final passenger =
        "${booking['last_name'] ?? ''} "
        "${booking['first_name'] ?? ''}";

    final totalPrice =
        booking['total_price']
                ?.toString() ??
            "0";

    return Container(

      margin: EdgeInsets.only(
        bottom: 2.h,
      ),

      padding: EdgeInsets.all(4.w),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        boxShadow: [

          BoxShadow(

            color:
                Colors.black
                    .withOpacity(0.05),

            blurRadius: 12,

            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // STATUS
          Row(

            children: [

              Container(

                width: 10,

                height: 10,

                decoration:
                    BoxDecoration(

                  color: statusColor,

                  shape:
                      BoxShape.circle,
                ),
              ),

              SizedBox(width: 2.w),

              Text(

                _getStatusText(
                  status,
                ),

                style:
                    GoogleFonts.poppins(

                  color:
                      statusColor,

                  fontWeight:
                      FontWeight.w700,

                  fontSize: 10.5.sp,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.7.h),

          // =================================================
          // FLIGHT
          // =================================================

          if (isFlight) ...[

            _compactSectionTitle(
              "✈️ Нислэг",
            ),

            _compactRow(
              "Нислэг",
              flightNumber,
            ),

            _compactRow(
              "Чиглэл",
              "$origin → $destination",
            ),

            _compactRow(
              "Зорчигч",
              passenger,
            ),

            _compactRow(
              "Утас",
              phone,
            ),
          ],

          // =================================================
          // TAXI
          // =================================================

          if (isTaxi) ...[

            _compactSectionTitle(
              "🚕 Такси",
            ),

            _compactRow(
              "Нэр",
              passenger,
            ),

            _compactRow(
              "Утас",
              phone,
            ),

            _compactRow(
              "Дүүрэг",
              district,
            ),

            _compactRow(
              "Хороо",
              khoroo,
            ),

            _compactRow(
              "Гудамж",
              street,
            ),

            _compactRow(
              "Байр",
              apartment,
            ),

            _compactRow(
              "Хаяг",
              detailAddress,
            ),
          ],

          // =================================================
          // TOUR
          // =================================================

          if (!isFlight &&
              !isTaxi) ...[

            _compactSectionTitle(
              "🌍 Аялал",
            ),

            _compactRow(
              "Нэр",
              tourName,
            ),

            _compactRow(
              "Огноо",
              booking['date']
                      ?.toString() ??
                  '-',
            ),

            _compactRow(
              "Хугацаа",
              booking['duration']
                      ?.toString() ??
                  '-',
            ),

            _compactRow(
              "Аялалчид",
              "${booking['people'] ?? 0}",
            ),
          ],

          SizedBox(height: 1.5.h),

          Container(

            padding:
                EdgeInsets.symmetric(

              horizontal: 4.w,

              vertical: 1.3.h,
            ),

            decoration:
                BoxDecoration(

              color:
                  const Color(
                0xFFF8FAFF,
              ),

              borderRadius:
                  BorderRadius.circular(
                14,
              ),

              border: Border.all(
                color:
                    Colors.blue
                        .shade100,
              ),
            ),

            child: Row(

              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

              children: [

                Text(

                  "Үнэ",

                  style:
                      GoogleFonts.poppins(

                    fontWeight:
                        FontWeight.w600,

                    fontSize: 10.5.sp,
                  ),
                ),

                Text(

                  "₮ $totalPrice",

                  style:
                      GoogleFonts.poppins(

                    color:
                        const Color(
                      0xFF111827,
                    ),

                    fontWeight:
                        FontWeight.w700,

                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // COMPACT TITLE
  // =====================================================

  Widget _compactSectionTitle(
    String title,
  ) {

    return Padding(

      padding: EdgeInsets.only(
        bottom: 1.2.h,
      ),

      child: Text(

        title,

        style:
            GoogleFonts.poppins(

          fontSize: 11.5.sp,

          fontWeight:
              FontWeight.w700,

          color:
              const Color(
            0xFF111827,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // COMPACT ROW
  // =====================================================

  Widget _compactRow(

    String label,

    String value,

  ) {

    return Padding(

      padding: EdgeInsets.only(
        bottom: 0.9.h,
      ),

      child: Row(

        children: [

          SizedBox(

            width: 28.w,

            child: Text(

              "$label :",

              style:
                  GoogleFonts.poppins(

                fontSize: 10.sp,

                fontWeight:
                    FontWeight.w600,

                color:
                    Colors.grey
                        .shade700,
              ),
            ),
          ),

          Expanded(

            child: Text(

              value.isEmpty
                  ? "-"
                  : value,

              textAlign:
                  TextAlign.right,

              maxLines: 1,

              overflow:
                  TextOverflow
                      .ellipsis,

              style:
                  GoogleFonts.poppins(

                fontSize: 10.sp,

                fontWeight:
                    FontWeight.w700,

                color:
                    const Color(
                  0xFF111827,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}