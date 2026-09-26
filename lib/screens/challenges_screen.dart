import 'package:flutter/material.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 10),

            const Text(
              'Challenges',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Small steps, big changes.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 28),

            _challengeCard(
              title: '21 Days, No Phone',
              description:
                  'Stay away from unnecessary screen time.',
              progress: 0.45,
            ),

            _challengeCard(
              title: 'Morning Routine',
              description:
                  'Start every morning with a healthy routine.',
              progress: 0.70,
            ),

            _challengeCard(
              title: 'Read Every Day',
              description:
                  'Spend at least 20 minutes reading.',
              progress: 0.25,
            ),

            _challengeCard(
              title: 'Daily Exercise',
              description:
                  'Exercise for at least 30 minutes every day.',
              progress: 0.60,
            ),
          ],
        ),
      ),
    );
  }

  Widget _challengeCard({
    required String title,
    required String description,
    required double progress,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor:
                        const Color(0xFFE5E7EB),
                    valueColor:
                        const AlwaysStoppedAnimation<
                            Color>(
                      Color(0xFF22C55E),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}