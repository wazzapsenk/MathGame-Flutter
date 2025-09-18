import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../data/providers/arcade_provider.dart';
import '../../data/providers/user_progress_provider.dart';
import '../../data/models/arcade_game.dart';

class ArcadeModeScreen extends ConsumerWidget {
  const ArcadeModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arcade Mode'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mini Games',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Test your speed and accuracy with fun math games!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
                children: [
                  _GameCard(
                    title: 'Fast Operations',
                    description: 'Quick math calculations under time pressure',
                    icon: Icons.flash_on,
                    color: Colors.orange,
                    onTap: () => _navigateToFastOperations(context, ref),
                    isAvailable: true,
                  ),
                  _GameCard(
                    title: 'Fraction Puzzle',
                    description: 'Solve fraction problems with visual aids',
                    icon: Icons.pie_chart,
                    color: Colors.blue,
                    onTap: () => _showComingSoon(context),
                    isAvailable: false,
                  ),
                  _GameCard(
                    title: 'Geometry Draw',
                    description: 'Draw shapes and calculate areas',
                    icon: Icons.draw,
                    color: Colors.green,
                    onTap: () => _showComingSoon(context),
                    isAvailable: false,
                  ),
                  _GameCard(
                    title: 'Boss Challenge',
                    description: 'Ultimate math boss battles',
                    icon: Icons.sports_kabaddi,
                    color: Colors.red,
                    onTap: () => _showComingSoon(context),
                    isAvailable: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToFastOperations(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FastOperationsScreen(),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon!'),
        content: const Text('This game will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isAvailable;

  const _GameCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(isAvailable ? 0.1 : 0.05),
                color.withOpacity(isAvailable ? 0.05 : 0.02),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(isAvailable ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isAvailable ? color : Colors.grey,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  if (!isAvailable)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'SOON',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isAvailable ? null : Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isAvailable
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Colors.grey,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FastOperationsScreen extends ConsumerStatefulWidget {
  const FastOperationsScreen({super.key});

  @override
  ConsumerState<FastOperationsScreen> createState() => _FastOperationsScreenState();
}

class _FastOperationsScreenState extends ConsumerState<FastOperationsScreen> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(fastOperationsProvider);

    if (!gameState.isPlaying && !gameState.isGameOver) {
      return _DifficultySelectionScreen(
        onDifficultySelected: (difficulty) {
          ref.read(fastOperationsProvider.notifier).startGame(difficulty);
          _startTimer();
        },
      );
    }

    if (gameState.isGameOver) {
      return _GameOverScreen(
        gameState: gameState,
        onPlayAgain: () {
          ref.read(fastOperationsProvider.notifier).resetGame();
        },
        onBackToMenu: () {
          ref.read(fastOperationsProvider.notifier).resetGame();
          Navigator.of(context).pop();
        },
      );
    }

    return _GamePlayScreen(gameState: gameState);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      ref.read(fastOperationsProvider.notifier).updateTimer();
    });
  }
}

class _DifficultySelectionScreen extends StatelessWidget {
  final Function(ArcadeGameDifficulty) onDifficultySelected;

  const _DifficultySelectionScreen({required this.onDifficultySelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fast Operations'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Difficulty',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Solve as many math problems as you can before time runs out!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  _DifficultyCard(
                    difficulty: ArcadeGameDifficulty.easy,
                    title: 'Easy',
                    description: '1-10 numbers, addition & subtraction\n20 questions in 90 seconds',
                    color: Colors.green,
                    points: '10 pts per question',
                    onTap: () => onDifficultySelected(ArcadeGameDifficulty.easy),
                  ),
                  const SizedBox(height: 16),
                  _DifficultyCard(
                    difficulty: ArcadeGameDifficulty.medium,
                    title: 'Medium',
                    description: '1-20 numbers, +, -, ×\n25 questions in 75 seconds',
                    color: Colors.blue,
                    points: '15 pts per question',
                    onTap: () => onDifficultySelected(ArcadeGameDifficulty.medium),
                  ),
                  const SizedBox(height: 16),
                  _DifficultyCard(
                    difficulty: ArcadeGameDifficulty.hard,
                    title: 'Hard',
                    description: '1-50 numbers, all operations\n30 questions in 60 seconds',
                    color: Colors.orange,
                    points: '20 pts per question',
                    onTap: () => onDifficultySelected(ArcadeGameDifficulty.hard),
                  ),
                  const SizedBox(height: 16),
                  _DifficultyCard(
                    difficulty: ArcadeGameDifficulty.expert,
                    title: 'Expert',
                    description: '1-100 numbers, all operations\n35 questions in 45 seconds',
                    color: Colors.red,
                    points: '25 pts per question',
                    onTap: () => onDifficultySelected(ArcadeGameDifficulty.expert),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  final ArcadeGameDifficulty difficulty;
  final String title;
  final String description;
  final Color color;
  final String points;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.difficulty,
    required this.title,
    required this.description,
    required this.color,
    required this.points,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(
                  child: Text(
                    title[0],
                    style: TextStyle(
                      color: color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        points,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GamePlayScreen extends ConsumerWidget {
  final FastOperationsState gameState;

  const _GamePlayScreen({required this.gameState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuestion = gameState.currentQuestion;

    if (currentQuestion == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: _getBackgroundColor(gameState.timeLeft),
      appBar: AppBar(
        title: Text('Fast Operations - ${gameState.difficulty.name.toUpperCase()}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Quit Game?'),
                  content: const Text('Are you sure you want to quit the current game?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref.read(fastOperationsProvider.notifier).resetGame();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Quit'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _GameHeader(gameState: gameState),
            const SizedBox(height: 32),
            _QuestionDisplay(question: currentQuestion),
            const SizedBox(height: 32),
            Expanded(
              child: _AnswerOptions(
                options: currentQuestion.options,
                onAnswerSelected: (answer) {
                  ref.read(fastOperationsProvider.notifier).answerQuestion(answer);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(int timeLeft) {
    if (timeLeft <= 10) {
      return Colors.red.withOpacity(0.1);
    } else if (timeLeft <= 20) {
      return Colors.orange.withOpacity(0.1);
    }
    return Colors.transparent;
  }
}

class _GameHeader extends StatelessWidget {
  final FastOperationsState gameState;

  const _GameHeader({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Score',
            value: '${gameState.score}',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: 'Question',
            value: '${gameState.currentQuestionIndex + 1}/${gameState.questions.length}',
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: 'Time',
            value: '${gameState.timeLeft}s',
            color: gameState.timeLeft <= 10 ? Colors.red : Colors.orange,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionDisplay extends StatelessWidget {
  final FastOperationQuestion question;

  const _QuestionDisplay({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          question.questionText,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _AnswerOptions extends StatelessWidget {
  final List<int> options;
  final Function(int) onAnswerSelected;

  const _AnswerOptions({
    required this.options,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return ElevatedButton(
          onPressed: () => onAnswerSelected(option),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            option.toString(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

class _GameOverScreen extends ConsumerWidget {
  final FastOperationsState gameState;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToMenu;

  const _GameOverScreen({
    required this.gameState,
    required this.onPlayAgain,
    required this.onBackToMenu,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.read(fastOperationsProvider.notifier).getGameResult();

    // Award XP to user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProgressProvider.notifier).addXP(result.xpEarned);
    });

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
                  color: _getResultColor(result.scorePercentage),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getResultIcon(result.scorePercentage),
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Game Over!',
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
                      _ResultRow('Score', '${result.score}'),
                      _ResultRow('Correct Answers', '${result.correctAnswers}/${result.totalQuestions}'),
                      _ResultRow('Accuracy', '${(result.accuracy * 100).round()}%'),
                      _ResultRow('Time Spent', '${result.timeSpent}s'),
                      _ResultRow('XP Earned', '+${result.xpEarned}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onBackToMenu,
                      icon: const Icon(Icons.home),
                      label: const Text('Menu'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onPlayAgain,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Play Again'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getResultColor(double scorePercentage) {
    if (scorePercentage >= 0.8) return Colors.green;
    if (scorePercentage >= 0.6) return Colors.blue;
    if (scorePercentage >= 0.4) return Colors.orange;
    return Colors.red;
  }

  IconData _getResultIcon(double scorePercentage) {
    if (scorePercentage >= 0.8) return Icons.emoji_events;
    if (scorePercentage >= 0.6) return Icons.star;
    if (scorePercentage >= 0.4) return Icons.thumb_up;
    return Icons.thumb_down;
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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