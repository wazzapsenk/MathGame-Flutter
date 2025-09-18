import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_profile.dart';
import '../models/question.dart';
import '../models/daily_task.dart';
import '../models/badge.dart';
import '../models/arcade_game.dart';
import '../models/practice_session.dart';
import '../models/learn_lesson.dart';

class DatabaseHelper {
  static const String _databaseName = 'mindmath.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String _userProfileTable = 'user_profiles';
  static const String _questionsTable = 'questions';
  static const String _dailyTasksTable = 'daily_tasks';
  static const String _badgesTable = 'badges';
  static const String _userBadgesTable = 'user_badges';
  static const String _arcadeResultsTable = 'arcade_results';
  static const String _practiceSessionsTable = 'practice_sessions';
  static const String _practiceResultsTable = 'practice_results';
  static const String _learnProgressTable = 'learn_progress';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // User Profile table
    await db.execute('''
      CREATE TABLE $_userProfileTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        level INTEGER NOT NULL,
        totalXP INTEGER NOT NULL,
        currentStreak INTEGER NOT NULL,
        longestStreak INTEGER NOT NULL,
        lastActiveDate TEXT,
        skillLevel TEXT NOT NULL,
        preferences TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Questions table
    await db.execute('''
      CREATE TABLE $_questionsTable (
        id TEXT PRIMARY KEY,
        topic TEXT NOT NULL,
        type INTEGER NOT NULL,
        difficulty INTEGER NOT NULL,
        question TEXT NOT NULL,
        options TEXT NOT NULL,
        correctAnswer TEXT NOT NULL,
        explanation TEXT NOT NULL,
        hints TEXT NOT NULL,
        metadata TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Daily Tasks table
    await db.execute('''
      CREATE TABLE $_dailyTasksTable (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        questions TEXT NOT NULL,
        specialProblem TEXT,
        results TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        xpEarned INTEGER NOT NULL,
        completedAt TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Badges table
    await db.execute('''
      CREATE TABLE $_badgesTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        iconName TEXT NOT NULL,
        rarity INTEGER NOT NULL,
        type INTEGER NOT NULL,
        requiredValue INTEGER,
        isActive INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // User Badges table (many-to-many relationship)
    await db.execute('''
      CREATE TABLE $_userBadgesTable (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        badgeId TEXT NOT NULL,
        unlockedAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES $_userProfileTable (id),
        FOREIGN KEY (badgeId) REFERENCES $_badgesTable (id)
      )
    ''');

    // Arcade Results table
    await db.execute('''
      CREATE TABLE $_arcadeResultsTable (
        id TEXT PRIMARY KEY,
        gameType INTEGER NOT NULL,
        difficulty INTEGER NOT NULL,
        score INTEGER NOT NULL,
        maxScore INTEGER NOT NULL,
        timeSpent INTEGER NOT NULL,
        correctAnswers INTEGER NOT NULL,
        totalQuestions INTEGER NOT NULL,
        xpEarned INTEGER NOT NULL,
        playedAt TEXT NOT NULL,
        userId TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES $_userProfileTable (id)
      )
    ''');

    // Practice Sessions table
    await db.execute('''
      CREATE TABLE $_practiceSessionsTable (
        id TEXT PRIMARY KEY,
        mode INTEGER NOT NULL,
        topic INTEGER NOT NULL,
        startDifficulty INTEGER NOT NULL,
        currentDifficulty INTEGER NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT,
        targetScore INTEGER NOT NULL,
        timeLimit INTEGER NOT NULL,
        isActive INTEGER NOT NULL,
        isCompleted INTEGER NOT NULL,
        userId TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES $_userProfileTable (id)
      )
    ''');

    // Practice Results table
    await db.execute('''
      CREATE TABLE $_practiceResultsTable (
        id TEXT PRIMARY KEY,
        sessionId TEXT NOT NULL,
        questionId TEXT NOT NULL,
        userAnswer TEXT NOT NULL,
        correctAnswer TEXT NOT NULL,
        isCorrect INTEGER NOT NULL,
        responseTimeMs INTEGER NOT NULL,
        pointsEarned INTEGER NOT NULL,
        questionDifficulty INTEGER NOT NULL,
        answeredAt TEXT NOT NULL,
        FOREIGN KEY (sessionId) REFERENCES $_practiceSessionsTable (id)
      )
    ''');

    // Learn Progress table
    await db.execute('''
      CREATE TABLE $_learnProgressTable (
        id TEXT PRIMARY KEY,
        lessonId TEXT NOT NULL,
        currentStepIndex INTEGER NOT NULL,
        currentExampleIndex INTEGER NOT NULL,
        conceptCompleted INTEGER NOT NULL,
        examplesCompleted INTEGER NOT NULL,
        practiceCompleted INTEGER NOT NULL,
        startedAt TEXT NOT NULL,
        completedAt TEXT,
        progressPercentage REAL NOT NULL,
        userId TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES $_userProfileTable (id)
      )
    ''');

    // Insert default badges
    await _insertDefaultBadges(db);
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades
    if (oldVersion < newVersion) {
      // Add migration logic here when needed
    }
  }

  static Future<void> _insertDefaultBadges(Database db) async {
    final defaultBadges = [
      {
        'id': 'first_steps',
        'name': 'First Steps',
        'description': 'Complete your first daily task',
        'iconName': 'baby_changing_station',
        'rarity': BadgeRarity.common.index,
        'type': BadgeType.special.index,
        'requiredValue': 1,
        'isActive': 1,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'streak_3',
        'name': '3-Day Streak',
        'description': 'Complete daily tasks for 3 consecutive days',
        'iconName': 'local_fire_department',
        'rarity': BadgeRarity.common.index,
        'type': BadgeType.streak.index,
        'requiredValue': 3,
        'isActive': 1,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'streak_7',
        'name': 'Week Warrior',
        'description': 'Complete daily tasks for 7 consecutive days',
        'iconName': 'local_fire_department',
        'rarity': BadgeRarity.rare.index,
        'type': BadgeType.streak.index,
        'requiredValue': 7,
        'isActive': 1,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'xp_100',
        'name': 'Century Club',
        'description': 'Earn 100 XP',
        'iconName': 'star',
        'rarity': BadgeRarity.common.index,
        'type': BadgeType.xp.index,
        'requiredValue': 100,
        'isActive': 1,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'accuracy_90',
        'name': 'Sharp Shooter',
        'description': 'Achieve 90% accuracy in practice',
        'iconName': 'check_circle',
        'rarity': BadgeRarity.epic.index,
        'type': BadgeType.accuracy.index,
        'requiredValue': 90,
        'isActive': 1,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'speed_master',
        'name': 'Speed Master',
        'description': 'Answer 10 questions in under 30 seconds',
        'iconName': 'flash_on',
        'rarity': BadgeRarity.legendary.index,
        'type': BadgeType.speed.index,
        'requiredValue': 30,
        'isActive': 1,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ];

    for (final badge in defaultBadges) {
      await db.insert(_badgesTable, badge);
    }
  }

  // User Profile methods
  static Future<void> insertUserProfile(UserProfile profile) async {
    final db = await database;
    await db.insert(
      _userProfileTable,
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<UserProfile?> getUserProfile(String id) async {
    final db = await database;
    final maps = await db.query(
      _userProfileTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserProfile.fromMap(maps.first);
    }
    return null;
  }

  static Future<void> updateUserProfile(UserProfile profile) async {
    final db = await database;
    await db.update(
      _userProfileTable,
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  // Daily Tasks methods
  static Future<void> insertDailyTask(DailyTask task) async {
    final db = await database;
    await db.insert(
      _dailyTasksTable,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<DailyTask?> getDailyTask(String date) async {
    final db = await database;
    final maps = await db.query(
      _dailyTasksTable,
      where: 'date = ?',
      whereArgs: [date],
    );

    if (maps.isNotEmpty) {
      return DailyTask.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<DailyTask>> getAllDailyTasks() async {
    final db = await database;
    final maps = await db.query(
      _dailyTasksTable,
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) => DailyTask.fromMap(maps[i]));
  }

  // Badges methods
  static Future<List<Badge>> getAllBadges() async {
    final db = await database;
    final maps = await db.query(_badgesTable);

    return List.generate(maps.length, (i) => Badge.fromMap(maps[i]));
  }

  static Future<void> insertUserBadge(String userId, String badgeId) async {
    final db = await database;
    await db.insert(
      _userBadgesTable,
      {
        'id': '${userId}_$badgeId',
        'userId': userId,
        'badgeId': badgeId,
        'unlockedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Badge>> getUserBadges(String userId) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT b.* FROM $_badgesTable b
      INNER JOIN $_userBadgesTable ub ON b.id = ub.badgeId
      WHERE ub.userId = ?
      ORDER BY ub.unlockedAt DESC
    ''', [userId]);

    return List.generate(maps.length, (i) => Badge.fromMap(maps[i]));
  }

  // Arcade Results methods
  static Future<void> insertArcadeResult(ArcadeGameResult result, String userId) async {
    final db = await database;
    final map = result.toMap();
    map['userId'] = userId;
    map['id'] = '${userId}_${DateTime.now().millisecondsSinceEpoch}';

    await db.insert(_arcadeResultsTable, map);
  }

  static Future<List<ArcadeGameResult>> getArcadeResults(String userId) async {
    final db = await database;
    final maps = await db.query(
      _arcadeResultsTable,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'playedAt DESC',
      limit: 50,
    );

    return List.generate(maps.length, (i) => ArcadeGameResult.fromMap(maps[i]));
  }

  // Practice Sessions methods
  static Future<void> insertPracticeSession(PracticeSession session, String userId) async {
    final db = await database;
    await db.insert(_practiceSessionsTable, {
      'id': session.id,
      'mode': session.mode.index,
      'topic': session.topic.index,
      'startDifficulty': session.startDifficulty.index,
      'currentDifficulty': session.currentDifficulty.index,
      'startTime': session.startTime.toIso8601String(),
      'endTime': session.endTime?.toIso8601String(),
      'targetScore': session.targetScore,
      'timeLimit': session.timeLimit,
      'isActive': session.isActive ? 1 : 0,
      'isCompleted': session.isCompleted ? 1 : 0,
      'userId': userId,
    });
  }

  static Future<void> updatePracticeSession(PracticeSession session) async {
    final db = await database;
    await db.update(
      _practiceSessionsTable,
      {
        'currentDifficulty': session.currentDifficulty.index,
        'endTime': session.endTime?.toIso8601String(),
        'isActive': session.isActive ? 1 : 0,
        'isCompleted': session.isCompleted ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  static Future<void> insertPracticeResult(PracticeResult result, String sessionId) async {
    final db = await database;
    await db.insert(_practiceResultsTable, {
      'id': '${sessionId}_${DateTime.now().millisecondsSinceEpoch}',
      'sessionId': sessionId,
      'questionId': result.questionId,
      'userAnswer': result.userAnswer,
      'correctAnswer': result.correctAnswer,
      'isCorrect': result.isCorrect ? 1 : 0,
      'responseTimeMs': result.responseTimeMs,
      'pointsEarned': result.pointsEarned,
      'questionDifficulty': result.questionDifficulty.index,
      'answeredAt': result.answeredAt.toIso8601String(),
    });
  }

  // Questions cache methods
  static Future<void> insertQuestion(Question question) async {
    final db = await database;
    await db.insert(
      _questionsTable,
      {
        ...question.toMap(),
        'createdAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Question>> getCachedQuestions({
    String? topic,
    DifficultyLevel? difficulty,
    int? limit,
  }) async {
    final db = await database;
    String where = '';
    List<String> whereArgs = [];

    if (topic != null) {
      where += 'topic = ?';
      whereArgs.add(topic);
    }

    if (difficulty != null) {
      if (where.isNotEmpty) where += ' AND ';
      where += 'difficulty = ?';
      whereArgs.add(difficulty.index.toString());
    }

    final maps = await db.query(
      _questionsTable,
      where: where.isEmpty ? null : where,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'RANDOM()',
      limit: limit,
    );

    return List.generate(maps.length, (i) => Question.fromMap(maps[i]));
  }

  // Utility methods
  static Future<void> clearAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(_userProfileTable);
      await txn.delete(_dailyTasksTable);
      await txn.delete(_userBadgesTable);
      await txn.delete(_arcadeResultsTable);
      await txn.delete(_practiceSessionsTable);
      await txn.delete(_practiceResultsTable);
      await txn.delete(_learnProgressTable);
      await txn.delete(_questionsTable);
    });
  }

  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}