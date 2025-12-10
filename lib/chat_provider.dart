// chat_provider.dart

import 'package:flutter/material.dart';
import 'message_model.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> _messages = [];
  String _currentLanguage = '';

  List<Message> get messages => _messages;
  String get currentLanguage => _currentLanguage;

  /// Sets up a new chat session with the selected language and sends the initial AI greeting.
  void startNewSession(String language) {
    _currentLanguage = language;
    _messages = []; // Clear previous messages

    // Initial AI message
    _messages.add(
      Message(
        text: 'Hello! I am your AI tutor for $_currentLanguage. How can I help you practice?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  /// Adds a new message (user or AI) to the history.
  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  /// Clears the session memory (satisfies the "Auto-clear when leaving the screen" requirement).
  void clearSession() {
    _messages = [];
    _currentLanguage = '';
    notifyListeners();
  }
}