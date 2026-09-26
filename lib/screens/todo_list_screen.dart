import 'package:flutter/material.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      ['Complete project report', 'Work', '10:00 AM'],
      ['Study Flutter', 'Education', '12:00 PM'],
      ['Buy groceries', 'Shopping', '05:00 PM'],
      ['Go for a walk', 'Health', '07:00 PM'],
      ['Read a book', 'Personal', '09:00 PM'],
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 10),

            const Text(
              'To Do List',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Keep your day organized.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 28),

            ...tasks.map(
              (task) {
                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.radio_button_unchecked,
                        color: Color(0xFF9CA3AF),
                        size: 27,
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              task[0],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.w600,
                                color:
                                    Color(0xFF111827),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              '${task[1]} • ${task[2]}',
                              style: const TextStyle(
                                fontSize: 12,
                                color:
                                    Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFFD1D5DB),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}