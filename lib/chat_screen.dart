import 'package:flutter/material.dart';
import 'ai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AiService _aiService = AiService();
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];
  bool _isLoading = false;

  Future<void> _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isLoading = true;
      _controller.clear();
    });

    try {
      final reply = await _aiService.sendMessage(text);
      setState(() {
        _messages.add(_ChatMessage(text: reply, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.add(
          _ChatMessage(
            text: 'Error: $e',
            isUser: false,
          ),
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    final alignment =
        msg.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bgColor = msg.isUser ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB);
    final textColor = msg.isUser ? Colors.white : Colors.black87;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg.text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isLoading ? null : _handleSend,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  _ChatMessage({
    required this.text,
    required this.isUser,
  });
}
