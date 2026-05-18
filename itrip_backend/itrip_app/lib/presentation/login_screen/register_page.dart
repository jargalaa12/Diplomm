import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();

  final fullName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();

  // ✅ PASSWORD REPEAT
  final confirmPassword = TextEditingController();

  bool loading = false;

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void dispose() {

    fullName.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();

    super.dispose();
  }

  Future<void> register() async {

    if (!_formKey.currentState!.validate()) return;

    // ✅ PASSWORD CHECK
    if (password.text != confirmPassword.text) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Нууц үг таарахгүй байна ❌"),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    setState(() => loading = true);

    try {

      await ApiService.registerUser(
        fullName: fullName.text.trim(),
        email: email.text.trim(),
        password: password.text.trim(),
        phone: phone.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Амжилттай бүртгэгдлээ 🎉"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Алдаа: $e"),
          backgroundColor: Colors.red,
        ),
      );

    } finally {

      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Widget buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),

      child: TextFormField(
        controller: controller,

        obscureText: isPassword
            ? !isPasswordVisible
            : isConfirmPassword
                ? !isConfirmPasswordVisible
                : false,

        style: const TextStyle(color: Colors.white),

        decoration: InputDecoration(

          hintText: hint,

          hintStyle: const TextStyle(
            color: Colors.white70,
          ),

          prefixIcon: Icon(
            icon,
            color: Colors.white,
          ),

          suffixIcon: isPassword || isConfirmPassword
              ? IconButton(
                  icon: Icon(
                    isPassword
                        ? (isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off)
                        : (isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),

                    color: Colors.white,
                  ),

                  onPressed: () {

                    setState(() {

                      if (isPassword) {
                        isPasswordVisible = !isPasswordVisible;
                      }

                      if (isConfirmPassword) {
                        isConfirmPasswordVisible =
                            !isConfirmPasswordVisible;
                      }
                    });
                  },
                )
              : null,

          filled: true,
          fillColor: Colors.white.withOpacity(0.2),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),

        validator: (value) {

          if (value == null || value.isEmpty) {
            return '$hint оруулна уу';
          }

          if (hint == "И-мэйл" && !value.contains('@')) {
            return 'Зөв и-мэйл оруулна уу';
          }

          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      body: Container(

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Center(
            child: ConstrainedBox(

              constraints: const BoxConstraints(
                maxWidth: 450,
              ),

              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const Icon(
                          Icons.person_add_alt_1,
                          size: 80,
                          color: Colors.white,
                        ),

                        SizedBox(height: 4.h),

                        const Text(
                          "Бүртгүүлэх",

                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        // ================= NAME =================
                        buildInput(
                          controller: fullName,
                          hint: "Овог нэр",
                          icon: Icons.person,
                        ),

                        // ================= EMAIL =================
                        buildInput(
                          controller: email,
                          hint: "И-мэйл",
                          icon: Icons.email,
                        ),

                        // ================= PHONE =================
                        buildInput(
                          controller: phone,
                          hint: "Утасны дугаар",
                          icon: Icons.phone,
                        ),

                        // ================= PASSWORD =================
                        buildInput(
                          controller: password,
                          hint: "Нууц үг",
                          icon: Icons.lock,
                          isPassword: true,
                        ),

                        // ================= CONFIRM PASSWORD =================
                        buildInput(
                          controller: confirmPassword,
                          hint: "Нууц үг давтах",
                          icon: Icons.lock_outline,
                          isConfirmPassword: true,
                        ),

                        SizedBox(height: 3.h),

                        // ================= REGISTER BUTTON =================
                        SizedBox(
                          width: double.infinity,
                          height: 52,

                          child: ElevatedButton(
                            onPressed: loading
                                ? null
                                : register,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: theme.primaryColor,

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                            ),

                            child: loading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "БҮРТГҮҮЛЭХ",

                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },

                          child: const Text(
                            "Бүртгэлтэй юу? Нэвтрэх",
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
      ),
    );
  }
}