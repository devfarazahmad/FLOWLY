import 'dart:convert';

import 'package:flowly/database/auth_controller.dart';
import 'package:flowly/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  late final AuthController authController;

  int selectedCategory = 0;

  bool isLoading = true;

  Map<String, dynamic>? todayData;

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

  List<HomeTask> tasks = [];

  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<AuthController>()) {
      authController = Get.find<AuthController>();
    } else {
      authController = Get.put(AuthController());
    }

    _loadTodayTasks();
  }

  int? get currentUserId {
    final user = authController.currentUser.value;

    if (user == null) {
      return null;
    }

    final id = user['id'];

    if (id is int) {
      return id;
    }

    return int.tryParse(id.toString());
  }

  String get todayDateKey {
    final now = DateTime.now();

    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');

    return '${now.year}-$month-$day';
  }

  // ============================================================
  // LOAD TODAY'S TASKS FROM SQLITE
  // ============================================================

  Future<void> _loadTodayTasks() async {
    final userId = currentUserId;

    if (userId == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
          tasks = [];
        });
      }
      return;
    }

    try {
      final data = await databaseHelper.getTodayEntry(
        userId: userId,
        entryDate: todayDateKey,
      );

      List<String> savedTasks = [];

      if (data != null) {
        todayData = data;

        savedTasks = _decodeList(data['today_tasks']);
      }

      // Get saved completion information.
      List<int> completedIndexes = [];

      try {
        final completedData =
            await databaseHelper.getCompletedTaskIndexes(
          userId: userId,
          entryDate: todayDateKey,
        );

        completedIndexes = completedData;
      } catch (e) {
        debugPrint(
          'Completion table not available yet: $e',
        );
      }

      final List<HomeTask> loadedTasks = [];

      for (int i = 0; i < savedTasks.length; i++) {
        final title = savedTasks[i].trim();

        if (title.isEmpty) {
          continue;
        }

        loadedTasks.add(
          HomeTask(
            id: i,
            title: title,
            category: 'Personal',
            completed: completedIndexes.contains(i),
          ),
        );
      }

      if (mounted) {
        setState(() {
          tasks = loadedTasks;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(
        'Error loading Home tasks: $e',
      );

      if (mounted) {
        setState(() {
          tasks = [];
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // DECODE TASK LIST
  // ============================================================

  List<String> _decodeList(dynamic value) {
    if (value == null) {
      return [];
    }

    if (value is List) {
      return value
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList();
    }

    if (value is String) {
      if (value.trim().isEmpty) {
        return [];
      }

      try {
        final decoded = jsonDecode(value);

        if (decoded is List) {
          return decoded
              .map((item) => item.toString())
              .where((item) => item.trim().isNotEmpty)
              .toList();
        }

        // Fallback if old data is just normal text.
        return [value];
      } catch (e) {
        return [value];
      }
    }

    return [];
  }

  // ============================================================
  // COMPLETED TASK COUNT
  // ============================================================

  int get completedTasks {
    return tasks.where((task) => task.completed).length;
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  double get progress {
    if (tasks.isEmpty) {
      return 0;
    }

    return completedTasks / tasks.length;
  }

  // ============================================================
  // FILTER TASKS
  // ============================================================

  List<HomeTask> get filteredTasks {
    if (selectedCategory == 0) {
      return tasks;
    }

    final category = categories[selectedCategory];

    return tasks
        .where((task) => task.category == category)
        .toList();
  }

  // ============================================================
  // TOGGLE TASK
  // ============================================================

  Future<void> toggleTask(HomeTask task) async {
    final userId = currentUserId;

    if (userId == null) {
      return;
    }

    final newStatus = !task.completed;

    setState(() {
      final index = tasks.indexWhere(
        (item) => item.id == task.id,
      );

      if (index != -1) {
        tasks[index] = tasks[index].copyWith(
          completed: newStatus,
        );
      }
    });

    try {
      await databaseHelper.setTaskCompleted(
        userId: userId,
        entryDate: todayDateKey,
        taskIndex: task.id,
        completed: newStatus,
      );
    } catch (e) {
      debugPrint(
        'Error saving task completion: $e',
      );

      // Reload if saving failed.
      await _loadTodayTasks();
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshHome() async {
    setState(() {
      isLoading = true;
    });

    await _loadTodayTasks();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

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

        actions: [
          IconButton(
            onPressed: refreshHome,
            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF111827),
                ),
              )
            : RefreshIndicator(
                onRefresh: refreshHome,

                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),

                  padding: const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    40,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      // ======================================================
                      // GREETING
                      // ======================================================

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

                      const SizedBox(height: 18),

                      // ======================================================
                      // CATEGORY BUTTONS
                      // ======================================================

                      SizedBox(
                        height: 38,

                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,

                          physics:
                              const BouncingScrollPhysics(),

                          itemCount: categories.length,

                          separatorBuilder:
                              (context, index) {
                            return const SizedBox(
                              width: 10,
                            );
                          },

                          itemBuilder:
                              (context, index) {
                            final category =
                                categories[index];

                            final isSelected =
                                selectedCategory == index;

                            final isAddNew =
                                category == 'Add New';

                            return GestureDetector(
                              onTap: () {
                                if (isAddNew) {
                                  _showAddTaskMessage();
                                } else {
                                  setState(() {
                                    selectedCategory =
                                        index;
                                  });
                                }
                              },

                              child: AnimatedContainer(
                                duration:
                                    const Duration(
                                  milliseconds: 200,
                                ),

                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 17,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: isAddNew
                                      ? const Color(
                                          0xFF111827,
                                        )
                                      : isSelected
                                          ? const Color(
                                              0xFF111827,
                                            )
                                          : Colors.white,

                                  borderRadius:
                                      BorderRadius.circular(
                                    22,
                                  ),

                                  border: Border.all(
                                    color: isAddNew ||
                                            isSelected
                                        ? const Color(
                                            0xFF111827,
                                          )
                                        : const Color(
                                            0xFFE5E7EB,
                                          ),
                                  ),
                                ),

                                alignment:
                                    Alignment.center,

                                child: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,

                                  children: [
                                    if (isAddNew) ...[
                                      const Icon(
                                        Icons.add,
                                        size: 17,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],

                                    Text(
                                      category,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.w600,
                                        color:
                                            isAddNew ||
                                                    isSelected
                                                ? Colors.white
                                                : const Color(
                                                    0xFF4B5563,
                                                  ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 26),

                      // ======================================================
                      // TODAY PROGRESS
                      // ======================================================

                      const Text(
                        'Today Progress',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,

                        padding:
                            const EdgeInsets.fromLTRB(
                          20,
                          20,
                          20,
                          22,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(24),

                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(
                                0.04,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [
                            // =================================================
                            // PROGRESS GAUGE
                            // =================================================

                            SizedBox(
                              height: 180,

                              child: CustomPaint(
                                painter:
                                    ProgressGaugePainter(
                                  progress: progress,
                                ),

                                child: Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(
                                      top: 55,
                                    ),

                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,

                                      children: [
                                        Text(
                                          '${(progress * 100).round()}%',

                                          style:
                                              const TextStyle(
                                            fontSize: 34,
                                            fontWeight:
                                                FontWeight.w800,
                                            color: Color(
                                              0xFF111827,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 2,
                                        ),

                                        const Text(
                                          'Completed',
                                          style:
                                              TextStyle(
                                            fontSize: 13,
                                            color: Color(
                                              0xFF9CA3AF,
                                            ),
                                            fontWeight:
                                                FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 5),

                            // =================================================
                            // 0 - 100
                            // =================================================

                            const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,

                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(
                                      0xFF9CA3AF,
                                    ),
                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),

                                Text(
                                  '100',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(
                                      0xFF9CA3AF,
                                    ),
                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            // =================================================
                            // COMPLETED INFORMATION
                            // =================================================

                            Container(
                              width: double.infinity,

                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),

                              decoration:
                                  BoxDecoration(
                                color:
                                    const Color(
                                  0xFFF8F9FC,
                                ),

                                borderRadius:
                                    BorderRadius.circular(
                                  16,
                                ),
                              ),

                              child: Row(
                                children: [
                                  Container(
                                    height: 42,
                                    width: 42,

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          const Color(
                                        0xFFE8F5E9,
                                      ),
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        12,
                                      ),
                                    ),

                                    child:
                                        const Icon(
                                      Icons.check_rounded,
                                      color:
                                          Color(0xFF16A34A),
                                      size: 22,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 12,
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                      children: [
                                        const Text(
                                          'Total tasks completed',
                                          style:
                                              TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color(
                                              0xFF6B7280,
                                            ),
                                            fontWeight:
                                                FontWeight
                                                    .w500,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 3,
                                        ),

                                        Text(
                                          '$completedTasks of ${tasks.length} tasks',

                                          style:
                                              const TextStyle(
                                            fontSize: 17,
                                            color:
                                                Color(
                                              0xFF111827,
                                            ),
                                            fontWeight:
                                                FontWeight
                                                    .w700,
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

                      // ======================================================
                      // TODAY TASKS
                      // ======================================================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [
                          const Text(
                            "Today's Tasks",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight:
                                  FontWeight.w700,
                              color:
                                  Color(0xFF111827),
                            ),
                          ),

                          Text(
                            '${filteredTasks.length} tasks',

                            style:
                                const TextStyle(
                              fontSize: 13,
                              color:
                                  Color(0xFF6B7280),
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ======================================================
                      // TASK LIST
                      // ======================================================

                      if (filteredTasks.isEmpty)
                        _buildEmptyTasks()
                      else
                        ...List.generate(
                          filteredTasks.length,
                          (index) {
                            final task =
                                filteredTasks[index];

                            return Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 12,
                              ),

                              child:
                                  _buildTaskCard(task),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // ============================================================
  // EMPTY TASKS
  // ============================================================

  Widget _buildEmptyTasks() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        vertical: 35,
        horizontal: 20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        children: [
          const Icon(
            Icons.task_alt_rounded,
            size: 45,
            color: Color(0xFFD1D5DB),
          ),

          const SizedBox(height: 10),

          Text(
            tasks.isEmpty
                ? 'No tasks added for today'
                : 'No tasks in this category',

            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          if (tasks.isEmpty)
            const Text(
              'Add tasks from the To-Do screen.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF9CA3AF),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // TASK CARD
  // ============================================================

  Widget _buildTaskCard(HomeTask task) {
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
          // ========================================================
          // CHECK BUTTON
          // ========================================================

          GestureDetector(
            onTap: () {
              toggleTask(task);
            },

            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: 200),

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

          // ========================================================
          // TASK DETAILS
          // ========================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  task.title,

                  maxLines: 2,

                  overflow:
                      TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w600,

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
                      Icons.today_rounded,
                      size: 14,
                      color: Color(0xFF9CA3AF),
                    ),

                    const SizedBox(width: 4),

                    const Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            const Color(0xFFF3F4F6),

                        borderRadius:
                            BorderRadius.circular(
                          7,
                        ),
                      ),

                      child: Text(
                        task.category,

                        style:
                            const TextStyle(
                          fontSize: 10,
                          color:
                              Color(0xFF6B7280),
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Icon(
            task.completed
                ? Icons.check_circle_rounded
                : Icons.chevron_right_rounded,

            color: task.completed
                ? const Color(0xFF16A34A)
                : const Color(0xFFD1D5DB),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADD NEW MESSAGE
  // ============================================================

  void _showAddTaskMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Add tasks from the To-Do screen.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ============================================================================
// HOME TASK MODEL
// ============================================================================

class HomeTask {
  final int id;
  final String title;
  final String category;
  final bool completed;

  const HomeTask({
    required this.id,
    required this.title,
    required this.category,
    required this.completed,
  });

  HomeTask copyWith({
    int? id,
    String? title,
    String? category,
    bool? completed,
  }) {
    return HomeTask(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      completed: completed ?? this.completed,
    );
  }
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

    // Background
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

    // Progress
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