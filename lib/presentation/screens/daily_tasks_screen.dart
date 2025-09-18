import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyTasksScreen extends ConsumerWidget {
  const DailyTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Tasks'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 64),
            SizedBox(height: 16),
            Text('Daily Tasks Coming Soon!'),
            SizedBox(height: 8),
            Text('Complete daily challenges to earn XP and maintain your streak.'),
          ],
        ),
      ),
    );
  }
}