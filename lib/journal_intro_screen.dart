import 'package:flutter/material.dart';
import 'login_screen.dart';

class JournalIntroScreen extends StatelessWidget {
  const JournalIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),

          child: Column(
            children: [
              // ------------------------------------------------
              // Main Content
              // ------------------------------------------------
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      // ------------------------------------------------
                      // Journal Image
                      // ------------------------------------------------
                      Image.asset(
                        'assets/images/flowly_logo.jfif',

                        width: 150,
                        height: 150,

                        fit: BoxFit.contain,

                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 150,
                            height: 150,

                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(35),
                            ),

                            child: const Icon(
                              Icons.menu_book_rounded,
                              size: 65,
                              color: Color(0xFF22C55E),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      // ------------------------------------------------
                      // First Text
                      // ------------------------------------------------
                      const Text(
                        'Reflect and Reset',
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF222222),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ------------------------------------------------
                      // Second Text
                      // ------------------------------------------------
                      const Text(
                        'A space just for you',
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF22C55E),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ------------------------------------------------
                      // Third Text
                      // ------------------------------------------------
                      const Text(
                        'Write it down, clear your mind, '
                        'keep the moments that matter to you.',
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ------------------------------------------------
              // Continue Button
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
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 12, 1, 31),

                      foregroundColor: Colors.white,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: const Text(
                      'Continue',

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
