import 'package:flutter/material.dart';

import 'package:flowly/database/auth_controller.dart';
import 'package:flowly/database/database_helper.dart';
import 'package:get/get.dart';

import 'new_journal_entry_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() =>
      _JournalScreenState();
}

class _JournalScreenState
    extends State<JournalScreen> {
  List<Map<String, dynamic>> journalEntries = [];

  bool isLoading = true;

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _loadJournalEntries();
  }

  // ==========================================================================
  // GET USER ID
  // ==========================================================================

  int? _getUserId() {
    try {
      final authController =
          Get.find<AuthController>();

      final currentUser =
          authController.currentUser.value;

      if (currentUser == null) {
        return null;
      }

      final dynamic id = currentUser['id'];

      if (id is int) {
        return id;
      }

      return int.tryParse(id.toString());
    } catch (e) {
      return null;
    }
  }

  // ==========================================================================
  // LOAD JOURNAL ENTRIES
  // ==========================================================================

  Future<void> _loadJournalEntries() async {
    final userId = _getUserId();

    if (userId == null) {
      if (!mounted) return;

      setState(() {
        journalEntries = [];
        isLoading = false;
      });

      return;
    }

    try {
      final entries =
          await DatabaseHelper.instance
              .getJournalEntries(
        userId: userId,
      );

      if (!mounted) return;

      setState(() {
        journalEntries = entries;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Unable to load journal entries: $e',
          ),
        ),
      );
    }
  }

  // ==========================================================================
  // OPEN NEW JOURNAL
  // ==========================================================================

  Future<void> _openNewJournal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const NewJournalEntryScreen(),
      ),
    );

    // New journal was successfully saved
    if (result == true) {
      await _loadJournalEntries();
    }
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F8FC),

      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                110,
              ),
              children: [
                // ------------------------------------------------------------
                // HEADER
                // ------------------------------------------------------------

                const Text(
                  'Journal',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Reflect, write and reset',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 26),

                // ------------------------------------------------------------
                // JOURNAL IMAGE
                // ------------------------------------------------------------

                Container(
                  height: 220,
                  width: double.infinity,
                  clipBehavior:
                      Clip.antiAlias,
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFFEDE9FE),
                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),
                  ),
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
                                .auto_stories_rounded,
                            size: 60,
                            color:
                                Color(0xFF8B80C8),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Your journal space',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),

                // ------------------------------------------------------------
                // INTRO CARD
                // ------------------------------------------------------------

                Container(
                  padding:
                      const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                      22,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'A little space for you',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight:
                              FontWeight.w800,
                          color:
                              Color(0xFF111827),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Capture your thoughts, celebrate '
                        'small moments, and make sense of '
                        'your day.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color:
                              Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ------------------------------------------------------------
                // SAVED JOURNAL SECTION
                // ------------------------------------------------------------

                const Text(
                  'Your Journal',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 14),

                if (isLoading)
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(
                      vertical: 35,
                    ),
                    child: Center(
                      child:
                          CircularProgressIndicator(),
                    ),
                  )
                else if (journalEntries.isEmpty)
                  _buildEmptyJournal()
                else
                  ...journalEntries.map(
                    (entry) =>
                        _buildJournalCard(
                      entry,
                    ),
                  ),
              ],
            ),

            // ---------------------------------------------------------------
            // START WRITING BUTTON
            // ---------------------------------------------------------------

            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: ElevatedButton.icon(
                onPressed:
                    _openNewJournal,
                icon: const Icon(
                  Icons.edit_note_rounded,
                  size: 23,
                ),
                label: const Text(
                  'Start Writing',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF111827),
                  foregroundColor:
                      Colors.white,
                  elevation: 5,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 17,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      17,
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

  // ==========================================================================
  // EMPTY JOURNAL
  // ==========================================================================

  Widget _buildEmptyJournal() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 45,
            color: Color(0xFF9CA3AF),
          ),
          SizedBox(height: 12),
          Text(
            'No journal entries yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Start writing and your journal entries '
            'will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // JOURNAL CARD
  // ==========================================================================

  Widget _buildJournalCard(
    Map<String, dynamic> entry,
  ) {
    final String title =
        entry['title']?.toString() ?? '';

    final String thoughts =
        entry['thoughts']?.toString() ?? '';

    final String moodEmoji =
        entry['mood_emoji']?.toString() ??
            '😊';

    final String moodName =
        entry['mood_name']?.toString() ??
            'Good';

    final String entryDay =
        entry['entry_day']?.toString() ?? '';

    final String entryDate =
        entry['entry_date']?.toString() ?? '';

    return Container(
      margin:
          const EdgeInsets.only(bottom: 14),
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // --------------------------------------------------------------
          // TOP ROW
          // --------------------------------------------------------------

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // Mood
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFF3F0FF),
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
                alignment:
                    Alignment.center,
                child: Text(
                  moodEmoji,
                  style: const TextStyle(
                    fontSize: 28,
                  ),
                ),
              ),

              const SizedBox(width: 13),

              // Title + date
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w800,
                        color:
                            Color(0xFF111827),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '$entryDay • $entryDate',
                      style: const TextStyle(
                        fontSize: 12,
                        color:
                            Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),

              // Mood name
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFF7F8FC),
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
                child: Text(
                  moodName,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // --------------------------------------------------------------
          // THOUGHTS
          // --------------------------------------------------------------

          Text(
            thoughts,
            maxLines: 5,
            overflow:
                TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF4B5563),
            ),
          ),

          const SizedBox(height: 14),

          // --------------------------------------------------------------
          // READ MORE
          // --------------------------------------------------------------

          Row(
            mainAxisAlignment:
                MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  _showFullEntry(entry);
                },
                style: TextButton.styleFrom(
                  foregroundColor:
                      const Color(0xFF111827),
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                ),
                child: const Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Text(
                      'Read entry',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons
                          .arrow_forward_rounded,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SHOW FULL JOURNAL ENTRY
  // ==========================================================================

  void _showFullEntry(
    Map<String, dynamic> entry,
  ) {
    final String title =
        entry['title']?.toString() ?? '';

    final String thoughts =
        entry['thoughts']?.toString() ?? '';

    final String moodEmoji =
        entry['mood_emoji']?.toString() ??
            '😊';

    final String moodName =
        entry['mood_name']?.toString() ??
            'Good';

    final String entryDay =
        entry['entry_day']?.toString() ?? '';

    final String entryDate =
        entry['entry_date']?.toString() ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height:
              MediaQuery.of(context).size.height *
                  0.82,
          decoration: const BoxDecoration(
            color: Color(0xFFF7F8FC),
            borderRadius:
                BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // ----------------------------------------------------------
                // HANDLE
                // ----------------------------------------------------------

                const SizedBox(height: 10),

                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFFD1D5DB),
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ----------------------------------------------------------
                // HEADER
                // ----------------------------------------------------------

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFEDE9FE,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            15,
                          ),
                        ),
                        alignment:
                            Alignment.center,
                        child: Text(
                          moodEmoji,
                          style:
                              const TextStyle(
                            fontSize: 26,
                          ),
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
                            Text(
                              title,
                              maxLines: 2,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                              style:
                                  const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight
                                        .w800,
                                color: Color(
                                  0xFF111827,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '$entryDay • $entryDate • $moodName',
                              style:
                                  const TextStyle(
                                fontSize: 12,
                                color: Color(
                                  0xFF6B7280,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ----------------------------------------------------------
                // THOUGHTS
                // ----------------------------------------------------------

                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      30,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(
                        20,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          22,
                        ),
                      ),
                      child: Text(
                        thoughts,
                        style:
                            const TextStyle(
                          fontSize: 15,
                          height: 1.7,
                          color:
                              Color(0xFF374151),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}