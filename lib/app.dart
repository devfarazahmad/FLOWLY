
import 'package:flowly/onboarding_screen.dart';
import 'package:flowly/splash_screen.dart';
import 'package:flutter/material.dart';


class FlowlyApp extends StatelessWidget {
  const FlowlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flowly',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}
