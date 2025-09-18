// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'MatematikSind';

  @override
  String get appDescription => 'Uddannelses matematik spil app til alle aldre';

  @override
  String get home => 'Hjem';

  @override
  String get settings => 'Indstillinger';

  @override
  String get profile => 'Profil';

  @override
  String get learn => 'Lær';

  @override
  String get practice => 'Øv';

  @override
  String get arcade => 'Arkade';

  @override
  String get dailyTasks => 'Daglige Opgaver';

  @override
  String get welcome => 'Velkommen til MatematikSind!';

  @override
  String get welcomeMessage => 'Lad os starte din matematiske rejse.';

  @override
  String get skillLevel => 'Færdighedsniveau';

  @override
  String get beginner => 'Begynder';

  @override
  String get elementary => 'Grundlæggende';

  @override
  String get intermediate => 'Mellemliggende';

  @override
  String get advanced => 'Avanceret';

  @override
  String get level => 'Niveau';

  @override
  String get xp => 'XP';

  @override
  String get streak => 'Streak';

  @override
  String get longestStreak => 'Længste Streak';

  @override
  String get totalXP => 'Total XP';

  @override
  String get currentStreak => 'Nuværende Streak';

  @override
  String get dailyProgress => 'Daglig Fremgang';

  @override
  String tasksCompleted(int completed, int total) {
    return '$completed af $total opgaver fuldført';
  }

  @override
  String get todaysTasks => 'Dagens Opgaver';

  @override
  String get allTasksCompleted => 'Alle opgaver fuldført!';

  @override
  String get comeBackTomorrow => 'Kom tilbage i morgen for nye udfordringer.';

  @override
  String get readyForChallenge => 'Klar til dagens udfordring?';

  @override
  String questionsSpecialProblem(int questions) {
    return 'Fuldfør $questions spørgsmål + 1 særligt problem.';
  }

  @override
  String get startDailyTask => 'Start Daglig Opgave';

  @override
  String get taskComplete => 'Opgave Fuldført!';

  @override
  String get correctAnswers => 'Korrekte Svar:';

  @override
  String get accuracy => 'Nøjagtighed:';

  @override
  String get xpEarned => 'XP Optjent:';

  @override
  String get returnToHome => 'Tilbage til Hjem';

  @override
  String question(int current, int total) {
    return 'Spørgsmål $current/$total';
  }

  @override
  String get practiceModeTitle => 'Øvelses Tilstand';

  @override
  String get selectTopic => 'Vælg Emne';

  @override
  String get selectDifficulty => 'Vælg Sværhedsgrad';

  @override
  String get selectMode => 'Vælg Tilstand';

  @override
  String get practiceTopicArithmetic => 'Aritmetik';

  @override
  String get practiceTopicFractions => 'Brøker';

  @override
  String get practiceTopicDecimals => 'Decimaler';

  @override
  String get practiceTopicGeometry => 'Geometri';

  @override
  String get practiceTopicAlgebra => 'Algebra';

  @override
  String get practiceTopicMixed => 'Blandet';

  @override
  String get practiceModeEndless => 'Uendelig';

  @override
  String get practiceModeTimed => 'Tidsbestemt';

  @override
  String get practiceModeTargetScore => 'Mål Score';

  @override
  String get timeLimit => 'Tidsgrænse';

  @override
  String get targetScore => 'Mål Score';

  @override
  String get minutes => 'minutter';

  @override
  String get points => 'point';

  @override
  String get startPractice => 'Start Øvelse';

  @override
  String get arcadeTitle => 'Arkade';

  @override
  String get fastOperations => 'Hurtige Operationer';

  @override
  String get fastOperationsDesc =>
      'Løs matematik problemer så hurtigt som muligt!';

  @override
  String get selectDifficultyLevel => 'Vælg Sværhedsgrad';

  @override
  String get easy => 'Let';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Svær';

  @override
  String get expert => 'Ekspert';

  @override
  String get start => 'Start';

  @override
  String get gameOver => 'Spil Slut!';

  @override
  String get score => 'Score';

  @override
  String get timeSpent => 'Tid Brugt';

  @override
  String get finalAccuracy => 'Endelig Nøjagtighed';

  @override
  String get playAgain => 'Spil Igen';

  @override
  String get backToMenu => 'Tilbage til Menu';

  @override
  String get learnTitle => 'Lær';

  @override
  String get workedExamples => 'Løste Eksempler';

  @override
  String get basicArithmetic => 'Grundlæggende Aritmetik';

  @override
  String get fractionBasics => 'Brøk Grundlag';

  @override
  String get decimalOperations => 'Decimal Operationer';

  @override
  String get geometryBasics => 'Geometri Grundlag';

  @override
  String get algebraIntro => 'Algebra Introduktion';

  @override
  String get settingsTitle => 'Indstillinger';

  @override
  String get profileSection => 'Profil';

  @override
  String get preferencesSection => 'Præferencer';

  @override
  String get supportSection => 'Support';

  @override
  String get aboutSection => 'Om';

  @override
  String get editProfile => 'Rediger Profil';

  @override
  String get skillAssessmentTest => 'Færdigheds Vurderings Test';

  @override
  String get language => 'Sprog';

  @override
  String get theme => 'Tema';

  @override
  String get notifications => 'Notifikationer';

  @override
  String get sounds => 'Lyde';

  @override
  String get accessibilityFeatures => 'Tilgængeligheds Funktioner';

  @override
  String get colorBlindMode => 'Farveblind Tilstand';

  @override
  String get textToSpeech => 'Tekst til Tale';

  @override
  String get helpCenter => 'Hjælp Center';

  @override
  String get contactSupport => 'Kontakt Support';

  @override
  String get aboutApp => 'Om App';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privatlivspolitik';

  @override
  String get termsOfService => 'Servicevilkår';

  @override
  String get languageOptionEn => 'English';

  @override
  String get languageOptionTr => 'Türkçe';

  @override
  String get languageOptionDa => 'Dansk';

  @override
  String get themeOptionSystem => 'System';

  @override
  String get themeOptionLight => 'Lys';

  @override
  String get themeOptionDark => 'Mørk';

  @override
  String get placementTestTitle => 'Færdigheds Vurderings Test';

  @override
  String get placementTestDescription =>
      'Tag denne test for at bestemme dit nuværende færdighedsniveau og få personligt indhold.';

  @override
  String get takePlacementTest => 'Tag Vurderings Test';

  @override
  String get retakePlacementTest => 'Gentag Vurderings Test';

  @override
  String get badges => 'Badges';

  @override
  String get achievements => 'Præstationer';

  @override
  String get badgeFirstLogin =>
      'Velkommen! Du har startet din matematik rejse.';

  @override
  String get badgeCompletedFirstTask =>
      'Fantastisk start! Du fuldførte din første daglige opgave.';

  @override
  String get badgeStreak3 => 'I brand! Du opretholdt en 3-dages streak.';

  @override
  String get badgeStreak7 => 'Fantastisk! Du opretholdt en 7-dages streak.';

  @override
  String get badgeStreak30 => 'Utroligt! Du opretholdt en 30-dages streak.';

  @override
  String get badgeLevel5 => 'Stigende stjerne! Du nåede niveau 5.';

  @override
  String get badgeLevel10 => 'Matematik entusiast! Du nåede niveau 10.';

  @override
  String get badgeLevel25 => 'Matematik ekspert! Du nåede niveau 25.';

  @override
  String get badgeFastOperationsWin =>
      'Hastighedsdæmon! Du vandt et Hurtige Operationer spil.';

  @override
  String get badgePerfectScore => 'Perfektionist! Du opnåede 100% nøjagtighed.';

  @override
  String get hints => 'Hints';

  @override
  String get showHint => 'Vis Hint';

  @override
  String get nextQuestion => 'Næste Spørgsmål';

  @override
  String get submit => 'Indsend';

  @override
  String get skip => 'Spring Over';

  @override
  String get tryAgain => 'Prøv Igen';

  @override
  String get continueButton => 'Fortsæt';

  @override
  String get cancel => 'Annuller';

  @override
  String get save => 'Gem';

  @override
  String get edit => 'Rediger';

  @override
  String get delete => 'Slet';

  @override
  String get confirm => 'Bekræft';

  @override
  String get close => 'Luk';

  @override
  String get errorConnectionError =>
      'Forbindelsesfejl. Tjek venligst din internetforbindelse.';

  @override
  String get errorDataLoadError =>
      'Fejl ved indlæsning af data. Prøv venligst igen.';

  @override
  String get errorSavingError =>
      'Fejl ved gemning af data. Prøv venligst igen.';

  @override
  String get errorInvalidInput =>
      'Ugyldigt input. Tjek venligst din indtastning.';

  @override
  String get errorTimeout => 'Anmodning fik timeout. Prøv venligst igen.';

  @override
  String get confirmExitGame =>
      'Er du sikker på, at du vil forlade spillet? Dit fremskridt vil gå tabt.';

  @override
  String get confirmResetProgress =>
      'Er du sikker på, at du vil nulstille alle fremskridt? Denne handling kan ikke fortrydes.';

  @override
  String get confirmDeleteProfile =>
      'Er du sikker på, at du vil slette din profil? Denne handling kan ikke fortrydes.';

  @override
  String get loading => 'Indlæser...';

  @override
  String get pleaseWait => 'Vent venligst...';

  @override
  String get noDataAvailable => 'Ingen data tilgængelig';

  @override
  String get retry => 'Prøv Igen';

  @override
  String get refresh => 'Opdater';

  @override
  String timeRemaining(String time) {
    return 'Resterende Tid: $time';
  }

  @override
  String currentScore(int score) {
    return 'Nuværende Score: $score';
  }

  @override
  String get mathTopicAddition => 'Addition';

  @override
  String get mathTopicSubtraction => 'Subtraktion';

  @override
  String get mathTopicMultiplication => 'Multiplikation';

  @override
  String get mathTopicDivision => 'Division';

  @override
  String get mathTopicFractions => 'Brøker';

  @override
  String get mathTopicDecimals => 'Decimaler';

  @override
  String get mathTopicPercentages => 'Procenter';

  @override
  String get mathTopicGeometry => 'Geometri';

  @override
  String get mathTopicAlgebra => 'Algebra';
}
