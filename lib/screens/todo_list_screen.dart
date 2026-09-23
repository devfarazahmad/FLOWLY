import 'package:flutter/material.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      {
        'title': 'Complete project report',
        'category': 'Work',
        'time': '10:00 AM',
        'completed': false,
      },
      {
        'title': 'Study Flutter for 1 hour',
        'category': 'Education',
        'time': '12:00 PM',
        'completed': false,
      },
      {
        'title': 'Buy groceries',
        'category': 'Shopping',
        'time': '05:00 PM',
        'completed': true,
      },
      {
        'title': 'Go for a walk',
        'category': 'Health',
        'time': '07:00 PM',
        'completed': false,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'To Do List',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.filter_list_rounded,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF22C55E),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.task_alt_rounded,
                  size: 32,
                  color: Color(0xFF22C55E),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF222222),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '3 of 4 tasks remaining',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          ...tasks.map(
            (task) => Container(
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
                  Icon(
                    task['completed'] == true
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: task['completed'] == true
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFAAAAAA),
                    size: 25,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['title'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: task['completed'] == true
                                ? const Color(0xFF999999)
                                : const Color(0xFF333333),
                            decoration: task['completed'] == true
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${task['category']} • ${task['time']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.more_vert_rounded,
                    color: Color(0xFF999999),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}