enum BadgeType {
  streak,
  xp,
  accuracy,
  speed,
  topic,
  special,
}

enum BadgeRarity {
  common,
  rare,
  epic,
  legendary,
}

class Badge {
  final String id;
  final String name;
  final String description;
  final BadgeType type;
  final BadgeRarity rarity;
  final String iconName;
  final int? requiredValue;
  final String? topic;
  final DateTime? unlockedAt;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rarity,
    required this.iconName,
    this.requiredValue,
    this.topic,
    this.unlockedAt,
  });

  Badge copyWith({
    String? id,
    String? name,
    String? description,
    BadgeType? type,
    BadgeRarity? rarity,
    String? iconName,
    int? requiredValue,
    String? topic,
    DateTime? unlockedAt,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      iconName: iconName ?? this.iconName,
      requiredValue: requiredValue ?? this.requiredValue,
      topic: topic ?? this.topic,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  bool get isUnlocked => unlockedAt != null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.index,
      'rarity': rarity.index,
      'iconName': iconName,
      'requiredValue': requiredValue,
      'topic': topic,
      'unlockedAt': unlockedAt?.millisecondsSinceEpoch,
    };
  }

  factory Badge.fromMap(Map<String, dynamic> map) {
    return Badge(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      type: BadgeType.values[map['type'] ?? 0],
      rarity: BadgeRarity.values[map['rarity'] ?? 0],
      iconName: map['iconName'] ?? '',
      requiredValue: map['requiredValue']?.toInt(),
      topic: map['topic'],
      unlockedAt: map['unlockedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['unlockedAt'])
          : null,
    );
  }
}

class BadgeDefinitions {
  static List<Badge> get allBadges => [
    // Streak Badges
    Badge(
      id: 'streak_3',
      name: 'Getting Started',
      description: 'Complete 3 days in a row',
      type: BadgeType.streak,
      rarity: BadgeRarity.common,
      iconName: 'local_fire_department',
      requiredValue: 3,
    ),
    Badge(
      id: 'streak_7',
      name: 'Week Warrior',
      description: 'Complete 7 days in a row',
      type: BadgeType.streak,
      rarity: BadgeRarity.rare,
      iconName: 'local_fire_department',
      requiredValue: 7,
    ),
    Badge(
      id: 'streak_30',
      name: 'Month Master',
      description: 'Complete 30 days in a row',
      type: BadgeType.streak,
      rarity: BadgeRarity.epic,
      iconName: 'local_fire_department',
      requiredValue: 30,
    ),
    Badge(
      id: 'streak_100',
      name: 'Century Club',
      description: 'Complete 100 days in a row',
      type: BadgeType.streak,
      rarity: BadgeRarity.legendary,
      iconName: 'local_fire_department',
      requiredValue: 100,
    ),

    // XP Badges
    Badge(
      id: 'xp_100',
      name: 'Novice Learner',
      description: 'Earn 100 XP',
      type: BadgeType.xp,
      rarity: BadgeRarity.common,
      iconName: 'star',
      requiredValue: 100,
    ),
    Badge(
      id: 'xp_500',
      name: 'Dedicated Student',
      description: 'Earn 500 XP',
      type: BadgeType.xp,
      rarity: BadgeRarity.common,
      iconName: 'star',
      requiredValue: 500,
    ),
    Badge(
      id: 'xp_1000',
      name: 'Scholar',
      description: 'Earn 1,000 XP',
      type: BadgeType.xp,
      rarity: BadgeRarity.rare,
      iconName: 'star',
      requiredValue: 1000,
    ),
    Badge(
      id: 'xp_5000',
      name: 'Math Genius',
      description: 'Earn 5,000 XP',
      type: BadgeType.xp,
      rarity: BadgeRarity.epic,
      iconName: 'star',
      requiredValue: 5000,
    ),
    Badge(
      id: 'xp_10000',
      name: 'Mathematics Master',
      description: 'Earn 10,000 XP',
      type: BadgeType.xp,
      rarity: BadgeRarity.legendary,
      iconName: 'star',
      requiredValue: 10000,
    ),

    // Accuracy Badges
    Badge(
      id: 'perfect_task',
      name: 'Perfectionist',
      description: 'Complete a task with 100% accuracy',
      type: BadgeType.accuracy,
      rarity: BadgeRarity.rare,
      iconName: 'check_circle',
      requiredValue: 100,
    ),
    Badge(
      id: 'accuracy_90',
      name: 'Sharp Shooter',
      description: 'Maintain 90%+ accuracy for 10 tasks',
      type: BadgeType.accuracy,
      rarity: BadgeRarity.epic,
      iconName: 'check_circle',
      requiredValue: 90,
    ),

    // Speed Badges
    Badge(
      id: 'speed_demon',
      name: 'Speed Demon',
      description: 'Answer 10 questions in under 15 seconds each',
      type: BadgeType.speed,
      rarity: BadgeRarity.rare,
      iconName: 'flash_on',
      requiredValue: 15,
    ),

    // Topic Badges
    Badge(
      id: 'arithmetic_master',
      name: 'Arithmetic Master',
      description: 'Complete 50 arithmetic problems',
      type: BadgeType.topic,
      rarity: BadgeRarity.rare,
      iconName: 'calculate',
      topic: 'arithmetic',
      requiredValue: 50,
    ),
    Badge(
      id: 'fraction_hero',
      name: 'Fraction Hero',
      description: 'Complete 25 fraction problems',
      type: BadgeType.topic,
      rarity: BadgeRarity.rare,
      iconName: 'pie_chart',
      topic: 'fractions',
      requiredValue: 25,
    ),
    Badge(
      id: 'geometry_explorer',
      name: 'Geometry Explorer',
      description: 'Complete 25 geometry problems',
      type: BadgeType.topic,
      rarity: BadgeRarity.rare,
      iconName: 'square',
      topic: 'geometry',
      requiredValue: 25,
    ),

    // Special Badges
    Badge(
      id: 'first_task',
      name: 'First Steps',
      description: 'Complete your first daily task',
      type: BadgeType.special,
      rarity: BadgeRarity.common,
      iconName: 'baby_changing_station',
    ),
    Badge(
      id: 'placement_test',
      name: 'Ready to Learn',
      description: 'Complete the placement test',
      type: BadgeType.special,
      rarity: BadgeRarity.common,
      iconName: 'school',
    ),
    Badge(
      id: 'weekend_warrior',
      name: 'Weekend Warrior',
      description: 'Complete tasks on Saturday and Sunday',
      type: BadgeType.special,
      rarity: BadgeRarity.rare,
      iconName: 'weekend',
    ),
  ];
}