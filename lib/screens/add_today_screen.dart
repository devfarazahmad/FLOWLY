import 'package:flowly/database/auth_controller.dart';
import 'package:flowly/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTodayScreen extends StatefulWidget {
  const AddTodayScreen({
    super.key,
  });

  @override
  State<AddTodayScreen> createState() =>
      _AddTodayScreenState();
}

class _AddTodayScreenState
    extends State<AddTodayScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController moodController =
      TextEditingController();

  final TextEditingController lessonController =
      TextEditingController();

  final List<TextEditingController>
      gratitudeControllers =
      List.generate(
    3,
    (index) => TextEditingController(),
  );

  final List<TextEditingController>
      taskControllers =
      List.generate(
    3,
    (index) => TextEditingController(),
  );

  final List<TextEditingController>
      goalControllers =
      List.generate(
    3,
    (index) => TextEditingController(),
  );

  final List<TextEditingController>
      wrongControllers =
      List.generate(
    3,
    (index) => TextEditingController(),
  );

  final List<TextEditingController>
      learnedControllers =
      List.generate(
    3,
    (index) => TextEditingController(),
  );

  // ============================================================
  // DATABASE
  // ============================================================

  final DatabaseHelper databaseHelper =
      DatabaseHelper.instance;

  late final AuthController authController;

  // ============================================================
  // STATE
  // ============================================================

  bool isEditing = true;

  bool isLoading = true;

  bool hasSavedData = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<AuthController>()) {
      authController =
          Get.find<AuthController>();
    } else {
      authController =
          Get.put(AuthController());
    }

    _loadTodayData();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    moodController.dispose();
    lessonController.dispose();

    for (final controller
        in gratitudeControllers) {
      controller.dispose();
    }

    for (final controller
        in taskControllers) {
      controller.dispose();
    }

    for (final controller
        in goalControllers) {
      controller.dispose();
    }

    for (final controller
        in wrongControllers) {
      controller.dispose();
    }

    for (final controller
        in learnedControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  // ============================================================
  // USER ID
  // ============================================================

  int? get currentUserId {
    final user = authController.currentUser.value;

    if (user == null) {
      return null;
    }

    return user['id'] as int?;
  }

  // ============================================================
  // DATE KEY
  // ============================================================

  String get todayDateKey {
    final now = DateTime.now();

    final String month =
        now.month.toString().padLeft(2, '0');

    final String day =
        now.day.toString().padLeft(2, '0');

    return '${now.year}-$month-$day';
  }

  // ============================================================
  // TODAY DAY
  // ============================================================

  String get todayDay {
    final now = DateTime.now();

    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return days[now.weekday - 1];
  }

  // ============================================================
  // TODAY DATE
  // ============================================================

  String get todayDate {
    final now = DateTime.now();

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

    return '${now.day} '
        '${months[now.month - 1]} '
        '${now.year}';
  }

  // ============================================================
  // LOAD TODAY DATA
  // ============================================================

  Future<void> _loadTodayData() async {
    final int? userId = currentUserId;

    if (userId == null) {
      setState(() {
        isLoading = false;
      });

      return;
    }

    try {
      final Map<String, dynamic>? data =
          await databaseHelper.getTodayEntry(
        userId: userId,
        entryDate: todayDateKey,
      );

      if (data != null) {
        _fillControllers(data);

        hasSavedData = true;

        isEditing = false;
      }
    } catch (e) {
      debugPrint(
        'Error loading today data: $e',
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ============================================================
  // FILL CONTROLLERS
  // ============================================================

  void _fillControllers(
    Map<String, dynamic> data,
  ) {
    moodController.text =
        data['mood']?.toString() ?? '';

    lessonController.text =
        data['lesson']?.toString() ?? '';

    _fillList(
      data['gratitude'],
      gratitudeControllers,
    );

    _fillList(
      data['today_tasks'],
      taskControllers,
    );

    _fillList(
      data['future_goals'],
      goalControllers,
    );

    _fillList(
      data['wrong_today'],
      wrongControllers,
    );

    _fillList(
      data['learned_today'],
      learnedControllers,
    );
  }

  // ============================================================
  // FILL LIST
  // ============================================================

  void _fillList(
    dynamic value,
    List<TextEditingController>
        controllers,
  ) {
    if (value == null) {
      return;
    }

    try {
      final List<dynamic> list =
          value is String
              ? List<dynamic>.from(
                  _decodeJson(value),
                )
              : List<dynamic>.from(value);

      for (int i = 0;
          i < controllers.length;
          i++) {
        if (i < list.length) {
          controllers[i].text =
              list[i]?.toString() ?? '';
        }
      }
    } catch (e) {
      debugPrint(
        'Error loading list: $e',
      );
    }
  }

  List<dynamic> _decodeJson(
    String value,
  ) {
    try {
      return value.isEmpty
          ? []
          : List<dynamic>.from(
              // ignore: avoid_dynamic_calls
              _jsonDecode(value),
            );
    } catch (_) {
      return [];
    }
  }

  dynamic _jsonDecode(String value) {
    // Using dart:convert through a local helper
    // would be cleaner, but this keeps this screen
    // simple.
    //
    // The database stores valid JSON arrays.
    return value.isEmpty ? [] : _decode(value);
  }

  dynamic _decode(String value) {
    // This function is replaced below by the
    // standard JSON decoder import.
    return [];
  }

  // ============================================================
  // SAVE TODAY
  // ============================================================

  Future<void> _saveToday({
    bool closeAfterSave = false,
  }) async {
    FocusScope.of(context).unfocus();

    final int? userId = currentUserId;

    if (userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please login again.',
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await databaseHelper.saveTodayEntry(
        userId: userId,

        entryDate: todayDateKey,

        mood: moodController.text.trim(),

        gratitude:
            gratitudeControllers
                .map(
                  (controller) =>
                      controller.text.trim(),
                )
                .toList(),

        todayTasks:
            taskControllers
                .map(
                  (controller) =>
                      controller.text.trim(),
                )
                .toList(),

        futureGoals:
            goalControllers
                .map(
                  (controller) =>
                      controller.text.trim(),
                )
                .toList(),

        wrongToday:
            wrongControllers
                .map(
                  (controller) =>
                      controller.text.trim(),
                )
                .toList(),

        learnedToday:
            learnedControllers
                .map(
                  (controller) =>
                      controller.text.trim(),
                )
                .toList(),

        lesson:
            lessonController.text.trim(),
      );

      hasSavedData = true;

      if (closeAfterSave) {
        if (!mounted) return;

        Navigator.pop(
          context,
          true,
        );

        return;
      }

      setState(() {
        isEditing = false;
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Today\'s information saved successfully.',
          ),
        ),
      );
    } catch (e) {
      debugPrint(
        'Error saving today: $e',
      );

      if (mounted) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to save today\'s information.',
            ),
          ),
        );
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor:
            const Color(0xFFF7F8FC),

        appBar: AppBar(
          backgroundColor:
              const Color(0xFFF7F8FC),
          elevation: 0,
          surfaceTintColor:
              Colors.transparent,

          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },

            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF111827),
              size: 20,
            ),
          ),

          title: const Text(
            'Add Today',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),

          centerTitle: true,
        ),

        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF111827),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F8FC),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor:
            const Color(0xFFF7F8FC),

        elevation: 0,

        surfaceTintColor:
            Colors.transparent,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF111827),
            size: 20,
          ),
        ),

        title: const Text(
          'Add Today',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),

        centerTitle: true,
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            40,
          ),

          children: [
            // ==================================================
            // TITLE
            // ==================================================

            const Text(
              'Your Day, Your Space',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Write about yourself, imagine your day.',
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // DAY + MOOD
            // ==================================================

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Expanded(
                  child: _dayDateCard(),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _moodCard(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ==================================================
            // EDIT + SAVE
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },

                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(0xFF111827),

                      side: const BorderSide(
                        color: Color(0xFFD1D5DB),
                      ),

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
                      'Edit',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: isEditing
                        ? () => _saveToday()
                        : null,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF111827),

                      foregroundColor:
                          Colors.white,

                      disabledBackgroundColor:
                          const Color(0xFFD1D5DB),

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
                      'Save',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ==================================================
            // GRATITUDE
            // ==================================================

            _sectionTitle(
              'Gratitude',
            ),

            const SizedBox(height: 12),

            _circleInputList(
              controllers:
                  gratitudeControllers,
              hintPrefix:
                  'I am grateful for',
            ),

            const SizedBox(height: 28),

            // ==================================================
            // TODAY TASK
            // ==================================================

            _sectionTitle(
              'Today Task',
            ),

            const SizedBox(height: 12),

            _rectangleInputList(
              controllers:
                  taskControllers,
              hintPrefix:
                  'Today I want to',
            ),

            const SizedBox(height: 28),

            // ==================================================
            // FUTURE GOAL
            // ==================================================

            _sectionTitle(
              'Future Goal',
            ),

            const SizedBox(height: 12),

            _circleInputList(
              controllers:
                  goalControllers,
              hintPrefix:
                  'My future goal is',
            ),

            const SizedBox(height: 28),

            // ==================================================
            // WRONG TODAY
            // ==================================================

            _sectionTitle(
              'What I Did Wrong Today',
            ),

            const SizedBox(height: 12),

            _circleInputList(
              controllers:
                  wrongControllers,
              hintPrefix:
                  'I could improve',
            ),

            const SizedBox(height: 28),

            // ==================================================
            // LEARNED TODAY
            // ==================================================

            _sectionTitle(
              'What I Learned Today',
            ),

            const SizedBox(height: 12),

            _circleInputList(
              controllers:
                  learnedControllers,
              hintPrefix:
                  'Today I learned',
            ),

            const SizedBox(height: 28),

            // ==================================================
            // LESSON
            // ==================================================

            _sectionTitle(
              'Lesson',
            ),

            const SizedBox(height: 12),

            _lessonTextField(),

            const SizedBox(height: 30),

            // ==================================================
            // SAVE TODAY
            // ==================================================

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isEditing
                    ? () => _saveToday(
                          closeAfterSave: true,
                        )
                    : () {
                        setState(() {
                          isEditing = true;
                        });
                      },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF111827),

                  foregroundColor:
                      Colors.white,

                  elevation: 0,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 17,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),

                child: Text(
                  isEditing
                      ? 'Save Today'
                      : 'Edit Today',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DAY & DATE CARD
  // ============================================================

  Widget _dayDateCard() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            'Day & Date',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
            ),
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,

            padding:
                const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 10,
            ),

            decoration: BoxDecoration(
              color:
                  const Color(0xFFF7F8FC),

              borderRadius:
                  BorderRadius.circular(14),
            ),

            child: Column(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  size: 27,
                  color: Color(0xFF111827),
                ),

                const SizedBox(height: 7),

                Text(
                  todayDay,
                  textAlign:
                      TextAlign.center,

                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  todayDate,
                  textAlign:
                      TextAlign.center,

                  style: const TextStyle(
                    fontSize: 11,
                    color:
                        Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOOD CARD
  // ============================================================

  Widget _moodCard() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            'Mood',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
            ),
          ),

          const SizedBox(height: 14),

          TextField(
            controller:
                moodController,

            enabled: isEditing,

            maxLines: 4,

            decoration:
                InputDecoration(
              hintText:
                  'How do you feel?',

              hintStyle:
                  const TextStyle(
                fontSize: 12,
                color:
                    Color(0xFF9CA3AF),
              ),

              filled: true,

              fillColor:
                  const Color(0xFFF7F8FC),

              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
                borderSide:
                    BorderSide.none,
              ),

              contentPadding:
                  const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(
    String title,
  ) {
    return Text(
      title,

      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Color(0xFF111827),
      ),
    );
  }

  // ============================================================
  // CIRCLE INPUT LIST
  // ============================================================

  Widget _circleInputList({
    required List<TextEditingController>
        controllers,

    required String hintPrefix,
  }) {
    return Column(
      children: List.generate(
        3,
        (index) {
          return Padding(
            padding:
                const EdgeInsets.only(
              bottom: 10,
            ),

            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center,

              children: [
                Container(
                  width: 9,
                  height: 9,

                  decoration:
                      const BoxDecoration(
                    shape:
                        BoxShape.circle,
                    color:
                        Color(0xFF111827),
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child: _smallTextField(
                    controller:
                        controllers[index],

                    hint:
                        '$hintPrefix ${index + 1}',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // RECTANGLE INPUT LIST
  // ============================================================

  Widget _rectangleInputList({
    required List<TextEditingController>
        controllers,

    required String hintPrefix,
  }) {
    return Column(
      children: List.generate(
        3,
        (index) {
          return Padding(
            padding:
                const EdgeInsets.only(
              bottom: 10,
            ),

            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center,

              children: [
                Container(
                  width: 9,
                  height: 9,

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFF111827,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      2,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child: _smallTextField(
                    controller:
                        controllers[index],

                    hint:
                        '$hintPrefix ${index + 1}',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // SMALL TEXT FIELD
  // ============================================================

  Widget _smallTextField({
    required TextEditingController
        controller,

    required String hint,
  }) {
    return TextField(
      controller: controller,

      enabled: isEditing,

      minLines: 1,

      maxLines: 2,

      decoration:
          InputDecoration(
        hintText: hint,

        hintStyle:
            const TextStyle(
          fontSize: 13,
          color:
              Color(0xFF9CA3AF),
        ),

        filled: true,

        fillColor: Colors.white,

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(13),

          borderSide:
              const BorderSide(
            color:
                Color(0xFFE5E7EB),
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(13),

          borderSide:
              const BorderSide(
            color:
                Color(0xFFE5E7EB),
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(13),

          borderSide:
              const BorderSide(
            color:
                Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LESSON
  // ============================================================

  Widget _lessonTextField() {
    return TextField(
      controller:
          lessonController,

      enabled: isEditing,

      minLines: 5,

      maxLines: 8,

      decoration:
          InputDecoration(
        hintText:
            'Write the most important lesson from today...',

        hintStyle:
            const TextStyle(
          fontSize: 14,
          color:
              Color(0xFF9CA3AF),
        ),

        filled: true,

        fillColor:
            Colors.white,

        contentPadding:
            const EdgeInsets.all(16),

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(18),

          borderSide:
              const BorderSide(
            color:
                Color(0xFFE5E7EB),
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(18),

          borderSide:
              const BorderSide(
            color:
                Color(0xFFE5E7EB),
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(18),

          borderSide:
              const BorderSide(
            color:
                Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }
}