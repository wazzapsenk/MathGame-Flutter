import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_task.dart';
import '../models/question.dart';
import '../repositories/question_repository.dart';
import '../../core/constants/app_constants.dart';
import 'package:uuid/uuid.dart';

class DailyTasksState {
  final List<DailyTask> tasks;
  final DailyTask? currentTask;
  final bool isLoading;
  final String? error;

  const DailyTasksState({
    required this.tasks,
    this.currentTask,
    required this.isLoading,
    this.error,
  });

  DailyTasksState copyWith({
    List<DailyTask>? tasks,
    DailyTask? currentTask,
    bool? isLoading,
    String? error,
  }) {
    return DailyTasksState(
      tasks: tasks ?? this.tasks,
      currentTask: currentTask ?? this.currentTask,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  DailyTask? get todaysTask {
    final today = DateTime.now();
    final todaysTasks = tasks.where((task) =>
      task.date.year == today.year &&
      task.date.month == today.month &&
      task.date.day == today.day
    );
    return todaysTasks.isNotEmpty ? todaysTasks.first : null;
  }

  int get completedTasksToday {
    final today = DateTime.now();
    return tasks.where((task) =>
      task.date.year == today.year &&
      task.date.month == today.month &&
      task.date.day == today.day &&
      task.isCompleted
    ).length;
  }

  bool get canCreateNewTask => completedTasksToday < AppConstants.dailyTaskLimit;
}

class DailyTasksNotifier extends StateNotifier<DailyTasksState> {
  DailyTasksNotifier() : super(const DailyTasksState(
    tasks: [],
    isLoading: false,
  ));

  final _uuid = const Uuid();

  void loadTasks() {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: Load from local database
      // For now, create today's task if it doesn't exist
      final today = DateTime.now();
      final existingTask = state.todaysTask;

      if (existingTask == null && state.canCreateNewTask) {
        _createTodaysTask();
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void _createTodaysTask() {
    final questions = _generateQuestionsForLevel(DifficultyLevel.elementary);
    final specialProblem = _generateSpecialProblem(DifficultyLevel.elementary);

    final newTask = DailyTask(
      id: _uuid.v4(),
      date: DateTime.now(),
      questions: questions,
      specialProblem: specialProblem,
      status: TaskStatus.pending,
      results: [],
      totalXP: 0,
    );

    final updatedTasks = [...state.tasks, newTask];
    state = state.copyWith(tasks: updatedTasks);
  }

  List<Question> _generateQuestionsForLevel(DifficultyLevel level) {
    // Generate mixed questions based on user level
    final questions = <Question>[];

    for (int i = 0; i < AppConstants.questionsPerTask; i++) {
      questions.add(_generateArithmeticQuestion(level, i));
    }

    return questions;
  }

  Question _generateArithmeticQuestion(DifficultyLevel level, int index) {
    final questionId = _uuid.v4();

    switch (level) {
      case DifficultyLevel.beginner:
        return _generateBeginnerQuestion(questionId, index);
      case DifficultyLevel.elementary:
        return _generateElementaryQuestion(questionId, index);
      case DifficultyLevel.intermediate:
        return _generateIntermediateQuestion(questionId, index);
      case DifficultyLevel.advanced:
        return _generateAdvancedQuestion(questionId, index);
    }
  }

  Question _generateBeginnerQuestion(String id, int index) {
    // Simple addition/subtraction within 20
    final num1 = (index % 2 == 0) ? (5 + index % 10) : (10 + index % 8);
    final num2 = 2 + index % 6;
    final isAddition = index % 2 == 0;

    if (isAddition) {
      final answer = num1 + num2;
      return Question(
        id: id,
        topic: 'arithmetic',
        type: QuestionType.multipleChoice,
        difficulty: DifficultyLevel.beginner,
        question: '$num1 + $num2 = ?',
        options: [
          (answer - 2).toString(),
          (answer - 1).toString(),
          answer.toString(),
          (answer + 1).toString(),
        ]..shuffle(),
        correctAnswer: answer.toString(),
        explanation: 'When we add $num1 and $num2, we get $answer.',
        hints: ['Try counting on your fingers', 'Start with $num1, then count $num2 more'],
      );
    } else {
      final answer = num1 - num2;
      return Question(
        id: id,
        topic: 'arithmetic',
        type: QuestionType.multipleChoice,
        difficulty: DifficultyLevel.beginner,
        question: '$num1 - $num2 = ?',
        options: [
          (answer - 1).toString(),
          answer.toString(),
          (answer + 1).toString(),
          (answer + 2).toString(),
        ]..shuffle(),
        correctAnswer: answer.toString(),
        explanation: 'When we subtract $num2 from $num1, we get $answer.',
        hints: ['Start with $num1 and count backwards $num2 times'],
      );
    }
  }

  Question _generateElementaryQuestion(String id, int index) {
    final operations = ['addition', 'subtraction', 'multiplication', 'division'];
    final operation = operations[index % operations.length];

    switch (operation) {
      case 'multiplication':
        final num1 = 2 + index % 8;
        final num2 = 2 + index % 6;
        final answer = num1 * num2;
        return Question(
          id: id,
          topic: 'arithmetic',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyLevel.elementary,
          question: '$num1 × $num2 = ?',
          options: [
            (answer - 4).toString(),
            (answer + 2).toString(),
            answer.toString(),
            (answer + 4).toString(),
          ]..shuffle(),
          correctAnswer: answer.toString(),
          explanation: '$num1 × $num2 = $answer. You can think of it as adding $num1 a total of $num2 times.',
          hints: ['Try adding $num1 a total of $num2 times', 'Use the multiplication table'],
        );
      case 'division':
        final answer = 2 + index % 8;
        final num2 = 2 + index % 6;
        final num1 = answer * num2;
        return Question(
          id: id,
          topic: 'arithmetic',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyLevel.elementary,
          question: '$num1 ÷ $num2 = ?',
          options: [
            (answer - 1).toString(),
            answer.toString(),
            (answer + 1).toString(),
            (answer + 2).toString(),
          ]..shuffle(),
          correctAnswer: answer.toString(),
          explanation: '$num1 ÷ $num2 = $answer. How many groups of $num2 can you make from $num1?',
          hints: ['How many ${num2}s make $num1?', 'Think about the multiplication table'],
        );
      default:
        return _generateBeginnerQuestion(id, index);
    }
  }

  Question _generateIntermediateQuestion(String id, int index) {
    final topics = ['fractions', 'percentages', 'geometry'];
    final topic = topics[index % topics.length];

    switch (topic) {
      case 'fractions':
        return Question(
          id: id,
          topic: 'fractions',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyLevel.intermediate,
          question: 'What is 1/3 + 1/6?',
          options: ['1/2', '2/9', '1/9', '2/6'],
          correctAnswer: '1/2',
          explanation: '1/3 = 2/6, so 2/6 + 1/6 = 3/6 = 1/2',
          hints: ['Convert to the same denominator first', 'Find a common denominator'],
        );
      case 'percentages':
        final number = 20 + (index * 10);
        final percentage = 25;
        final answer = (number * percentage / 100).round();
        return Question(
          id: id,
          topic: 'percentages',
          type: QuestionType.multipleChoice,
          difficulty: DifficultyLevel.intermediate,
          question: 'What is $percentage% of $number?',
          options: [
            (answer - 5).toString(),
            answer.toString(),
            (answer + 5).toString(),
            (answer + 10).toString(),
          ]..shuffle(),
          correctAnswer: answer.toString(),
          explanation: '$percentage% = 1/4, so $percentage% of $number = $number ÷ 4 = $answer',
          hints: ['$percentage% is the same as 1/4', 'Find one quarter of $number'],
        );
      default:
        return _generateElementaryQuestion(id, index);
    }
  }

  Question _generateAdvancedQuestion(String id, int index) {
    return Question(
      id: id,
      topic: 'algebra',
      type: QuestionType.multipleChoice,
      difficulty: DifficultyLevel.advanced,
      question: 'If 2x + 4 = 12, what is x?',
      options: ['2', '4', '6', '8'],
      correctAnswer: '4',
      explanation: '2x + 4 = 12, so 2x = 8, therefore x = 4',
      hints: ['Subtract 4 from both sides first', 'Then divide by 2'],
    );
  }

  Question _generateSpecialProblem(DifficultyLevel level) {
    return Question(
      id: _uuid.v4(),
      topic: 'special',
      type: QuestionType.multipleChoice,
      difficulty: level,
      question: 'Challenge: A train travels 60 km in 1 hour. How far will it travel in 3 hours?',
      options: ['120 km', '150 km', '180 km', '200 km'],
      correctAnswer: '180 km',
      explanation: 'If the train travels 60 km per hour, in 3 hours it will travel 60 × 3 = 180 km.',
      hints: ['Multiply the distance per hour by the number of hours', 'Speed × Time = Distance'],
    );
  }

  void startTask(String taskId) {
    final taskIndex = state.tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      final task = state.tasks[taskIndex];
      final updatedTask = task.copyWith(status: TaskStatus.inProgress);
      final updatedTasks = [...state.tasks];
      updatedTasks[taskIndex] = updatedTask;

      state = state.copyWith(
        tasks: updatedTasks,
        currentTask: updatedTask,
      );
    }
  }

  void submitAnswer(String questionId, String answer, int timeSpent, int hintsUsed) {
    if (state.currentTask == null) return;

    Question? question;
    final matchingQuestions = state.currentTask!.questions.where((q) => q.id == questionId);
    if (matchingQuestions.isNotEmpty) {
      question = matchingQuestions.first;
    } else if (state.currentTask!.specialProblem?.id == questionId) {
      question = state.currentTask!.specialProblem;
    }

    if (question == null) return;

    final isCorrect = answer == question.correctAnswer;
    final result = QuestionResult(
      questionId: questionId,
      userAnswer: answer,
      isCorrect: isCorrect,
      timeSpent: timeSpent,
      hintsUsed: hintsUsed,
      answeredAt: DateTime.now(),
    );

    final updatedResults = [...state.currentTask!.results, result];
    int xpEarned = 0;

    if (isCorrect) {
      xpEarned = AppConstants.baseXPPerQuestion;
      if (hintsUsed == 0) xpEarned += 5; // Bonus for no hints
      if (timeSpent < 30) xpEarned += 5; // Bonus for quick answer
    }

    final updatedTask = state.currentTask!.copyWith(
      results: updatedResults,
      totalXP: state.currentTask!.totalXP + xpEarned,
    );

    // Check if task is complete
    final totalQuestions = state.currentTask!.questions.length +
        (state.currentTask!.specialProblem != null ? 1 : 0);

    if (updatedResults.length >= totalQuestions) {
      final completedTask = updatedTask.copyWith(
        status: TaskStatus.completed,
        completedAt: DateTime.now(),
      );
      _updateTask(completedTask);
    } else {
      _updateTask(updatedTask);
    }
  }

  void _updateTask(DailyTask updatedTask) {
    final taskIndex = state.tasks.indexWhere((task) => task.id == updatedTask.id);
    if (taskIndex != -1) {
      final updatedTasks = [...state.tasks];
      updatedTasks[taskIndex] = updatedTask;

      state = state.copyWith(
        tasks: updatedTasks,
        currentTask: updatedTask,
      );
    }
  }

  void clearCurrentTask() {
    state = state.copyWith(currentTask: null);
  }
}

final dailyTasksProvider = StateNotifierProvider<DailyTasksNotifier, DailyTasksState>((ref) {
  return DailyTasksNotifier();
});