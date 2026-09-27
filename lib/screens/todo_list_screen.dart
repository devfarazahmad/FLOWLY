import 'package:flutter/material.dart';
import 'add_today_screen.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                120,
              ),
              children: [
                // ----------------------------------------------------------
                // HEADER
                // ----------------------------------------------------------
                const Text(
                  'TO-DO List',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Take a Moment for yourself today',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 24),

                // ----------------------------------------------------------
                // IMAGE
                // ----------------------------------------------------------
                Container(
                  height: 210,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'assets/images/flowly_logo.png',
                    fit: BoxFit.cover,

                    // If the image has not been added yet,
                    // this will show a placeholder.
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return const Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 55,
                            color: Color(0xFF9CA3AF),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Add your To-Do image',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // ----------------------------------------------------------
                // TODAY'S TASKS
                // ----------------------------------------------------------
                const Text(
                  'Today\'s Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 14),

                _taskCard(
                  title: 'Complete project report',
                  category: 'Work',
                  time: '10:00 AM',
                  icon: Icons.work_outline_rounded,
                ),

                _taskCard(
                  title: 'Study Flutter',
                  category: 'Education',
                  time: '12:00 PM',
                  icon: Icons.school_outlined,
                ),

                _taskCard(
                  title: 'Buy groceries',
                  category: 'Shopping',
                  time: '05:00 PM',
                  icon: Icons.shopping_bag_outlined,
                ),

                _taskCard(
                  title: 'Go for a walk',
                  category: 'Health',
                  time: '07:00 PM',
                  icon: Icons.directions_walk_rounded,
                ),

                _taskCard(
                  title: 'Read a book',
                  category: 'Personal',
                  time: '09:00 PM',
                  icon: Icons.menu_book_outlined,
                ),
              ],
            ),

            // --------------------------------------------------------------
            // ADD TODAY BUTTON
            // --------------------------------------------------------------
            Positioned(
              right: 20,
              bottom: 20,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AddTodayScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add_rounded,
                  size: 21,
                ),
                label: const Text(
                  'Add Today',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF111827),
                  foregroundColor: Colors.white,
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------------
  // TASK CARD
  // ------------------------------------------------------------------------

  static Widget _taskCard({
    required String title,
    required String category,
    required String time,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF0F0F3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF374151),
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
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '$category • $time',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.radio_button_unchecked_rounded,
            color: Color(0xFFD1D5DB),
            size: 25,
          ),
        ],
      ),
    );
  }
}