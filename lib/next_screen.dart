
import 'package:flutter/material.dart';

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

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
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      // ------------------------------------------------
                      // Temporary Icon
                      // ------------------------------------------------
                      Container(
                        width: 110,
                        height: 110,

                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(32),
                        ),

                        child: const Icon(
                          Icons.waving_hand_rounded,
                          size: 55,
                          color: Color(0xFF22C55E),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ------------------------------------------------
                      // Title
                      // ------------------------------------------------
                      const Text(
                        'Let’s get started',
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF222222),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ------------------------------------------------
                      // Description
                      // ------------------------------------------------
                      const Text(
                        'Organize your tasks, build better habits, '
                        'and make every day flow smoothly.',

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
              // Temporary Continue Button
              // ------------------------------------------------
              Padding(
                padding: const EdgeInsets.only(bottom: 30),

                child: SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: () {
                      // We will connect the next Flowly screen here.
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const  Color.fromARGB(255, 12, 1, 31),
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
