enum SkillLevel {
  beginner,
  elementary,
  intermediate,
  advanced,
}

class UserProfile {
  final String id;
  final String name;
  final int level;
  final int totalXP;
  final int currentStreak;
  final int longestStreak;
  final SkillLevel skillLevel;
  final DateTime? lastActiveDate;
  final Map<String, dynamic>? preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.level,
    required this.totalXP,
    required this.currentStreak,
    required this.longestStreak,
    required this.skillLevel,
    this.lastActiveDate,
    this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    int? level,
    int? totalXP,
    int? currentStreak,
    int? longestStreak,
    SkillLevel? skillLevel,
    DateTime? lastActiveDate,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      totalXP: totalXP ?? this.totalXP,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      skillLevel: skillLevel ?? this.skillLevel,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
      'skillLevel': skillLevel.index,
      'lastActiveDate': lastActiveDate?.millisecondsSinceEpoch,
      'preferences': preferences?.toString(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
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
      skillLevel: SkillLevel.values[map['skillLevel'] ?? 0],
      lastActiveDate: map['lastActiveDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastActiveDate'])
          : null,
      preferences: map['preferences'] != null ? {} : null, // TODO: Parse JSON if needed
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
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