import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question.dart';
import '../repositories/question_repository.dart';

class PlacementTestState {
  final List<Question> questions;
  final List<String> selectedAnswers;
  final int currentQuestionIndex;
  final bool isCompleted;
  final DifficultyLevel? determinedLevel;
  final List<String>? unlockedTopics;

  const PlacementTestState({
    required this.questions,
    required this.selectedAnswers,
    required this.currentQuestionIndex,
    required this.isCompleted,
    this.determinedLevel,
    this.unlockedTopics,
  });

  PlacementTestState copyWith({
    List<Question>? questions,
    List<String>? selectedAnswers,
    int? currentQuestionIndex,
    bool? isCompleted,
    DifficultyLevel? determinedLevel,
    List<String>? unlockedTopics,
  }) {
    return PlacementTestState(
      questions: questions ?? this.questions,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      determinedLevel: determinedLevel ?? this.determinedLevel,
      unlockedTopics: unlockedTopics ?? this.unlockedTopics,
    );
  }

  Question get currentQuestion => questions[currentQuestionIndex];
  String get currentAnswer => selectedAnswers[currentQuestionIndex];
  bool get hasAnswer => currentAnswer.isNotEmpty;
  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;
  double get progress => (currentQuestionIndex + 1) / questions.length;
  int get score {
    int correct = 0;
    for (int i = 0; i < questions.length && i < selectedAnswers.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswer) {
        correct++;
      }
    }
    return correct;
  }
}

class PlacementTestNotifier extends StateNotifier<PlacementTestState> {
  PlacementTestNotifier() : super(PlacementTestState(
    questions: QuestionRepository.getPlacementTestQuestions(),
    selectedAnswers: List.filled(QuestionRepository.getPlacementTestQuestions().length, ''),
    currentQuestionIndex: 0,
    isCompleted: false,
  ));

  void selectAnswer(String answer) {
    final newAnswers = List<String>.from(state.selectedAnswers);
    newAnswers[state.currentQuestionIndex] = answer;

    state = state.copyWith(selectedAnswers: newAnswers);
  }

  void nextQuestion() {
    if (!state.isLastQuestion) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
      );
    } else {
      _completeTest();
    }
  }

  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
      );
    }
  }

  void _completeTest() {
    final level = QuestionRepository.calculateLevel(state.selectedAnswers);
    final topics = QuestionRepository.getUnlockedTopics(level);

    state = state.copyWith(
      isCompleted: true,
      determinedLevel: level,
      unlockedTopics: topics,
    );
  }

  void reset() {
    state = PlacementTestState(
      questions: QuestionRepository.getPlacementTestQuestions(),
      selectedAnswers: List.filled(QuestionRepository.getPlacementTestQuestions().length, ''),
      currentQuestionIndex: 0,
      isCompleted: false,
    );
  }
}

final placementTestProvider = StateNotifierProvider<PlacementTestNotifier, PlacementTestState>((ref) {
  return PlacementTestNotifier();
});