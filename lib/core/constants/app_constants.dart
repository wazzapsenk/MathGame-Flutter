class AppConstants {
  static const String appName = 'MindMath';
  static const String appVersion = '1.0.0';

  // Limits for free version
  static const int dailyTaskLimit = 3;
  static const int questionsPerTask = 10;
  static const int specialProblemsPerTask = 1;

  // Database
  static const String databaseName = 'mindmath.db';
  static const int databaseVersion = 1;

  // Local Storage Keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyUserLevel = 'user_level';
  static const String keyStreak = 'current_streak';
  static const String keyXP = 'total_xp';
  static const String keyCompletedTasks = 'completed_tasks_today';
  static const String keyLanguage = 'selected_language';
  static const String keyDarkMode = 'dark_mode';
  static const String keyTTSEnabled = 'tts_enabled';
  static const String keyColorBlindMode = 'color_blind_mode';

  // Game Constants
  static const int baseXPPerQuestion = 10;
  static const int streakMultiplier = 2;
  static const int perfectScoreBonus = 50;

  // Difficulty Levels
  static const List<String> difficultyLevels = [
    'beginner',
    'elementary',
    'intermediate',
    'advanced'
  ];

  // Math Topics
  static const List<String> mathTopics = [
    'arithmetic',
    'fractions',
    'geometry',
    'algebra',
    'percentages',
    'ratios',
    'probability',
    'data_analysis'
  ];
}