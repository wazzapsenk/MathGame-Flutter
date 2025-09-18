import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_da.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('da'),
    Locale('en'),
    Locale('tr'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'MindMath'**
  String get appTitle;

  /// A short description of the app
  ///
  /// In en, this message translates to:
  /// **'Educational math game app for all ages'**
  String get appDescription;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// No description provided for @arcade.
  ///
  /// In en, this message translates to:
  /// **'Arcade'**
  String get arcade;

  /// No description provided for @dailyTasks.
  ///
  /// In en, this message translates to:
  /// **'Daily Tasks'**
  String get dailyTasks;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to MindMath!'**
  String get welcome;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start your mathematical journey.'**
  String get welcomeMessage;

  /// No description provided for @skillLevel.
  ///
  /// In en, this message translates to:
  /// **'Skill Level'**
  String get skillLevel;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @elementary.
  ///
  /// In en, this message translates to:
  /// **'Elementary'**
  String get elementary;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @xp.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get xp;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Streak'**
  String get longestStreak;

  /// No description provided for @totalXP.
  ///
  /// In en, this message translates to:
  /// **'Total XP'**
  String get totalXP;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @dailyProgress.
  ///
  /// In en, this message translates to:
  /// **'Daily Progress'**
  String get dailyProgress;

  /// Shows how many tasks are completed out of total
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} tasks completed'**
  String tasksCompleted(int completed, int total);

  /// No description provided for @todaysTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tasks'**
  String get todaysTasks;

  /// No description provided for @allTasksCompleted.
  ///
  /// In en, this message translates to:
  /// **'All tasks completed!'**
  String get allTasksCompleted;

  /// No description provided for @comeBackTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Come back tomorrow for new challenges.'**
  String get comeBackTomorrow;

  /// No description provided for @readyForChallenge.
  ///
  /// In en, this message translates to:
  /// **'Ready for today\'s challenge?'**
  String get readyForChallenge;

  /// Description of daily task structure
  ///
  /// In en, this message translates to:
  /// **'Complete {questions} questions + 1 special problem.'**
  String questionsSpecialProblem(int questions);

  /// No description provided for @startDailyTask.
  ///
  /// In en, this message translates to:
  /// **'Start Daily Task'**
  String get startDailyTask;

  /// No description provided for @taskComplete.
  ///
  /// In en, this message translates to:
  /// **'Task Complete!'**
  String get taskComplete;

  /// No description provided for @correctAnswers.
  ///
  /// In en, this message translates to:
  /// **'Correct Answers:'**
  String get correctAnswers;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy:'**
  String get accuracy;

  /// No description provided for @xpEarned.
  ///
  /// In en, this message translates to:
  /// **'XP Earned:'**
  String get xpEarned;

  /// No description provided for @returnToHome.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get returnToHome;

  /// Shows current question number
  ///
  /// In en, this message translates to:
  /// **'Question {current}/{total}'**
  String question(int current, int total);

  /// No description provided for @practiceModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice Mode'**
  String get practiceModeTitle;

  /// No description provided for @selectTopic.
  ///
  /// In en, this message translates to:
  /// **'Select Topic'**
  String get selectTopic;

  /// No description provided for @selectDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Select Difficulty'**
  String get selectDifficulty;

  /// No description provided for @selectMode.
  ///
  /// In en, this message translates to:
  /// **'Select Mode'**
  String get selectMode;

  /// No description provided for @practiceTopicArithmetic.
  ///
  /// In en, this message translates to:
  /// **'Arithmetic'**
  String get practiceTopicArithmetic;

  /// No description provided for @practiceTopicFractions.
  ///
  /// In en, this message translates to:
  /// **'Fractions'**
  String get practiceTopicFractions;

  /// No description provided for @practiceTopicDecimals.
  ///
  /// In en, this message translates to:
  /// **'Decimals'**
  String get practiceTopicDecimals;

  /// No description provided for @practiceTopicGeometry.
  ///
  /// In en, this message translates to:
  /// **'Geometry'**
  String get practiceTopicGeometry;

  /// No description provided for @practiceTopicAlgebra.
  ///
  /// In en, this message translates to:
  /// **'Algebra'**
  String get practiceTopicAlgebra;

  /// No description provided for @practiceTopicMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get practiceTopicMixed;

  /// No description provided for @practiceModeEndless.
  ///
  /// In en, this message translates to:
  /// **'Endless'**
  String get practiceModeEndless;

  /// No description provided for @practiceModeTimed.
  ///
  /// In en, this message translates to:
  /// **'Timed'**
  String get practiceModeTimed;

  /// No description provided for @practiceModeTargetScore.
  ///
  /// In en, this message translates to:
  /// **'Target Score'**
  String get practiceModeTargetScore;

  /// No description provided for @timeLimit.
  ///
  /// In en, this message translates to:
  /// **'Time Limit'**
  String get timeLimit;

  /// No description provided for @targetScore.
  ///
  /// In en, this message translates to:
  /// **'Target Score'**
  String get targetScore;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// No description provided for @startPractice.
  ///
  /// In en, this message translates to:
  /// **'Start Practice'**
  String get startPractice;

  /// No description provided for @arcadeTitle.
  ///
  /// In en, this message translates to:
  /// **'Arcade'**
  String get arcadeTitle;

  /// No description provided for @fastOperations.
  ///
  /// In en, this message translates to:
  /// **'Fast Operations'**
  String get fastOperations;

  /// No description provided for @fastOperationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve math problems as fast as you can!'**
  String get fastOperationsDesc;

  /// No description provided for @selectDifficultyLevel.
  ///
  /// In en, this message translates to:
  /// **'Select Difficulty Level'**
  String get selectDifficultyLevel;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @expert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get expert;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over!'**
  String get gameOver;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @timeSpent.
  ///
  /// In en, this message translates to:
  /// **'Time Spent'**
  String get timeSpent;

  /// No description provided for @finalAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Final Accuracy'**
  String get finalAccuracy;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @backToMenu.
  ///
  /// In en, this message translates to:
  /// **'Back to Menu'**
  String get backToMenu;

  /// No description provided for @learnTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learnTitle;

  /// No description provided for @workedExamples.
  ///
  /// In en, this message translates to:
  /// **'Worked Examples'**
  String get workedExamples;

  /// No description provided for @basicArithmetic.
  ///
  /// In en, this message translates to:
  /// **'Basic Arithmetic'**
  String get basicArithmetic;

  /// No description provided for @fractionBasics.
  ///
  /// In en, this message translates to:
  /// **'Fraction Basics'**
  String get fractionBasics;

  /// No description provided for @decimalOperations.
  ///
  /// In en, this message translates to:
  /// **'Decimal Operations'**
  String get decimalOperations;

  /// No description provided for @geometryBasics.
  ///
  /// In en, this message translates to:
  /// **'Geometry Basics'**
  String get geometryBasics;

  /// No description provided for @algebraIntro.
  ///
  /// In en, this message translates to:
  /// **'Algebra Introduction'**
  String get algebraIntro;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @profileSection.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileSection;

  /// No description provided for @preferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesSection;

  /// No description provided for @supportSection.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportSection;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @skillAssessmentTest.
  ///
  /// In en, this message translates to:
  /// **'Skill Assessment Test'**
  String get skillAssessmentTest;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @sounds.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get sounds;

  /// No description provided for @accessibilityFeatures.
  ///
  /// In en, this message translates to:
  /// **'Accessibility Features'**
  String get accessibilityFeatures;

  /// No description provided for @colorBlindMode.
  ///
  /// In en, this message translates to:
  /// **'Color Blind Mode'**
  String get colorBlindMode;

  /// No description provided for @textToSpeech.
  ///
  /// In en, this message translates to:
  /// **'Text to Speech'**
  String get textToSpeech;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @languageOptionEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageOptionEn;

  /// No description provided for @languageOptionTr.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageOptionTr;

  /// No description provided for @languageOptionDa.
  ///
  /// In en, this message translates to:
  /// **'Dansk'**
  String get languageOptionDa;

  /// No description provided for @themeOptionSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeOptionSystem;

  /// No description provided for @themeOptionLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeOptionLight;

  /// No description provided for @themeOptionDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeOptionDark;

  /// No description provided for @placementTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Skill Assessment Test'**
  String get placementTestTitle;

  /// No description provided for @placementTestDescription.
  ///
  /// In en, this message translates to:
  /// **'Take this test to determine your current skill level and get personalized content.'**
  String get placementTestDescription;

  /// No description provided for @takePlacementTest.
  ///
  /// In en, this message translates to:
  /// **'Take Assessment Test'**
  String get takePlacementTest;

  /// No description provided for @retakePlacementTest.
  ///
  /// In en, this message translates to:
  /// **'Retake Assessment Test'**
  String get retakePlacementTest;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @badgeFirstLogin.
  ///
  /// In en, this message translates to:
  /// **'Welcome! You\'ve started your math journey.'**
  String get badgeFirstLogin;

  /// No description provided for @badgeCompletedFirstTask.
  ///
  /// In en, this message translates to:
  /// **'Great start! You completed your first daily task.'**
  String get badgeCompletedFirstTask;

  /// No description provided for @badgeStreak3.
  ///
  /// In en, this message translates to:
  /// **'On fire! You maintained a 3-day streak.'**
  String get badgeStreak3;

  /// No description provided for @badgeStreak7.
  ///
  /// In en, this message translates to:
  /// **'Amazing! You maintained a 7-day streak.'**
  String get badgeStreak7;

  /// No description provided for @badgeStreak30.
  ///
  /// In en, this message translates to:
  /// **'Incredible! You maintained a 30-day streak.'**
  String get badgeStreak30;

  /// No description provided for @badgeLevel5.
  ///
  /// In en, this message translates to:
  /// **'Rising star! You reached level 5.'**
  String get badgeLevel5;

  /// No description provided for @badgeLevel10.
  ///
  /// In en, this message translates to:
  /// **'Math enthusiast! You reached level 10.'**
  String get badgeLevel10;

  /// No description provided for @badgeLevel25.
  ///
  /// In en, this message translates to:
  /// **'Math expert! You reached level 25.'**
  String get badgeLevel25;

  /// No description provided for @badgeFastOperationsWin.
  ///
  /// In en, this message translates to:
  /// **'Speed demon! You won a Fast Operations game.'**
  String get badgeFastOperationsWin;

  /// No description provided for @badgePerfectScore.
  ///
  /// In en, this message translates to:
  /// **'Perfectionist! You achieved 100% accuracy.'**
  String get badgePerfectScore;

  /// No description provided for @hints.
  ///
  /// In en, this message translates to:
  /// **'Hints'**
  String get hints;

  /// No description provided for @showHint.
  ///
  /// In en, this message translates to:
  /// **'Show Hint'**
  String get showHint;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get nextQuestion;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @errorConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please check your internet connection.'**
  String get errorConnectionError;

  /// No description provided for @errorDataLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading data. Please try again.'**
  String get errorDataLoadError;

  /// No description provided for @errorSavingError.
  ///
  /// In en, this message translates to:
  /// **'Error saving data. Please try again.'**
  String get errorSavingError;

  /// No description provided for @errorInvalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input. Please check your entry.'**
  String get errorInvalidInput;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get errorTimeout;

  /// No description provided for @confirmExitGame.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the game? Your progress will be lost.'**
  String get confirmExitGame;

  /// No description provided for @confirmResetProgress.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all progress? This action cannot be undone.'**
  String get confirmResetProgress;

  /// No description provided for @confirmDeleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your profile? This action cannot be undone.'**
  String get confirmDeleteProfile;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Shows remaining time
  ///
  /// In en, this message translates to:
  /// **'Time Remaining: {time}'**
  String timeRemaining(String time);

  /// Shows current score
  ///
  /// In en, this message translates to:
  /// **'Current Score: {score}'**
  String currentScore(int score);

  /// No description provided for @mathTopicAddition.
  ///
  /// In en, this message translates to:
  /// **'Addition'**
  String get mathTopicAddition;

  /// No description provided for @mathTopicSubtraction.
  ///
  /// In en, this message translates to:
  /// **'Subtraction'**
  String get mathTopicSubtraction;

  /// No description provided for @mathTopicMultiplication.
  ///
  /// In en, this message translates to:
  /// **'Multiplication'**
  String get mathTopicMultiplication;

  /// No description provided for @mathTopicDivision.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get mathTopicDivision;

  /// No description provided for @mathTopicFractions.
  ///
  /// In en, this message translates to:
  /// **'Fractions'**
  String get mathTopicFractions;

  /// No description provided for @mathTopicDecimals.
  ///
  /// In en, this message translates to:
  /// **'Decimals'**
  String get mathTopicDecimals;

  /// No description provided for @mathTopicPercentages.
  ///
  /// In en, this message translates to:
  /// **'Percentages'**
  String get mathTopicPercentages;

  /// No description provided for @mathTopicGeometry.
  ///
  /// In en, this message translates to:
  /// **'Geometry'**
  String get mathTopicGeometry;

  /// No description provided for @mathTopicAlgebra.
  ///
  /// In en, this message translates to:
  /// **'Algebra'**
  String get mathTopicAlgebra;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['da', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'da':
      return AppLocalizationsDa();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
