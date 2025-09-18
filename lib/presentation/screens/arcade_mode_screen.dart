import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArcadeModeScreen extends ConsumerWidget {
  const ArcadeModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arcade Mode'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.games, size: 64),
            SizedBox(height: 16),
            Text('Arcade Mode Coming Soon!'),
            SizedBox(height: 8),
            Text('Fun mini-games to make learning math exciting.'),
          ],
        ),
      ),
    );
  }
}