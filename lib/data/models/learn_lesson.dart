import 'question.dart';

enum MathTopic {
  addition,
  subtraction,
  multiplication,
  division,
  fractions,
  decimals,
  geometry,
  algebra,
}

enum LessonType {
  concept,
  workedExample,
  practice,
}

class LessonStep {
  final String explanation;
  final String? formula;
  final List<String> examples;
  final String? visualAid; // Could be an asset path or description

  const LessonStep({
    required this.explanation,
    this.formula,
    required this.examples,
    this.visualAid,
  });
}

class WorkedExample {
  final String problem;
  final List<LessonStep> steps;
  final String finalAnswer;
  final String hint;

  const WorkedExample({
    required this.problem,
    required this.steps,
    required this.finalAnswer,
    required this.hint,
  });
}

class LearnLesson {
  final String id;
  final String title;
  final String description;
  final MathTopic topic;
  final int difficultyLevel; // 1-10
  final LessonType type;
  final List<LessonStep> conceptSteps;
  final List<WorkedExample> workedExamples;
  final List<Question> practiceQuestions;
  final bool isCompleted;
  final bool isUnlocked;
  final int estimatedMinutes;

  const LearnLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.topic,
    required this.difficultyLevel,
    required this.type,
    required this.conceptSteps,
    required this.workedExamples,
    required this.practiceQuestions,
    this.isCompleted = false,
    this.isUnlocked = true,
    required this.estimatedMinutes,
  });

  LearnLesson copyWith({
    String? id,
    String? title,
    String? description,
    MathTopic? topic,
    int? difficultyLevel,
    LessonType? type,
    List<LessonStep>? conceptSteps,
    List<WorkedExample>? workedExamples,
    List<Question>? practiceQuestions,
    bool? isCompleted,
    bool? isUnlocked,
    int? estimatedMinutes,
  }) {
    return LearnLesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      topic: topic ?? this.topic,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      type: type ?? this.type,
      conceptSteps: conceptSteps ?? this.conceptSteps,
      workedExamples: workedExamples ?? this.workedExamples,
      practiceQuestions: practiceQuestions ?? this.practiceQuestions,
      isCompleted: isCompleted ?? this.isCompleted,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }
}

class LearningProgress {
  final String lessonId;
  final int currentStepIndex;
  final int currentExampleIndex;
  final bool conceptCompleted;
  final bool examplesCompleted;
  final bool practiceCompleted;
  final DateTime startedAt;
  final DateTime? completedAt;
  final double progressPercentage;

  const LearningProgress({
    required this.lessonId,
    required this.currentStepIndex,
    required this.currentExampleIndex,
    required this.conceptCompleted,
    required this.examplesCompleted,
    required this.practiceCompleted,
    required this.startedAt,
    this.completedAt,
    required this.progressPercentage,
  });

  LearningProgress copyWith({
    String? lessonId,
    int? currentStepIndex,
    int? currentExampleIndex,
    bool? conceptCompleted,
    bool? examplesCompleted,
    bool? practiceCompleted,
    DateTime? startedAt,
    DateTime? completedAt,
    double? progressPercentage,
  }) {
    return LearningProgress(
      lessonId: lessonId ?? this.lessonId,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      currentExampleIndex: currentExampleIndex ?? this.currentExampleIndex,
      conceptCompleted: conceptCompleted ?? this.conceptCompleted,
      examplesCompleted: examplesCompleted ?? this.examplesCompleted,
      practiceCompleted: practiceCompleted ?? this.practiceCompleted,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      progressPercentage: progressPercentage ?? this.progressPercentage,
    );
  }
}