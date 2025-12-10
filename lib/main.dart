// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // NEW
import 'chat_screen.dart';
import 'splash_screen.dart';
import 'home_screen.dart'; // NEW
import 'chat_provider.dart'; // NEW

void main() {
  // Wrap MyApp with the provider for state management
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chatbot',
      debugShowCheckedModeBanner: false,

      // ROUTES
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(), // NEW HOME ROUTE
        '/chat': (context) => const ChatScreen(),
      },

      themeMode: ThemeMode.system, // Auto switch

      // LIGHT THEME
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF2563EB),
          secondary: Color(0xFF64748B),
          background: Colors.white,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // DARK THEME
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF94A3B8),
          background: Color(0xFF0F172A),
          surface: Color(0xFF1E293B),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color(0xFF0F172A),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}