import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../database/database_helper.dart';
import '../screens/main_navigation_screen.dart';

class AuthController extends GetxController {
  final DatabaseHelper _databaseHelper =
      DatabaseHelper.instance;

  // --------------------------------------------------------------------------
  // USER DATA
  // --------------------------------------------------------------------------

  final Rxn<Map<String, dynamic>> currentUser =
      Rxn<Map<String, dynamic>>();

  final RxBool isLoading = false.obs;

  // --------------------------------------------------------------------------
  // LOGIN
  // --------------------------------------------------------------------------

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail =
        email.trim().toLowerCase();

    final cleanPassword =
        password.trim();

    if (cleanEmail.isEmpty) {
      Get.snackbar(
        'Email Required',
        'Please enter your email.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (cleanPassword.isEmpty) {
      Get.snackbar(
        'Password Required',
        'Please enter your password.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final user =
          await _databaseHelper.loginUser(
        email: cleanEmail,
        password: cleanPassword,
      );

      if (user == null) {
        Get.snackbar(
          'Login Failed',
          'Email or password is incorrect.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor:
              const Color(0xFF111827),
          colorText: Colors.white,
        );

        return;
      }

      currentUser.value = user;

      // Remove LoginScreen from navigation stack.
      Get.offAll(
        () => const MainNavigationScreen(),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while logging in.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --------------------------------------------------------------------------
  // LOGOUT
  // --------------------------------------------------------------------------

  void logout() {
    currentUser.value = null;

    Get.offAllNamed('/login');
  }
}