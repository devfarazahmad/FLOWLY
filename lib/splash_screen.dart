
import 'dart:math' as math;

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _circleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _circleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToNextScreen();
      }
    });

    _controller.forward();
  }

  void _goToNextScreen() {
    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      '/onboarding',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double height = constraints.maxHeight;

          // Calculate the diagonal so the circle can completely
          // cover the screen, including all four corners.
          final double screenDiagonal = math.sqrt(
            (width * width) + (height * height),
          );

          return AnimatedBuilder(
            animation: _circleAnimation,
            builder: (context, child) {
              final double circleSize =
                  70 + (screenDiagonal * 1.5 * _circleAnimation.value);

              return Stack(
                alignment: Alignment.center,
                children: [
                  // ------------------------------------------------
                  // Background
                  // ------------------------------------------------
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: const Color(0xFFF8F7FC),
                  ),

                  // ------------------------------------------------
                  // Expanding Purple + Green Circle
                  // ------------------------------------------------
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 12, 1, 31), // Purple
                          Color(0xFF22C55E), // Green
                        ],
                      ),
                    ),
                  ),

                  // ------------------------------------------------
                  // Flowly Logo
                  // ------------------------------------------------
                  Opacity(
                    opacity: 1 - _circleAnimation.value,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 42,
                        ),

                        SizedBox(height: 12),

                        Text(
                          'Flowly',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
