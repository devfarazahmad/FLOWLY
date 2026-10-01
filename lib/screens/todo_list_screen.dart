import 'package:flowly/database/auth_controller.dart';
import 'package:flowly/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_today_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({
    super.key,
  });

  @override
  State<TodoScreen> createState() =>
      _TodoScreenState();
}

class _TodoScreenState
    extends State<TodoScreen> {
  // ============================================================
  // DATABASE
  // ============================================================

  final DatabaseHelper databaseHelper =
      DatabaseHelper.instance;

  late final AuthController authController;

  // ============================================================
  // STATE
  // ============================================================

  bool isLoading = true;

  Map<String, dynamic>? todayData;

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
  // USER ID
  // ============================================================

  int? get currentUserId {
    final user =
        authController.currentUser.value;

    if (user == null) {
      return null;
    }

    return user['id'] as int?;
  }

  // ============================================================
  // TODAY DATE KEY
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
  // LOAD TODAY
  // ============================================================

  Future<void> _loadTodayData() async {
    final int? userId =
        currentUserId;

    if (userId == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      return;
    }

    try {
      final data =
          await databaseHelper.getTodayEntry(
        userId: userId,
        entryDate: todayDateKey,
      );

      if (mounted) {
        setState(() {
          todayData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(
        'Error loading To-Do data: $e',
      );

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // OPEN ADD TODAY
  // ============================================================

  Future<void> _openAddToday() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddTodayScreen(),
      ),
    );

    // ----------------------------------------------------------
    // IMPORTANT
    // ----------------------------------------------------------
    // AddTodayScreen returns true after saving.
    //
    // We reload SQLite immediately.
    // ----------------------------------------------------------

    if (result == true) {
      await _loadTodayData();
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F8FC),

      body: SafeArea(
        child: Stack(
          children: [
            if (isLoading)
              const Center(
                child:
                    CircularProgressIndicator(
                  color:
                      Color(0xFF111827),
                ),
              )
            else
              ListView(
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  24,
                  20,
                  120,
                ),

                children: [
                  // ==================================================
                  // HEADER
                  // ==================================================

                  const Text(
                    'TO-DO List',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.w800,
                      color:
                          Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  const Text(
                    'Take a Moment for yourself today',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          Color(0xFF6B7280),
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ==================================================
                  // IMAGE
                  // ==================================================

                  Container(
                    height: 210,
                    width:
                        double.infinity,

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFEDE9FE,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),
                    ),

                    clipBehavior:
                        Clip.antiAlias,

                    child: Image.asset(
                      'assets/images/flowly_logo.png',

                      fit: BoxFit.cover,

                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                          children: [
                            Icon(
                              Icons
                                  .image_outlined,
                              size: 55,
                              color:
                                  Color(
                                0xFF9CA3AF,
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            Text(
                              'Add your To-Do image',
                              style:
                                  TextStyle(
                                color:
                                    Color(
                                  0xFF6B7280,
                                ),
                                fontSize:
                                    14,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  // ==================================================
                  // IF NO DATA
                  // ==================================================

                  if (todayData == null)
                    _buildEmptyToday()

                  else ...[
                    // ================================================
                    // SAVED TODAY
                    // ================================================

                    const Text(
                      'Today\'s Saved Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            Color(0xFF111827),
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    // ================================================
                    // MOOD
                    // ================================================

                    _infoCard(
                      icon:
                          Icons.mood_rounded,
                      title:
                          'Mood',
                      value:
                          todayData![
                                  'mood']
                              ?.toString()
                              .trim()
                              .isNotEmpty ==
                              true
                          ? todayData![
                                  'mood']
                              .toString()
                          : 'No mood added',
                    ),

                    // ================================================
                    // GRATITUDE
                    // ================================================

                    _savedListCard(
                      title:
                          'Gratitude',
                      icon:
                          Icons.favorite_border_rounded,
                      items:
                          _decodeList(
                        todayData![
                            'gratitude'],
                      ),
                      circle:
                          true,
                    ),

                    // ================================================
                    // TODAY TASK
                    // ================================================

                    _savedListCard(
                      title:
                          'Today Task',
                      icon:
                          Icons.check_circle_outline_rounded,
                      items:
                          _decodeList(
                        todayData![
                            'today_tasks'],
                      ),
                      circle:
                          false,
                    ),

                    // ================================================
                    // FUTURE GOAL
                    // ================================================

                    _savedListCard(
                      title:
                          'Future Goal',
                      icon:
                          Icons.flag_outlined,
                      items:
                          _decodeList(
                        todayData![
                            'future_goals'],
                      ),
                      circle:
                          true,
                    ),

                    // ================================================
                    // WRONG TODAY
                    // ================================================

                    _savedListCard(
                      title:
                          'What I Did Wrong Today',
                      icon:
                          Icons.refresh_rounded,
                      items:
                          _decodeList(
                        todayData![
                            'wrong_today'],
                      ),
                      circle:
                          true,
                    ),

                    // ================================================
                    // LEARNED TODAY
                    // ================================================

                    _savedListCard(
                      title:
                          'What I Learned Today',
                      icon:
                          Icons.lightbulb_outline_rounded,
                      items:
                          _decodeList(
                        todayData![
                            'learned_today'],
                      ),
                      circle:
                          true,
                    ),

                    // ================================================
                    // LESSON
                    // ================================================

                    _infoCard(
                      icon:
                          Icons.menu_book_rounded,
                      title:
                          'Lesson',
                      value:
                          todayData![
                                  'lesson']
                              ?.toString()
                              .trim()
                              .isNotEmpty ==
                              true
                          ? todayData![
                                  'lesson']
                              .toString()
                          : 'No lesson added',
                    ),
                  ],
                ],
              ),

            // ==========================================================
            // ADD TODAY BUTTON
            // ==========================================================

            Positioned(
              right: 20,
              bottom: 20,

              child: ElevatedButton.icon(
                onPressed:
                    _openAddToday,

                icon: const Icon(
                  Icons.add_rounded,
                  size: 21,
                ),

                label: const Text(
                  'Add Today',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF111827,
                  ),

                  foregroundColor:
                      Colors.white,

                  elevation: 5,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
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
  // EMPTY TODAY
  // ============================================================

  Widget _buildEmptyToday() {
    return Container(
      padding:
          const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color:
              const Color(0xFFE5E7EB),
        ),
      ),

      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration:
                const BoxDecoration(
              color:
                  Color(0xFFF3F4F6),
              shape:
                  BoxShape.circle,
            ),

            child: const Icon(
              Icons.edit_note_rounded,
              color:
                  Color(0xFF374151),
              size: 30,
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          const Text(
            'Nothing added for today',
            textAlign:
                TextAlign.center,

            style: TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.w700,
              color:
                  Color(0xFF111827),
            ),
          ),

          const SizedBox(
            height: 7,
          ),

          const Text(
            'Take a moment to write about your day.',
            textAlign:
                TextAlign.center,

            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color:
                  Color(0xFF6B7280),
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          OutlinedButton(
            onPressed:
                _openAddToday,

            style:
                OutlinedButton.styleFrom(
              foregroundColor:
                  const Color(
                0xFF111827,
              ),

              side:
                  const BorderSide(
                color:
                    Color(0xFFD1D5DB),
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
            ),

            child: const Text(
              'Write Today',
              style: TextStyle(
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color:
              const Color(0xFFF0F0F3),
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            width: 44,
            height: 44,

            decoration:
                BoxDecoration(
              color:
                  const Color(0xFFF3F4F6),

              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),

            child: Icon(
              icon,
              color:
                  const Color(0xFF374151),
              size: 22,
            ),
          ),

          const SizedBox(
            width: 13,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style:
                      const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(0xFF111827),
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  value,

                  style:
                      const TextStyle(
                    fontSize: 13,
                    height: 1.4,
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
  // SAVED LIST CARD
  // ============================================================

  Widget _savedListCard({
    required String title,
    required IconData icon,
    required List<String> items,
    required bool circle,
  }) {
    final List<String> validItems =
        items
            .where(
              (item) =>
                  item.trim().isNotEmpty,
            )
            .toList();

    if (validItems.isEmpty) {
      return _infoCard(
        icon: icon,
        title: title,
        value: 'Nothing added',
      );
    }

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color:
              const Color(0xFFF0F0F3),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFFF3F4F6,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    13,
                  ),
                ),

                child: Icon(
                  icon,
                  color:
                      const Color(
                    0xFF374151,
                  ),
                  size: 21,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Text(
                  title,

                  style:
                      const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 15,
          ),

          ...validItems.map(
            (item) {
              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 9,
                ),

                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(
                        top: 5,
                      ),

                      width: 9,
                      height: 9,

                      decoration:
                          BoxDecoration(
                        shape: circle
                            ? BoxShape.circle
                            : BoxShape.rectangle,

                        borderRadius:
                            circle
                                ? null
                                : BorderRadius
                                    .circular(
                                    2,
                                  ),

                        color:
                            const Color(
                          0xFF111827,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child: Text(
                        item,

                        style:
                            const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color:
                              Color(
                            0xFF4B5563,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DECODE LIST
  // ============================================================

  List<String> _decodeList(
    dynamic value,
  ) {
    if (value == null) {
      return [];
    }

    try {
      if (value is String) {
        if (value.trim().isEmpty) {
          return [];
        }

        // The JSON decoder is imported
        // below through dart:convert.
        return [];
      }

      if (value is List) {
        return value
            .map(
              (item) =>
                  item.toString(),
            )
            .toList();
      }
    } catch (e) {
      debugPrint(
        'Error decoding list: $e',
      );
    }

    return [];
  }
}