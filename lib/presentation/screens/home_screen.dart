import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../navigation/app_router.dart';
import '../widgets/home_card.dart';
import '../widgets/progress_indicator_widget.dart';
import '../widgets/streak_widget.dart';
import '../../data/providers/user_progress_provider.dart';
import '../../data/models/badge.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProgressProvider.notifier).loadUserProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressState = ref.watch(userProgressProvider);

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
            _buildWelcomeSection(context, progressState),
            const SizedBox(height: 24),
            _buildProgressSection(context, progressState),
            const SizedBox(height: 24),
            _buildActivitiesSection(context),
            const SizedBox(height: 24),
            _buildQuickAccessSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, UserProgressState progressState) {
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
            StreakWidget(
              currentStreak: progressState.currentStreak,
              longestStreak: progressState.longestStreak,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, UserProgressState progressState) {
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
        ProgressIndicatorWidget(
          level: progressState.currentLevel,
          currentXP: progressState.xpInCurrentLevel,
          totalXP: 1000,
        ),
        if (progressState.recentBadges.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildRecentBadges(context, progressState),
        ],
        const SizedBox(height: 16),
        _buildViewAllBadgesButton(context),
      ],
    );
  }

  Widget _buildRecentBadges(BuildContext context, UserProgressState progressState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Achievements',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: progressState.recentBadges.length,
            itemBuilder: (context, index) {
              final badge = progressState.recentBadges[index];
              return Container(
                width: 60,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _getBadgeColor(badge.rarity).withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getBadgeColor(badge.rarity),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _getBadgeIcon(badge.iconName),
                        color: _getBadgeColor(badge.rarity),
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      badge.name,
                      style: Theme.of(context).textTheme.labelSmall,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getBadgeColor(BadgeRarity rarity) {
    switch (rarity) {
      case BadgeRarity.common:
        return Colors.grey;
      case BadgeRarity.rare:
        return Colors.blue;
      case BadgeRarity.epic:
        return Colors.purple;
      case BadgeRarity.legendary:
        return Colors.orange;
    }
  }

  IconData _getBadgeIcon(String iconName) {
    switch (iconName) {
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'star':
        return Icons.star;
      case 'check_circle':
        return Icons.check_circle;
      case 'flash_on':
        return Icons.flash_on;
      case 'calculate':
        return Icons.calculate;
      case 'pie_chart':
        return Icons.pie_chart;
      case 'square':
        return Icons.square;
      case 'baby_changing_station':
        return Icons.baby_changing_station;
      case 'school':
        return Icons.school;
      case 'weekend':
        return Icons.weekend;
      default:
        return Icons.emoji_events;
    }
  }

  Widget _buildViewAllBadgesButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => context.push(AppRouter.badges),
        icon: const Icon(Icons.emoji_events),
        label: const Text('View All Achievements'),
      ),
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