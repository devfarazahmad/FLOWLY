import 'package:flutter/material.dart';

class ChallengeDetailScreen extends StatefulWidget {
  const ChallengeDetailScreen({super.key});

  @override
  State<ChallengeDetailScreen> createState() =>
      _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState
    extends State<ChallengeDetailScreen> {
  final TextEditingController challengeController =
      TextEditingController();

  final TextEditingController reasonController =
      TextEditingController();

  final TextEditingController goalController =
      TextEditingController();

  int selectedDays = 21;

  @override
  void dispose() {
    challengeController.dispose();
    reasonController.dispose();
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF111827),
            size: 20,
          ),
        ),

        title: const Text(
          'Start Challenge',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            35,
          ),
          children: [
            // --------------------------------------------------------------
            // HEADER
            // --------------------------------------------------------------

            const Text(
              'Write Your Challenge',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Create a challenge that fits your day '
              'and your goals.',
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 28),

            // --------------------------------------------------------------
            // CHALLENGE NAME
            // --------------------------------------------------------------

            _sectionTitle('Challenge'),

            const SizedBox(height: 10),

            TextField(
              controller:
                  challengeController,
              textCapitalization:
                  TextCapitalization.sentences,
              decoration: _inputDecoration(
                hint:
                    'Write your challenge',
                icon:
                    Icons.flag_outlined,
              ),
            ),

            const SizedBox(height: 25),

            // --------------------------------------------------------------
            // DURATION
            // --------------------------------------------------------------

            _sectionTitle('Duration'),

            const SizedBox(height: 10),

            Row(
              children: [
                _durationButton(7),
                const SizedBox(width: 10),
                _durationButton(14),
                const SizedBox(width: 10),
                _durationButton(21),
                const SizedBox(width: 10),
                _durationButton(30),
              ],
            ),

            const SizedBox(height: 25),

            // --------------------------------------------------------------
            // WHY
            // --------------------------------------------------------------

            _sectionTitle(
              'Why do you want to do this?',
            ),

            const SizedBox(height: 10),

            TextField(
              controller:
                  reasonController,
              textCapitalization:
                  TextCapitalization.sentences,
              minLines: 4,
              maxLines: 7,
              decoration: _largeInputDecoration(
                hint:
                    'Write what motivates you...',
              ),
            ),

            const SizedBox(height: 25),

            // --------------------------------------------------------------
            // GOAL
            // --------------------------------------------------------------

            _sectionTitle(
              'What do you want to achieve?',
            ),

            const SizedBox(height: 10),

            TextField(
              controller:
                  goalController,
              textCapitalization:
                  TextCapitalization.sentences,
              minLines: 3,
              maxLines: 5,
              decoration: _largeInputDecoration(
                hint:
                    'Write your goal...',
              ),
            ),

            const SizedBox(height: 30),

            // --------------------------------------------------------------
            // CHALLENGE PREVIEW
            // --------------------------------------------------------------

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius:
                    BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(
                        0.12,
                      ),
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.emoji_events_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Challenge',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Color(0xFF9CA3AF),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          selectedDays == 21
                              ? '21 Days Challenge'
                              : '$selectedDays Days Challenge',
                          style:
                              const TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --------------------------------------------------------------
            // START BUTTON
            // --------------------------------------------------------------

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _startChallenge,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF111827),
                  foregroundColor:
                      Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 17,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(17),
                  ),
                ),
                child: const Text(
                  'Start Challenge',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // SECTION TITLE
  // ==========================================================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        color: Color(0xFF111827),
      ),
    );
  }

  // ==========================================================================
  // DURATION BUTTON
  // ==========================================================================

  Widget _durationButton(int days) {
    final selected =
        selectedDays == days;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedDays = days;
          });
        },
        child: Container(
          padding:
              const EdgeInsets.symmetric(
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF111827)
                : Colors.white,
            borderRadius:
                BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? const Color(0xFF111827)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: Text(
            '$days days',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected
                  ? Colors.white
                  : const Color(0xFF374151),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // INPUT DECORATION
  // ==========================================================================

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xFF9CA3AF),
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF9CA3AF),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF9CA3AF),
          width: 1.5,
        ),
      ),
    );
  }

  // ==========================================================================
  // LARGE INPUT
  // ==========================================================================

  InputDecoration _largeInputDecoration({
    required String hint,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 14,
        height: 1.5,
        color: Color(0xFF9CA3AF),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.all(17),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFF9CA3AF),
          width: 1.5,
        ),
      ),
    );
  }

  // ==========================================================================
  // START CHALLENGE
  // ==========================================================================

  void _startChallenge() {
    final challenge =
        challengeController.text.trim();

    if (challenge.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please write your challenge first.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          '"$challenge" started for '
          '$selectedDays days.',
        ),
      ),
    );

    Navigator.pop(context);
  }
}