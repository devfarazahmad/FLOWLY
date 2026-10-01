import 'package:flowly/database/database_helper.dart';
import 'package:flowly/login_screen.dart';
import 'package:flowly/screens/main_navigation_screen.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  // ============================================================
  // CURRENT USER
  // ============================================================

  final Rxn<Map<String, dynamic>> currentUser =
      Rxn<Map<String, dynamic>>();

  // ============================================================
  // LOADING
  // ============================================================

  final RxBool isLoading = false.obs;

  // ============================================================
  // SIGN UP
  // ============================================================

  Future<void> signup({
    required String email,
    required String password,
  }) async {
    final String cleanEmail = email.trim().toLowerCase();

    if (cleanEmail.isEmpty) {
      Get.snackbar(
        'Email Required',
        'Please enter your email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(cleanEmail)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.isEmpty) {
      Get.snackbar(
        'Password Required',
        'Please enter a password.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Weak Password',
        'Password must contain at least 6 characters.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Check whether email already exists.
      final bool exists =
          await databaseHelper.emailExists(cleanEmail);

      if (exists) {
        Get.snackbar(
          'Account Already Exists',
          'An account with this email already exists.',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      // Create account.
      await databaseHelper.createUser(
        email: cleanEmail,
        password: password, name: '',
      );

      Get.snackbar(
        'Account Created',
        'Your account has been created successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Go back to login screen.
      Get.off(
        () => const LoginScreen(),
      );
    } catch (e) {
      Get.snackbar(
        'Sign Up Error',
        'Something went wrong while creating your account.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final String cleanEmail = email.trim().toLowerCase();

    if (cleanEmail.isEmpty) {
      Get.snackbar(
        'Email Required',
        'Please enter your email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(cleanEmail)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.isEmpty) {
      Get.snackbar(
        'Password Required',
        'Please enter your password.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final Map<String, dynamic>? user =
          await databaseHelper.loginUser(
        email: cleanEmail,
        password: password,
      );

      if (user == null) {
        Get.snackbar(
          'Login Failed',
          'Email or password is incorrect.',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      // Save currently logged-in user.
      currentUser.value = user;

      // Move to main application.
      Get.offAll(
        () => const MainNavigationScreen(),
      );
    } catch (e) {
      Get.snackbar(
        'Login Error',
        'Something went wrong while logging in.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void logout() {
    currentUser.value = null;

    Get.offAll(
      () => const LoginScreen(),
    );
  }
}