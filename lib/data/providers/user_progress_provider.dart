import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../models/badge.dart';
import '../services/offline_service.dart';
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

  int get currentLevel => profile?.level ?? 1;
  int get xpInCurrentLevel => OfflineService.getXPForCurrentLevel(totalXP, currentLevel);
  int get xpToNextLevel => OfflineService.getXPRequiredForNextLevel(currentLevel);
  double get levelProgress => xpToNextLevel > 0 ? xpInCurrentLevel / xpToNextLevel : 0.0;

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
          availableBadges: [],
          currentStreak: 0,
          longestStreak: 0,
          totalXP: 0,
          isLoading: false,
        ));

  Future<void> loadUserProgress() async {
    state = state.copyWith(isLoading: true);

    try {
      // Load user profile from offline service
      final profile = await OfflineService.getCurrentUser();
      final earnedBadges = await OfflineService.getUserBadges();
      final allBadges = await OfflineService.getAllBadges();

      state = state.copyWith(
        profile: profile,
        earnedBadges: earnedBadges,
        availableBadges: allBadges,
        currentStreak: profile.currentStreak,
        longestStreak: profile.longestStreak,
        totalXP: profile.totalXP,
        lastActiveDate: profile.lastActiveDate,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> addXP(int xp) async {
    try {
      await OfflineService.addXP(xp);

      // Check for newly unlocked badges
      final newBadges = await OfflineService.checkAndUnlockBadges();

      // Reload to get updated data
      await loadUserProgress();

      // TODO: Show badge notification if new badges were unlocked
      if (newBadges.isNotEmpty) {
        // Show notification for new badges
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateStreak() async {
    try {
      final profile = state.profile;
      if (profile == null) return;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastActive = profile.lastActiveDate != null
          ? DateTime(
              profile.lastActiveDate!.year,
              profile.lastActiveDate!.month,
              profile.lastActiveDate!.day,
            )
          : null;

      int newStreak;

      if (lastActive == null) {
        // First time playing
        newStreak = 1;
      } else if (lastActive == today) {
        // Already played today, no change
        return;
      } else if (lastActive == today.subtract(const Duration(days: 1))) {
        // Played yesterday, continue streak
        newStreak = profile.currentStreak + 1;
      } else {
        // Streak broken, reset to 1
        newStreak = 1;
      }

      await OfflineService.updateStreak(newStreak);

      // Check for newly unlocked badges
      await OfflineService.checkAndUnlockBadges();

      // Reload to get updated data
      await loadUserProgress();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> unlockBadge(String badgeId) async {
    try {
      await OfflineService.unlockBadge(badgeId);
      await loadUserProgress();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  List<Badge> getBadgesByType(BadgeType type) {
    return state.availableBadges.where((badge) => badge.type == type).toList();
  }

  List<Badge> getBadgesByRarity(BadgeRarity rarity) {
    return state.earnedBadges.where((badge) => badge.rarity == rarity).toList();
  }

  Future<void> resetProgress() async {
    try {
      state = state.copyWith(isLoading: true);
      await OfflineService.resetAllProgress();
      await loadUserProgress();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Map<String, dynamic>> exportData() async {
    try {
      return await OfflineService.exportUserData();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return {};
    }
  }

  Future<void> importData(Map<String, dynamic> data) async {
    try {
      state = state.copyWith(isLoading: true);
      await OfflineService.importUserData(data);
      await loadUserProgress();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final userProgressProvider = StateNotifierProvider<UserProgressNotifier, UserProgressState>((ref) {
  return UserProgressNotifier();
});