// chat_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ai_service.dart';
import 'message_model.dart'; // Now using the correct Message model
import 'chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AiService _aiService = AiService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    // Clear session when the chat screen is popped/disposed
    Provider.of<ChatProvider>(context, listen: false).clearSession();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Get the provider without listening (listen: false)
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final selectedLanguage = chatProvider.currentLanguage;

    // 1. Add User Message
    final userMessage = Message(
        text: text,
        isUser: true,
        timestamp: DateTime.now()
    );

    setState(() {
      chatProvider.addMessage(userMessage);
      _isLoading = true;
      _controller.clear();
      _scrollToBottom();
    });

    // 2. Construct the language-specific prompt, using the selected language
    final languagePrompt =
        "You are a helpful, concise, and friendly AI tutor assisting with $selectedLanguage language learning. You should primarily respond in $selectedLanguage, unless the user specifically asks for English translation or explanation. Respond to the user's message appropriately.\n\nUser: $text";


    try {
      final reply = await _aiService.sendMessage(languagePrompt);
      // 3. Add AI Reply
      chatProvider.addMessage(
          Message(
              text: reply,
              isUser: false,
              timestamp: DateTime.now()
          )
      );
    } catch (e) {
      // 4. Add Error Message
      chatProvider.addMessage(
          Message(
              text: 'Error: Could not reach the AI. Check your connection.',
              isUser: false,
              timestamp: DateTime.now()
          )
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  // Uses the public Message model
  Widget _buildMessageBubble(Message msg, BuildContext context) {
    final isUser = msg.isUser;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;

    // Use Theme.of(context) to get theme colors
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    final bgColor = isUser ? primaryColor : surfaceColor;
    final textColor = isUser ? Colors.white : onSurfaceColor;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16).copyWith(
              topLeft: isUser ? const Radius.circular(16) : Radius.zero,
              topRight: isUser ? Radius.zero : const Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              )
            ]
        ),
        child: Text(
          msg.text,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 5. Use Consumer to listen for message updates
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Scaffold(
          appBar: AppBar(
            // Use language from Provider for title
            title: Text('${chatProvider.currentLanguage} Tutor'),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController, // Attach controller
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  // Use messages from Provider
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final msg = chatProvider.messages[index];
                    return _buildMessageBubble(msg, context);
                  },
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              // Apply theme colors to input border
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onSubmitted: _isLoading ? null : (_) => _handleSend(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                            Icons.send,
                            color: _isLoading
                                ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
                                : Theme.of(context).colorScheme.primary
                        ),
                        iconSize: 28,
                        onPressed: _isLoading ? null : _handleSend,
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}