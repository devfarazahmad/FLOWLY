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

  final List<Task> tasks = [
    Task(
      title: 'Complete Flutter project',
      category: 'Work',
      time: '09:00 AM',
      completed: true,
    ),
    Task(
      title: 'Study Flutter & Dart',
      category: 'Education',
      time: '11:00 AM',
      completed: true,
    ),
    Task(
      title: 'Buy groceries',
      category: 'Shopping',
      time: '02:00 PM',
      completed: false,
    ),
    Task(
      title: 'Exercise for 30 minutes',
      category: 'Health',
      time: '05:30 PM',
      completed: false,
    ),
    Task(
      title: 'Read a book',
      category: 'Personal',
      time: '08:00 PM',
      completed: false,
    ),
  ];

  int get completedTasks {
    return tasks.where((task) => task.completed).length;
  }

  double get progress {
    if (tasks.isEmpty) return 0;
    return completedTasks / tasks.length;
  }

  List<Task> get filteredTasks {
    if (selectedCategory == 0) {
      return tasks;
    }

    final category = categories[selectedCategory];

    return tasks
        .where((task) => task.category == category)
        .toList();
  }

  void toggleTask(int index) {
    setState(() {
      final task = filteredTasks[index];

      final originalIndex = tasks.indexOf(task);

      tasks[originalIndex] = Task(
        title: task.title,
        category: task.category,
        time: task.time,
        completed: !task.completed,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Flowly',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ----------------------------------------------------------
              // GREETING
              // ----------------------------------------------------------

              const Text(
                'Good morning',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Ready to make your daily flow?',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 10),

              // ----------------------------------------------------------
              // CATEGORY BUTTONS
              // ----------------------------------------------------------

              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 10);
                  },
                  itemBuilder: (context, index) {
                    final bool isSelected =
                        selectedCategory == index;

                    final bool isAddNew =
                        categories[index] == 'Add New';

                    return GestureDetector(
                      onTap: () {
                        if (isAddNew) {
                          _showAddTaskMessage();
                        } else {
                          setState(() {
                            selectedCategory = index;
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 17,
                        ),
                        decoration: BoxDecoration(
                          color: isAddNew
                              ? const Color(0xFF111827)
                              : isSelected
                                  ? const Color(0xFF111827)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isAddNew || isSelected
                                ? const Color(0xFF111827)
                                : const Color(0xFFE5E7EB),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isAddNew) ...[
                              const Icon(
                                Icons.add,
                                size: 17,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                            ],
                            Text(
                              categories[index],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isAddNew || isSelected
                                    ? Colors.white
                                    : const Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ----------------------------------------------------------
              // TODAY PROGRESS TITLE
              // ----------------------------------------------------------

              const Text(
                'Today Progress',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 16),

              // ----------------------------------------------------------
              // PROGRESS CARD
              // ----------------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  22,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    // Progress Gauge
                    SizedBox(
                      height: 180,
                      child: CustomPaint(
                        painter: ProgressGaugePainter(
                          progress: progress,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 55),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${(progress * 100).round()}%',
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Completed',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF9CA3AF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // 0 - 100 Labels
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '100',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Completed Task Information
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Color(0xFF16A34A),
                              size: 22,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total tasks completed',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '$completedTasks of ${tasks.length} tasks',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Color(0xFF111827),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ----------------------------------------------------------
              // TODAY'S TASKS
              // ----------------------------------------------------------

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Tasks",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),

                  Text(
                    '${filteredTasks.length} tasks',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ----------------------------------------------------------
              // TASK LIST
              // ----------------------------------------------------------

              if (filteredTasks.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 35,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.task_alt_rounded,
                        size: 45,
                        color: Color(0xFFD1D5DB),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No tasks in this category',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...List.generate(
                  filteredTasks.length,
                  (index) {
                    final task = filteredTasks[index];

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: _buildTaskCard(
                        task,
                        index,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // TASK CARD
  // ----------------------------------------------------------

  Widget _buildTaskCard(
    Task task,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [

          // Check Button
          GestureDetector(
            onTap: () {
              toggleTask(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 27,
              width: 27,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.completed
                    ? const Color(0xFF16A34A)
                    : Colors.transparent,
                border: Border.all(
                  color: task.completed
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: task.completed
                  ? const Icon(
                      Icons.check,
                      size: 17,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 13),

          // Task Details
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: task.completed
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF111827),
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius:
                            BorderRadius.circular(7),
                      ),
                      child: Text(
                        task.category,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
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
  }

  // ----------------------------------------------------------
  // ADD NEW MESSAGE
  // ----------------------------------------------------------

  void _showAddTaskMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add New Task selected'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ============================================================================
// TASK MODEL
// ============================================================================

class Task {
  final String title;
  final String category;
  final String time;
  final bool completed;

  Task({
    required this.title,
    required this.category,
    required this.time,
    required this.completed,
  });
}

// ============================================================================
// PROGRESS GAUGE PAINTER
// ============================================================================

class ProgressGaugePainter extends CustomPainter {
  final double progress;

  ProgressGaugePainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center = Offset(
      size.width / 2,
      size.height - 15,
    );

    final radius = size.width * 0.38;

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFE9ECF2);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF111827);

    // ----------------------------------------------------------
    // HALF CIRCLE BACKGROUND
    // ----------------------------------------------------------

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      3.14159,
      3.14159,
      false,
      backgroundPaint,
    );

    // ----------------------------------------------------------
    // PROGRESS
    // ----------------------------------------------------------

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        3.14159,
        3.14159 * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant ProgressGaugePainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}