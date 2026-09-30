import 'package:flowly/database/auth_controller.dart';
import 'package:flowly/intro_screen/onboarding_screen.dart';
import 'package:flowly/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register AuthController before the application starts.
  Get.put(AuthController());

  runApp(const FlowlyApp());
}

class FlowlyApp extends StatelessWidget {
  const FlowlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flowly',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
        ),

        scaffoldBackgroundColor: Colors.white,
      ),

      // ------------------------------------------------------------
      // FIRST SCREEN
      // ------------------------------------------------------------
      home: const SplashScreen(),

      // ------------------------------------------------------------
      // GETX ROUTES
      // ------------------------------------------------------------
      getPages: [
        GetPage(
          name: '/onboarding',
          page: () => const OnboardingScreen(),
        ),
      ],
    );
  }
}