import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../navigation/app_router.dart';

class PlacementTestScreen extends ConsumerStatefulWidget {
  const PlacementTestScreen({super.key});

  @override
  ConsumerState<PlacementTestScreen> createState() => _PlacementTestScreenState();
}

class _PlacementTestScreenState extends ConsumerState<PlacementTestScreen> {
  int _currentQuestionIndex = 0;
  final List<String> _selectedAnswers = [];

  final List<PlacementQuestion> _questions = [
    PlacementQuestion(
      question: '7 + 5 = ?',
      options: ['11', '12', '13', '14'],
      correctAnswer: '12',
    ),
    PlacementQuestion(
      question: '24 ÷ 6 = ?',
      options: ['3', '4', '5', '6'],
      correctAnswer: '4',
    ),
    PlacementQuestion(
      question: 'What is 1/2 + 1/4?',
      options: ['1/6', '2/6', '3/4', '1/3'],
      correctAnswer: '3/4',
    ),
    PlacementQuestion(
      question: 'If x + 3 = 10, what is x?',
      options: ['6', '7', '8', '13'],
      correctAnswer: '7',
    ),
    PlacementQuestion(
      question: 'What is the area of a rectangle with length 6 and width 4?',
      options: ['10', '20', '24', '28'],
      correctAnswer: '24',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedAnswers.addAll(List.filled(_questions.length, ''));
  }

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _completeTest();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _completeTest() {
    final score = _calculateScore();

    // TODO: Save placement test result
    // TODO: Determine appropriate difficulty level

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Test Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your score: ${score}/${_questions.length}'),
            const SizedBox(height: 16),
            const Text('Based on your performance, we\'ve set your difficulty level to help you learn effectively.'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(AppRouter.home);
            },
            child: const Text('Start Learning'),
          ),
        ],
      ),
    );
  }

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i].correctAnswer) {
        score++;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final selectedAnswer = _selectedAnswers[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Placement Test (${_currentQuestionIndex + 1}/${_questions.length})'),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      currentQuestion.question,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, index) {
                  final option = currentQuestion.options[index];
                  final isSelected = selectedAnswer == option;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(option),
                        onTap: () => _selectAnswer(option),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                if (_currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentQuestionIndex > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: selectedAnswer.isNotEmpty ? _nextQuestion : null,
                    child: Text(_currentQuestionIndex == _questions.length - 1
                        ? 'Complete'
                        : 'Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlacementQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  PlacementQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}