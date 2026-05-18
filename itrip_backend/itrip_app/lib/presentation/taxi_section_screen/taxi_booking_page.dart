import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../services/api_service.dart';

class TaxiBookingPage extends StatefulWidget {

  final Map taxi;

  const TaxiBookingPage({
    super.key,
    required this.taxi,
  });

  @override
  State<TaxiBookingPage>
      createState() =>
          _TaxiBookingPageState();
}

class _TaxiBookingPageState
    extends State<TaxiBookingPage> {

  static const Color orange =
      Color(0xFFFF6B00);

  static const Color bg =
      Color(0xFFF4F6F8);

  // =====================================================
  // USER INFO
  // =====================================================

  final nameController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final noteController =
      TextEditingController();

  // =====================================================
  // FLIGHT INFO
  // =====================================================

  final flightNoController =
      TextEditingController();

  // =====================================================
  // ADDRESS
  // =====================================================

  final districtController =
      TextEditingController();

  final khorooController =
      TextEditingController();

  final apartmentController =
      TextEditingController();

  final streetController =
      TextEditingController();

  final detailAddressController =
      TextEditingController();

  // =====================================================
  // DATE TIME
  // =====================================================

  DateTime? selectedDate;

  TimeOfDay? selectedTime;

  bool agreed = false;

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {

    final imageUrl =
        widget.taxi["image"] != null

        ? ApiService.getImageUrl(
            widget.taxi["image"],
          )

        : "";

    return Scaffold(

      backgroundColor: bg,

      body: SafeArea(

        child: Column(

          children: [

            _header(),

            Expanded(

              child:
                  SingleChildScrollView(

                padding:
                    EdgeInsets.all(
                  4.w,
                ),

                child: Column(

                  children: [

                    _carCard(imageUrl),

                    SizedBox(
                      height: 2.h,
                    ),

                    _flightInfoCard(),

                    SizedBox(
                      height: 2.h,
                    ),

                    _addressCard(),

                    SizedBox(
                      height: 2.h,
                    ),

                    _formCard(),

                    SizedBox(
                      height: 2.h,
                    ),

                    _noteCard(),

                    SizedBox(
                      height: 3.h,
                    ),
                  ],
                ),
              ),
            ),

            _bottomBar(),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // HEADER
  // =====================================================

  Widget _header() {

    return Padding(

      padding: EdgeInsets.all(
        3.w,
      ),

      child: Row(

        children: [

          GestureDetector(

            onTap: () =>
                Navigator.pop(
              context,
            ),

            child: const Icon(
              Icons.arrow_back,
            ),
          ),

          const Spacer(),

          Text(

            "Захиалгын мэдээлэл",

            style:
                GoogleFonts.poppins(

              fontSize: 15.sp,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  // =====================================================
  // CAR CARD
  // =====================================================

  Widget _carCard(
    String imageUrl,
  ) {

    return Container(

      padding: EdgeInsets.all(
        3.w,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Row(

        children: [

          Container(

            width: 25.w,

            height: 12.h,

            decoration: BoxDecoration(

              borderRadius:
                  BorderRadius.circular(
                14,
              ),

              color:
                  Colors.grey[200],

              image:
                  imageUrl.isNotEmpty

                  ? DecorationImage(

                      image:
                          NetworkImage(
                        imageUrl,
                      ),

                      fit: BoxFit.cover,
                    )

                  : null,
            ),
          ),

          SizedBox(
            width: 4.w,
          ),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(

                  widget.taxi["name"] ??
                      "",

                  style:
                      GoogleFonts.poppins(

                    fontSize: 12.sp,

                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                SizedBox(
                  height: 1.h,
                ),

                Text(

                  "₮ ${widget.taxi["price"] ?? 0}",

                  style:
                      GoogleFonts.poppins(

                    color: orange,

                    fontWeight:
                        FontWeight.w700,

                    fontSize: 13.sp,
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
  // FLIGHT INFO
  // =====================================================

  Widget _flightInfoCard() {

    return _card(

      Column(

        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [

          _title(
            "Нислэгийн мэдээлэл",
          ),

          SizedBox(
            height: 2.h,
          ),

          _datePicker(),

          SizedBox(
            height: 1.h,
          ),

          _timePicker(),

          SizedBox(
            height: 1.h,
          ),

          _inputField(
            "Нислэгийн дугаар",
            flightNoController,
          ),
        ],
      ),
    );
  }

  // =====================================================
  // ADDRESS CARD
  // =====================================================

  Widget _addressCard() {

    return _card(

      Column(

        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [

          _title(
            "Хаягийн мэдээлэл",
          ),

          SizedBox(
            height: 2.h,
          ),

          _inputField(
            "Дүүрэг",
            districtController,
          ),

          SizedBox(
            height: 1.h,
          ),

          _inputField(
            "Хороо",
            khorooController,
          ),

          SizedBox(
            height: 1.h,
          ),

          _inputField(
            "Хороолол / Байр",
            apartmentController,
          ),

          SizedBox(
            height: 1.h,
          ),

          _inputField(
            "Гудамж",
            streetController,
          ),

          SizedBox(
            height: 1.h,
          ),

          _inputField(
            "Дэлгэрэнгүй хаяг",
            detailAddressController,
          ),
        ],
      ),
    );
  }

  // =====================================================
  // USER FORM
  // =====================================================

  Widget _formCard() {

    return _card(

      Column(

        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [

          _title(
            "Хэрэглэгчийн мэдээлэл",
          ),

          SizedBox(
            height: 2.h,
          ),

          _inputField(
            "Овог нэр",
            nameController,
          ),

          SizedBox(
            height: 1.h,
          ),

          _inputField(
            "Утас",
            phoneController,
          ),

          SizedBox(
            height: 1.h,
          ),

          _inputField(
            "Имэйл",
            emailController,
          ),
        ],
      ),
    );
  }

  // =====================================================
  // NOTE
  // =====================================================

  Widget _noteCard() {

    return _card(

      Column(

        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [

          _title(
            "Нэмэлт мэдээлэл",
          ),

          SizedBox(
            height: 1.h,
          ),

          TextField(

            controller:
                noteController,

            maxLines: 4,

            decoration:
                InputDecoration(

              hintText:
                  "Жолоочид үлдээх мэдээлэл",

              hintStyle:
                  GoogleFonts.poppins(),

              filled: true,

              fillColor:
                  const Color(
                0xFFF7F7F7,
              ),

              border:
                  OutlineInputBorder(

                borderRadius:
                    BorderRadius.circular(
                  14,
                ),

                borderSide:
                    BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // DATE PICKER
  // =====================================================

  Widget _datePicker() {

    return ListTile(

      tileColor: const Color(
        0xFFF7F7F7,
      ),

      shape:
          RoundedRectangleBorder(

        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),

      title: Text(

        selectedDate == null

            ? "Нисэх огноо"

            : selectedDate
                .toString()
                .split(" ")[0],

        style:
            GoogleFonts.poppins(),
      ),

      trailing: const Icon(
        Icons.calendar_today,
      ),

      onTap: () async {

        final picked =
            await showDatePicker(

          context: context,

          initialDate:
              DateTime.now(),

          firstDate:
              DateTime.now(),

          lastDate:
              DateTime(2030),
        );

        if (picked != null) {

          setState(() {

            selectedDate =
                picked;
          });
        }
      },
    );
  }

  // =====================================================
  // TIME PICKER
  // =====================================================

  Widget _timePicker() {

    return ListTile(

      tileColor: const Color(
        0xFFF7F7F7,
      ),

      shape:
          RoundedRectangleBorder(

        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),

      title: Text(

        selectedTime == null

            ? "Нисэх цаг"

            : selectedTime!
                .format(context),

        style:
            GoogleFonts.poppins(),
      ),

      trailing: const Icon(
        Icons.access_time,
      ),

      onTap: () async {

        final picked =
            await showTimePicker(

          context: context,

          initialTime:
              TimeOfDay.now(),
        );

        if (picked != null) {

          setState(() {

            selectedTime =
                picked;
          });
        }
      },
    );
  }

  // =====================================================
  // INPUT FIELD
  // =====================================================

  Widget _inputField(
    String hint,
    TextEditingController
        controller,
  ) {

    return TextField(

      controller: controller,

      style:
          GoogleFonts.poppins(),

      decoration: InputDecoration(

        hintText: hint,

        hintStyle:
            GoogleFonts.poppins(),

        filled: true,

        fillColor:
            const Color(
          0xFFF7F7F7,
        ),

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(
            14,
          ),

          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }

  // =====================================================
  // CARD
  // =====================================================

  Widget _card(
    Widget child,
  ) {

    return Container(

      padding: EdgeInsets.all(
        4.w,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: child,
    );
  }

  // =====================================================
  // TITLE
  // =====================================================

  Widget _title(
    String text,
  ) {

    return Text(

      text,

      style:
          GoogleFonts.poppins(

        fontSize: 12.sp,

        fontWeight:
            FontWeight.w700,
      ),
    );
  }

  // =====================================================
  // BOTTOM BAR
  // =====================================================

 // =====================================================
// BOTTOM BAR
// =====================================================

Widget _bottomBar() {

  return Container(

    padding: EdgeInsets.all(
      4.w,
    ),

    decoration: BoxDecoration(

      color: Colors.white,

      boxShadow: [

        BoxShadow(

          color: Colors.black
              .withOpacity(
            0.05,
          ),

          blurRadius: 10,

          offset: const Offset(
            0,
            -2,
          ),
        ),
      ],
    ),

    child: Column(

      mainAxisSize:
          MainAxisSize.min,

      children: [

        // ===============================================
        // TERMS
        // ===============================================

        Row(

          children: [

            Checkbox(

              value: agreed,

              activeColor:
                  orange,

              shape:
                  RoundedRectangleBorder(

                borderRadius:
                    BorderRadius.circular(
                  4,
                ),
              ),

              onChanged: (v) {

                setState(() {

                  agreed =
                      v ?? false;
                });
              },
            ),

            Expanded(

              child: Text(

                "Үйлчилгээний нөхцөл зөвшөөрч байна",

                style:
                    GoogleFonts.poppins(

                  fontSize: 10.sp,

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

        // ===============================================
        // BOOK BUTTON
        // ===============================================

        SizedBox(

          width: double.infinity,

          height: 6.5.h,

          child: ElevatedButton(

            onPressed:

                agreed

                ? () async {

                    // ===========================
                    // VALIDATION
                    // ===========================

                    if (
                        selectedDate ==
                            null ||
                        selectedTime ==
                            null) {

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(

                        const SnackBar(
                          content: Text(
                            "Огноо болон цаг сонгоно уу",
                          ),
                        ),
                      );

                      return;
                    }

                    if (

                        nameController
                            .text
                            .trim()
                            .isEmpty ||

                        phoneController
                            .text
                            .trim()
                            .isEmpty ||

                        districtController
                            .text
                            .trim()
                            .isEmpty ||

                        khorooController
                            .text
                            .trim()
                            .isEmpty ||

                        apartmentController
                            .text
                            .trim()
                            .isEmpty ||

                        streetController
                            .text
                            .trim()
                            .isEmpty ||

                        detailAddressController
                            .text
                            .trim()
                            .isEmpty
                    ) {

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(

                        const SnackBar(
                          content: Text(
                            "Бүх мэдээллээ оруулна уу",
                          ),
                        ),
                      );

                      return;
                    }

                    try {

                      // =========================
                      // API REQUEST
                      // =========================

                      await ApiService
                          .createTaxiBooking(

                        taxiId:
                            widget
                                .taxi["id"],

                        firstName:
                            nameController
                                .text
                                .trim(),

                        phone:
                            phoneController
                                .text
                                .trim(),

                        email:
                            emailController
                                .text
                                .trim(),

                        district:
                            districtController
                                .text
                                .trim(),

                        khoroo:
                            khorooController
                                .text
                                .trim(),

                        apartment:
                            apartmentController
                                .text
                                .trim(),

                        street:
                            streetController
                                .text
                                .trim(),

                        detailAddress:
                            detailAddressController
                                .text
                                .trim(),

                        flightNumber:
                            flightNoController
                                .text
                                .trim(),

                        pickupDate:
                            selectedDate!
                                .toString()
                                .split(" ")[0],

                        pickupTime:
                            "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00",

                        note:
                            noteController
                                .text
                                .trim(),
                      );

                      if (!mounted) {
                        return;
                      }

                      // =========================
                      // SUCCESS PAGE
                      // =========================

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                              _successPage(),
                        ),
                      );

                    } catch (e) {

                      if (!mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(

                        SnackBar(

                          backgroundColor:
                              Colors.red,

                          content: Text(
                            e.toString(),
                          ),
                        ),
                      );
                    }
                  }

                : null,

            style:
                ElevatedButton
                    .styleFrom(

              backgroundColor:
                  orange,

              disabledBackgroundColor:
                  Colors.grey
                      .shade400,

              elevation: 0,

              shape:
                  RoundedRectangleBorder(

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
            ),

            child: Row(

              mainAxisAlignment:
                  MainAxisAlignment
                      .center,

              children: [

                Icon(

                  Icons.local_taxi,

                  color:
                      Colors.white,

                  size: 18.sp,
                ),

                SizedBox(
                  width: 2.w,
                ),

                Text(

                  "Захиалах",

                  style:
                      GoogleFonts.poppins(

                    fontSize: 12.sp,

                    fontWeight:
                        FontWeight.w600,

                    color:
                        Colors.white,
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
  // =====================================================
  // SUCCESS PAGE
  // =====================================================

  Widget _successPage() {

    return Scaffold(

      backgroundColor:
          Colors.white,

      body: Center(

        child: Padding(

          padding: EdgeInsets.all(
            8.w,
          ),

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment
                    .center,

            children: [

              Container(

                width: 24.w,

                height: 24.w,

                decoration:
                    BoxDecoration(

                  color: Colors.green
                      .withOpacity(
                    0.1,
                  ),

                  shape:
                      BoxShape.circle,
                ),

                child: Icon(

                  Icons.check_circle,

                  color:
                      Colors.green,

                  size: 50.sp,
                ),
              ),

              SizedBox(
                height: 3.h,
              ),

              Text(

                "Амжилттай захиаллаа 🚕",

                style:
                    GoogleFonts.poppins(

                  fontSize: 16.sp,

                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              SizedBox(
                height: 1.h,
              ),

              Text(

                "Таны такси захиалга амжилттай бүртгэгдлээ.",

                textAlign:
                    TextAlign.center,

                style:
                    GoogleFonts.poppins(

                  color:
                      Colors.grey
                          .shade600,
                ),
              ),

              SizedBox(
                height: 4.h,
              ),

              SizedBox(

                width: double.infinity,

                height: 6.h,

                child: ElevatedButton(

                  onPressed: () {

                    Navigator.popUntil(
                      context,
                      (route) =>
                          route.isFirst,
                    );
                  },

                  style:
                      ElevatedButton
                          .styleFrom(

                    backgroundColor:
                        orange,
                  ),

                  child: Text(

                    "Нүүр хуудас",

                    style:
                        GoogleFonts.poppins(

                      color:
                          Colors.white,

                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}