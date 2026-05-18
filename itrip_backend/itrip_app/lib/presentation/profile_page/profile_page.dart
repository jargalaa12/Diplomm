import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../services/api_service.dart';

import '../login_screen/login_screen.dart';
import './widgets/edit_profile_modal.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {

  // =====================================================
  // USER
  // =====================================================

  String _userName = '';

  String _userEmail = '';

  String _userPhone = '';

  String _avatarUrl =
      'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png';

  bool _isLoading = true;

  // =====================================================
  // ❤️ FAVORITES
  // =====================================================

  List<dynamic> _favorites = [];

  // =====================================================
  // INIT
  // =====================================================

  @override
  void initState() {

    super.initState();

    _fetchProfile();
  }

  // =====================================================
  // FETCH PROFILE
  // =====================================================

  Future<void> _fetchProfile() async {

    try {

      final data =
          await ApiService.getProfile();

      final favorites =
          await ApiService.getFavorites();

      setState(() {

        _userName =
            data["username"] ??
            data["full_name"] ??
            "";

        _userEmail =
            data["email"] ??
            "";

        _userPhone =
            data["phone"] ??
            "";

        // ❤️ FAVORITES
        _favorites = favorites;

        if (data["profile_image"] !=
                null &&
            data["profile_image"]
                .toString()
                .isNotEmpty) {

          _avatarUrl =
              ApiService.getImageUrl(
            data["profile_image"],
          );
        }

        _isLoading = false;
      });

    } catch (e) {

      print(e);

      setState(() {

        _isLoading = false;
      });

      Fluttertoast.showToast(
        msg:
            "Profile load failed",
      );
    }
  }

  // =====================================================
  // EDIT PROFILE
  // =====================================================

  void _showEditProfileModal() {

    showModalBottomSheet(

      context: context,

      isScrollControlled: true,

      backgroundColor:
          Colors.transparent,

      builder:
          (context) =>
              EditProfileModal(

        currentName:
            _userName,

        currentEmail:
            _userEmail,

        currentPhone:
            _userPhone,

        onSave: (
          name,
          email,
          phone,
        ) async {

          try {

            await ApiService
                .updateProfile(

              fullName: name,

              email: email,

              phone: phone,
            );

            setState(() {

              _userName = name;

              _userEmail = email;

              _userPhone = phone;
            });

            Fluttertoast.showToast(

              msg:
                  'Профайл шинэчлэгдлээ',
            );

          } catch (e) {

            Fluttertoast.showToast(

              msg:
                  'Алдаа гарлаа',
            );
          }
        },
      ),
    );
  }

  // =====================================================
  // LOGOUT
  // =====================================================

  Future<void> _logout() async {

    try {

      await ApiService.logout();

    } catch (e) {

      print(e);
    }

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(

        builder: (_) =>
            const LoginScreen(),
      ),

      (route) => false,
    );
  }

  // =====================================================
  // REMOVE FAVORITE
  // =====================================================

  Future<void> _removeFavorite(
    int favoriteId,
  ) async {

    try {

      await ApiService.removeFavorite(
        favoriteId,
      );

      setState(() {

        _favorites.removeWhere(
          (item) =>
              item["id"] ==
              favoriteId,
        );
      });

      Fluttertoast.showToast(
        msg:
            "❤️ Дуртай аяллаас хасагдлаа",
      );

    } catch (e) {

      Fluttertoast.showToast(
        msg:
            "Алдаа гарлаа",
      );
    }
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {

    if (_isLoading) {

      return const Scaffold(

        body: Center(

          child:
              CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      );
    }

    return Scaffold(

      backgroundColor:
          const Color(0xFFF7F8FA),

      body: SafeArea(

        child: RefreshIndicator(

          onRefresh:
              _fetchProfile,

          child: ListView(

            physics:
                const BouncingScrollPhysics(),

            padding:
                EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 2.h,
            ),

            children: [

              // =====================================================
              // HEADER
              // =====================================================

              Container(

                padding:
                    EdgeInsets.all(
                  5.w,
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
                        0.04,
                      ),

                      blurRadius: 14,
                    ),
                  ],
                ),

                child: Column(

                  children: [

                    Row(

                      children: [

                        Stack(

                          children: [

                            CircleAvatar(

                              radius: 32,

                              backgroundImage:
                                  NetworkImage(
                                _avatarUrl,
                              ),
                            ),

                            Positioned(

                              bottom: 0,

                              right: 0,

                              child:
                                  GestureDetector(

                                onTap:
                                    _showEditProfileModal,

                                child:
                                    Container(

                                  padding:
                                      const EdgeInsets.all(
                                    5,
                                  ),

                                  decoration:
                                      const BoxDecoration(

                                    color:
                                        Color(
                                      0xFFFF7A00,
                                    ),

                                    shape:
                                        BoxShape.circle,
                                  ),

                                  child:
                                      const Icon(

                                    Icons.edit,

                                    size: 14,

                                    color:
                                        Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 4.w),

                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(

                                _userName,

                                maxLines: 1,

                                overflow:
                                    TextOverflow
                                        .ellipsis,

                                style:
                                    GoogleFonts.dmSans(

                                  fontSize: 13.sp,

                                  fontWeight:
                                      FontWeight
                                          .bold,

                                  color:
                                      const Color(
                                    0xFF111827,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 0.3.h,
                              ),

                              Text(

                                _userEmail,

                                maxLines: 1,

                                overflow:
                                    TextOverflow
                                        .ellipsis,

                                style:
                                    GoogleFonts.dmSans(

                                  fontSize: 9.5.sp,

                                  color:
                                      Colors.grey
                                          .shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    Row(

                      children: [

                        Expanded(

                          child:
                              _buildInfoCard(

                            Icons.phone,

                            "Утас",

                            _userPhone,
                          ),
                        ),

                        SizedBox(width: 3.w),

                        Expanded(

                          child:
                              _buildInfoCard(

                            Icons.favorite,

                            "Дуртай",

                            "${_favorites.length}",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.5.h),

              // =====================================================
              // FAVORITES
              // =====================================================

              Row(

                children: [

                  Text(

                    "❤️ Дуртай аялал",

                    style:
                        GoogleFonts.dmSans(

                      fontSize: 12.sp,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          const Color(
                        0xFF111827,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Text(

                    "${_favorites.length}",

                    style:
                        GoogleFonts.dmSans(

                      fontSize: 9.5.sp,

                      fontWeight:
                          FontWeight.w700,

                      color:
                          Colors.orange,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.5.h),

              // =====================================================
              // EMPTY FAVORITES
              // =====================================================

              if (_favorites.isEmpty)

                Container(

                  padding:
                      EdgeInsets.all(5.w),

                  decoration:
                      BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),

                  child: Column(

                    children: [

                      Icon(

                        Icons.favorite_border,

                        size: 50,

                        color:
                            Colors.grey
                                .shade400,
                      ),

                      SizedBox(height: 1.h),

                      Text(

                        "Дуртай аялал байхгүй байна",

                        style:
                            GoogleFonts.dmSans(

                          fontSize: 10.sp,

                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )

              else

                SizedBox(

                  height: 24.h,

                  child: ListView.builder(

                    scrollDirection:
                        Axis.horizontal,

                    itemCount:
                        _favorites.length,

                    itemBuilder:
                        (context, index) {

                      final favorite =
                          _favorites[index];

                      return Container(

                        width: 46.w,

                        margin:
                            EdgeInsets.only(
                          right: 3.w,
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

                              blurRadius: 10,
                            ),
                          ],
                        ),

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Stack(

                              children: [

                                ClipRRect(

                                  borderRadius:
                                      const BorderRadius.only(

                                    topLeft:
                                        Radius.circular(
                                      18,
                                    ),

                                    topRight:
                                        Radius.circular(
                                      18,
                                    ),
                                  ),

                                  child:
                                      Image.network(

                                    favorite["image"] ??
                                        "",

                                    height: 14.h,

                                    width:
                                        double.infinity,

                                    fit:
                                        BoxFit.cover,
                                  ),
                                ),

                                Positioned(

                                  top: 8,

                                  right: 8,

                                  child:
                                      GestureDetector(

                                    onTap: () {

                                      _removeFavorite(
                                        favorite["id"],
                                      );
                                    },

                                    child:
                                        Container(

                                      padding:
                                          const EdgeInsets.all(
                                        6,
                                      ),

                                      decoration:
                                          BoxDecoration(

                                        color: Colors
                                            .black
                                            .withOpacity(
                                          0.4,
                                        ),

                                        shape:
                                            BoxShape.circle,
                                      ),

                                      child:
                                          const Icon(

                                        Icons.favorite,

                                        color:
                                            Colors.red,

                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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

                                      favorite[
                                              "tour_name"] ??
                                          "",

                                      maxLines: 1,

                                      overflow:
                                          TextOverflow
                                              .ellipsis,

                                      style:
                                          GoogleFonts.dmSans(

                                        fontSize:
                                            10.sp,

                                        fontWeight:
                                            FontWeight
                                                .bold,

                                        color:
                                            const Color(
                                          0xFF111827,
                                        ),
                                      ),
                                    ),

                                    SizedBox(
                                      height: 0.3.h,
                                    ),

                                    Text(

                                      favorite[
                                              "location"] ??
                                          "",

                                      style:
                                          GoogleFonts.dmSans(

                                        fontSize:
                                            8.8.sp,

                                        color:
                                            Colors.grey
                                                .shade700,
                                      ),
                                    ),

                                    const Spacer(),

                                    Text(

                                      "₮${favorite["price"] ?? "0"}",

                                      style:
                                          GoogleFonts.dmSans(

                                        fontSize:
                                            10.5.sp,

                                        fontWeight:
                                            FontWeight
                                                .bold,

                                        color:
                                            const Color(
                                          0xFFFF7A00,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              SizedBox(height: 2.5.h),

              // =====================================================
              // SETTINGS
              // =====================================================

              Text(

                "Тохиргоо",

                style:
                    GoogleFonts.dmSans(

                  fontSize: 12.sp,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      const Color(
                    0xFF111827,
                  ),
                ),
              ),

              SizedBox(height: 1.4.h),

              _buildSettingItem(

                Icons.person_outline,

                "Профайл засах",

                _showEditProfileModal,
              ),

              _buildSettingItem(

                Icons.notifications_none,

                "Мэдэгдэл",

                () {},
              ),

              _buildSettingItem(

                Icons.help_outline,

                "Тусламж",

                () {},
              ),

              SizedBox(height: 2.5.h),

              // =====================================================
              // LOGOUT
              // =====================================================

              SizedBox(

                height: 50,

                child:
                    ElevatedButton(

                  onPressed: () async {

                    await _logout();
                  },

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        const Color(
                      0xFFFF7A00,
                    ),

                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),

                  child: Text(

                    "Гарах",

                    style:
                        GoogleFonts.dmSans(

                      fontSize: 10.5.sp,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // INFO CARD
  // =====================================================

  Widget _buildInfoCard(

    IconData icon,

    String title,

    String value,

  ) {

    return Container(

      padding:
          EdgeInsets.symmetric(
        vertical: 1.5.h,
      ),

      decoration:
          BoxDecoration(

        color:
            const Color(
          0xFFF7F8FA,
        ),

        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),

      child: Column(

        children: [

          Icon(

            icon,

            size: 18,

            color:
                Colors.orange,
          ),

          SizedBox(height: 0.6.h),

          Text(

            title,

            style:
                GoogleFonts.dmSans(

              fontSize: 8.8.sp,

              color:
                  Colors.grey
                      .shade600,
            ),
          ),

          SizedBox(height: 0.2.h),

          Text(

            value,

            maxLines: 1,

            overflow:
                TextOverflow
                    .ellipsis,

            style:
                GoogleFonts.dmSans(

              fontSize: 9.5.sp,

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
    );
  }

  // =====================================================
  // SETTINGS ITEM
  // =====================================================

  Widget _buildSettingItem(

    IconData icon,

    String title,

    VoidCallback onTap,

  ) {

    return Container(

      margin:
          EdgeInsets.only(
        bottom: 1.2.h,
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
              0.03,
            ),

            blurRadius: 8,
          ),
        ],
      ),

      child: ListTile(

        onTap: onTap,

        contentPadding:
            EdgeInsets.symmetric(
          horizontal: 4.w,
        ),

        leading: Container(

          padding:
              const EdgeInsets.all(
            9,
          ),

          decoration:
              BoxDecoration(

            color:
                const Color(
              0xFFFFF4EB,
            ),

            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),

          child: Icon(

            icon,

            color:
                Colors.orange,

            size: 18,
          ),
        ),

        title: Text(

          title,

          style:
              GoogleFonts.dmSans(

            fontSize: 10.sp,

            fontWeight:
                FontWeight.w700,

            color:
                const Color(
              0xFF111827,
            ),
          ),
        ),

        trailing:
            const Icon(
          Icons.chevron_right,
          size: 20,
        ),
      ),
    );
  }
}