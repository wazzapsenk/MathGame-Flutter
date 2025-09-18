import '../database/database_helper.dart';
import '../models/user_profile.dart';
import '../models/daily_task.dart';
import '../models/badge.dart';
import '../models/arcade_game.dart';
import '../models/practice_session.dart';
import '../models/question.dart';

class OfflineService {
  static const String _defaultUserId = 'default_user';

  // User Profile methods
  static Future<UserProfile> getCurrentUser() async {
    UserProfile? profile = await DatabaseHelper.getUserProfile(_defaultUserId);

    if (profile == null) {
      // Create default user profile
      profile = UserProfile(
        id: _defaultUserId,
        name: 'Student',
        level: 1,
        totalXP: 0,
        currentStreak: 0,
        longestStreak: 0,
        skillLevel: SkillLevel.beginner,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await DatabaseHelper.insertUserProfile(profile);
    }

    return profile;
  }

  static Future<void> updateUserProfile(UserProfile profile) async {
    final updatedProfile = profile.copyWith(updatedAt: DateTime.now());
    await DatabaseHelper.updateUserProfile(updatedProfile);
  }

  static Future<void> addXP(int xp) async {
    final user = await getCurrentUser();
    final newTotalXP = user.totalXP + xp;
    final newLevel = _calculateLevel(newTotalXP);

    final updatedUser = user.copyWith(
      totalXP: newTotalXP,
      level: newLevel,
      updatedAt: DateTime.now(),
    );

    await updateUserProfile(updatedUser);
  }

  static Future<void> updateStreak(int newStreak) async {
    final user = await getCurrentUser();
    final longestStreak = newStreak > user.longestStreak ? newStreak : user.longestStreak;

    final updatedUser = user.copyWith(
      currentStreak: newStreak,
      longestStreak: longestStreak,
      lastActiveDate: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await updateUserProfile(updatedUser);
  }

  // Daily Tasks methods
  static Future<DailyTask?> getTodayTask() async {
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return await DatabaseHelper.getDailyTask(dateKey);
  }

  static Future<void> saveDailyTask(DailyTask task) async {
    await DatabaseHelper.insertDailyTask(task);
  }

  static Future<List<DailyTask>> getAllDailyTasks() async {
    return await DatabaseHelper.getAllDailyTasks();
  }

  // Badges methods
  static Future<List<Badge>> getAllBadges() async {
    return await DatabaseHelper.getAllBadges();
  }

  static Future<List<Badge>> getUserBadges() async {
    return await DatabaseHelper.getUserBadges(_defaultUserId);
  }

  static Future<void> unlockBadge(String badgeId) async {
    await DatabaseHelper.insertUserBadge(_defaultUserId, badgeId);
  }

  static Future<List<Badge>> checkAndUnlockBadges() async {
    final user = await getCurrentUser();
    final allBadges = await getAllBadges();
    final userBadges = await getUserBadges();
    final userBadgeIds = userBadges.map((b) => b.id).toSet();

    final newlyUnlocked = <Badge>[];

    for (final badge in allBadges) {
      if (userBadgeIds.contains(badge.id)) continue;

      bool shouldUnlock = false;

      switch (badge.type) {
        case BadgeType.xp:
          shouldUnlock = user.totalXP >= (badge.requiredValue ?? 0);
          break;
        case BadgeType.streak:
          shouldUnlock = user.currentStreak >= (badge.requiredValue ?? 0);
          break;
        case BadgeType.special:
          // Handle special badges based on specific conditions
          if (badge.id == 'first_steps') {
            final tasks = await getAllDailyTasks();
            shouldUnlock = tasks.any((task) => task.isCompleted);
          }
          break;
        case BadgeType.accuracy:
        case BadgeType.speed:
        case BadgeType.topic:
          // These require more complex logic based on practice/arcade results
          break;
      }

      if (shouldUnlock) {
        await unlockBadge(badge.id);
        newlyUnlocked.add(badge);
      }
    }

    return newlyUnlocked;
  }

  // Arcade Results methods
  static Future<void> saveArcadeResult(ArcadeGameResult result) async {
    await DatabaseHelper.insertArcadeResult(result, _defaultUserId);

    // Add XP to user
    await addXP(result.xpEarned);

    // Check for new badges
    await checkAndUnlockBadges();
  }

  static Future<List<ArcadeGameResult>> getArcadeResults() async {
    return await DatabaseHelper.getArcadeResults(_defaultUserId);
  }

  // Practice Sessions methods
  static Future<void> savePracticeSession(PracticeSession session) async {
    await DatabaseHelper.insertPracticeSession(session, _defaultUserId);
  }

  static Future<void> updatePracticeSession(PracticeSession session) async {
    await DatabaseHelper.updatePracticeSession(session);
  }

  static Future<void> savePracticeResult(PracticeResult result, String sessionId) async {
    await DatabaseHelper.insertPracticeResult(result, sessionId);
  }

  // Questions cache methods
  static Future<void> cacheQuestion(Question question) async {
    await DatabaseHelper.insertQuestion(question);
  }

  static Future<List<Question>> getCachedQuestions({
    String? topic,
    DifficultyLevel? difficulty,
    int? limit,
  }) async {
    return await DatabaseHelper.getCachedQuestions(
      topic: topic,
      difficulty: difficulty,
      limit: limit,
    );
  }

  // Sync and backup methods
  static Future<Map<String, dynamic>> exportUserData() async {
    final user = await getCurrentUser();
    final dailyTasks = await getAllDailyTasks();
    final userBadges = await getUserBadges();
    final arcadeResults = await getArcadeResults();

    return {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'user': user.toMap(),
      'dailyTasks': dailyTasks.map((task) => task.toMap()).toList(),
      'badges': userBadges.map((badge) => badge.toMap()).toList(),
      'arcadeResults': arcadeResults.map((result) => result.toMap()).toList(),
    };
  }

  static Future<void> importUserData(Map<String, dynamic> data) async {
    // Clear existing data
    await DatabaseHelper.clearAllData();

    // Import user profile
    if (data['user'] != null) {
      final user = UserProfile.fromMap(data['user']);
      await DatabaseHelper.insertUserProfile(user);
    }

    // Import daily tasks
    if (data['dailyTasks'] != null) {
      for (final taskData in data['dailyTasks']) {
        final task = DailyTask.fromMap(taskData);
        await DatabaseHelper.insertDailyTask(task);
      }
    }

    // Import badges
    if (data['badges'] != null) {
      for (final badgeData in data['badges']) {
        final badge = Badge.fromMap(badgeData);
        await DatabaseHelper.insertUserBadge(_defaultUserId, badge.id);
      }
    }

    // Import arcade results
    if (data['arcadeResults'] != null) {
      for (final resultData in data['arcadeResults']) {
        final result = ArcadeGameResult.fromMap(resultData);
        await DatabaseHelper.insertArcadeResult(result, _defaultUserId);
      }
    }
  }

  // Data management
  static Future<void> resetAllProgress() async {
    await DatabaseHelper.clearAllData();
  }

  static Future<Map<String, int>> getDataStats() async {
    final dailyTasks = await getAllDailyTasks();
    final userBadges = await getUserBadges();
    final arcadeResults = await getArcadeResults();

    return {
      'dailyTasksCompleted': dailyTasks.where((task) => task.isCompleted).length,
      'totalBadges': userBadges.length,
      'arcadeGamesPlayed': arcadeResults.length,
    };
  }

  // Utility methods
  static int _calculateLevel(int totalXP) {
    // Level progression: Level 1 = 0 XP, Level 2 = 100 XP, Level 3 = 250 XP, etc.
    if (totalXP < 100) return 1;
    if (totalXP < 250) return 2;
    if (totalXP < 500) return 3;
    if (totalXP < 850) return 4;
    if (totalXP < 1300) return 5;
    if (totalXP < 1850) return 6;
    if (totalXP < 2500) return 7;
    if (totalXP < 3250) return 8;
    if (totalXP < 4100) return 9;
    return 10 + ((totalXP - 4100) ~/ 1000); // Each additional level requires 1000 XP
  }

  static int getXPRequiredForLevel(int level) {
    switch (level) {
      case 1: return 0;
      case 2: return 100;
      case 3: return 250;
      case 4: return 500;
      case 5: return 850;
      case 6: return 1300;
      case 7: return 1850;
      case 8: return 2500;
      case 9: return 3250;
      case 10: return 4100;
      default: return 4100 + ((level - 10) * 1000);
    }
  }

  static int getXPForCurrentLevel(int totalXP, int currentLevel) {
    final requiredForCurrentLevel = getXPRequiredForLevel(currentLevel);
    return totalXP - requiredForCurrentLevel;
  }

  static int getXPRequiredForNextLevel(int currentLevel) {
    return getXPRequiredForLevel(currentLevel + 1) - getXPRequiredForLevel(currentLevel);
  }

  // Initialize the service
  static Future<void> initialize() async {
    // Ensure database is initialized
    await DatabaseHelper.database;

    // Create default user if not exists
    await getCurrentUser();
  }
}