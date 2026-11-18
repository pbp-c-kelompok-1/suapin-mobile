import 'package:flutter/material.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
    Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Story Progression')),
        body: Center(
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Icon(
                Icons.auto_stories_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                'Komik Suap.in',
                style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                'Kenali perjalanan makanan dari kebun ke piring.',
                textAlign: TextAlign.center,
                ),
            ],
            ),
        ),
        ),
    );
    }
}