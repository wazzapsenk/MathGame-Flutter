import '../models/question.dart';

class QuestionRepository {
  static final List<Question> _placementTestQuestions = [
    // Beginner Level (Grade 1-2)
    Question(
      id: 'pt_001',
      topic: 'arithmetic',
      type: QuestionType.multipleChoice,
      difficulty: DifficultyLevel.beginner,
      question: '3 + 2 = ?',
      options: ['4', '5', '6', '7'],
      correctAnswer: '5',
      explanation: 'When we add 3 and 2, we get 5. Count on your fingers: 3, then add 2 more to get 5.',
      hints: ['Try counting on your fingers', 'Start with 3, then count 2 more'],
    ),
    Question(
      id: 'pt_002',
      topic: 'arithmetic',
      type: QuestionType.multipleChoice,
      difficulty: DifficultyLevel.beginner,
      question: '8 - 3 = ?',
      options: ['4', '5', '6', '11'],
      correctAnswer: '5',
      explanation: 'When we subtract 3 from 8, we get 5.',
      hints: ['Start with 8 and count backwards 3 times', 'Use your fingers to help'],
    ),
    Question(
      id: 'pt_003',
      topic: 'arithmetic',
      type: QuestionType.multipleChoice,
      difficulty: DifficultyLevel.beginner,
      question: 'Which number comes after 15?',
      options: ['14', '16', '17', '13'],
      correctAnswer: '16',
      explanation: 'Numbers go in order: 14, 15, 16, 17...',
      hints: ['Count forwards from 15', 'What is 15 + 1?'],
    ),

    // Elementary Level (Grade 3-4)
    Question(
      id: 'pt_004',
      topic: 'arithmetic',
      type: QuestionType.multipleChoice,
      difficulty: DifficultyLevel.elementary,
      question: '7 × 4 = ?',
      options: ['24', '28', '32', '21'],
      correctAnswer: '28',
      explanation: '7 × 4 = 28. You can think of it as 7 + 7 + 7 + 7 = 28.',
      hints: ['Try adding 7 four times', 'Use the multiplication table'],
    ),
    Question(
      id: 'pt_005',
      topic: 'arithmetic',
      type: QuestionType.multipleChoice,
      difficulty: DifficultyLevel.elementary,
      question: '36 ÷ 6 = ?',
      options: ['5', '6', '7', '8'],
      correctAnswer: '6',
      explanation: '36 ÷ 6 = 6. How many groups of 6 can you make from 36?',
      hints: ['How many 6s make 36?', 'Think about the multiplication table'],
    ),
    Question(
      id: 'pt_006',
      topic: 'fractions',
      type: QuestionType.multipleChoice,
      difficulty: DifficultyLevel.elementary,
      question: 'What is 1/2 + 1/4?',
      options: ['2/6', '3/4', '1/3', '2/4'],
      correctAnswer: '3/4',
      explanation: '1/2 = 2/4, so 2/4 + 1/4 = 3/4',
      hints: ['Convert 1/2 to fourths first', 'Find a common denominator'],
    ),

    // Intermediate Level (Grade 5-6)
    Question(
      id: 'pt_007',
      topic: 'fractions',
      type: QuestionType.multipleChoice,
      difficulty: DifficultyLevel.intermediate,
      question: 'What is 2/3 × 3/4?',
      options: ['6/12', '5/7', '1/2', '3/2'],
      correctAnswer: '1/2',
      explanation: '2/3 × 3/4 = (2×3)/(3×4) = 6/12 = 1/2',
      hints: ['Multiply numerators together and denominators together', 'Simplify the result'],
    ),
    Question(
      id: 'pt_008',
      topic: 'percentages',
      type: QuestionType.multipleChoice,
      difficulty: DifficultyLevel.intermediate,
      question: 'What is 25% of 80?',
      options: ['15', '20', '25', '30'],
      correctAnswer: '20',
      explanation: '25% = 1/4, so 25% of 80 = 80 ÷ 4 = 20',
      hints: ['25% is the same as 1/4', 'Find one quarter of 80'],
    ),
    Question(
      id: 'pt_009',
      topic: 'geometry',
      type: QuestionType.multipleChoice,
      difficulty: DifficultyLevel.intermediate,
      question: 'What is the area of a rectangle with length 8 and width 5?',
      options: ['13', '26', '40', '45'],
      correctAnswer: '40',
      explanation: 'Area of rectangle = length × width = 8 × 5 = 40',
      hints: ['Area = length × width', 'Multiply 8 by 5'],
    ),

    // Advanced Level (Grade 7+)
    Question(
      id: 'pt_010',
      topic: 'algebra',
      type: QuestionType.multipleChoice,
      difficulty: DifficultyLevel.advanced,
      question: 'If 3x + 5 = 20, what is x?',
      options: ['3', '4', '5', '6'],
      correctAnswer: '5',
      explanation: '3x + 5 = 20, so 3x = 15, therefore x = 5',
      hints: ['Subtract 5 from both sides first', 'Then divide by 3'],
    ),
    Question(
      id: 'pt_011',
      topic: 'ratios',
      type: QuestionType.multipleChoice,
      difficulty: DifficultyLevel.advanced,
      question: 'In a ratio of 3:4, if the first number is 15, what is the second number?',
      options: ['12', '18', '20', '24'],
      correctAnswer: '20',
      explanation: 'If 3 corresponds to 15, then the multiplier is 5. So 4 × 5 = 20',
      hints: ['Find what 3 was multiplied by to get 15', 'Apply the same multiplier to 4'],
    ),
    Question(
      id: 'pt_012',
      topic: 'probability',
      type: QuestionType.multipleChoice,
      difficulty: DifficultyLevel.advanced,
      question: 'What is the probability of rolling a 6 on a fair six-sided die?',
      options: ['1/2', '1/3', '1/6', '1/12'],
      correctAnswer: '1/6',
      explanation: 'There is 1 way to roll a 6 out of 6 possible outcomes, so probability = 1/6',
      hints: ['How many sides have a 6?', 'How many total sides are there?'],
    ),
  ];

  static List<Question> getPlacementTestQuestions() {
    return List.from(_placementTestQuestions);
  }

  static DifficultyLevel calculateLevel(List<String> answers) {
    int score = 0;
    int beginnerCorrect = 0;
    int elementaryCorrect = 0;
    int intermediateCorrect = 0;
    int advancedCorrect = 0;

    for (int i = 0; i < _placementTestQuestions.length && i < answers.length; i++) {
      if (answers[i] == _placementTestQuestions[i].correctAnswer) {
        score++;

        switch (_placementTestQuestions[i].difficulty) {
          case DifficultyLevel.beginner:
            beginnerCorrect++;
            break;
          case DifficultyLevel.elementary:
            elementaryCorrect++;
            break;
          case DifficultyLevel.intermediate:
            intermediateCorrect++;
            break;
          case DifficultyLevel.advanced:
            advancedCorrect++;
            break;
        }
      }
    }

    // Determine level based on performance in each category
    if (advancedCorrect >= 2) {
      return DifficultyLevel.advanced;
    } else if (intermediateCorrect >= 2) {
      return DifficultyLevel.intermediate;
    } else if (elementaryCorrect >= 2) {
      return DifficultyLevel.elementary;
    } else {
      return DifficultyLevel.beginner;
    }
  }

  static List<String> getUnlockedTopics(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.beginner:
        return ['arithmetic'];
      case DifficultyLevel.elementary:
        return ['arithmetic', 'fractions'];
      case DifficultyLevel.intermediate:
        return ['arithmetic', 'fractions', 'geometry', 'percentages'];
      case DifficultyLevel.advanced:
        return ['arithmetic', 'fractions', 'geometry', 'percentages', 'algebra', 'ratios', 'probability'];
    }
  }

  static String getLevelDescription(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.beginner:
        return 'Perfect for learning basic addition and subtraction!';
      case DifficultyLevel.elementary:
        return 'Ready for multiplication, division, and simple fractions!';
      case DifficultyLevel.intermediate:
        return 'Great foundation for geometry, percentages, and advanced fractions!';
      case DifficultyLevel.advanced:
        return 'Ready for algebra, ratios, and probability concepts!';
    }
  }
}