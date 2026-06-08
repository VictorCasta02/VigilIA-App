import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const VigilIAApp());
}

class VigilIAApp extends StatelessWidget {
  const VigilIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VigilIA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A5276),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}