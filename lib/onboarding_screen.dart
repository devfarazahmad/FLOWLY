
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 70,
                color: Color(0xFF7C3AED),
              ),

              const SizedBox(height: 24),

              const Text(
                'Welcome to Flowly',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Make your day flow.',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF777777),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
