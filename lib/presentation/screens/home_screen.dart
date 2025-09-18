import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../navigation/app_router.dart';
import '../widgets/home_card.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/streak_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MindMath'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push(AppRouter.profile),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRouter.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(context),
            const SizedBox(height: 24),
            _buildProgressSection(context),
            const SizedBox(height: 24),
            _buildActivitiesSection(context),
            const SizedBox(height: 24),
            _buildQuickAccessSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ready for today\'s math adventure?',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            const StreakWidget(currentStreak: 5, longestStreak: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        const ProgressIndicatorWidget(
          level: 3,
          currentXP: 750,
          totalXP: 1000,
        ),
      ],
    );
  }

  Widget _buildActivitiesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Activities',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        HomeCard(
          icon: Icons.assignment,
          title: 'Daily Tasks',
          subtitle: 'Complete today\'s challenges',
          color: Theme.of(context).colorScheme.primary,
          onTap: () => context.push(AppRouter.dailyTasks),
          badge: '2/3',
        ),
      ],
    );
  }

  Widget _buildQuickAccessSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learning Modes',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            HomeCard(
              icon: Icons.school,
              title: 'Learn',
              subtitle: 'Interactive lessons',
              color: Colors.green,
              onTap: () => context.push(AppRouter.learn),
            ),
            HomeCard(
              icon: Icons.fitness_center,
              title: 'Practice',
              subtitle: 'Skill building',
              color: Colors.orange,
              onTap: () => context.push(AppRouter.practice),
            ),
            HomeCard(
              icon: Icons.games,
              title: 'Arcade',
              subtitle: 'Fun mini-games',
              color: Colors.purple,
              onTap: () => context.push(AppRouter.arcade),
            ),
            HomeCard(
              icon: Icons.analytics,
              title: 'Dashboard',
              subtitle: 'Track progress',
              color: Colors.blue,
              onTap: () => context.push(AppRouter.dashboard),
            ),
          ],
        ),
      ],
    );
  }
}