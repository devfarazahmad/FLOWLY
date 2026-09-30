import 'package:flowly/database/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  late final AuthController authController;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<AuthController>()) {
      authController = Get.find<AuthController>();
    } else {
      authController = Get.put(AuthController());
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // ============================================================
  // SIGN UP
  // ============================================================

  void _signup() {
    FocusScope.of(context).unfocus();

    final String password = passwordController.text;
    final String confirmPassword =
        confirmPasswordController.text;

    if (password != confirmPassword) {
      Get.snackbar(
        'Password Mismatch',
        'Password and confirm password do not match.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    authController.signup(
      email: emailController.text,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF222222),
            size: 20,
          ),
        ),

        title: const Text(
          'Flowly',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        centerTitle: true,
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35),

                // ==================================================
                // TITLE
                // ==================================================

                const Text(
                  'Create account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF222222),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Start your personal Flowly journey.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF777777),
                  ),
                ),

                const SizedBox(height: 40),

                // ==================================================
                // EMAIL
                // ==================================================

                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,

                  decoration: InputDecoration(
                    hintText: 'Enter your email',

                    hintStyle: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 15,
                    ),

                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF888888),
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 17,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF22C55E),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // ==================================================
                // PASSWORD
                // ==================================================

                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  textInputAction: TextInputAction.next,

                  decoration: InputDecoration(
                    hintText: 'Create a password',

                    hintStyle: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 15,
                    ),

                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: Color(0xFF888888),
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword =
                              !obscurePassword;
                        });
                      },

                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF888888),
                      ),
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 17,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF22C55E),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // ==================================================
                // CONFIRM PASSWORD
                // ==================================================

                const Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  textInputAction: TextInputAction.done,

                  onSubmitted: (_) {
                    _signup();
                  },

                  decoration: InputDecoration(
                    hintText: 'Confirm your password',

                    hintStyle: const TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 15,
                    ),

                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: Color(0xFF888888),
                    ),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword =
                              !obscureConfirmPassword;
                        });
                      },

                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF888888),
                      ),
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 17,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF22C55E),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Password must contain at least 6 characters.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                  ),
                ),

                const SizedBox(height: 30),

                // ==================================================
                // CREATE ACCOUNT BUTTON
                // ==================================================

                Obx(
                  () {
                    final bool loading =
                        authController.isLoading.value;

                    return SizedBox(
                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton(
                        onPressed:
                            loading ? null : _signup,

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(
                            255,
                            12,
                            1,
                            31,
                          ),

                          foregroundColor: Colors.white,

                          disabledBackgroundColor:
                              const Color(0xFF6B7280),

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                        ),

                        child: loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // ==================================================
                // LOGIN
                // ==================================================

                Center(
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF777777),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },

                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF22C55E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}