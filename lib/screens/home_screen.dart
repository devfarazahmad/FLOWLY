import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategory = 0;

  final List<String> categories = [
    'All',
    'Work',
    'Education',
    'Supports',
    'Personal',
    'Shopping',
    'Health',
    'Add New',
  ];

  final List<Map<String, dynamic>> dummyTasks = [
    {
      'title': 'Complete project report',
      'category': 'Work',
      'time': '10:00 AM',
      'completed': false,
    },
    {
      'title': 'Study Flutter',
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add task functionality will be added later.
        },
        backgroundColor: const Color(0xFF22C55E),
        elevation: 4,
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              const Text(
                'Good Morning !',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF222222),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Ready to make your daily flow?',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF777777),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 28),

              // Categories
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 10);
                  },
                  itemBuilder: (context, index) {
                    final bool isSelected = selectedCategory == index;
                    final bool isAddNew = index == categories.length - 1;

                    return GestureDetector(
                      onTap: () {
                        if (isAddNew) {
                          // Add new category functionality later.
                          return;
                        }

                        setState(() {
                          selectedCategory = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF22C55E)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFE5E5E5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isAddNew) ...[
                              Icon(
                                Icons.add_rounded,
                                size: 18,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF22C55E),
                              ),
                              const SizedBox(width: 5),
                            ],
                            Text(
                              categories[index],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF444444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // Home image
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/flowly_logo.jfif',
                  width: double.infinity,
                  height: 210,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 210,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 55,
                            color: Color(0xFF22C55E),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Your day, your flow.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Today's Tasks heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Tasks",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF222222),
                    ),
                  ),
                  Text(
                    '${dummyTasks.length} tasks',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF22C55E),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Dummy tasks
              ...dummyTasks.map(
                (task) => _buildTaskCard(task),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final bool completed = task['completed'] as bool;

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
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: completed
                  ? const Color(0xFF22C55E)
                  : Colors.transparent,
              border: Border.all(
                color: completed
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFBDBDBD),
                width: 1.5,
              ),
            ),
            child: completed
                ? const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: completed
                        ? const Color(0xFF999999)
                        : const Color(0xFF333333),
                    decoration:
                        completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      task['category'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF22C55E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '•',
                      style: TextStyle(
                        color: Color(0xFFBBBBBB),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      task['time'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
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
}