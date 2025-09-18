import 'question.dart';

enum PracticeMode {
  endless,
  timed,
  targetScore,
}

enum PracticeTopic {
  arithmetic,
  fractions,
  decimals,
  geometry,
  algebra,
  mixed,
}

class PracticeSession {
  final String id;
  final PracticeMode mode;
  final PracticeTopic topic;
  final DifficultyLevel startDifficulty;
  final DifficultyLevel currentDifficulty;
  final List<Question> questions;
  final List<PracticeResult> results;
  final DateTime startTime;
  final DateTime? endTime;
  final int targetScore;
  final int timeLimit; // in seconds, 0 for endless
  final bool isActive;
  final bool isCompleted;

  const PracticeSession({
    required this.id,
    required this.mode,
    required this.topic,
    required this.startDifficulty,
    required this.currentDifficulty,
    required this.questions,
    required this.results,
    required this.startTime,
    this.endTime,
    this.targetScore = 0,
    this.timeLimit = 0,
    this.isActive = false,
    this.isCompleted = false,
  });

  PracticeSession copyWith({
    String? id,
    PracticeMode? mode,
    PracticeTopic? topic,
    DifficultyLevel? startDifficulty,
    DifficultyLevel? currentDifficulty,
    List<Question>? questions,
    List<PracticeResult>? results,
    DateTime? startTime,
    DateTime? endTime,
    int? targetScore,
    int? timeLimit,
    bool? isActive,
    bool? isCompleted,
  }) {
    return PracticeSession(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      topic: topic ?? this.topic,
      startDifficulty: startDifficulty ?? this.startDifficulty,
      currentDifficulty: currentDifficulty ?? this.currentDifficulty,
      questions: questions ?? this.questions,
      results: results ?? this.results,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      targetScore: targetScore ?? this.targetScore,
      timeLimit: timeLimit ?? this.timeLimit,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Calculate performance metrics
  int get totalQuestions => results.length;
  int get correctAnswers => results.where((r) => r.isCorrect).length;
  double get accuracy => totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;
  int get currentScore => results.fold(0, (sum, result) => sum + result.pointsEarned);

  // Average response time in seconds
  double get averageResponseTime {
    if (results.isEmpty) return 0.0;
    final totalTime = results.fold(0, (sum, result) => sum + result.responseTimeMs);
    return totalTime / results.length / 1000; // Convert to seconds
  }

  // Recent performance (last 5 questions)
  double get recentAccuracy {
    final recent = results.take(5).toList();
    if (recent.isEmpty) return 0.0;
    return recent.where((r) => r.isCorrect).length / recent.length;
  }

  bool get shouldIncreaseDifficulty {
    if (results.length < 3) return false;
    final recent = results.take(3).toList();
    return recent.every((r) => r.isCorrect) &&
           recent.every((r) => r.responseTimeMs < 10000); // Less than 10 seconds
  }

  bool get shouldDecreaseDifficulty {
    if (results.length < 3) return false;
    final recent = results.take(3).toList();
    final incorrectCount = recent.where((r) => !r.isCorrect).length;
    return incorrectCount >= 2; // 2 or more incorrect in last 3
  }
}

class PracticeResult {
  final String questionId;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final int responseTimeMs;
  final int pointsEarned;
  final DifficultyLevel questionDifficulty;
  final DateTime answeredAt;

  const PracticeResult({
    required this.questionId,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.responseTimeMs,
    required this.pointsEarned,
    required this.questionDifficulty,
    required this.answeredAt,
  });
}

class PracticeSessionSummary {
  final PracticeSession session;
  final int xpEarned;
  final bool newLevelReached;
  final List<String> badgesEarned;

  const PracticeSessionSummary({
    required this.session,
    required this.xpEarned,
    required this.newLevelReached,
    required this.badgesEarned,
  });
}