import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/user_progress_provider.dart';
import '../../data/models/badge.dart';

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(userProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Earned', icon: Icon(Icons.star)),
                Tab(text: 'Available', icon: Icon(Icons.star_border)),
                Tab(text: 'All', icon: Icon(Icons.grid_view)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildEarnedBadges(context, progressState),
                  _buildAvailableBadges(context, progressState),
                  _buildAllBadges(context, progressState),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarnedBadges(BuildContext context, UserProgressState state) {
    if (state.earnedBadges.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No badges earned yet'),
            SizedBox(height: 8),
            Text('Complete daily tasks to start earning badges!'),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: state.earnedBadges.length,
      itemBuilder: (context, index) {
        final badge = state.earnedBadges[index];
        return _BadgeCard(badge: badge, isEarned: true);
      },
    );
  }

  Widget _buildAvailableBadges(BuildContext context, UserProgressState state) {
    final availableBadges = state.availableBadges
        .where((badge) => !state.earnedBadges.any((earned) => earned.id == badge.id))
        .toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: availableBadges.length,
      itemBuilder: (context, index) {
        final badge = availableBadges[index];
        return _BadgeCard(badge: badge, isEarned: false);
      },
    );
  }

  Widget _buildAllBadges(BuildContext context, UserProgressState state) {
    final badgesByType = <BadgeType, List<Badge>>{};
    for (final badge in state.availableBadges) {
      badgesByType[badge.type] = [...(badgesByType[badge.type] ?? []), badge];
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: badgesByType.keys.length,
      itemBuilder: (context, index) {
        final type = badgesByType.keys.elementAt(index);
        final badges = badgesByType[type]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                _getBadgeTypeName(type),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: badges.length,
              itemBuilder: (context, badgeIndex) {
                final badge = badges[badgeIndex];
                final isEarned = state.earnedBadges.any((earned) => earned.id == badge.id);
                return _BadgeCard(badge: badge, isEarned: isEarned);
              },
            ),
          ],
        );
      },
    );
  }

  String _getBadgeTypeName(BadgeType type) {
    switch (type) {
      case BadgeType.streak:
        return 'Streak Badges';
      case BadgeType.xp:
        return 'XP Badges';
      case BadgeType.accuracy:
        return 'Accuracy Badges';
      case BadgeType.speed:
        return 'Speed Badges';
      case BadgeType.topic:
        return 'Topic Badges';
      case BadgeType.special:
        return 'Special Badges';
    }
  }
}

class _BadgeCard extends StatelessWidget {
  final Badge badge;
  final bool isEarned;

  const _BadgeCard({
    required this.badge,
    required this.isEarned,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isEarned ? 4 : 1,
      child: InkWell(
        onTap: () => _showBadgeDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isEarned
                      ? _getBadgeColor(badge.rarity).withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isEarned ? _getBadgeColor(badge.rarity) : Colors.grey,
                    width: 3,
                  ),
                ),
                child: Icon(
                  _getBadgeIcon(badge.iconName),
                  color: isEarned ? _getBadgeColor(badge.rarity) : Colors.grey,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                badge.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isEarned ? null : Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getBadgeColor(badge.rarity).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge.rarity.name.toUpperCase(),
                  style: TextStyle(
                    color: _getBadgeColor(badge.rarity),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              if (isEarned && badge.unlockedAt != null)
                Text(
                  'Earned ${_formatDate(badge.unlockedAt!)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                )
              else
                Text(
                  badge.description,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBadgeDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isEarned
                    ? _getBadgeColor(badge.rarity).withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isEarned ? _getBadgeColor(badge.rarity) : Colors.grey,
                  width: 2,
                ),
              ),
              child: Icon(
                _getBadgeIcon(badge.iconName),
                color: isEarned ? _getBadgeColor(badge.rarity) : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                badge.name,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(badge.description),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Rarity: '),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getBadgeColor(badge.rarity).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge.rarity.name.toUpperCase(),
                    style: TextStyle(
                      color: _getBadgeColor(badge.rarity),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (badge.requiredValue != null) ...[
              const SizedBox(height: 8),
              Text('Requirement: ${badge.requiredValue}'),
            ],
            if (isEarned && badge.unlockedAt != null) ...[
              const SizedBox(height: 8),
              Text(
                'Earned on ${_formatDate(badge.unlockedAt!)}',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'today';
    } else if (difference == 1) {
      return 'yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}