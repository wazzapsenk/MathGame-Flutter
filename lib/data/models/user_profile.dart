class UserProfile {
  final String id;
  final String name;
  final int level;
  final int totalXP;
  final int currentStreak;
  final int longestStreak;
  final String difficulty;
  final List<String> unlockedTopics;
  final List<String> completedTopics;
  final DateTime createdAt;
  final DateTime lastActiveAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.level,
    required this.totalXP,
    required this.currentStreak,
    required this.longestStreak,
    required this.difficulty,
    required this.unlockedTopics,
    required this.completedTopics,
    required this.createdAt,
    required this.lastActiveAt,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    int? level,
    int? totalXP,
    int? currentStreak,
    int? longestStreak,
    String? difficulty,
    List<String>? unlockedTopics,
    List<String>? completedTopics,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      totalXP: totalXP ?? this.totalXP,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      difficulty: difficulty ?? this.difficulty,
      unlockedTopics: unlockedTopics ?? this.unlockedTopics,
      completedTopics: completedTopics ?? this.completedTopics,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'totalXP': totalXP,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'difficulty': difficulty,
      'unlockedTopics': unlockedTopics.join(','),
      'completedTopics': completedTopics.join(','),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastActiveAt': lastActiveAt.millisecondsSinceEpoch,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      level: map['level']?.toInt() ?? 1,
      totalXP: map['totalXP']?.toInt() ?? 0,
      currentStreak: map['currentStreak']?.toInt() ?? 0,
      longestStreak: map['longestStreak']?.toInt() ?? 0,
      difficulty: map['difficulty'] ?? 'beginner',
      unlockedTopics: map['unlockedTopics']?.split(',') ?? [],
      completedTopics: map['completedTopics']?.split(',') ?? [],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      lastActiveAt: DateTime.fromMillisecondsSinceEpoch(map['lastActiveAt'] ?? 0),
    );
  }

  int get xpToNextLevel {
    return (level * 1000) - (totalXP % 1000);
  }

  double get levelProgress {
    final currentLevelXP = totalXP % 1000;
    return currentLevelXP / 1000.0;
  }
}