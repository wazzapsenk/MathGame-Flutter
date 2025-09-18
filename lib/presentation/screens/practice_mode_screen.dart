import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PracticeModeScreen extends ConsumerWidget {
  const PracticeModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Mode'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 64),
            SizedBox(height: 16),
            Text('Practice Mode Coming Soon!'),
            SizedBox(height: 8),
            Text('Adaptive practice sessions to build your skills.'),
          ],
        ),
      ),
    );
  }
}