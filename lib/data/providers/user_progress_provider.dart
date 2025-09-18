import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../models/badge.dart';
import '../../core/constants/app_constants.dart';

class UserProgressState {
  final UserProfile? profile;
  final List<Badge> earnedBadges;
  final List<Badge> availableBadges;
  final int currentStreak;
  final int longestStreak;
  final int totalXP;
  final DateTime? lastActiveDate;
  final bool isLoading;
  final String? error;

  const UserProgressState({
    this.profile,
    required this.earnedBadges,
    required this.availableBadges,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalXP,
    this.lastActiveDate,
    required this.isLoading,
    this.error,
  });

  UserProgressState copyWith({
    UserProfile? profile,
    List<Badge>? earnedBadges,
    List<Badge>? availableBadges,
    int? currentStreak,
    int? longestStreak,
    int? totalXP,
    DateTime? lastActiveDate,
    bool? isLoading,
    String? error,
  }) {
    return UserProgressState(
      profile: profile ?? this.profile,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      availableBadges: availableBadges ?? this.availableBadges,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalXP: totalXP ?? this.totalXP,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  int get currentLevel => (totalXP / 1000).floor() + 1;
  int get xpInCurrentLevel => totalXP % 1000;
  int get xpToNextLevel => 1000 - xpInCurrentLevel;
  double get levelProgress => xpInCurrentLevel / 1000.0;

  List<Badge> get recentBadges => earnedBadges
      .where((badge) => badge.unlockedAt != null)
      .toList()
      ..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!))
      ..take(5);

  List<Badge> get unlockedBadges => [];
}

class UserProgressNotifier extends StateNotifier<UserProgressState> {
  UserProgressNotifier()
      : super(UserProgressState(
          earnedBadges: [],
          availableBadges: BadgeDefinitions.allBadges,
          currentStreak: 0,
          longestStreak: 0,
          totalXP: 0,
          isLoading: false,
        ));

  // Statistics tracking
  int _questionsAnswered = 0;
  int _correctAnswers = 0;
  int _fastAnswers = 0; // Under 15 seconds
  int _perfectTasks = 0;
  int _weekendDays = 0;
  Map<String, int> _topicCounts = {};

  void loadUserProgress() {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: Load from local storage
      // For now, simulate some progress
      _simulateProgress();

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void _simulateProgress() {
    // Simulate some existing progress for demonstration
    state = state.copyWith(
      currentStreak: 5,
      longestStreak: 12,
      totalXP: 750,
      lastActiveDate: DateTime.now().subtract(const Duration(days: 1)),
    );

    _questionsAnswered = 45;
    _correctAnswers = 38;
    _topicCounts = {
      'arithmetic': 25,
      'fractions': 12,
      'geometry': 8,
    };

    _checkAndAwardBadges();
  }

  void addXP(int xp) {
    final newTotalXP = state.totalXP + xp;
    state = state.copyWith(totalXP: newTotalXP);
    _checkAndAwardBadges();
  }

  void updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActive = state.lastActiveDate != null
        ? DateTime(
            state.lastActiveDate!.year,
            state.lastActiveDate!.month,
            state.lastActiveDate!.day,
          )
        : null;

    if (lastActive == null) {
      // First time playing
      state = state.copyWith(
        currentStreak: 1,
        longestStreak: 1,
        lastActiveDate: now,
      );
    } else if (lastActive == today) {
      // Already played today, no change
      return;
    } else if (lastActive == today.subtract(const Duration(days: 1))) {
      // Played yesterday, continue streak
      final newStreak = state.currentStreak + 1;
      state = state.copyWith(
        currentStreak: newStreak,
        longestStreak: newStreak > state.longestStreak ? newStreak : state.longestStreak,
        lastActiveDate: now,
      );
    } else {
      // Streak broken, reset to 1
      state = state.copyWith(
        currentStreak: 1,
        lastActiveDate: now,
      );
    }

    // Check for weekend activity
    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      _weekendDays++;
    }

    _checkAndAwardBadges();
  }

  void recordQuestionAnswered({
    required String topic,
    required bool isCorrect,
    required int timeSpent,
  }) {
    _questionsAnswered++;
    _topicCounts[topic] = (_topicCounts[topic] ?? 0) + 1;

    if (isCorrect) {
      _correctAnswers++;
    }

    if (timeSpent < 15) {
      _fastAnswers++;
    }

    _checkAndAwardBadges();
  }

  void recordTaskCompleted({required double accuracy}) {
    if (accuracy >= 1.0) {
      _perfectTasks++;
    }

    _checkAndAwardBadges();
  }

  void _checkAndAwardBadges() {
    final newlyEarned = <Badge>[];

    for (final badge in state.availableBadges) {
      // Skip if already earned
      if (state.earnedBadges.any((earned) => earned.id == badge.id)) {
        continue;
      }

      if (_checkBadgeRequirement(badge)) {
        final earnedBadge = badge.copyWith(unlockedAt: DateTime.now());
        newlyEarned.add(earnedBadge);
      }
    }

    if (newlyEarned.isNotEmpty) {
      final updatedEarnedBadges = [...state.earnedBadges, ...newlyEarned];
      state = state.copyWith(earnedBadges: updatedEarnedBadges);

      // TODO: Show badge notification
      // TODO: Save to local storage
    }
  }

  bool _checkBadgeRequirement(Badge badge) {
    switch (badge.type) {
      case BadgeType.streak:
        return state.currentStreak >= (badge.requiredValue ?? 0);

      case BadgeType.xp:
        return state.totalXP >= (badge.requiredValue ?? 0);

      case BadgeType.accuracy:
        if (badge.id == 'perfect_task') {
          return _perfectTasks >= 1;
        } else if (badge.id == 'accuracy_90') {
          return _perfectTasks >= 10; // Simplified for demo
        }
        return false;

      case BadgeType.speed:
        if (badge.id == 'speed_demon') {
          return _fastAnswers >= 10;
        }
        return false;

      case BadgeType.topic:
        final topicCount = _topicCounts[badge.topic] ?? 0;
        return topicCount >= (badge.requiredValue ?? 0);

      case BadgeType.special:
        switch (badge.id) {
          case 'first_task':
            return _questionsAnswered >= 10; // Completed first task
          case 'placement_test':
            return true; // Assume completed during onboarding
          case 'weekend_warrior':
            return _weekendDays >= 2; // Both weekend days
          default:
            return false;
        }
    }
  }

  void unlockBadge(String badgeId) {
    final matchingBadges = state.availableBadges.where((b) => b.id == badgeId);
    final badge = matchingBadges.isNotEmpty ? matchingBadges.first : null;

    if (badge != null && !state.earnedBadges.any((b) => b.id == badgeId)) {
      final earnedBadge = badge.copyWith(unlockedAt: DateTime.now());
      final updatedEarnedBadges = [...state.earnedBadges, earnedBadge];
      state = state.copyWith(earnedBadges: updatedEarnedBadges);
    }
  }

  List<Badge> getBadgesByType(BadgeType type) {
    return state.availableBadges.where((badge) => badge.type == type).toList();
  }

  List<Badge> getBadgesByRarity(BadgeRarity rarity) {
    return state.earnedBadges.where((badge) => badge.rarity == rarity).toList();
  }
}

final userProgressProvider = StateNotifierProvider<UserProgressNotifier, UserProgressState>((ref) {
  return UserProgressNotifier();
});