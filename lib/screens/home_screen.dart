import 'dart:math' as math;
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

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Complete project report',
      'category': 'Work',
      'time': '10:00 AM',
      'completed': true,
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
    {
      'title': 'Go for a 30 minute walk',
      'category': 'Health',
      'time': '06:30 PM',
      'completed': false,
    },
    {
      'title': 'Plan tomorrow',
      'category': 'Personal',
      'time': '09:00 PM',
      'completed': false,
    },
  ];

  int get completedTasks {
    return tasks.where((task) {
      return task['completed'] == true;
    }).length;
  }

  int get totalTasks {
    return tasks.length;
  }

  double get progress {
    if (totalTasks == 0) {
      return 0;
    }

    return completedTasks / totalTasks;
  }

  List<Map<String, dynamic>> get visibleTasks {
    if (selectedCategory == 0) {
      return tasks;
    }

    final String category = categories[selectedCategory];

    return tasks.where((task) {
      return task['category'] == category;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),

      // ===============================================================
      // FLOATING BUTTON
      // ===============================================================

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF22C55E),
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),

      // ===============================================================
      // HOME
      // ===============================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            25,
            20,
            100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =========================================================
              // GREETING
              // =========================================================

              const Text(
                'Good Morning!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF202020),
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

              const SizedBox(height: 25),

              // =========================================================
              // CATEGORY BUTTONS
              // =========================================================

              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 9,
                runSpacing: 10,
                children: List.generate(
                  categories.length,
                  (index) {
                    final bool selected =
                        selectedCategory == index;

                    final bool addNew =
                        categories[index] == 'Add New';

                    return GestureDetector(
                      onTap: () {
                        if (addNew) {
                          return;
                        }

                        setState(() {
                          selectedCategory = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF22C55E)
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF22C55E)
                                : const Color(0xFFDCDCDC),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (addNew) ...[
                              Icon(
                                Icons.add,
                                size: 17,
                                color: selected
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
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // =========================================================
              // TODAY PROGRESS
              // =========================================================

              const Text(
                'Today Progress',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 15),

              // =========================================================
              // PROGRESS TRACKER CARD
              // =========================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 25,
                  left: 15,
                  right: 15,
                  bottom: 22,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color(0xFFE5E5E5),
                  ),
                ),
                child: Column(
                  children: [

                    // ---------------------------------------------------
                    // PROGRESS TRACKER
                    // ---------------------------------------------------

                    SizedBox(
                      height: 190,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: TodayProgressPainter(
                          progress: progress,
                        ),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.end,
                          children: [

                            Text(
                              '${(progress * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF222222),
                              ),
                            ),

                            const SizedBox(height: 2),

                            const Text(
                              'Daily Progress',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF999999),
                              ),
                            ),

                            const SizedBox(height: 13),
                          ],
                        ),
                      ),
                    ),

                    // ---------------------------------------------------
                    // COMPLETED TASKS
                    // ---------------------------------------------------

                    const SizedBox(height: 8),

                    Text(
                      '$completedTasks of $totalTasks tasks completed',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF22C55E),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // =========================================================
              // TODAY TASKS
              // =========================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
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
                    '${visibleTasks.length} tasks',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF22C55E),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // =========================================================
              // TASKS
              // =========================================================

              if (visibleTasks.isEmpty)
                _emptyTasks()
              else
                ...visibleTasks.map(
                  (task) => _taskCard(task),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================================
  // TASK CARD
  // =====================================================================

  Widget _taskCard(
    Map<String, dynamic> task,
  ) {
    final bool completed =
        task['completed'] == true;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE6E6E6),
        ),
      ),
      child: Row(
        children: [

          // Checkbox
          GestureDetector(
            onTap: () {
              setState(() {
                task['completed'] =
                    !completed;
              });
            },
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed
                    ? const Color(0xFF22C55E)
                    : Colors.transparent,
                border: Border.all(
                  color: completed
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFAAAAAA),
                  width: 1.5,
                ),
              ),
              child: completed
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 17,
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 14),

          // Task information
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  task['title'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: completed
                        ? const Color(0xFF999999)
                        : const Color(0xFF333333),
                    decoration: completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Text(
                      task['category'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF22C55E),
                      ),
                    ),

                    const SizedBox(width: 7),

                    const Text(
                      '•',
                      style: TextStyle(
                        color: Color(0xFFBBBBBB),
                      ),
                    ),

                    const SizedBox(width: 7),

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

  // =====================================================================
  // EMPTY TASK
  // =====================================================================

  Widget _emptyTasks() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 45,
            color: Color(0xFF22C55E),
          ),
          SizedBox(height: 12),
          Text(
            'No tasks here',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================================
// PROGRESS TRACKER
// =======================================================================

class TodayProgressPainter extends CustomPainter {
  final double progress;

  TodayProgressPainter({
    required this.progress,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    const double strokeWidth = 20;

    final double centerX =
        size.width / 2;

    final double radius =
        math.min(
              size.width / 2,
              size.height,
            ) -
            18;

    final Offset center = Offset(
      centerX,
      size.height - 10,
    );

    final Rect rect =
        Rect.fromCircle(
      center: center,
      radius: radius,
    );

    // ================================================================
    // GREY TRACK
    // ================================================================

    final Paint trackPaint = Paint()
      ..color = const Color(0xFFE7E7E7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      math.pi,
      math.pi,
      false,
      trackPaint,
    );

    // ================================================================
    // GREEN PROGRESS
    // ================================================================

    final Paint progressPaint = Paint()
      ..color = const Color(0xFF22C55E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (progress > 0) {
      canvas.drawArc(
        rect,
        math.pi,
        math.pi * progress,
        false,
        progressPaint,
      );
    }

    // ================================================================
    // 0 LABEL
    // ================================================================

    const TextStyle labelStyle =
        TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFF999999),
    );

    _drawText(
      canvas,
      '0',
      const Offset(12, -2),
      labelStyle,
    );

    // ================================================================
    // 100 LABEL
    // ================================================================

    final TextPainter hundredPainter =
        TextPainter(
      text: const TextSpan(
        text: '100',
        style: labelStyle,
      ),
      textDirection: TextDirection.ltr,
    );

    hundredPainter.layout();

    hundredPainter.paint(
      canvas,
      Offset(
        size.width -
            hundredPainter.width -
            12,
        -2,
      ),
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset position,
    TextStyle style,
  ) {
    final TextPainter painter =
        TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    painter.paint(
      canvas,
      position,
    );
  }

  @override
  bool shouldRepaint(
    covariant TodayProgressPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}