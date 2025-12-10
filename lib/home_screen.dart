// home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> languages = const [
    'English',
    'Spanish',
    'French',
    'German',
    'Japanese',
    'Mandarin',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Language'),
        automaticallyImplyLeading: false, // Prevent back button from splash
      ),
      body: Column(
        children: [
          // Daily Vocabulary Button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/daily_vocab');
                },
                icon: const Icon(Icons.book),
                label: const Text('Daily Vocabulary'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          // Language List
          Expanded(
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 1,
                  child: ListTile(
                    title: Text(language, style: Theme.of(context).textTheme.titleMedium),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onTap: () {
                      // Get the provider instance
                      final chatProvider =
                          Provider.of<ChatProvider>(context, listen: false);

                      // Start a new session and initialize the chat history
                      chatProvider.startNewSession(language);

                      // Navigate to the chat screen
                      Navigator.pushNamed(context, '/chat');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
