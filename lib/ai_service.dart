// ai_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; 

class AiService {

  static const String _apiKey = 'AIzaSyAvYy6p7isD4ZqUc8-6oqkTxTekouqRQSk';

  static const String _model = 'gemini-2.5-flash';


  static String get _baseUrl =>
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent';

  Future<String> sendMessage(String message) async {
    try {
      final uri = Uri.parse(_baseUrl);

      final body = {
        "contents": [
          {
            "role": "user",
            "parts": [
              {
                "text":
                "You are a helpful, concise and friendly AI assistant.\n\nUser: $message"
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.7,
          "maxOutputTokens": 1000,
        }
      };

      // Wrapped in kDebugMode to resolve linter warnings
      if (kDebugMode) {
        print(' Sending request to Gemini: $uri');
        print(' Body: ${jsonEncode(body)}');
      }

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',

          'x-goog-api-key': _apiKey,
        },
        body: jsonEncode(body),
      );

      // Wrapped in kDebugMode to resolve linter warnings
      if (kDebugMode) {
        print(' Gemini status: ${response.statusCode}');
        print(' Gemini body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates == null || candidates.isEmpty) {
          throw Exception('No candidates returned from Gemini.');
        }

        final content = candidates[0]['content'];
        final parts = content['parts'] as List?;
        if (parts == null || parts.isEmpty) {
          throw Exception('No content parts returned from Gemini.');
        }

        final text = parts[0]['text']?.toString() ?? '';
        return text.trim();
      } else {
        throw Exception(
          'Gemini error. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e) {
      // Wrapped in kDebugMode to resolve linter warnings
      if (kDebugMode) {
        print(' Error communicating with Gemini: $e');
      }
      throw Exception('Error communicating with Gemini: $e');
    }
  }
}