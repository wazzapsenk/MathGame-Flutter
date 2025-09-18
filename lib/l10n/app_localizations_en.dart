// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MindMath';

  @override
  String get appDescription => 'Educational math game app for all ages';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get learn => 'Learn';

  @override
  String get practice => 'Practice';

  @override
  String get arcade => 'Arcade';

  @override
  String get dailyTasks => 'Daily Tasks';

  @override
  String get welcome => 'Welcome to MindMath!';

  @override
  String get welcomeMessage => 'Let\'s start your mathematical journey.';

  @override
  String get skillLevel => 'Skill Level';

  @override
  String get beginner => 'Beginner';

  @override
  String get elementary => 'Elementary';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get level => 'Level';

  @override
  String get xp => 'XP';

  @override
  String get streak => 'Streak';

  @override
  String get longestStreak => 'Longest Streak';

  @override
  String get totalXP => 'Total XP';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get dailyProgress => 'Daily Progress';

  @override
  String tasksCompleted(int completed, int total) {
    return '$completed of $total tasks completed';
  }

  @override
  String get todaysTasks => 'Today\'s Tasks';

  @override
  String get allTasksCompleted => 'All tasks completed!';

  @override
  String get comeBackTomorrow => 'Come back tomorrow for new challenges.';

  @override
  String get readyForChallenge => 'Ready for today\'s challenge?';

  @override
  String questionsSpecialProblem(int questions) {
    return 'Complete $questions questions + 1 special problem.';
  }

  @override
  String get startDailyTask => 'Start Daily Task';

  @override
  String get taskComplete => 'Task Complete!';

  @override
  String get correctAnswers => 'Correct Answers:';

  @override
  String get accuracy => 'Accuracy:';

  @override
  String get xpEarned => 'XP Earned:';

  @override
  String get returnToHome => 'Return to Home';

  @override
  String question(int current, int total) {
    return 'Question $current/$total';
  }

  @override
  String get practiceModeTitle => 'Practice Mode';

  @override
  String get selectTopic => 'Select Topic';

  @override
  String get selectDifficulty => 'Select Difficulty';

  @override
  String get selectMode => 'Select Mode';

  @override
  String get practiceTopicArithmetic => 'Arithmetic';

  @override
  String get practiceTopicFractions => 'Fractions';

  @override
  String get practiceTopicDecimals => 'Decimals';

  @override
  String get practiceTopicGeometry => 'Geometry';

  @override
  String get practiceTopicAlgebra => 'Algebra';

  @override
  String get practiceTopicMixed => 'Mixed';

  @override
  String get practiceModeEndless => 'Endless';

  @override
  String get practiceModeTimed => 'Timed';

  @override
  String get practiceModeTargetScore => 'Target Score';

  @override
  String get timeLimit => 'Time Limit';

  @override
  String get targetScore => 'Target Score';

  @override
  String get minutes => 'minutes';

  @override
  String get points => 'points';

  @override
  String get startPractice => 'Start Practice';

  @override
  String get arcadeTitle => 'Arcade';

  @override
  String get fastOperations => 'Fast Operations';

  @override
  String get fastOperationsDesc => 'Solve math problems as fast as you can!';

  @override
  String get selectDifficultyLevel => 'Select Difficulty Level';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get expert => 'Expert';

  @override
  String get start => 'Start';

  @override
  String get gameOver => 'Game Over!';

  @override
  String get score => 'Score';

  @override
  String get timeSpent => 'Time Spent';

  @override
  String get finalAccuracy => 'Final Accuracy';

  @override
  String get playAgain => 'Play Again';

  @override
  String get backToMenu => 'Back to Menu';

  @override
  String get learnTitle => 'Learn';

  @override
  String get workedExamples => 'Worked Examples';

  @override
  String get basicArithmetic => 'Basic Arithmetic';

  @override
  String get fractionBasics => 'Fraction Basics';

  @override
  String get decimalOperations => 'Decimal Operations';

  @override
  String get geometryBasics => 'Geometry Basics';

  @override
  String get algebraIntro => 'Algebra Introduction';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get profileSection => 'Profile';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get supportSection => 'Support';

  @override
  String get aboutSection => 'About';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get skillAssessmentTest => 'Skill Assessment Test';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get notifications => 'Notifications';

  @override
  String get sounds => 'Sounds';

  @override
  String get accessibilityFeatures => 'Accessibility Features';

  @override
  String get colorBlindMode => 'Color Blind Mode';

  @override
  String get textToSpeech => 'Text to Speech';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get aboutApp => 'About App';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get languageOptionEn => 'English';

  @override
  String get languageOptionTr => 'Türkçe';

  @override
  String get languageOptionDa => 'Dansk';

  @override
  String get themeOptionSystem => 'System';

  @override
  String get themeOptionLight => 'Light';

  @override
  String get themeOptionDark => 'Dark';

  @override
  String get placementTestTitle => 'Skill Assessment Test';

  @override
  String get placementTestDescription =>
      'Take this test to determine your current skill level and get personalized content.';

  @override
  String get takePlacementTest => 'Take Assessment Test';

  @override
  String get retakePlacementTest => 'Retake Assessment Test';

  @override
  String get badges => 'Badges';

  @override
  String get achievements => 'Achievements';

  @override
  String get badgeFirstLogin => 'Welcome! You\'ve started your math journey.';

  @override
  String get badgeCompletedFirstTask =>
      'Great start! You completed your first daily task.';

  @override
  String get badgeStreak3 => 'On fire! You maintained a 3-day streak.';

  @override
  String get badgeStreak7 => 'Amazing! You maintained a 7-day streak.';

  @override
  String get badgeStreak30 => 'Incredible! You maintained a 30-day streak.';

  @override
  String get badgeLevel5 => 'Rising star! You reached level 5.';

  @override
  String get badgeLevel10 => 'Math enthusiast! You reached level 10.';

  @override
  String get badgeLevel25 => 'Math expert! You reached level 25.';

  @override
  String get badgeFastOperationsWin =>
      'Speed demon! You won a Fast Operations game.';

  @override
  String get badgePerfectScore => 'Perfectionist! You achieved 100% accuracy.';

  @override
  String get hints => 'Hints';

  @override
  String get showHint => 'Show Hint';

  @override
  String get nextQuestion => 'Next Question';

  @override
  String get submit => 'Submit';

  @override
  String get skip => 'Skip';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get continueButton => 'Continue';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get errorConnectionError =>
      'Connection error. Please check your internet connection.';

  @override
  String get errorDataLoadError => 'Error loading data. Please try again.';

  @override
  String get errorSavingError => 'Error saving data. Please try again.';

  @override
  String get errorInvalidInput => 'Invalid input. Please check your entry.';

  @override
  String get errorTimeout => 'Request timed out. Please try again.';

  @override
  String get confirmExitGame =>
      'Are you sure you want to exit the game? Your progress will be lost.';

  @override
  String get confirmResetProgress =>
      'Are you sure you want to reset all progress? This action cannot be undone.';

  @override
  String get confirmDeleteProfile =>
      'Are you sure you want to delete your profile? This action cannot be undone.';

  @override
  String get loading => 'Loading...';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get retry => 'Retry';

  @override
  String get refresh => 'Refresh';

  @override
  String timeRemaining(String time) {
    return 'Time Remaining: $time';
  }

  @override
  String currentScore(int score) {
    return 'Current Score: $score';
  }

  @override
  String get mathTopicAddition => 'Addition';

  @override
  String get mathTopicSubtraction => 'Subtraction';

  @override
  String get mathTopicMultiplication => 'Multiplication';

  @override
  String get mathTopicDivision => 'Division';

  @override
  String get mathTopicFractions => 'Fractions';

  @override
  String get mathTopicDecimals => 'Decimals';

  @override
  String get mathTopicPercentages => 'Percentages';

  @override
  String get mathTopicGeometry => 'Geometry';

  @override
  String get mathTopicAlgebra => 'Algebra';
}
