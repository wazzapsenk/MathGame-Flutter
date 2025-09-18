import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/daily_tasks_provider.dart';
import '../../data/providers/user_progress_provider.dart';
import '../../data/models/daily_task.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/task_card.dart';
import '../widgets/question_widget.dart';

class DailyTasksScreen extends ConsumerStatefulWidget {
  const DailyTasksScreen({super.key});

  @override
  ConsumerState<DailyTasksScreen> createState() => _DailyTasksScreenState();
}

class _DailyTasksScreenState extends ConsumerState<DailyTasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dailyTasksProvider.notifier).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasksState = ref.watch(dailyTasksProvider);

    if (tasksState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (tasksState.currentTask != null) {
      return _TaskPlayScreen(task: tasksState.currentTask!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Tasks'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressCard(tasksState),
            const SizedBox(height: 24),
            Text(
              'Today\'s Tasks',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildTasksList(tasksState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(DailyTasksState state) {
    final completedTasks = state.completedTasksToday;
    final maxTasks = AppConstants.dailyTaskLimit;
    final progress = completedTasks / maxTasks;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.today,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Progress',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$completedTasks of $maxTasks tasks completed',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(DailyTasksState state) {
    final todaysTask = state.todaysTask;

    if (todaysTask == null && !state.canCreateNewTask) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'All tasks completed!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Come back tomorrow for new challenges.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (todaysTask == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Ready for today\'s challenge?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete ${AppConstants.questionsPerTask} questions + 1 special problem.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(dailyTasksProvider.notifier).loadTasks();
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Daily Task'),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        TaskCard(
          task: todaysTask,
          onStart: () {
            ref.read(dailyTasksProvider.notifier).startTask(todaysTask.id);
          },
        ),
      ],
    );
  }
}

class _TaskPlayScreen extends ConsumerStatefulWidget {
  final DailyTask task;

  const _TaskPlayScreen({required this.task});

  @override
  ConsumerState<_TaskPlayScreen> createState() => _TaskPlayScreenState();
}

class _TaskPlayScreenState extends ConsumerState<_TaskPlayScreen> {
  int _currentQuestionIndex = 0;
  DateTime? _questionStartTime;

  @override
  void initState() {
    super.initState();
    _questionStartTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final allQuestions = [
      ...widget.task.questions,
      if (widget.task.specialProblem != null) widget.task.specialProblem!,
    ];

    if (_currentQuestionIndex >= allQuestions.length) {
      return _TaskCompletionScreen(task: widget.task);
    }

    final currentQuestion = allQuestions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / allQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentQuestionIndex + 1}/${allQuestions.length}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(dailyTasksProvider.notifier).clearCurrentTask();
          },
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: progress),
          Expanded(
            child: QuestionWidget(
              question: currentQuestion,
              onAnswerSubmitted: (answer, hintsUsed) {
                final timeSpent = DateTime.now().difference(_questionStartTime!).inSeconds;

                // Track progress for badges
                final isCorrect = answer == currentQuestion.correctAnswer;
                ref.read(userProgressProvider.notifier).recordQuestionAnswered(
                  topic: currentQuestion.topic,
                  isCorrect: isCorrect,
                  timeSpent: timeSpent,
                );

                ref.read(dailyTasksProvider.notifier).submitAnswer(
                  currentQuestion.id,
                  answer,
                  timeSpent,
                  hintsUsed,
                );

                setState(() {
                  _currentQuestionIndex++;
                  _questionStartTime = DateTime.now();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCompletionScreen extends ConsumerWidget {
  final DailyTask task;

  const _TaskCompletionScreen({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final correctAnswers = task.correctAnswers;
    final totalQuestions = task.questions.length + (task.specialProblem != null ? 1 : 0);
    final accuracy = (correctAnswers / totalQuestions * 100).round();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Task Complete!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Correct Answers:'),
                          Text(
                            '$correctAnswers/$totalQuestions',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Accuracy:'),
                          Text(
                            '$accuracy%',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('XP Earned:'),
                          Text(
                            '${task.totalXP}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Update streak and task completion tracking
                    ref.read(userProgressProvider.notifier).updateStreak();
                    ref.read(userProgressProvider.notifier).recordTaskCompleted(
                      accuracy: task.accuracy,
                    );
                    ref.read(userProgressProvider.notifier).addXP(task.totalXP);

                    ref.read(dailyTasksProvider.notifier).clearCurrentTask();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Return to Home'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}