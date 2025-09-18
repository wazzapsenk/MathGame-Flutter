import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/learn_provider.dart';
import '../../data/models/learn_lesson.dart';
import '../../data/models/question.dart';

class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    final learnState = ref.watch(learnProvider);

    if (learnState.currentLesson != null) {
      return _LessonView(
        lesson: learnState.currentLesson!,
        progress: learnState.currentProgress!,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn'),
        centerTitle: true,
      ),
      body: learnState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildLessonsList(context, learnState),
    );
  }

  Widget _buildLessonsList(BuildContext context, LearnState state) {
    final topicGroups = <MathTopic, List<LearnLesson>>{};
    for (final lesson in state.unlockedLessons) {
      topicGroups[lesson.topic] = [...(topicGroups[lesson.topic] ?? []), lesson];
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressOverview(context, state),
          const SizedBox(height: 24),
          ...topicGroups.entries.map((entry) =>
            _buildTopicSection(context, entry.key, entry.value)
          ).toList(),
        ],
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context, LearnState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Learning Progress',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: state.overallProgress,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              '${(state.overallProgress * 100).toInt()}% Complete',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicSection(BuildContext context, MathTopic topic, List<LearnLesson> lessons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            _getTopicName(topic),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...lessons.map((lesson) => _LessonCard(lesson: lesson)).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  String _getTopicName(MathTopic topic) {
    switch (topic) {
      case MathTopic.addition:
        return 'Addition';
      case MathTopic.subtraction:
        return 'Subtraction';
      case MathTopic.multiplication:
        return 'Multiplication';
      case MathTopic.division:
        return 'Division';
      case MathTopic.fractions:
        return 'Fractions';
      case MathTopic.decimals:
        return 'Decimals';
      case MathTopic.geometry:
        return 'Geometry';
      case MathTopic.algebra:
        return 'Algebra';
    }
  }
}

class _LessonCard extends ConsumerWidget {
  final LearnLesson lesson;

  const _LessonCard({required this.lesson});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => ref.read(learnProvider.notifier).startLesson(lesson.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getTopicColor(lesson.topic).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getTopicColor(lesson.topic),
                    width: 2,
                  ),
                ),
                child: Icon(
                  _getTopicIcon(lesson.topic),
                  color: _getTopicColor(lesson.topic),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${lesson.estimatedMinutes} min',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.signal_cellular_alt,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Level ${lesson.difficultyLevel}',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (lesson.isCompleted)
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    )
                  else
                    Icon(
                      Icons.play_circle_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTopicColor(MathTopic topic) {
    switch (topic) {
      case MathTopic.addition:
        return Colors.green;
      case MathTopic.subtraction:
        return Colors.orange;
      case MathTopic.multiplication:
        return Colors.blue;
      case MathTopic.division:
        return Colors.purple;
      case MathTopic.fractions:
        return Colors.red;
      case MathTopic.decimals:
        return Colors.teal;
      case MathTopic.geometry:
        return Colors.indigo;
      case MathTopic.algebra:
        return Colors.brown;
    }
  }

  IconData _getTopicIcon(MathTopic topic) {
    switch (topic) {
      case MathTopic.addition:
        return Icons.add;
      case MathTopic.subtraction:
        return Icons.remove;
      case MathTopic.multiplication:
        return Icons.close;
      case MathTopic.division:
        return Icons.more_horiz;
      case MathTopic.fractions:
        return Icons.pie_chart;
      case MathTopic.decimals:
        return Icons.fiber_manual_record;
      case MathTopic.geometry:
        return Icons.change_history;
      case MathTopic.algebra:
        return Icons.functions;
    }
  }
}

class _LessonView extends ConsumerStatefulWidget {
  final LearnLesson lesson;
  final LearningProgress progress;

  const _LessonView({
    required this.lesson,
    required this.progress,
  });

  @override
  ConsumerState<_LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends ConsumerState<_LessonView> {
  int _practiceQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => ref.read(learnProvider.notifier).exitLesson(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: widget.progress.progressPercentage,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ),
      ),
      body: _buildCurrentContent(),
    );
  }

  Widget _buildCurrentContent() {
    if (!widget.progress.conceptCompleted) {
      return _buildConceptView();
    } else if (!widget.progress.examplesCompleted) {
      return _buildWorkedExampleView();
    } else if (!widget.progress.practiceCompleted) {
      return _buildPracticeView();
    } else {
      return _buildCompletionView();
    }
  }

  Widget _buildConceptView() {
    final step = widget.lesson.conceptSteps[widget.progress.currentStepIndex];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Concept',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    step.explanation,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (step.formula != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        step.formula!,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  if (step.examples.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Examples:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...step.examples.map((example) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          example,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    )).toList(),
                  ],
                  if (step.visualAid != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.tips_and_updates,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              step.visualAid!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Spacer(),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildWorkedExampleView() {
    final example = widget.lesson.workedExamples[widget.progress.currentExampleIndex];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.construction,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Worked Example',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Problem: ${example.problem}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Solution Steps:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...example.steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Step ${index + 1}:',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              step.explanation,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            if (step.examples.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              ...step.examples.map((example) => Text(
                                example,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w500,
                                ),
                              )).toList(),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Text(
                      'Answer: ${example.finalAnswer}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.orange.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Hint: ${example.hint}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildPracticeView() {
    final question = widget.lesson.practiceQuestions[_practiceQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.quiz,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Practice Question ${_practiceQuestionIndex + 1} of ${widget.lesson.practiceQuestions.length}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _PracticeQuestionWidget(
              question: question,
              onAnswerSelected: _handlePracticeAnswer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Lesson Complete!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Great job completing "${widget.lesson.title}"!',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => ref.read(learnProvider.notifier).exitLesson(),
              child: const Text('Continue Learning'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (widget.progress.currentStepIndex > 0 ||
            widget.progress.conceptCompleted ||
            widget.progress.currentExampleIndex > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () => ref.read(learnProvider.notifier).previousStep(),
              child: const Text('Previous'),
            ),
          ),
        if ((widget.progress.currentStepIndex > 0 ||
             widget.progress.conceptCompleted ||
             widget.progress.currentExampleIndex > 0) &&
            (!widget.progress.conceptCompleted ||
             !widget.progress.examplesCompleted))
          const SizedBox(width: 16),
        if (!widget.progress.conceptCompleted ||
            !widget.progress.examplesCompleted)
          Expanded(
            child: ElevatedButton(
              onPressed: () => ref.read(learnProvider.notifier).nextStep(),
              child: Text(_getNextButtonText()),
            ),
          ),
      ],
    );
  }

  String _getNextButtonText() {
    if (!widget.progress.conceptCompleted) {
      if (widget.progress.currentStepIndex < widget.lesson.conceptSteps.length - 1) {
        return 'Next';
      } else {
        return 'Continue to Examples';
      }
    } else if (!widget.progress.examplesCompleted) {
      if (widget.progress.currentExampleIndex < widget.lesson.workedExamples.length - 1) {
        return 'Next Example';
      } else {
        return 'Start Practice';
      }
    }
    return 'Next';
  }

  void _handlePracticeAnswer(String selectedAnswer) {
    final question = widget.lesson.practiceQuestions[_practiceQuestionIndex];

    if (selectedAnswer == question.correctAnswer) {
      if (_practiceQuestionIndex < widget.lesson.practiceQuestions.length - 1) {
        setState(() {
          _practiceQuestionIndex++;
        });
      } else {
        ref.read(learnProvider.notifier).completePractice();
      }
    }
  }
}

class _PracticeQuestionWidget extends StatefulWidget {
  final Question question;
  final Function(String) onAnswerSelected;

  const _PracticeQuestionWidget({
    required this.question,
    required this.onAnswerSelected,
  });

  @override
  State<_PracticeQuestionWidget> createState() => _PracticeQuestionWidgetState();
}

class _PracticeQuestionWidgetState extends State<_PracticeQuestionWidget> {
  String? selectedAnswer;
  bool showResult = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.question.question,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2,
                ),
                itemCount: widget.question.options.length,
                itemBuilder: (context, index) {
                  final option = widget.question.options[index];
                  final isSelected = selectedAnswer == option;
                  final isCorrect = option == widget.question.correctAnswer;

                  Color? backgroundColor;
                  Color? textColor;

                  if (showResult) {
                    if (isCorrect) {
                      backgroundColor = Colors.green.withOpacity(0.1);
                      textColor = Colors.green;
                    } else if (isSelected) {
                      backgroundColor = Colors.red.withOpacity(0.1);
                      textColor = Colors.red;
                    }
                  } else if (isSelected) {
                    backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
                    textColor = Theme.of(context).colorScheme.primary;
                  }

                  return InkWell(
                    onTap: showResult ? null : () => _selectAnswer(option),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: textColor ?? Theme.of(context).colorScheme.outline,
                          width: isSelected || (showResult && isCorrect) ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          option,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (showResult) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selectedAnswer == widget.question.correctAnswer
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      selectedAnswer == widget.question.correctAnswer ? 'Correct!' : 'Try Again!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: selectedAnswer == widget.question.correctAnswer ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.question.explanation,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedAnswer == widget.question.correctAnswer
                      ? () => widget.onAnswerSelected(selectedAnswer!)
                      : _resetQuestion,
                  child: Text(selectedAnswer == widget.question.correctAnswer ? 'Continue' : 'Try Again'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      showResult = true;
    });
  }

  void _resetQuestion() {
    setState(() {
      selectedAnswer = null;
      showResult = false;
    });
  }
}