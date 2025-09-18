enum ArcadeGameType {
  fastOperations,
  fractionPuzzle,
  geometryDraw,
  bossChallenge,
}

enum ArcadeGameDifficulty {
  easy,
  medium,
  hard,
  expert,
}

class ArcadeGameResult {
  final ArcadeGameType gameType;
  final ArcadeGameDifficulty difficulty;
  final int score;
  final int maxScore;
  final int timeSpent; // in seconds
  final int correctAnswers;
  final int totalQuestions;
  final int xpEarned;
  final DateTime playedAt;

  const ArcadeGameResult({
    required this.gameType,
    required this.difficulty,
    required this.score,
    required this.maxScore,
    required this.timeSpent,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.xpEarned,
    required this.playedAt,
  });

  double get accuracy => totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;
  double get scorePercentage => maxScore > 0 ? score / maxScore : 0.0;

  Map<String, dynamic> toMap() {
    return {
      'gameType': gameType.index,
      'difficulty': difficulty.index,
      'score': score,
      'maxScore': maxScore,
      'timeSpent': timeSpent,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'xpEarned': xpEarned,
      'playedAt': playedAt.millisecondsSinceEpoch,
    };
  }

  factory ArcadeGameResult.fromMap(Map<String, dynamic> map) {
    return ArcadeGameResult(
      gameType: ArcadeGameType.values[map['gameType'] ?? 0],
      difficulty: ArcadeGameDifficulty.values[map['difficulty'] ?? 0],
      score: map['score']?.toInt() ?? 0,
      maxScore: map['maxScore']?.toInt() ?? 0,
      timeSpent: map['timeSpent']?.toInt() ?? 0,
      correctAnswers: map['correctAnswers']?.toInt() ?? 0,
      totalQuestions: map['totalQuestions']?.toInt() ?? 0,
      xpEarned: map['xpEarned']?.toInt() ?? 0,
      playedAt: DateTime.fromMillisecondsSinceEpoch(map['playedAt'] ?? 0),
    );
  }
}

class FastOperationQuestion {
  final int num1;
  final int num2;
  final String operation;
  final int correctAnswer;
  final List<int> options;

  const FastOperationQuestion({
    required this.num1,
    required this.num2,
    required this.operation,
    required this.correctAnswer,
    required this.options,
  });

  String get questionText => '$num1 $operation $num2 = ?';
}