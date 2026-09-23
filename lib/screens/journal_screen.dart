import 'package:flutter/material.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final journalEntries = [
      {
        'date': 'Today',
        'title': 'A productive day',
        'preview': 'Today I completed most of my important tasks...',
        'mood': '😊',
      },
      {
        'date': 'Yesterday',
        'title': 'Small wins',
        'preview': 'I managed to stay focused and finish my work...',
        'mood': '😌',
      },
      {
        'date': 'Sep 20',
        'title': 'Weekend thoughts',
        'preview': 'Taking some time to reflect on the week...',
        'mood': '🌿',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Journal',
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
              Icons.search_rounded,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF22C55E),
        child: const Icon(
          Icons.edit_rounded,
          color: Colors.white,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How are you feeling today?',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF222222),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Take a moment to reflect and write it down.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF777777),
                  ),
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('😄', style: TextStyle(fontSize: 28)),
                    Text('😊', style: TextStyle(fontSize: 28)),
                    Text('😐', style: TextStyle(fontSize: 28)),
                    Text('😔', style: TextStyle(fontSize: 28)),
                    Text('😴', style: TextStyle(fontSize: 28)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Recent Entries',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 14),

          ...journalEntries.map(
            (entry) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFEDEDED),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      entry['mood']!,
                      style: const TextStyle(fontSize: 23),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry['date']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF22C55E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry['title']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          entry['preview']!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ],
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
}