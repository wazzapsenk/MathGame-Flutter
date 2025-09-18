import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/learn_lesson.dart';
import '../models/question.dart';
import '../repositories/question_repository.dart';

class LearnState {
  final List<LearnLesson> lessons;
  final LearnLesson? currentLesson;
  final LearningProgress? currentProgress;
  final bool isLoading;

  const LearnState({
    required this.lessons,
    this.currentLesson,
    this.currentProgress,
    this.isLoading = false,
  });

  LearnState copyWith({
    List<LearnLesson>? lessons,
    LearnLesson? currentLesson,
    LearningProgress? currentProgress,
    bool? isLoading,
  }) {
    return LearnState(
      lessons: lessons ?? this.lessons,
      currentLesson: currentLesson ?? this.currentLesson,
      currentProgress: currentProgress ?? this.currentProgress,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<LearnLesson> getLessonsByTopic(MathTopic topic) {
    return lessons.where((lesson) => lesson.topic == topic).toList();
  }

  List<LearnLesson> get unlockedLessons {
    return lessons.where((lesson) => lesson.isUnlocked).toList();
  }

  double get overallProgress {
    if (lessons.isEmpty) return 0.0;
    final completedLessons = lessons.where((lesson) => lesson.isCompleted).length;
    return completedLessons / lessons.length;
  }
}

class LearnNotifier extends StateNotifier<LearnState> {
  LearnNotifier() : super(const LearnState(lessons: [])) {
    _initializeLessons();
  }

  final Map<String, LearningProgress> _progressMap = {};

  void _initializeLessons() {
    state = state.copyWith(isLoading: true);

    final lessons = _generateSampleLessons();

    state = state.copyWith(
      lessons: lessons,
      isLoading: false,
    );
  }

  void startLesson(String lessonId) {
    final lesson = state.lessons.firstWhere((l) => l.id == lessonId);
    final progress = LearningProgress(
      lessonId: lessonId,
      currentStepIndex: 0,
      currentExampleIndex: 0,
      conceptCompleted: false,
      examplesCompleted: false,
      practiceCompleted: false,
      startedAt: DateTime.now(),
      progressPercentage: 0.0,
    );

    _progressMap[lessonId] = progress;

    state = state.copyWith(
      currentLesson: lesson,
      currentProgress: progress,
    );
  }

  void nextStep() {
    if (state.currentProgress == null || state.currentLesson == null) return;

    final progress = state.currentProgress!;
    final lesson = state.currentLesson!;

    if (!progress.conceptCompleted) {
      if (progress.currentStepIndex < lesson.conceptSteps.length - 1) {
        _updateProgress(progress.copyWith(
          currentStepIndex: progress.currentStepIndex + 1,
          progressPercentage: ((progress.currentStepIndex + 1) / lesson.conceptSteps.length) * 0.4,
        ));
      } else {
        _updateProgress(progress.copyWith(
          conceptCompleted: true,
          progressPercentage: 0.4,
        ));
      }
    } else if (!progress.examplesCompleted) {
      if (progress.currentExampleIndex < lesson.workedExamples.length - 1) {
        _updateProgress(progress.copyWith(
          currentExampleIndex: progress.currentExampleIndex + 1,
          progressPercentage: 0.4 + ((progress.currentExampleIndex + 1) / lesson.workedExamples.length) * 0.4,
        ));
      } else {
        _updateProgress(progress.copyWith(
          examplesCompleted: true,
          progressPercentage: 0.8,
        ));
      }
    }
  }

  void previousStep() {
    if (state.currentProgress == null) return;

    final progress = state.currentProgress!;

    if (progress.examplesCompleted && !progress.practiceCompleted) {
      _updateProgress(progress.copyWith(
        examplesCompleted: false,
        currentExampleIndex: state.currentLesson!.workedExamples.length - 1,
        progressPercentage: 0.4 + ((progress.currentExampleIndex) / state.currentLesson!.workedExamples.length) * 0.4,
      ));
    } else if (!progress.examplesCompleted && progress.conceptCompleted) {
      if (progress.currentExampleIndex > 0) {
        _updateProgress(progress.copyWith(
          currentExampleIndex: progress.currentExampleIndex - 1,
          progressPercentage: 0.4 + ((progress.currentExampleIndex - 1) / state.currentLesson!.workedExamples.length) * 0.4,
        ));
      } else {
        _updateProgress(progress.copyWith(
          conceptCompleted: false,
          currentStepIndex: state.currentLesson!.conceptSteps.length - 1,
          progressPercentage: ((progress.currentStepIndex) / state.currentLesson!.conceptSteps.length) * 0.4,
        ));
      }
    } else if (!progress.conceptCompleted) {
      if (progress.currentStepIndex > 0) {
        _updateProgress(progress.copyWith(
          currentStepIndex: progress.currentStepIndex - 1,
          progressPercentage: ((progress.currentStepIndex - 1) / state.currentLesson!.conceptSteps.length) * 0.4,
        ));
      }
    }
  }

  void completePractice() {
    if (state.currentProgress == null) return;

    final progress = state.currentProgress!.copyWith(
      practiceCompleted: true,
      progressPercentage: 1.0,
      completedAt: DateTime.now(),
    );

    _updateProgress(progress);
    _markLessonCompleted(progress.lessonId);
  }

  void _updateProgress(LearningProgress progress) {
    _progressMap[progress.lessonId] = progress;
    state = state.copyWith(currentProgress: progress);
  }

  void _markLessonCompleted(String lessonId) {
    final updatedLessons = state.lessons.map((lesson) {
      if (lesson.id == lessonId) {
        return lesson.copyWith(isCompleted: true);
      }
      return lesson;
    }).toList();

    state = state.copyWith(lessons: updatedLessons);
  }

  void exitLesson() {
    state = state.copyWith(
      currentLesson: null,
      currentProgress: null,
    );
  }

  List<LearnLesson> _generateSampleLessons() {
    return [
      LearnLesson(
        id: 'add_basics',
        title: 'Addition Basics',
        description: 'Learn the fundamentals of addition with single digits',
        topic: MathTopic.addition,
        difficultyLevel: 1,
        type: LessonType.concept,
        estimatedMinutes: 15,
        conceptSteps: [
          const LessonStep(
            explanation: 'Addition means combining two or more numbers to get a total.',
            examples: ['2 + 3 = 5', '1 + 4 = 5'],
            visualAid: 'Use your fingers or count objects',
          ),
          const LessonStep(
            explanation: 'When we add, we start with the first number and count up by the second number.',
            examples: ['5 + 2: Start at 5, count up 2 more: 6, 7. Answer: 7'],
          ),
          const LessonStep(
            explanation: 'The order doesn\'t matter in addition: 3 + 4 = 4 + 3',
            examples: ['3 + 4 = 7', '4 + 3 = 7'],
          ),
        ],
        workedExamples: [
          WorkedExample(
            problem: '6 + 3 = ?',
            steps: [
              const LessonStep(
                explanation: 'Start with the larger number: 6',
                examples: ['We begin counting from 6'],
              ),
              const LessonStep(
                explanation: 'Count up by 3: 6 + 1 = 7, 7 + 1 = 8, 8 + 1 = 9',
                examples: ['6 → 7 → 8 → 9'],
              ),
            ],
            finalAnswer: '9',
            hint: 'Try using your fingers to count up from 6',
          ),
          WorkedExample(
            problem: '7 + 2 = ?',
            steps: [
              const LessonStep(
                explanation: 'Start with 7',
                examples: ['Begin at 7'],
              ),
              const LessonStep(
                explanation: 'Add 2: 7 + 1 = 8, 8 + 1 = 9',
                examples: ['7 → 8 → 9'],
              ),
            ],
            finalAnswer: '9',
            hint: 'Count up from the bigger number',
          ),
        ],
        practiceQuestions: _generateAdditionQuestions(5),
      ),
      LearnLesson(
        id: 'sub_basics',
        title: 'Subtraction Basics',
        description: 'Learn how to subtract small numbers',
        topic: MathTopic.subtraction,
        difficultyLevel: 1,
        type: LessonType.concept,
        estimatedMinutes: 15,
        conceptSteps: [
          const LessonStep(
            explanation: 'Subtraction means taking away one number from another.',
            examples: ['5 - 2 = 3', '8 - 3 = 5'],
            visualAid: 'Cross out objects or count backwards',
          ),
          const LessonStep(
            explanation: 'When we subtract, we start with the first number and count backwards.',
            examples: ['7 - 2: Start at 7, count back 2: 6, 5. Answer: 5'],
          ),
        ],
        workedExamples: [
          WorkedExample(
            problem: '8 - 3 = ?',
            steps: [
              const LessonStep(
                explanation: 'Start with 8',
                examples: ['Begin at 8'],
              ),
              const LessonStep(
                explanation: 'Count back 3: 8 - 1 = 7, 7 - 1 = 6, 6 - 1 = 5',
                examples: ['8 → 7 → 6 → 5'],
              ),
            ],
            finalAnswer: '5',
            hint: 'Count backwards from 8',
          ),
        ],
        practiceQuestions: _generateSubtractionQuestions(5),
      ),
      LearnLesson(
        id: 'mult_basics',
        title: 'Multiplication Basics',
        description: 'Introduction to multiplication as repeated addition',
        topic: MathTopic.multiplication,
        difficultyLevel: 2,
        type: LessonType.concept,
        estimatedMinutes: 20,
        conceptSteps: [
          const LessonStep(
            explanation: 'Multiplication is repeated addition of the same number.',
            examples: ['3 × 4 = 3 + 3 + 3 + 3 = 12', '2 × 5 = 2 + 2 + 2 + 2 + 2 = 10'],
          ),
          const LessonStep(
            explanation: 'The first number tells us what to add, the second tells us how many times.',
            examples: ['4 × 3 means "add 4 three times"', '4 + 4 + 4 = 12'],
          ),
        ],
        workedExamples: [
          WorkedExample(
            problem: '5 × 3 = ?',
            steps: [
              const LessonStep(
                explanation: 'This means "5 added 3 times"',
                examples: ['5 + 5 + 5'],
              ),
              const LessonStep(
                explanation: 'Add step by step: 5 + 5 = 10, then 10 + 5 = 15',
                examples: ['5 + 5 = 10', '10 + 5 = 15'],
              ),
            ],
            finalAnswer: '15',
            hint: 'Add 5 three times',
          ),
        ],
        practiceQuestions: _generateMultiplicationQuestions(5),
      ),
    ];
  }

  static List<Question> _generateAdditionQuestions(int count) {
    final questions = <Question>[];
    for (int i = 0; i < count; i++) {
      final num1 = (i % 5) + 1;
      final num2 = ((i + 2) % 5) + 1;
      final correctAnswer = num1 + num2;

      questions.add(Question(
        id: 'add_practice_$i',
        question: '$num1 + $num2 = ?',
        options: [
          (correctAnswer - 1).toString(),
          correctAnswer.toString(),
          (correctAnswer + 1).toString(),
          (correctAnswer + 2).toString(),
        ]..shuffle(),
        correctAnswer: correctAnswer.toString(),
        difficulty: DifficultyLevel.beginner,
        topic: 'arithmetic',
        type: QuestionType.multipleChoice,
        explanation: 'Start with $num1 and count up $num2 more.',
        hints: ['Try counting on your fingers', 'Start with the bigger number'],
      ));
    }
    return questions;
  }

  static List<Question> _generateSubtractionQuestions(int count) {
    final questions = <Question>[];
    for (int i = 0; i < count; i++) {
      final num1 = (i % 5) + 5; // Ensure positive result
      final num2 = (i % 3) + 1;
      final correctAnswer = num1 - num2;

      questions.add(Question(
        id: 'sub_practice_$i',
        question: '$num1 - $num2 = ?',
        options: [
          (correctAnswer - 1).toString(),
          correctAnswer.toString(),
          (correctAnswer + 1).toString(),
          (correctAnswer + 2).toString(),
        ]..shuffle(),
        correctAnswer: correctAnswer.toString(),
        difficulty: DifficultyLevel.beginner,
        topic: 'arithmetic',
        type: QuestionType.multipleChoice,
        explanation: 'Start with $num1 and count back $num2.',
        hints: ['Count backwards', 'Use your fingers to help'],
      ));
    }
    return questions;
  }

  static List<Question> _generateMultiplicationQuestions(int count) {
    final questions = <Question>[];
    for (int i = 0; i < count; i++) {
      final num1 = (i % 4) + 2;
      final num2 = (i % 3) + 2;
      final correctAnswer = num1 * num2;

      questions.add(Question(
        id: 'mult_practice_$i',
        question: '$num1 × $num2 = ?',
        options: [
          (correctAnswer - 2).toString(),
          correctAnswer.toString(),
          (correctAnswer + 2).toString(),
          (correctAnswer + 4).toString(),
        ]..shuffle(),
        correctAnswer: correctAnswer.toString(),
        difficulty: DifficultyLevel.intermediate,
        topic: 'arithmetic',
        type: QuestionType.multipleChoice,
        explanation: 'Add $num1 a total of $num2 times: ${List.generate(num2, (index) => num1.toString()).join(' + ')} = $correctAnswer',
        hints: ['Think of it as repeated addition', 'Draw groups to visualize'],
      ));
    }
    return questions;
  }
}

final learnProvider = StateNotifierProvider<LearnNotifier, LearnState>((ref) {
  return LearnNotifier();
});