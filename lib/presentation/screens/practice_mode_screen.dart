import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/practice_provider.dart';
import '../../data/models/practice_session.dart';
import '../../data/models/question.dart';

class PracticeModeScreen extends ConsumerStatefulWidget {
  const PracticeModeScreen({super.key});

  @override
  ConsumerState<PracticeModeScreen> createState() => _PracticeModeScreenState();
}

class _PracticeModeScreenState extends ConsumerState<PracticeModeScreen> {
  @override
  Widget build(BuildContext context) {
    final practiceState = ref.watch(practiceProvider);

    if (practiceState.currentSession?.isActive == true) {
      return _PracticeSessionView();
    }

    if (practiceState.currentSession?.isCompleted == true) {
      return _SessionResultsView();
    }

    return _PracticeMenuView();
  }
}

class _PracticeMenuView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Mode'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: 24),
            _buildPracticeModes(context, ref),
            const SizedBox(height: 24),
            _buildTopicSelection(context, ref),
            const SizedBox(height: 24),
            _buildRecentSessions(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adaptive Practice',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Questions automatically adjust to your skill level. The more you practice, the better you get!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeModes(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Practice Modes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _PracticeModeCard(
              icon: Icons.all_inclusive,
              title: 'Endless',
              subtitle: 'Practice until you stop',
              color: Colors.blue,
              onTap: () => _showDifficultyDialog(context, ref, PracticeMode.endless),
            ),
            _PracticeModeCard(
              icon: Icons.timer,
              title: 'Timed',
              subtitle: '5 minute challenge',
              color: Colors.orange,
              onTap: () => _showDifficultyDialog(context, ref, PracticeMode.timed),
            ),
            _PracticeModeCard(
              icon: Icons.gps_fixed,
              title: 'Target Score',
              subtitle: 'Reach 100 points',
              color: Colors.green,
              onTap: () => _showDifficultyDialog(context, ref, PracticeMode.targetScore),
            ),
            _PracticeModeCard(
              icon: Icons.shuffle,
              title: 'Mixed Topics',
              subtitle: 'Random questions',
              color: Colors.purple,
              onTap: () => _startPractice(context, ref, PracticeMode.endless, PracticeTopic.mixed),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopicSelection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Practice by Topic',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _TopicChip(
              icon: Icons.calculate,
              label: 'Arithmetic',
              topic: PracticeTopic.arithmetic,
              onTap: (topic) => _showDifficultyDialog(context, ref, PracticeMode.endless, topic: topic),
            ),
            _TopicChip(
              icon: Icons.pie_chart,
              label: 'Fractions',
              topic: PracticeTopic.fractions,
              onTap: (topic) => _showDifficultyDialog(context, ref, PracticeMode.endless, topic: topic),
            ),
            _TopicChip(
              icon: Icons.fiber_manual_record,
              label: 'Decimals',
              topic: PracticeTopic.decimals,
              onTap: (topic) => _showDifficultyDialog(context, ref, PracticeMode.endless, topic: topic),
            ),
            _TopicChip(
              icon: Icons.change_history,
              label: 'Geometry',
              topic: PracticeTopic.geometry,
              onTap: (topic) => _showDifficultyDialog(context, ref, PracticeMode.endless, topic: topic),
            ),
            _TopicChip(
              icon: Icons.functions,
              label: 'Algebra',
              topic: PracticeTopic.algebra,
              onTap: (topic) => _showDifficultyDialog(context, ref, PracticeMode.endless, topic: topic),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentSessions(BuildContext context, WidgetRef ref) {
    final recentSessions = ref.watch(practiceProvider).recentSessions;

    if (recentSessions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Sessions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...recentSessions.take(3).map((session) => _SessionSummaryCard(session: session)).toList(),
      ],
    );
  }

  void _showDifficultyDialog(BuildContext context, WidgetRef ref, PracticeMode mode, {PracticeTopic? topic}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Difficulty'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DifficultyLevel.values.map((difficulty) => ListTile(
            title: Text(_getDifficultyName(difficulty)),
            subtitle: Text(_getDifficultyDescription(difficulty)),
            onTap: () {
              Navigator.of(context).pop();
              _startPractice(context, ref, mode, topic ?? PracticeTopic.mixed, difficulty: difficulty);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _startPractice(BuildContext context, WidgetRef ref, PracticeMode mode, PracticeTopic topic, {DifficultyLevel? difficulty}) {
    final targetScore = mode == PracticeMode.targetScore ? 100 : null;
    final timeLimit = mode == PracticeMode.timed ? 300 : null; // 5 minutes

    ref.read(practiceProvider.notifier).startSession(
      mode: mode,
      topic: topic,
      difficulty: difficulty ?? DifficultyLevel.elementary,
      targetScore: targetScore,
      timeLimit: timeLimit,
    );
  }

  String _getDifficultyName(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 'Beginner';
      case DifficultyLevel.elementary:
        return 'Elementary';
      case DifficultyLevel.intermediate:
        return 'Intermediate';
      case DifficultyLevel.advanced:
        return 'Advanced';
    }
  }

  String _getDifficultyDescription(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 'Simple numbers, basic operations';
      case DifficultyLevel.elementary:
        return 'Slightly larger numbers';
      case DifficultyLevel.intermediate:
        return 'More complex problems';
      case DifficultyLevel.advanced:
        return 'Challenging calculations';
    }
  }
}

class _PracticeModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _PracticeModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final PracticeTopic topic;
  final Function(PracticeTopic) onTap;

  const _TopicChip({
    required this.icon,
    required this.label,
    required this.topic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () => onTap(topic),
    );
  }
}

class _SessionSummaryCard extends StatelessWidget {
  final PracticeSession session;

  const _SessionSummaryCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(_getTopicIcon(session.topic)),
        title: Text('${_getTopicName(session.topic)} - ${_getModeName(session.mode)}'),
        subtitle: Text('${session.correctAnswers}/${session.totalQuestions} correct • ${session.currentScore} pts'),
        trailing: Text(
          '${(session.accuracy * 100).toInt()}%',
          style: TextStyle(
            color: session.accuracy >= 0.8 ? Colors.green : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getTopicName(PracticeTopic topic) {
    switch (topic) {
      case PracticeTopic.arithmetic:
        return 'Arithmetic';
      case PracticeTopic.fractions:
        return 'Fractions';
      case PracticeTopic.decimals:
        return 'Decimals';
      case PracticeTopic.geometry:
        return 'Geometry';
      case PracticeTopic.algebra:
        return 'Algebra';
      case PracticeTopic.mixed:
        return 'Mixed';
    }
  }

  String _getModeName(PracticeMode mode) {
    switch (mode) {
      case PracticeMode.endless:
        return 'Endless';
      case PracticeMode.timed:
        return 'Timed';
      case PracticeMode.targetScore:
        return 'Target';
    }
  }

  IconData _getTopicIcon(PracticeTopic topic) {
    switch (topic) {
      case PracticeTopic.arithmetic:
        return Icons.calculate;
      case PracticeTopic.fractions:
        return Icons.pie_chart;
      case PracticeTopic.decimals:
        return Icons.fiber_manual_record;
      case PracticeTopic.geometry:
        return Icons.change_history;
      case PracticeTopic.algebra:
        return Icons.functions;
      case PracticeTopic.mixed:
        return Icons.shuffle;
    }
  }
}

class _PracticeSessionView extends ConsumerStatefulWidget {
  @override
  ConsumerState<_PracticeSessionView> createState() => _PracticeSessionViewState();
}

class _PracticeSessionViewState extends ConsumerState<_PracticeSessionView> {
  String? selectedAnswer;
  bool showResult = false;

  @override
  Widget build(BuildContext context) {
    final practiceState = ref.watch(practiceProvider);
    final session = practiceState.currentSession!;
    final question = practiceState.currentQuestion!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getSessionTitle(session)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(context),
        ),
        actions: [
          if (session.mode == PracticeMode.timed)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  _formatTime(practiceState.timeLeft),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProgressCard(session),
            const SizedBox(height: 16),
            _buildQuestionCard(question),
            const SizedBox(height: 16),
            Expanded(child: _buildAnswerOptions(question)),
            if (showResult) _buildResultCard(question),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(PracticeSession session) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Score: ${session.currentScore}'),
                  if (session.mode == PracticeMode.targetScore)
                    Text('Target: ${session.targetScore}'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Accuracy: ${(session.accuracy * 100).toInt()}%'),
                  Text('Questions: ${session.totalQuestions}'),
                ],
              ),
            ),
            Column(
              children: [
                Text('Level'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(session.currentDifficulty).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getDifficultyName(session.currentDifficulty),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getDifficultyColor(session.currentDifficulty),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              question.question,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(Question question) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2,
      ),
      itemCount: question.options.length,
      itemBuilder: (context, index) {
        final option = question.options[index];
        final isSelected = selectedAnswer == option;
        final isCorrect = option == question.correctAnswer;

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
    );
  }

  Widget _buildResultCard(Question question) {
    final isCorrect = selectedAnswer == question.correctAnswer;

    return Card(
      color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              isCorrect ? 'Correct!' : 'Incorrect',
              style: TextStyle(
                color: isCorrect ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (!isCorrect) ...[
              const SizedBox(height: 8),
              Text('Correct answer: ${question.correctAnswer}'),
            ],
            const SizedBox(height: 8),
            Text(question.explanation),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _nextQuestion,
              child: const Text('Continue'),
            ),
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

  void _nextQuestion() {
    ref.read(practiceProvider.notifier).answerQuestion(selectedAnswer!);
    setState(() {
      selectedAnswer = null;
      showResult = false;
    });
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Practice?'),
        content: const Text('Your progress will be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () {
              ref.read(practiceProvider.notifier).endSessionManually();
              Navigator.of(context).pop();
            },
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }

  String _getSessionTitle(PracticeSession session) {
    switch (session.mode) {
      case PracticeMode.endless:
        return 'Endless Practice';
      case PracticeMode.timed:
        return 'Timed Practice';
      case PracticeMode.targetScore:
        return 'Target Practice';
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _getDifficultyName(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 'Beginner';
      case DifficultyLevel.elementary:
        return 'Elementary';
      case DifficultyLevel.intermediate:
        return 'Intermediate';
      case DifficultyLevel.advanced:
        return 'Advanced';
    }
  }

  Color _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return Colors.green;
      case DifficultyLevel.elementary:
        return Colors.blue;
      case DifficultyLevel.intermediate:
        return Colors.orange;
      case DifficultyLevel.advanced:
        return Colors.red;
    }
  }
}

class _SessionResultsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(practiceProvider).currentSession!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Complete'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 64,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Great Job!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildStat('Questions Answered', session.totalQuestions.toString()),
                    _buildStat('Correct Answers', session.correctAnswers.toString()),
                    _buildStat('Accuracy', '${(session.accuracy * 100).toInt()}%'),
                    _buildStat('Final Score', session.currentScore.toString()),
                    if (session.averageResponseTime > 0)
                      _buildStat('Avg. Response Time', '${session.averageResponseTime.toStringAsFixed(1)}s'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => ref.read(practiceProvider.notifier).resetSession(),
                child: const Text('Practice Again'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}