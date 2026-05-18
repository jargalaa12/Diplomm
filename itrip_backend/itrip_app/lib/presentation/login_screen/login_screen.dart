import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_service.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final _fullNameController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  bool _isPasswordVisible =
      false;

  bool _isLoading = false;

  // =====================================
  // ERROR TEXT
  // =====================================

  String? _usernameError;

  String? _passwordError;

  @override
  void dispose() {

    _fullNameController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  // =====================================
  // LOGIN
  // =====================================

  Future<void> _handleLogin() async {

    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    setState(() {

      _isLoading = true;

      _usernameError = null;

      _passwordError = null;
    });

    try {

      final data =
          await ApiService.loginUser(

        _fullNameController.text
            .trim(),

        _passwordController.text
            .trim(),
      );

      print(
        "LOGIN RESPONSE: $data",
      );

      final token =
          data['token'] ??
              data['access'];

      if (token == null) {

        throw Exception(
          "Token ирсэнгүй ❌",
        );
      }

      final prefs =
          await SharedPreferences
              .getInstance();

      /// 🔥 DELETE OLD TOKEN
      await prefs.remove(
        'token',
      );

      /// 🔥 SAVE NEW TOKEN
      ApiService.token =
          token;

      await prefs.setString(
        'token',
        token,
      );

      print(
        "NEW TOKEN: $token",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(

          content: Text(
            "Амжилттай нэвтэрлээ 🎉",
          ),

          backgroundColor:
              Colors.green,
        ),
      );

      Navigator.pushReplacementNamed(

        context,

        AppRoutes.home,
      );

    } catch (e) {

      print(
        "LOGIN ERROR: $e",
      );

      final error =
          e.toString().toLowerCase();

      setState(() {

        _usernameError = null;

        _passwordError = null;

        // =============================
        // USERNAME ERROR
        // =============================

        if (

            error.contains(
                "user not found") ||

            error.contains(
                "username not found")

        ) {

          _usernameError =
              "Таны username буруу байна";
        }

        // =============================
        // PASSWORD ERROR
        // =============================

        else if (

            error.contains(
                "wrong password") ||

            error.contains(
                "invalid password") ||

            error.contains(
                "incorrect password")

        ) {

          _passwordError =
              "Таны password буруу байна";
        }

        // =============================
        // INVALID LOGIN
        // =============================

        else if (

            error.contains(
                "invalid credentials") ||

            error.contains(
                "no active account")

        ) {

          _passwordError =
              "Нууц үг буруу байна";
        }

        // =============================
        // DEFAULT
        // =============================

        else {

          _passwordError =
              "Нэвтрэх мэдээлэл буруу байна";
        }
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(

          content: Text(
            "Алдаа: $e",
          ),

          backgroundColor:
              Colors.red,
        ),
      );

    } finally {

      if (mounted) {

        setState(() {

          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    final theme =
        Theme.of(context);

    return Scaffold(

      body: Container(

        decoration: BoxDecoration(

          gradient: LinearGradient(

            colors: [

              theme.colorScheme.primary,

              theme.colorScheme.secondary,
            ],

            begin:
                Alignment.topLeft,

            end:
                Alignment.bottomRight,
          ),
        ),

        child: SafeArea(

          child: Center(

            child: ConstrainedBox(

              constraints:
                  const BoxConstraints(
                maxWidth: 450,
              ),

              child: Padding(

                padding:
                    EdgeInsets.symmetric(
                  horizontal: 5.w,
                ),

                child: Form(

                  key: _formKey,

                  child: Column(

                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [

                      // =====================================
                      // LOGO
                      // =====================================

                      const Icon(

                        Icons.flight_takeoff,

                        size: 80,

                        color: Colors.white,
                      ),

                      SizedBox(
                        height: 4.h,
                      ),

                      const Text(

                        'iTrip Mongolia',

                        style: TextStyle(

                          fontSize: 26,

                          fontWeight:
                              FontWeight.bold,

                          color: Colors.white,
                        ),
                      ),

                      SizedBox(
                        height: 4.h,
                      ),

                      // =====================================
                      // USERNAME
                      // =====================================

                      TextFormField(

                        controller:
                            _fullNameController,

                        style:
                            const TextStyle(
                          color: Colors.white,
                        ),

                        decoration:
                            InputDecoration(

                          hintText: 'Username',

                          errorText:
                              _usernameError,

                          hintStyle:
                              const TextStyle(
                            color:
                                Colors.white70,
                          ),

                          prefixIcon:
                              const Icon(

                            Icons.person,

                            color:
                                Colors.white,
                          ),

                          filled: true,

                          fillColor:
                              Colors.white
                                  .withOpacity(
                            0.2,
                          ),

                          border:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),

                            borderSide:
                                BorderSide.none,
                          ),

                          errorBorder:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),

                            borderSide:
                                const BorderSide(

                              color:
                                  Colors.red,

                              width: 2,
                            ),
                          ),

                          focusedErrorBorder:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),

                            borderSide:
                                const BorderSide(

                              color:
                                  Colors.red,

                              width: 2,
                            ),
                          ),
                        ),

                        validator:
                            (value) {

                          if (value ==
                                  null ||
                              value
                                  .isEmpty) {

                            return 'Username оруулна уу';
                          }

                          return null;
                        },
                      ),

                      SizedBox(
                        height: 2.h,
                      ),

                      // =====================================
                      // PASSWORD
                      // =====================================

                      TextFormField(

                        controller:
                            _passwordController,

                        obscureText:
                            !_isPasswordVisible,

                        style:
                            const TextStyle(
                          color: Colors.white,
                        ),

                        decoration:
                            InputDecoration(

                          hintText:
                              'Password',

                          errorText:
                              _passwordError,

                          hintStyle:
                              const TextStyle(
                            color:
                                Colors.white70,
                          ),

                          prefixIcon:
                              const Icon(

                            Icons.lock,

                            color:
                                Colors.white,
                          ),

                          suffixIcon:
                              IconButton(

                            icon: Icon(

                              _isPasswordVisible

                                  ? Icons.visibility

                                  : Icons.visibility_off,

                              color:
                                  Colors.white,
                            ),

                            onPressed: () {

                              setState(() {

                                _isPasswordVisible =
                                    !_isPasswordVisible;
                              });
                            },
                          ),

                          filled: true,

                          fillColor:
                              Colors.white
                                  .withOpacity(
                            0.2,
                          ),

                          border:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),

                            borderSide:
                                BorderSide.none,
                          ),

                          errorBorder:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),

                            borderSide:
                                const BorderSide(

                              color:
                                  Colors.red,

                              width: 2,
                            ),
                          ),

                          focusedErrorBorder:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),

                            borderSide:
                                const BorderSide(

                              color:
                                  Colors.red,

                              width: 2,
                            ),
                          ),
                        ),

                        validator:
                            (value) {

                          if (value ==
                                  null ||
                              value
                                  .isEmpty) {

                            return 'Password оруулна уу';
                          }

                          return null;
                        },
                      ),

                      SizedBox(
                        height: 3.h,
                      ),

                      // =====================================
                      // LOGIN BUTTON
                      // =====================================

                      SizedBox(

                        width:
                            double.infinity,

                        height: 52,

                        child:
                            ElevatedButton(

                          onPressed:

                              _isLoading

                                  ? null

                                  : _handleLogin,

                          style:
                              ElevatedButton.styleFrom(

                            backgroundColor:
                                Colors.white,

                            foregroundColor:
                                theme.primaryColor,

                            shape:
                                RoundedRectangleBorder(

                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                            ),
                          ),

                          child:
                              _isLoading

                                  ? const CircularProgressIndicator()

                                  : const Text(

                                      'Нэвтрэх',

                                      style:
                                          TextStyle(

                                        fontSize:
                                            16,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                        ),
                      ),

                      SizedBox(
                        height: 3.h,
                      ),

                      // =====================================
                      // REGISTER
                      // =====================================

                      TextButton(

                        onPressed: () {

                          Navigator.pushNamed(

                            context,

                            AppRoutes.register,
                          );
                        },

                        child:
                            const Text(

                          'Шинэ хэрэглэгч үү? Бүртгүүлэх',

                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}