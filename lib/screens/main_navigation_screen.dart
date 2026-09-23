import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),

      // ----------------------------------------------------------
      // BODY
      // ----------------------------------------------------------
      body: _buildCurrentScreen(),

      // ----------------------------------------------------------
      // BOTTOM NAVIGATION
      // ----------------------------------------------------------
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        backgroundColor: Colors.white,
        elevation: 0,
        height: 72,

        indicatorColor: const Color(0xFFE8F5E9),

        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: Color(0xFF777777),
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
              color: Color(0xFF22C55E),
            ),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.check_circle_outline_rounded,
              color: Color(0xFF777777),
            ),
            selectedIcon: Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF22C55E),
            ),
            label: 'To Do',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.menu_book_outlined,
              color: Color(0xFF777777),
            ),
            selectedIcon: Icon(
              Icons.menu_book_rounded,
              color: Color(0xFF22C55E),
            ),
            label: 'Journal',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.emoji_events_outlined,
              color: Color(0xFF777777),
            ),
            selectedIcon: Icon(
              Icons.emoji_events_rounded,
              color: Color(0xFF22C55E),
            ),
            label: 'Challenges',
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // CURRENT SCREEN
  // ------------------------------------------------------------

  Widget _buildCurrentScreen() {
    switch (currentIndex) {
      case 0:
        return _buildHomeScreen();

      case 1:
        return _buildTodoScreen();

      case 2:
        return _buildJournalScreen();

      case 3:
        return _buildChallengesScreen();

      default:
        return _buildHomeScreen();
    }
  }

  // ------------------------------------------------------------
  // HOME
  // ------------------------------------------------------------

  Widget _buildHomeScreen() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              'Good Morning !',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Color(0xFF222222),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Ready to make your daily flow?',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF777777),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 65,
                  color: Color(0xFF22C55E),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Today's Tasks",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF222222),
              ),
            ),

            const SizedBox(height: 15),

            _taskCard(
              'Complete project report',
              'Work',
              '10:00 AM',
            ),

            _taskCard(
              'Study Flutter',
              'Education',
              '12:00 PM',
            ),

            _taskCard(
              'Buy groceries',
              'Shopping',
              '05:00 PM',
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TODO
  // ------------------------------------------------------------

  Widget _buildTodoScreen() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 20),

          const Text(
            'To Do List',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Keep your day organized.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF777777),
            ),
          ),

          const SizedBox(height: 30),

          _taskCard(
            'Complete project report',
            'Work',
            '10:00 AM',
          ),

          _taskCard(
            'Study Flutter',
            'Education',
            '12:00 PM',
          ),

          _taskCard(
            'Buy groceries',
            'Shopping',
            '05:00 PM',
          ),

          _taskCard(
            'Go for a walk',
            'Health',
            '07:00 PM',
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // JOURNAL
  // ------------------------------------------------------------

  Widget _buildJournalScreen() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 20),

          const Text(
            'Journal',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Reflect, write, and reset.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF777777),
            ),
          ),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How are you feeling today?',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF222222),
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text('😄', style: TextStyle(fontSize: 30)),
                    Text('😊', style: TextStyle(fontSize: 30)),
                    Text('😐', style: TextStyle(fontSize: 30)),
                    Text('😔', style: TextStyle(fontSize: 30)),
                    Text('😴', style: TextStyle(fontSize: 30)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          _journalCard(
            'A productive day',
            'Today I completed most of my important tasks...',
            'Today',
          ),

          _journalCard(
            'Small wins',
            'I managed to stay focused and finish my work...',
            'Yesterday',
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // CHALLENGES
  // ------------------------------------------------------------

  Widget _buildChallengesScreen() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 20),

          const Text(
            'Challenges',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Small steps, big changes.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF777777),
            ),
          ),

          const SizedBox(height: 30),

          _challengeCard(
            '21 Days, No Phone',
            'Stay away from unnecessary screen time.',
            0.45,
          ),

          _challengeCard(
            'Morning Routine',
            'Start every morning with a healthy routine.',
            0.70,
          ),

          _challengeCard(
            'Read Every Day',
            'Spend at least 20 minutes reading.',
            0.25,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TASK CARD
  // ------------------------------------------------------------

  Widget _taskCard(
    String title,
    String category,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEDEDED),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.radio_button_unchecked_rounded,
            color: Color(0xFFAAAAAA),
            size: 25,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '$category • $time',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFFAAAAAA),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // JOURNAL CARD
  // ------------------------------------------------------------

  Widget _journalCard(
    String title,
    String description,
    String date,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEDEDED),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF22C55E),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF777777),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // CHALLENGE CARD
  // ------------------------------------------------------------

  Widget _challengeCard(
    String title,
    String description,
    double progress,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFEDEDED),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF777777),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor:
                        const Color(0xFFE8E8E8),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}