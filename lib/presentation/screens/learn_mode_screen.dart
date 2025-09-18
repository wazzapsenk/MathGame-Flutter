import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LearnModeScreen extends ConsumerWidget {
  const LearnModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Mode'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 64),
            SizedBox(height: 16),
            Text('Learn Mode Coming Soon!'),
            SizedBox(height: 8),
            Text('Interactive lessons with step-by-step explanations.'),
          ],
        ),
      ),
    );
  }
}