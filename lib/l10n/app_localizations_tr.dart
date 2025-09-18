// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'ZihinMat';

  @override
  String get appDescription =>
      'Her yaş için eğitici matematik oyunu uygulaması';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get settings => 'Ayarlar';

  @override
  String get profile => 'Profil';

  @override
  String get learn => 'Öğren';

  @override
  String get practice => 'Alıştırma';

  @override
  String get arcade => 'Oyun';

  @override
  String get dailyTasks => 'Günlük Görevler';

  @override
  String get welcome => 'ZihinMat\'a Hoş Geldiniz!';

  @override
  String get welcomeMessage => 'Matematik yolculuğunuza başlayalım.';

  @override
  String get skillLevel => 'Beceri Seviyesi';

  @override
  String get beginner => 'Başlangıç';

  @override
  String get elementary => 'Temel';

  @override
  String get intermediate => 'Orta';

  @override
  String get advanced => 'İleri';

  @override
  String get level => 'Seviye';

  @override
  String get xp => 'XP';

  @override
  String get streak => 'Seri';

  @override
  String get longestStreak => 'En Uzun Seri';

  @override
  String get totalXP => 'Toplam XP';

  @override
  String get currentStreak => 'Mevcut Seri';

  @override
  String get dailyProgress => 'Günlük İlerleme';

  @override
  String tasksCompleted(int completed, int total) {
    return '$total görevden $completed tanesi tamamlandı';
  }

  @override
  String get todaysTasks => 'Bugünkü Görevler';

  @override
  String get allTasksCompleted => 'Tüm görevler tamamlandı!';

  @override
  String get comeBackTomorrow => 'Yeni zorluklar için yarın tekrar gel.';

  @override
  String get readyForChallenge => 'Bugünkü zorluğa hazır mısın?';

  @override
  String questionsSpecialProblem(int questions) {
    return '$questions soru + 1 özel problem tamamla.';
  }

  @override
  String get startDailyTask => 'Günlük Görevi Başlat';

  @override
  String get taskComplete => 'Görev Tamamlandı!';

  @override
  String get correctAnswers => 'Doğru Cevaplar:';

  @override
  String get accuracy => 'Doğruluk:';

  @override
  String get xpEarned => 'Kazanılan XP:';

  @override
  String get returnToHome => 'Ana Sayfaya Dön';

  @override
  String question(int current, int total) {
    return 'Soru $current/$total';
  }

  @override
  String get practiceModeTitle => 'Alıştırma Modu';

  @override
  String get selectTopic => 'Konu Seç';

  @override
  String get selectDifficulty => 'Zorluk Seç';

  @override
  String get selectMode => 'Mod Seç';

  @override
  String get practiceTopicArithmetic => 'Aritmetik';

  @override
  String get practiceTopicFractions => 'Kesirler';

  @override
  String get practiceTopicDecimals => 'Ondalık Sayılar';

  @override
  String get practiceTopicGeometry => 'Geometri';

  @override
  String get practiceTopicAlgebra => 'Cebir';

  @override
  String get practiceTopicMixed => 'Karışık';

  @override
  String get practiceModeEndless => 'Sonsuz';

  @override
  String get practiceModeTimed => 'Zamanlı';

  @override
  String get practiceModeTargetScore => 'Hedef Puan';

  @override
  String get timeLimit => 'Zaman Sınırı';

  @override
  String get targetScore => 'Hedef Puan';

  @override
  String get minutes => 'dakika';

  @override
  String get points => 'puan';

  @override
  String get startPractice => 'Alıştırmayı Başlat';

  @override
  String get arcadeTitle => 'Oyun';

  @override
  String get fastOperations => 'Hızlı İşlemler';

  @override
  String get fastOperationsDesc =>
      'Matematik problemlerini olabildiğince hızlı çöz!';

  @override
  String get selectDifficultyLevel => 'Zorluk Seviyesi Seç';

  @override
  String get easy => 'Kolay';

  @override
  String get medium => 'Orta';

  @override
  String get hard => 'Zor';

  @override
  String get expert => 'Uzman';

  @override
  String get start => 'Başla';

  @override
  String get gameOver => 'Oyun Bitti!';

  @override
  String get score => 'Puan';

  @override
  String get timeSpent => 'Harcanan Zaman';

  @override
  String get finalAccuracy => 'Son Doğruluk';

  @override
  String get playAgain => 'Tekrar Oyna';

  @override
  String get backToMenu => 'Menüye Dön';

  @override
  String get learnTitle => 'Öğren';

  @override
  String get workedExamples => 'Çözümlü Örnekler';

  @override
  String get basicArithmetic => 'Temel Aritmetik';

  @override
  String get fractionBasics => 'Kesir Temelleri';

  @override
  String get decimalOperations => 'Ondalık İşlemler';

  @override
  String get geometryBasics => 'Geometri Temelleri';

  @override
  String get algebraIntro => 'Cebir Giriş';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get profileSection => 'Profil';

  @override
  String get preferencesSection => 'Tercihler';

  @override
  String get supportSection => 'Destek';

  @override
  String get aboutSection => 'Hakkında';

  @override
  String get editProfile => 'Profili Düzenle';

  @override
  String get skillAssessmentTest => 'Beceri Değerlendirme Testi';

  @override
  String get language => 'Dil';

  @override
  String get theme => 'Tema';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get sounds => 'Sesler';

  @override
  String get accessibilityFeatures => 'Erişilebilirlik Özellikleri';

  @override
  String get colorBlindMode => 'Renk Körlüğü Modu';

  @override
  String get textToSpeech => 'Sesli Okuma';

  @override
  String get helpCenter => 'Yardım Merkezi';

  @override
  String get contactSupport => 'Destek İletişim';

  @override
  String get aboutApp => 'Uygulama Hakkında';

  @override
  String get version => 'Sürüm';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get termsOfService => 'Hizmet Şartları';

  @override
  String get languageOptionEn => 'English';

  @override
  String get languageOptionTr => 'Türkçe';

  @override
  String get languageOptionDa => 'Dansk';

  @override
  String get themeOptionSystem => 'Sistem';

  @override
  String get themeOptionLight => 'Açık';

  @override
  String get themeOptionDark => 'Koyu';

  @override
  String get placementTestTitle => 'Beceri Değerlendirme Testi';

  @override
  String get placementTestDescription =>
      'Mevcut beceri seviyenizi belirlemek ve kişiselleştirilmiş içerik almak için bu testi alın.';

  @override
  String get takePlacementTest => 'Değerlendirme Testini Al';

  @override
  String get retakePlacementTest => 'Değerlendirme Testini Tekrarla';

  @override
  String get badges => 'Rozetler';

  @override
  String get achievements => 'Başarımlar';

  @override
  String get badgeFirstLogin => 'Hoş geldin! Matematik yolculuğuna başladın.';

  @override
  String get badgeCompletedFirstTask =>
      'Harika başlangıç! İlk günlük görevini tamamladın.';

  @override
  String get badgeStreak3 => 'Ateş gibisin! 3 günlük seriyi sürdürdün.';

  @override
  String get badgeStreak7 => 'Muhteşem! 7 günlük seriyi sürdürdün.';

  @override
  String get badgeStreak30 => 'İnanılmaz! 30 günlük seriyi sürdürdün.';

  @override
  String get badgeLevel5 => 'Yükselen yıldız! 5. seviyeye ulaştın.';

  @override
  String get badgeLevel10 => 'Matematik meraklısı! 10. seviyeye ulaştın.';

  @override
  String get badgeLevel25 => 'Matematik uzmanı! 25. seviyeye ulaştın.';

  @override
  String get badgeFastOperationsWin =>
      'Hız canavarı! Hızlı İşlemler oyununu kazandın.';

  @override
  String get badgePerfectScore => 'Mükemmeliyetçi! %100 doğruluk elde ettin.';

  @override
  String get hints => 'İpuçları';

  @override
  String get showHint => 'İpucu Göster';

  @override
  String get nextQuestion => 'Sonraki Soru';

  @override
  String get submit => 'Gönder';

  @override
  String get skip => 'Atla';

  @override
  String get tryAgain => 'Tekrar Dene';

  @override
  String get continueButton => 'Devam Et';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get edit => 'Düzenle';

  @override
  String get delete => 'Sil';

  @override
  String get confirm => 'Onayla';

  @override
  String get close => 'Kapat';

  @override
  String get errorConnectionError =>
      'Bağlantı hatası. Lütfen internet bağlantınızı kontrol edin.';

  @override
  String get errorDataLoadError =>
      'Veri yükleme hatası. Lütfen tekrar deneyin.';

  @override
  String get errorSavingError => 'Veri kaydetme hatası. Lütfen tekrar deneyin.';

  @override
  String get errorInvalidInput =>
      'Geçersiz giriş. Lütfen girişinizi kontrol edin.';

  @override
  String get errorTimeout =>
      'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.';

  @override
  String get confirmExitGame =>
      'Oyundan çıkmak istediğinizden emin misiniz? İlerlemeniz kaybolacak.';

  @override
  String get confirmResetProgress =>
      'Tüm ilerlemeyi sıfırlamak istediğinizden emin misiniz? Bu işlem geri alınamaz.';

  @override
  String get confirmDeleteProfile =>
      'Profilinizi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get pleaseWait => 'Lütfen bekleyin...';

  @override
  String get noDataAvailable => 'Veri bulunamadı';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get refresh => 'Yenile';

  @override
  String timeRemaining(String time) {
    return 'Kalan Zaman: $time';
  }

  @override
  String currentScore(int score) {
    return 'Mevcut Puan: $score';
  }

  @override
  String get mathTopicAddition => 'Toplama';

  @override
  String get mathTopicSubtraction => 'Çıkarma';

  @override
  String get mathTopicMultiplication => 'Çarpma';

  @override
  String get mathTopicDivision => 'Bölme';

  @override
  String get mathTopicFractions => 'Kesirler';

  @override
  String get mathTopicDecimals => 'Ondalık Sayılar';

  @override
  String get mathTopicPercentages => 'Yüzdeler';

  @override
  String get mathTopicGeometry => 'Geometri';

  @override
  String get mathTopicAlgebra => 'Cebir';
}
