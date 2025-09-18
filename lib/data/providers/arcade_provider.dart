import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../models/arcade_game.dart';
import '../services/offline_service.dart';

class FastOperationsState {
  final List<FastOperationQuestion> questions;
  final int currentQuestionIndex;
  final int score;
  final int timeLeft; // in seconds
  final bool isPlaying;
  final bool isGameOver;
  final List<bool> answerResults; // true for correct, false for wrong
  final ArcadeGameDifficulty difficulty;

  const FastOperationsState({
    required this.questions,
    required this.currentQuestionIndex,
    required this.score,
    required this.timeLeft,
    required this.isPlaying,
    required this.isGameOver,
    required this.answerResults,
    required this.difficulty,
  });

  FastOperationsState copyWith({
    List<FastOperationQuestion>? questions,
    int? currentQuestionIndex,
    int? score,
    int? timeLeft,
    bool? isPlaying,
    bool? isGameOver,
    List<bool>? answerResults,
    ArcadeGameDifficulty? difficulty,
  }) {
    return FastOperationsState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      timeLeft: timeLeft ?? this.timeLeft,
      isPlaying: isPlaying ?? this.isPlaying,
      isGameOver: isGameOver ?? this.isGameOver,
      answerResults: answerResults ?? this.answerResults,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  FastOperationQuestion? get currentQuestion {
    if (currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  int get correctAnswers => answerResults.where((result) => result).length;
  int get totalAnswered => answerResults.length;
  double get accuracy => totalAnswered > 0 ? correctAnswers / totalAnswered : 0.0;
}

class FastOperationsNotifier extends StateNotifier<FastOperationsState> {
  FastOperationsNotifier()
      : super(const FastOperationsState(
          questions: [],
          currentQuestionIndex: 0,
          score: 0,
          timeLeft: 60,
          isPlaying: false,
          isGameOver: false,
          answerResults: [],
          difficulty: ArcadeGameDifficulty.easy,
        ));

  final Random _random = Random();

  void startGame(ArcadeGameDifficulty difficulty) {
    final questions = _generateQuestions(difficulty);
    final gameTime = _getGameTime(difficulty);

    state = state.copyWith(
      questions: questions,
      currentQuestionIndex: 0,
      score: 0,
      timeLeft: gameTime,
      isPlaying: true,
      isGameOver: false,
      answerResults: [],
      difficulty: difficulty,
    );
  }

  void answerQuestion(int answer) {
    if (!state.isPlaying || state.isGameOver || state.currentQuestion == null) {
      return;
    }

    final currentQuestion = state.currentQuestion!;
    final isCorrect = answer == currentQuestion.correctAnswer;
    final pointsEarned = isCorrect ? _getPointsForDifficulty(state.difficulty) : 0;

    final newAnswerResults = [...state.answerResults, isCorrect];
    final newScore = state.score + pointsEarned;
    final newQuestionIndex = state.currentQuestionIndex + 1;

    state = state.copyWith(
      answerResults: newAnswerResults,
      score: newScore,
      currentQuestionIndex: newQuestionIndex,
    );

    // Check if all questions answered
    if (newQuestionIndex >= state.questions.length) {
      _endGame();
    }
  }

  void updateTimer() {
    if (state.isPlaying && !state.isGameOver && state.timeLeft > 0) {
      final newTimeLeft = state.timeLeft - 1;
      state = state.copyWith(timeLeft: newTimeLeft);

      if (newTimeLeft <= 0) {
        _endGame();
      }
    }
  }

  void _endGame() {
    state = state.copyWith(
      isPlaying: false,
      isGameOver: true,
    );
  }

  void resetGame() {
    state = const FastOperationsState(
      questions: [],
      currentQuestionIndex: 0,
      score: 0,
      timeLeft: 60,
      isPlaying: false,
      isGameOver: false,
      answerResults: [],
      difficulty: ArcadeGameDifficulty.easy,
    );
  }

  ArcadeGameResult getGameResult() {
    final totalQuestions = state.questions.length;
    final maxPossibleScore = totalQuestions * _getPointsForDifficulty(state.difficulty);
    final timeSpent = _getGameTime(state.difficulty) - state.timeLeft;
    final xpEarned = (state.score * 0.1).round(); // 10% of score as XP

    return ArcadeGameResult(
      gameType: ArcadeGameType.fastOperations,
      difficulty: state.difficulty,
      score: state.score,
      maxScore: maxPossibleScore,
      timeSpent: timeSpent,
      correctAnswers: state.correctAnswers,
      totalQuestions: totalQuestions,
      xpEarned: xpEarned,
      playedAt: DateTime.now(),
    );
  }

  Future<void> saveGameResult() async {
    final result = getGameResult();
    await OfflineService.saveArcadeResult(result);
  }

  List<FastOperationQuestion> _generateQuestions(ArcadeGameDifficulty difficulty) {
    final questions = <FastOperationQuestion>[];
    final questionCount = _getQuestionCount(difficulty);

    for (int i = 0; i < questionCount; i++) {
      questions.add(_generateQuestion(difficulty));
    }

    return questions;
  }

  FastOperationQuestion _generateQuestion(ArcadeGameDifficulty difficulty) {
    final operations = _getOperations(difficulty);
    final operation = operations[_random.nextInt(operations.length)];

    late int num1, num2, correctAnswer;

    switch (difficulty) {
      case ArcadeGameDifficulty.easy:
        num1 = _random.nextInt(10) + 1; // 1-10
        num2 = _random.nextInt(10) + 1; // 1-10
        break;
      case ArcadeGameDifficulty.medium:
        num1 = _random.nextInt(20) + 1; // 1-20
        num2 = _random.nextInt(15) + 1; // 1-15
        break;
      case ArcadeGameDifficulty.hard:
        num1 = _random.nextInt(50) + 1; // 1-50
        num2 = _random.nextInt(25) + 1; // 1-25
        break;
      case ArcadeGameDifficulty.expert:
        num1 = _random.nextInt(100) + 1; // 1-100
        num2 = _random.nextInt(50) + 1; // 1-50
        break;
    }

    switch (operation) {
      case '+':
        correctAnswer = num1 + num2;
        break;
      case '-':
        // Ensure positive result
        if (num1 < num2) {
          final temp = num1;
          num1 = num2;
          num2 = temp;
        }
        correctAnswer = num1 - num2;
        break;
      case '×':
        // Smaller numbers for multiplication
        num1 = _random.nextInt(12) + 1;
        num2 = _random.nextInt(12) + 1;
        correctAnswer = num1 * num2;
        break;
      case '÷':
        // Generate division with whole number results
        num2 = _random.nextInt(12) + 1; // divisor
        final quotient = _random.nextInt(12) + 1; // result
        num1 = num2 * quotient; // dividend
        correctAnswer = quotient;
        break;
      default:
        correctAnswer = num1 + num2;
    }

    // Generate wrong options
    final options = <int>[correctAnswer];
    while (options.length < 4) {
      int wrongAnswer;
      switch (operation) {
        case '+':
          wrongAnswer = correctAnswer + _random.nextInt(10) - 5;
          break;
        case '-':
          wrongAnswer = correctAnswer + _random.nextInt(8) - 4;
          break;
        case '×':
          wrongAnswer = correctAnswer + _random.nextInt(20) - 10;
          break;
        case '÷':
          wrongAnswer = correctAnswer + _random.nextInt(6) - 3;
          break;
        default:
          wrongAnswer = correctAnswer + _random.nextInt(10) - 5;
      }

      if (wrongAnswer > 0 && !options.contains(wrongAnswer)) {
        options.add(wrongAnswer);
      }
    }

    options.shuffle();

    return FastOperationQuestion(
      num1: num1,
      num2: num2,
      operation: operation,
      correctAnswer: correctAnswer,
      options: options,
    );
  }

  List<String> _getOperations(ArcadeGameDifficulty difficulty) {
    switch (difficulty) {
      case ArcadeGameDifficulty.easy:
        return ['+', '-'];
      case ArcadeGameDifficulty.medium:
        return ['+', '-', '×'];
      case ArcadeGameDifficulty.hard:
      case ArcadeGameDifficulty.expert:
        return ['+', '-', '×', '÷'];
    }
  }

  int _getQuestionCount(ArcadeGameDifficulty difficulty) {
    switch (difficulty) {
      case ArcadeGameDifficulty.easy:
        return 20;
      case ArcadeGameDifficulty.medium:
        return 25;
      case ArcadeGameDifficulty.hard:
        return 30;
      case ArcadeGameDifficulty.expert:
        return 35;
    }
  }

  int _getGameTime(ArcadeGameDifficulty difficulty) {
    switch (difficulty) {
      case ArcadeGameDifficulty.easy:
        return 90; // 1.5 minutes
      case ArcadeGameDifficulty.medium:
        return 75; // 1.25 minutes
      case ArcadeGameDifficulty.hard:
        return 60; // 1 minute
      case ArcadeGameDifficulty.expert:
        return 45; // 45 seconds
    }
  }

  int _getPointsForDifficulty(ArcadeGameDifficulty difficulty) {
    switch (difficulty) {
      case ArcadeGameDifficulty.easy:
        return 10;
      case ArcadeGameDifficulty.medium:
        return 15;
      case ArcadeGameDifficulty.hard:
        return 20;
      case ArcadeGameDifficulty.expert:
        return 25;
    }
  }
}

final fastOperationsProvider = StateNotifierProvider<FastOperationsNotifier, FastOperationsState>((ref) {
  return FastOperationsNotifier();
});