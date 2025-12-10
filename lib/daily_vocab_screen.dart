// daily_vocab_screen.dart

import 'package:flutter/material.dart';

class DailyVocabScreen extends StatelessWidget {
  const DailyVocabScreen({super.key});

  // Example daily words (later can fetch from AI)
  final List<Map<String, String>> dailyWords = const [
    {
      'word': 'Bonjour',
      'translation': 'Hello',
      'example': 'Bonjour! Comment ça va?',
    },
    {
      'word': 'Gracias',
      'translation': 'Thank you',
      'example': 'Gracias por tu ayuda.',
    },
    {
      'word': 'Danke',
      'translation': 'Thank you',
      'example': 'Danke für alles.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Vocabulary'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: dailyWords.length,
        itemBuilder: (context, index) {
          final item = dailyWords[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['word']!,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Meaning: ${item['translation']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Example: ${item['example']}',
                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Add functionality to save word
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${item['word']} added to favorites!')),
                        );
                      },
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
