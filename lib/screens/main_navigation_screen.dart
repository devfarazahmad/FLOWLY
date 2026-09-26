import 'package:flowly/screens/todo_list_screen.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'journal_screen.dart';
import 'challenges_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
  });

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int currentIndex = 0;

  // ------------------------------------------------------------
  // ALL SCREENS
  // ------------------------------------------------------------

  final List<Widget> screens = const [
    HomeScreen(),
    TodoScreen(),
    JournalScreen(),
    ChallengesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      // --------------------------------------------------------
      // CURRENT SCREEN
      // --------------------------------------------------------

      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      // --------------------------------------------------------
      // BOTTOM NAVIGATION
      // --------------------------------------------------------

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
          // ----------------------------------------------------
          // HOME
          // ----------------------------------------------------

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

          // ----------------------------------------------------
          // TO DO
          // ----------------------------------------------------

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

          // ----------------------------------------------------
          // JOURNAL
          // ----------------------------------------------------

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

          // ----------------------------------------------------
          // CHALLENGES
          // ----------------------------------------------------

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
}