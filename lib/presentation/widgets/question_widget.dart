import 'package:flutter/material.dart';
import '../../data/models/question.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final Function(String answer, int hintsUsed) onAnswerSubmitted;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onAnswerSubmitted,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? selectedAnswer;
  int hintsUsed = 0;
  bool showExplanation = false;
  List<String> visibleHints = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildQuestionCard(),
          const SizedBox(height: 24),
          if (visibleHints.isNotEmpty) ...[
            _buildHintsSection(),
            const SizedBox(height: 16),
          ],
          Expanded(
            child: _buildOptionsGrid(),
          ),
          if (showExplanation) ...[
            const SizedBox(height: 16),
            _buildExplanationCard(),
            const SizedBox(height: 16),
          ],
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getTopicColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.question.topic.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _getTopicColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.question.difficulty.name.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _getDifficultyColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.question.question,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHintsSection() {
    return Card(
      color: Colors.blue.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Colors.blue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Hints',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...visibleHints.map((hint) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $hint',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: widget.question.options.length,
      itemBuilder: (context, index) {
        final option = widget.question.options[index];
        final isSelected = selectedAnswer == option;

        return Card(
          elevation: isSelected ? 4 : 1,
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
          child: InkWell(
            onTap: () {
              setState(() {
                selectedAnswer = option;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + index), // A, B, C, D
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExplanationCard() {
    return Card(
      color: Colors.green.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Explanation',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.question.explanation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (!showExplanation) ...[
          Row(
            children: [
              if (widget.question.hints.isNotEmpty && hintsUsed < widget.question.hints.length)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showNextHint,
                    icon: const Icon(Icons.lightbulb_outline),
                    label: Text('Hint (${hintsUsed + 1}/${widget.question.hints.length})'),
                  ),
                ),
              if (widget.question.hints.isNotEmpty && hintsUsed < widget.question.hints.length)
                const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: selectedAnswer != null ? _submitAnswer : null,
                  icon: const Icon(Icons.check),
                  label: const Text('Submit Answer'),
                ),
              ),
            ],
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                widget.onAnswerSubmitted(selectedAnswer!, hintsUsed);
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Continue'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showNextHint() {
    if (hintsUsed < widget.question.hints.length) {
      setState(() {
        visibleHints.add(widget.question.hints[hintsUsed]);
        hintsUsed++;
      });
    }
  }

  void _submitAnswer() {
    if (selectedAnswer != null) {
      setState(() {
        showExplanation = true;
      });
    }
  }

  Color _getTopicColor() {
    switch (widget.question.topic) {
      case 'arithmetic':
        return Colors.blue;
      case 'fractions':
        return Colors.orange;
      case 'geometry':
        return Colors.green;
      case 'algebra':
        return Colors.purple;
      case 'percentages':
        return Colors.teal;
      case 'special':
        return Colors.amber;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Color _getDifficultyColor() {
    switch (widget.question.difficulty) {
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