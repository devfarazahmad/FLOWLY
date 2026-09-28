import 'package:flutter/material.dart';

class NewJournalEntryScreen extends StatefulWidget {
  const NewJournalEntryScreen({super.key});

  @override
  State<NewJournalEntryScreen> createState() =>
      _NewJournalEntryScreenState();
}

class _NewJournalEntryScreenState
    extends State<NewJournalEntryScreen> {
  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController thoughtsController =
      TextEditingController();

  String selectedMood = '😊';
  String selectedMoodName = 'Good';

  final List<Map<String, String>> moods = [
    {'emoji': '😄', 'name': 'Great'},
    {'emoji': '😊', 'name': 'Good'},
    {'emoji': '😐', 'name': 'Okay'},
    {'emoji': '😔', 'name': 'Sad'},
    {'emoji': '😴', 'name': 'Tired'},
  ];

  @override
  void dispose() {
    titleController.dispose();
    thoughtsController.dispose();
    super.dispose();
  }

  // Today's day name
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

  // Today's date
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

    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
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
          'New Journal Entry',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            35,
          ),
          children: [
            // Heading
            const Text(
              'New Journal Entry',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Take a moment to write what’s on your mind.',
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 25),

            // Day & Date + Mood
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDateCard(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMoodCard(),
                ),
              ],
            ),

            const SizedBox(height: 27),

            // Title
            _sectionLabel('Title'),

            const SizedBox(height: 10),

            TextField(
              controller: titleController,
              textCapitalization:
                  TextCapitalization.sentences,
              decoration: _inputDecoration(
                hint: 'Give your entry a title',
                icon: Icons.title_rounded,
              ),
            ),

            const SizedBox(height: 25),

            // Thoughts
            _sectionLabel('Your Thoughts'),

            const SizedBox(height: 10),

            TextField(
              controller: thoughtsController,
              textCapitalization:
                  TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              minLines: 10,
              maxLines: 16,
              decoration: InputDecoration(
                hintText:
                    'Write freely. What happened today? '
                    'What are you thinking or feeling?',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF9CA3AF),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.all(18),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFF9CA3AF),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Save Entry
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveEntry,
                icon: const Icon(
                  Icons.check_rounded,
                  size: 21,
                ),
                label: const Text(
                  'Save Journal Entry',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF111827),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 17,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(17),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // DATE CARD
  // --------------------------------------------------------------------------

  Widget _buildDateCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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

          const SizedBox(height: 15),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FC),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  color: Color(0xFF111827),
                  size: 28,
                ),

                const SizedBox(height: 9),

                Text(
                  todayDay,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  todayDate,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // MOOD CARD
  // --------------------------------------------------------------------------

  Widget _buildMoodCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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

          const SizedBox(height: 15),

          // Selected mood
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FC),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text(
                  selectedMood,
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  selectedMoodName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Mood selector
          PopupMenuButton<Map<String, String>>(
            tooltip: 'Choose mood',
            onSelected: (mood) {
              setState(() {
                selectedMood = mood['emoji']!;
                selectedMoodName = mood['name']!;
              });
            },
            itemBuilder: (context) {
              return moods.map((mood) {
                return PopupMenuItem<
                    Map<String, String>>(
                  value: mood,
                  child: Row(
                    children: [
                      Text(
                        mood['emoji']!,
                        style: const TextStyle(
                          fontSize: 23,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(mood['name']!),
                    ],
                  ),
                );
              }).toList();
            },
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                vertical: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_reaction_outlined,
                    size: 16,
                    color: Color(0xFF6B7280),
                  ),
                  SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      'Change',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // SECTION LABEL
  // --------------------------------------------------------------------------

  Widget _sectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        color: Color(0xFF111827),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // INPUT DECORATION
  // --------------------------------------------------------------------------

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xFF9CA3AF),
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF9CA3AF),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE5E7EB),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF9CA3AF),
          width: 1.5,
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // SAVE
  // --------------------------------------------------------------------------

  void _saveEntry() {
    final title = titleController.text.trim();
    final thoughts = thoughtsController.text.trim();

    if (title.isEmpty || thoughts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a title and your thoughts.',
          ),
        ),
      );
      return;
    }

    // Currently validates and confirms the entry.
    // Database storage can be added later.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Journal entry saved for this session.',
        ),
      ),
    );

    Navigator.pop(context);
  }
}