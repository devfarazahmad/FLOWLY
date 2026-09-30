import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_screen.dart';

class JournalIntroScreen extends StatelessWidget {
  const JournalIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),

      // ============================================================
      // APP BAR
      // ============================================================

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

      // ============================================================
      // BODY
      // ============================================================

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),

          child: Column(
            children: [
              // ======================================================
              // MAIN CONTENT
              // ======================================================

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      // ------------------------------------------------
                      // LOGO
                      // ------------------------------------------------

                      Image.asset(
                        'assets/images/flowly_logo.png',

                        width: 150,
                        height: 150,

                        fit: BoxFit.contain,

                        errorBuilder: (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
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
                      // TITLE
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
                      // SUBTITLE
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
                      // DESCRIPTION
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

              // ======================================================
              // CONTINUE BUTTON
              // ======================================================

              Padding(
                padding: const EdgeInsets.only(bottom: 30),

                child: SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(
                        () => const LoginScreen(),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                        255,
                        12,
                        1,
                        31,
                      ),

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