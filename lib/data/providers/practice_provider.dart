import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../models/practice_session.dart';
import '../models/question.dart';
import '../services/offline_service.dart';

class PracticeState {
  final PracticeSession? currentSession;
  final Question? currentQuestion;
  final int timeLeft; // in seconds
  final bool isLoading;
  final List<PracticeSession> recentSessions;

  const PracticeState({
    this.currentSession,
    this.currentQuestion,
    this.timeLeft = 0,
    this.isLoading = false,
    this.recentSessions = const [],
  });

  PracticeState copyWith({
    PracticeSession? currentSession,
    Question? currentQuestion,
    int? timeLeft,
    bool? isLoading,
    List<PracticeSession>? recentSessions,
  }) {
    return PracticeState(
      currentSession: currentSession ?? this.currentSession,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      timeLeft: timeLeft ?? this.timeLeft,
      isLoading: isLoading ?? this.isLoading,
      recentSessions: recentSessions ?? this.recentSessions,
    );
  }
}

class PracticeNotifier extends StateNotifier<PracticeState> {
  PracticeNotifier() : super(const PracticeState());

  final Random _random = Random();
  DateTime? _questionStartTime;

  Future<void> startSession({
    required PracticeMode mode,
    required PracticeTopic topic,
    required DifficultyLevel difficulty,
    int? targetScore,
    int? timeLimit,
  }) async {
    final session = PracticeSession(
      id: 'practice_${DateTime.now().millisecondsSinceEpoch}',
      mode: mode,
      topic: topic,
      startDifficulty: difficulty,
      currentDifficulty: difficulty,
      questions: [],
      results: [],
      startTime: DateTime.now(),
      targetScore: targetScore ?? 0,
      timeLimit: timeLimit ?? 0,
      isActive: true,
    );

    // Save session to offline storage
    await OfflineService.savePracticeSession(session);

    state = state.copyWith(
      currentSession: session,
      timeLeft: timeLimit ?? 0,
      isLoading: true,
    );

    _generateNextQuestion();
  }

  void _generateNextQuestion() {
    if (state.currentSession == null) return;

    final question = _createAdaptiveQuestion(
      state.currentSession!.topic,
      state.currentSession!.currentDifficulty,
    );

    state = state.copyWith(
      currentQuestion: question,
      isLoading: false,
    );
    _questionStartTime = DateTime.now();
  }

  Future<void> answerQuestion(String answer) async {
    if (state.currentSession == null || state.currentQuestion == null || _questionStartTime == null) {
      return;
    }

    final session = state.currentSession!;
    final question = state.currentQuestion!;
    final responseTime = DateTime.now().difference(_questionStartTime!).inMilliseconds;
    final isCorrect = answer == question.correctAnswer;

    final result = PracticeResult(
      questionId: question.id,
      userAnswer: answer,
      correctAnswer: question.correctAnswer,
      isCorrect: isCorrect,
      responseTimeMs: responseTime,
      pointsEarned: isCorrect ? _getPointsForDifficulty(session.currentDifficulty) : 0,
      questionDifficulty: session.currentDifficulty,
      answeredAt: DateTime.now(),
    );

    // Save result to offline storage
    await OfflineService.savePracticeResult(result, session.id);

    final updatedResults = [result, ...session.results];
    final updatedQuestions = [question, ...session.questions];

    // Update session with new result
    var updatedSession = session.copyWith(
      questions: updatedQuestions,
      results: updatedResults,
    );

    // Adaptive difficulty adjustment
    updatedSession = _adjustDifficulty(updatedSession);

    state = state.copyWith(currentSession: updatedSession);

    // Check if session should end
    if (_shouldEndSession(updatedSession)) {
      await _endSession();
    } else {
      _generateNextQuestion();
    }
  }

  PracticeSession _adjustDifficulty(PracticeSession session) {
    DifficultyLevel newDifficulty = session.currentDifficulty;

    if (session.shouldIncreaseDifficulty) {
      // Increase difficulty if performing well
      switch (session.currentDifficulty) {
        case DifficultyLevel.beginner:
          newDifficulty = DifficultyLevel.elementary;
          break;
        case DifficultyLevel.elementary:
          newDifficulty = DifficultyLevel.intermediate;
          break;
        case DifficultyLevel.intermediate:
          newDifficulty = DifficultyLevel.advanced;
          break;
        case DifficultyLevel.advanced:
          // Already at max
          break;
      }
    } else if (session.shouldDecreaseDifficulty) {
      // Decrease difficulty if struggling
      switch (session.currentDifficulty) {
        case DifficultyLevel.advanced:
          newDifficulty = DifficultyLevel.intermediate;
          break;
        case DifficultyLevel.intermediate:
          newDifficulty = DifficultyLevel.elementary;
          break;
        case DifficultyLevel.elementary:
          newDifficulty = DifficultyLevel.beginner;
          break;
        case DifficultyLevel.beginner:
          // Already at min
          break;
      }
    }

    return session.copyWith(currentDifficulty: newDifficulty);
  }

  bool _shouldEndSession(PracticeSession session) {
    switch (session.mode) {
      case PracticeMode.timed:
        return state.timeLeft <= 0;
      case PracticeMode.targetScore:
        return session.currentScore >= session.targetScore;
      case PracticeMode.endless:
        return false; // Only manual end
    }
  }

  Future<void> _endSession() async {
    if (state.currentSession == null) return;

    final completedSession = state.currentSession!.copyWith(
      isActive: false,
      isCompleted: true,
      endTime: DateTime.now(),
    );

    // Save session to offline storage
    await OfflineService.updatePracticeSession(completedSession);

    final updatedRecentSessions = [completedSession, ...state.recentSessions].take(10).toList();

    state = state.copyWith(
      currentSession: completedSession,
      currentQuestion: null,
      recentSessions: updatedRecentSessions,
    );
  }

  void endSessionManually() {
    _endSession();
  }

  void updateTimer() {
    if (state.currentSession?.isActive == true && state.timeLeft > 0) {
      final newTimeLeft = state.timeLeft - 1;
      state = state.copyWith(timeLeft: newTimeLeft);

      if (newTimeLeft <= 0) {
        _endSession();
      }
    }
  }

  void resetSession() {
    state = state.copyWith(
      currentSession: null,
      currentQuestion: null,
      timeLeft: 0,
      isLoading: false,
    );
  }

  Question _createAdaptiveQuestion(PracticeTopic topic, DifficultyLevel difficulty) {
    switch (topic) {
      case PracticeTopic.arithmetic:
        return _createArithmeticQuestion(difficulty);
      case PracticeTopic.fractions:
        return _createFractionQuestion(difficulty);
      case PracticeTopic.decimals:
        return _createDecimalQuestion(difficulty);
      case PracticeTopic.geometry:
        return _createGeometryQuestion(difficulty);
      case PracticeTopic.algebra:
        return _createAlgebraQuestion(difficulty);
      case PracticeTopic.mixed:
        final topics = [PracticeTopic.arithmetic, PracticeTopic.fractions, PracticeTopic.decimals];
        final randomTopic = topics[_random.nextInt(topics.length)];
        return _createAdaptiveQuestion(randomTopic, difficulty);
    }
  }

  Question _createArithmeticQuestion(DifficultyLevel difficulty) {
    final operations = ['+', '-', '×', '÷'];
    final operation = operations[_random.nextInt(operations.length)];

    late int num1, num2, correctAnswer;

    switch (difficulty) {
      case DifficultyLevel.beginner:
        num1 = _random.nextInt(10) + 1; // 1-10
        num2 = _random.nextInt(10) + 1; // 1-10
        break;
      case DifficultyLevel.elementary:
        num1 = _random.nextInt(20) + 1; // 1-20
        num2 = _random.nextInt(15) + 1; // 1-15
        break;
      case DifficultyLevel.intermediate:
        num1 = _random.nextInt(50) + 1; // 1-50
        num2 = _random.nextInt(25) + 1; // 1-25
        break;
      case DifficultyLevel.advanced:
        num1 = _random.nextInt(100) + 1; // 1-100
        num2 = _random.nextInt(50) + 1; // 1-50
        break;
    }

    switch (operation) {
      case '+':
        correctAnswer = num1 + num2;
        break;
      case '-':
        if (num1 < num2) {
          final temp = num1;
          num1 = num2;
          num2 = temp;
        }
        correctAnswer = num1 - num2;
        break;
      case '×':
        num1 = _random.nextInt(12) + 1;
        num2 = _random.nextInt(12) + 1;
        correctAnswer = num1 * num2;
        break;
      case '÷':
        num2 = _random.nextInt(12) + 1;
        final quotient = _random.nextInt(12) + 1;
        num1 = num2 * quotient;
        correctAnswer = quotient;
        break;
      default:
        correctAnswer = num1 + num2;
    }

    final options = _generateOptions(correctAnswer, 4);

    return Question(
      id: 'arithmetic_${DateTime.now().millisecondsSinceEpoch}',
      question: '$num1 $operation $num2 = ?',
      options: options,
      correctAnswer: correctAnswer.toString(),
      difficulty: difficulty,
      topic: 'arithmetic',
      type: QuestionType.multipleChoice,
      explanation: 'Calculate: $num1 $operation $num2 = $correctAnswer',
      hints: ['Take your time', 'Use mental math or write it down'],
    );
  }

  Question _createFractionQuestion(DifficultyLevel difficulty) {
    // Simple fraction addition for now
    int num1 = _random.nextInt(8) + 1;
    int den1 = _random.nextInt(8) + 2;
    int num2 = _random.nextInt(8) + 1;
    int den2 = den1; // Same denominator for simplicity

    int resultNum = num1 + num2;
    String correctAnswer = '$resultNum/$den1';

    final options = ['$resultNum/$den1', '${resultNum + 1}/$den1', '${resultNum - 1}/$den1', '$resultNum/${den1 + 1}'];

    return Question(
      id: 'fraction_${DateTime.now().millisecondsSinceEpoch}',
      question: '$num1/$den1 + $num2/$den2 = ?',
      options: options,
      correctAnswer: correctAnswer,
      difficulty: difficulty,
      topic: 'fractions',
      type: QuestionType.multipleChoice,
      explanation: 'Add the numerators: $num1 + $num2 = $resultNum, keep the denominator: $den1',
      hints: ['Add numerators when denominators are the same', 'Keep the denominator unchanged'],
    );
  }

  Question _createDecimalQuestion(DifficultyLevel difficulty) {
    double num1 = (_random.nextInt(50) + 1) / 10; // 0.1 to 5.0
    double num2 = (_random.nextInt(30) + 1) / 10; // 0.1 to 3.0
    double result = num1 + num2;

    final options = _generateDecimalOptions(result);

    return Question(
      id: 'decimal_${DateTime.now().millisecondsSinceEpoch}',
      question: '$num1 + $num2 = ?',
      options: options,
      correctAnswer: result.toStringAsFixed(1),
      difficulty: difficulty,
      topic: 'decimals',
      type: QuestionType.multipleChoice,
      explanation: 'Line up the decimal points and add: $num1 + $num2 = ${result.toStringAsFixed(1)}',
      hints: ['Line up the decimal points', 'Add normally then place the decimal'],
    );
  }

  Question _createGeometryQuestion(DifficultyLevel difficulty) {
    // Simple area calculation
    int length = _random.nextInt(10) + 1;
    int width = _random.nextInt(10) + 1;
    int area = length * width;

    final options = _generateOptions(area, 4);

    return Question(
      id: 'geometry_${DateTime.now().millisecondsSinceEpoch}',
      question: 'What is the area of a rectangle with length $length and width $width?',
      options: options,
      correctAnswer: area.toString(),
      difficulty: difficulty,
      topic: 'geometry',
      type: QuestionType.multipleChoice,
      explanation: 'Area = length × width = $length × $width = $area',
      hints: ['Area of rectangle = length × width', 'Multiply the two dimensions'],
    );
  }

  Question _createAlgebraQuestion(DifficultyLevel difficulty) {
    // Simple equation solving: x + a = b
    int a = _random.nextInt(20) + 1;
    int b = _random.nextInt(30) + a;
    int x = b - a;

    final options = _generateOptions(x, 4);

    return Question(
      id: 'algebra_${DateTime.now().millisecondsSinceEpoch}',
      question: 'Solve for x: x + $a = $b',
      options: options,
      correctAnswer: x.toString(),
      difficulty: difficulty,
      topic: 'algebra',
      type: QuestionType.multipleChoice,
      explanation: 'x = $b - $a = $x',
      hints: ['Subtract $a from both sides', 'x = $b - $a'],
    );
  }

  List<String> _generateOptions(int correct, int count) {
    final options = <String>[correct.toString()];

    while (options.length < count) {
      int wrong = correct + _random.nextInt(20) - 10;
      if (wrong > 0 && !options.contains(wrong.toString())) {
        options.add(wrong.toString());
      }
    }

    options.shuffle();
    return options;
  }

  List<String> _generateDecimalOptions(double correct) {
    final options = <String>[correct.toStringAsFixed(1)];

    while (options.length < 4) {
      double wrong = correct + (_random.nextDouble() - 0.5) * 2;
      if (wrong > 0 && !options.contains(wrong.toStringAsFixed(1))) {
        options.add(wrong.toStringAsFixed(1));
      }
    }

    options.shuffle();
    return options;
  }

  int _getPointsForDifficulty(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 10;
      case DifficultyLevel.elementary:
        return 15;
      case DifficultyLevel.intermediate:
        return 20;
      case DifficultyLevel.advanced:
        return 25;
    }
  }
}

final practiceProvider = StateNotifierProvider<PracticeNotifier, PracticeState>((ref) {
  return PracticeNotifier();
});