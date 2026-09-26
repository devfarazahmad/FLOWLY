
import 'package:flutter/material.dart';
import 'next_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),

          child: Column(
            children: [
              // ------------------------------------------------
              // Center Content
              // ------------------------------------------------
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Flowly Logo
                      Image.asset(
                        'assets/images/flowly_logo.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,

                        // Temporary fallback if image is missing
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 120,

                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(30),
                            ),

                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              size: 55,
                              color: Color(0xFF22C55E),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 28),

                      // ------------------------------------------------
                      // App Name
                      // ------------------------------------------------
                      const Text(
                        'Flowly',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 12, 1, 31),
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ------------------------------------------------
                      // Tagline
                      // ------------------------------------------------
                      const Text(
                        'make your day flow.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ------------------------------------------------
              // Get Started Button
              // ------------------------------------------------
              Padding(
                padding: const EdgeInsets.only(bottom: 30),

                child: SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NextScreen(),
                        ),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 12, 1, 31),
                      foregroundColor: Colors.white,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: const Text(
                      'Get Started',

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
