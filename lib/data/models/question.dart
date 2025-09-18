enum QuestionType {
  multipleChoice,
  fillInBlank,
  trueFalse,
  dragAndDrop,
  drawing,
}

enum DifficultyLevel {
  beginner,
  elementary,
  intermediate,
  advanced,
}

class Question {
  final String id;
  final String topic;
  final QuestionType type;
  final DifficultyLevel difficulty;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final List<String> hints;
  final Map<String, dynamic>? metadata;

  const Question({
    required this.id,
    required this.topic,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.hints,
    this.metadata,
  });

  Question copyWith({
    String? id,
    String? topic,
    QuestionType? type,
    DifficultyLevel? difficulty,
    String? question,
    List<String>? options,
    String? correctAnswer,
    String? explanation,
    List<String>? hints,
    Map<String, dynamic>? metadata,
  }) {
    return Question(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      hints: hints ?? this.hints,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic': topic,
      'type': type.index,
      'difficulty': difficulty.index,
      'question': question,
      'options': options.join('|'),
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'hints': hints.join('|'),
      'metadata': metadata != null ? metadata.toString() : null,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? '',
      topic: map['topic'] ?? '',
      type: QuestionType.values[map['type'] ?? 0],
      difficulty: DifficultyLevel.values[map['difficulty'] ?? 0],
      question: map['question'] ?? '',
      options: map['options']?.split('|') ?? [],
      correctAnswer: map['correctAnswer'] ?? '',
      explanation: map['explanation'] ?? '',
      hints: map['hints']?.split('|') ?? [],
      metadata: map['metadata'],
    );
  }
}

class QuestionResult {
  final String questionId;
  final String userAnswer;
  final bool isCorrect;
  final int timeSpent; // in seconds
  final int hintsUsed;
  final DateTime answeredAt;

  const QuestionResult({
    required this.questionId,
    required this.userAnswer,
    required this.isCorrect,
    required this.timeSpent,
    required this.hintsUsed,
    required this.answeredAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'userAnswer': userAnswer,
      'isCorrect': isCorrect ? 1 : 0,
      'timeSpent': timeSpent,
      'hintsUsed': hintsUsed,
      'answeredAt': answeredAt.millisecondsSinceEpoch,
    };
  }

  factory QuestionResult.fromMap(Map<String, dynamic> map) {
    return QuestionResult(
      questionId: map['questionId'] ?? '',
      userAnswer: map['userAnswer'] ?? '',
      isCorrect: (map['isCorrect'] ?? 0) == 1,
      timeSpent: map['timeSpent']?.toInt() ?? 0,
      hintsUsed: map['hintsUsed']?.toInt() ?? 0,
      answeredAt: DateTime.fromMillisecondsSinceEpoch(map['answeredAt'] ?? 0),
    );
  }
}