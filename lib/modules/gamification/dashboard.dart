import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const Color _teal = Color(0xFF0DA69B);
  static const Color _background = Color(0xFFEAF7F1);
  static const Color _text = Color(0xFF12201D);
  static const Color _textMuted = Color(0xFF5B6B66);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: _background,
        foregroundColor: _text,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.eco_rounded, size: 96, color: _teal),
              SizedBox(height: 24),
              Text(
                'Coming soon',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: _text,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'level, streak, dan lencanamu akan muncul di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: _textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}