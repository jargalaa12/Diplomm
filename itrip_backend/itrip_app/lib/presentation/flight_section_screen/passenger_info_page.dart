import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../services/api_service.dart';

class PassengerInfoPage
    extends StatefulWidget {

  final int flightId;

  const PassengerInfoPage({
    super.key,
    required this.flightId,
  });

  @override
  State<PassengerInfoPage>
      createState() =>
          _PassengerInfoPageState();
}

class _PassengerInfoPageState
    extends State<PassengerInfoPage> {

  static const Color orange =
      Color(0xFFFF6B00);

  final _formKey =
      GlobalKey<FormState>();

  bool _isLoading = false;

  // =====================================================
  // CONTROLLERS
  // =====================================================

  final TextEditingController
      lastNameController =
      TextEditingController();

  final TextEditingController
      firstNameController =
      TextEditingController();

  final TextEditingController
      passportController =
      TextEditingController();

  final TextEditingController
      birthDateController =
      TextEditingController();

  final TextEditingController
      expireDateController =
      TextEditingController();

  // =====================================================
  // DROPDOWN VALUES
  // =====================================================

  String gender = "Эр";

  String nationality =
      "Mongolia";

  // =====================================================
  // DATE PICKER
  // =====================================================

  Future<void> _pickDate(
    TextEditingController controller,
  ) async {

    final picked =
        await showDatePicker(

      context: context,

      initialDate:
          DateTime.now(),

      firstDate:
          DateTime(1950),

      lastDate:
          DateTime(2100),
    );

    if (picked != null) {

      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  // =====================================================
  // INPUT FIELD
  // =====================================================

  Widget _inputField({

    required String hint,

    required TextEditingController
        controller,

    IconData? icon,

    VoidCallback? onTap,

    bool readOnly = false,

  }) {

    return Container(
      margin: EdgeInsets.only(
        bottom: 2.h,
      ),

      child: TextFormField(

        controller: controller,

        readOnly: readOnly,

        onTap: onTap,

        style:
            GoogleFonts.poppins(
          fontSize: 11.sp,

          fontWeight:
              FontWeight.w500,
        ),

        decoration: InputDecoration(

          hintText: hint,

          hintStyle:
              GoogleFonts.poppins(
            color: Colors.grey,

            fontSize: 10.8.sp,
          ),

          suffixIcon:
              icon != null

              ? Icon(
                  icon,
                  color: Colors.grey,
                )

              : null,

          filled: true,

          fillColor: Colors.white,

          contentPadding:
              EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),

          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),

            borderSide:
                BorderSide(
              color:
                  Colors.grey
                      .shade300,
            ),
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),

            borderSide:
                BorderSide(
              color:
                  Colors.grey
                      .shade300,
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              18,
            ),

            borderSide:
                const BorderSide(
              color: orange,
              width: 1.5,
            ),
          ),
        ),

        validator: (value) {

          if (
              value == null ||
              value.isEmpty) {

            return
                "Мэдээлэл оруулна уу";
          }

          return null;
        },
      ),
    );
  }

  // =====================================================
  // SUBMIT BOOKING
  // =====================================================

  Future<void> _submitBooking()
  async {

    if (
        !_formKey.currentState!
            .validate()) {

      return;
    }

    try {

      setState(() {
        _isLoading = true;
      });

      await ApiService
          .createFlightBooking(

        flightId:
            widget.flightId,

        firstName:
            firstNameController
                .text,

        lastName:
            lastNameController
                .text,

        gender: gender,

        nationality:
            nationality,

        birthDate:
            birthDateController
                .text,

        passportNumber:
            passportController
                .text,

        passportExpireDate:
            expireDateController
                .text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(
          content: Text(
            "Амжилттай захиаллаа ✈️",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }

    finally {

      if (mounted) {

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      backgroundColor:
          const Color(
        0xFFF4F6F8,
      ),

      // =================================================
      // BOTTOM BUTTON
      // =================================================

      bottomNavigationBar:
          Container(

        padding:
            EdgeInsets.fromLTRB(
          4.w,
          1.h,
          4.w,
          3.h,
        ),

        color: Colors.white,

        child: SizedBox(

          height: 6.2.h,

          child: ElevatedButton(

            style:
                ElevatedButton
                    .styleFrom(

              backgroundColor:
                  orange,

              elevation: 0,

              shape:
                  RoundedRectangleBorder(

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
            ),

            onPressed:
                _isLoading
                    ? null
                    : _submitBooking,

            child:
                _isLoading

                ? SizedBox(
                    width: 22.sp,
                    height: 22.sp,

                    child:
                        const CircularProgressIndicator(
                      color:
                          Colors.white,

                      strokeWidth:
                          2,
                    ),
                  )

                : Text(

                    "Захиалах",

                    style:
                        GoogleFonts.poppins(

                      fontSize:
                          12.sp,

                      fontWeight:
                          FontWeight
                              .w600,

                      color:
                          Colors.white,
                    ),
                  ),
          ),
        ),
      ),

      // =================================================
      // BODY
      // =================================================

      body: SafeArea(

        child: Column(

          children: [

            // =============================================
            // APP BAR
            // =============================================

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

                        "Аялагчийн мэдээлэл",

                        style:
                            GoogleFonts.poppins(

                          fontSize:
                              15.sp,

                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 12.w,
                  ),
                ],
              ),
            ),

            // =============================================
            // FORM
            // =============================================

            Expanded(

              child: Form(

                key: _formKey,

                child: ListView(

                  padding:
                      EdgeInsets.all(
                    4.w,
                  ),

                  children: [

                    Container(

                      padding:
                          EdgeInsets.all(
                        5.w,
                      ),

                      decoration:
                          BoxDecoration(

                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),

                        boxShadow: [

                          BoxShadow(

                            color:
                                Colors
                                    .black
                                    .withOpacity(
                              0.04,
                            ),

                            blurRadius:
                                14,

                            offset:
                                const Offset(
                              0,
                              6,
                            ),
                          ),
                        ],
                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          // =================================
                          // TITLE
                          // =================================

                          Row(

                            children: [

                              Text(

                                "Аялагч 1",

                                style:
                                    GoogleFonts.poppins(

                                  fontSize:
                                      14.sp,

                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),

                              SizedBox(
                                width: 2.w,
                              ),

                              Container(

                                padding:
                                    EdgeInsets.symmetric(

                                  horizontal:
                                      2.5.w,

                                  vertical:
                                      0.5.h,
                                ),

                                decoration:
                                    BoxDecoration(

                                  color: orange
                                      .withOpacity(
                                    0.1,
                                  ),

                                  borderRadius:
                                      BorderRadius.circular(
                                    30,
                                  ),
                                ),

                                child: Text(

                                  "Том хүн",

                                  style:
                                      GoogleFonts.poppins(

                                    color:
                                        orange,

                                    fontSize:
                                        9.sp,

                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 1.h,
                          ),

                          Text(

                            "(A-Z) латин үсэг байх хэрэгтэй.",

                            style:
                                GoogleFonts.poppins(

                              fontSize:
                                  10.sp,

                              color: Colors
                                  .grey
                                  .shade600,
                            ),
                          ),

                          SizedBox(
                            height: 2.5.h,
                          ),

                          // =================================
                          // INPUTS
                          // =================================

                          _inputField(
                            hint: "Овог",
                            controller:
                                lastNameController,
                          ),

                          _inputField(
                            hint: "Нэр",
                            controller:
                                firstNameController,
                          ),

                          _inputField(
                            hint:
                                "Төрсөн огноо",

                            controller:
                                birthDateController,

                            icon: Icons
                                .calendar_today,

                            readOnly: true,

                            onTap: () =>
                                _pickDate(
                              birthDateController,
                            ),
                          ),

                          // =================================
                          // GENDER
                          // =================================

                          Container(

                            margin:
                                EdgeInsets.only(
                              bottom: 2.h,
                            ),

                            padding:
                                EdgeInsets.symmetric(
                              horizontal:
                                  4.w,
                            ),

                            decoration:
                                BoxDecoration(

                              color:
                                  Colors.white,

                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),

                              border:
                                  Border.all(
                                color: Colors
                                    .grey
                                    .shade300,
                              ),
                            ),

                            child:
                                DropdownButtonHideUnderline(

                              child:
                                  DropdownButton<
                                      String>(

                                value: gender,

                                isExpanded:
                                    true,

                                items: [

                                  "Эр",
                                  "Эм",

                                ]
                                    .map(
                                      (
                                        e,
                                      ) =>
                                          DropdownMenuItem(

                                        value:
                                            e,

                                        child:
                                            Text(
                                          e,

                                          style:
                                              GoogleFonts.poppins(),
                                        ),
                                      ),
                                    )
                                    .toList(),

                                onChanged:
                                    (
                                      value,
                                    ) {

                                  setState(() {

                                    gender =
                                        value!;
                                  });
                                },
                              ),
                            ),
                          ),

                          // =================================
                          // NATIONALITY
                          // =================================

                          Container(

                            margin:
                                EdgeInsets.only(
                              bottom: 2.h,
                            ),

                            padding:
                                EdgeInsets.symmetric(
                              horizontal:
                                  4.w,
                            ),

                            decoration:
                                BoxDecoration(

                              color:
                                  Colors.white,

                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),

                              border:
                                  Border.all(
                                color: Colors
                                    .grey
                                    .shade300,
                              ),
                            ),

                            child:
                                DropdownButtonHideUnderline(

                              child:
                                  DropdownButton<
                                      String>(

                                value:
                                    nationality,

                                isExpanded:
                                    true,

                                items: [

                                  "Mongolia",
                                  "Korea",
                                  "Japan",
                                  "China",
                                  "USA",

                                ]
                                    .map(
                                      (
                                        e,
                                      ) =>
                                          DropdownMenuItem(

                                        value:
                                            e,

                                        child:
                                            Text(
                                          e,

                                          style:
                                              GoogleFonts.poppins(),
                                        ),
                                      ),
                                    )
                                    .toList(),

                                onChanged:
                                    (
                                      value,
                                    ) {

                                  setState(() {

                                    nationality =
                                        value!;
                                  });
                                },
                              ),
                            ),
                          ),

                          _inputField(

                            hint:
                                "Паспорт дугаар",

                            controller:
                                passportController,
                          ),

                          _inputField(

                            hint:
                                "Паспорт хүчинтэй хугацаа",

                            controller:
                                expireDateController,

                            icon:
                                Icons.calendar_today,

                            readOnly: true,

                            onTap: () =>
                                _pickDate(
                              expireDateController,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 4.h,
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
}