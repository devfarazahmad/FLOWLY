import 'package:flutter/material.dart';
import 'challenge_detail_screen.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() =>
      _ChallengesScreenState();
}

class _ChallengesScreenState
    extends State<ChallengesScreen> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Study',
    'Reading',
    'Travel',
    'Self Growth',
    'Add New',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            24,
            20,
            35,
          ),
          children: [
            // --------------------------------------------------------------
            // HEADER
            // --------------------------------------------------------------

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

            const SizedBox(height: 22),

            // --------------------------------------------------------------
            // SEARCH BAR
            // --------------------------------------------------------------

            Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search challenges...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF6B7280),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // --------------------------------------------------------------
            // FEATURED CHALLENGE
            // --------------------------------------------------------------

            const Text(
              'Featured Challenge',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 14),

            _featuredChallenge(),

            const SizedBox(height: 30),

            // --------------------------------------------------------------
            // EXPLORE CHALLENGES
            // --------------------------------------------------------------

            const Text(
              'Explore Challenges',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 14),

            _categoryButtons(),

            const SizedBox(height: 20),

            // --------------------------------------------------------------
            // SAMPLE CHALLENGES
            // --------------------------------------------------------------

            _exploreChallenge(
              icon: Icons.menu_book_rounded,
              title: 'Read Every Day',
              description:
                  'Spend at least 20 minutes reading.',
              category: 'Reading',
              progress: 0.25,
            ),

            _exploreChallenge(
              icon: Icons.school_rounded,
              title: 'Study Focus',
              description:
                  'Study without distractions every day.',
              category: 'Study',
              progress: 0.45,
            ),

            _exploreChallenge(
              icon: Icons.directions_walk_rounded,
              title: 'Explore Somewhere New',
              description:
                  'Discover a new place and enjoy the journey.',
              category: 'Travel',
              progress: 0.10,
            ),

            _exploreChallenge(
              icon: Icons.self_improvement_rounded,
              title: 'Better Every Day',
              description:
                  'Build one small positive habit every day.',
              category: 'Self Growth',
              progress: 0.60,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // FEATURED CHALLENGE
  // ==========================================================================

  Widget _featuredChallenge() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.phone_disabled_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),

              const Spacer(),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: const Text(
                  'FEATURED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            '21 Days, No Phone',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Stay away from unnecessary screen time '
            'and create more space for yourself.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFFD1D5DB),
            ),
          ),

          const SizedBox(height: 20),

          // Calendar
          _challengeCalendar(),

          const SizedBox(height: 18),

          // Progress
          Row(
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFD1D5DB),
                ),
              ),

              const Spacer(),

              const Text(
                '0 / 21 days',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0,
              minHeight: 7,
              backgroundColor:
                  Color(0xFF374151),
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                Color(0xFF22C55E),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Start Challenge
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ChallengeDetailScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor:
                    const Color(0xFF111827),
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Start Challenge',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // CALENDAR
  // ==========================================================================

  Widget _challengeCalendar() {
    final now = DateTime.now();

    final firstDay =
        DateTime(now.year, now.month, 1);

    final daysInMonth =
        DateTime(now.year, now.month + 1, 0).day;

    final startingWeekday =
        firstDay.weekday;

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            '${months[now.month - 1]} ${now.year}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              'M',
              'T',
              'W',
              'T',
              'F',
              'S',
              'S',
            ].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 8),

          GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            itemCount:
                startingWeekday - 1 +
                    daysInMonth,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 3,
            ),
            itemBuilder: (context, index) {
              if (index < startingWeekday - 1) {
                return const SizedBox();
              }

              final day =
                  index -
                      (startingWeekday - 1) +
                      1;

              final isToday =
                  day == now.day;

              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday
                      ? const Color(0xFF22C55E)
                      : Colors.transparent,
                ),
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isToday
                        ? FontWeight.w800
                        : FontWeight.w500,
                    color: isToday
                        ? Colors.white
                        : const Color(
                            0xFFD1D5DB,
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // CATEGORY BUTTONS
  // ==========================================================================

  Widget _categoryButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final isSelected =
              selectedCategory == category;

          return Padding(
            padding:
                const EdgeInsets.only(right: 9),
            child: GestureDetector(
              onTap: () {
                if (category == 'Add New') {
                  _showAddChallengeDialog();
                  return;
                }

                setState(() {
                  selectedCategory = category;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF111827)
                      : Colors.white,
                  borderRadius:
                      BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF111827)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF374151),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================================================
  // EXPLORE CHALLENGE CARD
  // ==========================================================================

  Widget _exploreChallenge({
    required IconData icon,
    required String title,
    required String description,
    required String category,
    required double progress,
  }) {
    if (selectedCategory != 'All' &&
        selectedCategory != category) {
      return const SizedBox.shrink();
    }

    return Container(
      margin:
          const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF111827),
              size: 22,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 9),

                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10),
                  child:
                      LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor:
                        const Color(0xFFE5E7EB),
                    valueColor:
                        const AlwaysStoppedAnimation<
                            Color>(
                      Color(0xFF22C55E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // ADD NEW CHALLENGE
  // ==========================================================================

  void _showAddChallengeDialog() {
    final controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add New Challenge',
          ),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(
              hintText:
                  'Challenge name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                if (controller.text
                    .trim()
                    .isNotEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        '${controller.text.trim()} added.',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}