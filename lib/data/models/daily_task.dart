import 'question.dart';

enum TaskStatus {
  pending,
  inProgress,
  completed,
}

class DailyTask {
  final String id;
  final DateTime date;
  final List<Question> questions;
  final Question? specialProblem;
  final TaskStatus status;
  final List<QuestionResult> results;
  final int totalXP;
  final DateTime? completedAt;

  const DailyTask({
    required this.id,
    required this.date,
    required this.questions,
    this.specialProblem,
    required this.status,
    required this.results,
    required this.totalXP,
    this.completedAt,
  });

  DailyTask copyWith({
    String? id,
    DateTime? date,
    List<Question>? questions,
    Question? specialProblem,
    TaskStatus? status,
    List<QuestionResult>? results,
    int? totalXP,
    DateTime? completedAt,
  }) {
    return DailyTask(
      id: id ?? this.id,
      date: date ?? this.date,
      questions: questions ?? this.questions,
      specialProblem: specialProblem ?? this.specialProblem,
      status: status ?? this.status,
      results: results ?? this.results,
      totalXP: totalXP ?? this.totalXP,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'status': status.index,
      'totalXP': totalXP,
      'completedAt': completedAt?.millisecondsSinceEpoch,
    };
  }

  factory DailyTask.fromMap(Map<String, dynamic> map) {
    return DailyTask(
      id: map['id'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      questions: [], // Will be loaded separately
      status: TaskStatus.values[map['status'] ?? 0],
      results: [], // Will be loaded separately
      totalXP: map['totalXP']?.toInt() ?? 0,
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'])
          : null,
    );
  }

  double get completionPercentage {
    if (questions.isEmpty) return 0.0;
    return results.length / questions.length;
  }

  int get correctAnswers {
    return results.where((r) => r.isCorrect).length;
  }

  double get accuracy {
    if (results.isEmpty) return 0.0;
    return correctAnswers / results.length;
  }

  bool get isCompleted => status == TaskStatus.completed;
}