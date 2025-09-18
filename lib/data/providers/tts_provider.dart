import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TtsNotifier extends StateNotifier<TtsState> {
  TtsNotifier() : super(const TtsState()) {
    _init();
  }

  FlutterTts? _flutterTts;

  static const String _ttsEnabledKey = 'tts_enabled';
  static const String _speechRateKey = 'speech_rate';
  static const String _speechVolumeKey = 'speech_volume';
  static const String _speechPitchKey = 'speech_pitch';

  Future<void> _init() async {
    try {
      _flutterTts = FlutterTts();
      await _loadSettings();
      await _configureTts();
    } catch (e) {
      if (kDebugMode) {
        print('TTS initialization error: $e');
      }
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    state = state.copyWith(
      isEnabled: prefs.getBool(_ttsEnabledKey) ?? true,
      rate: prefs.getDouble(_speechRateKey) ?? 0.5,
      volume: prefs.getDouble(_speechVolumeKey) ?? 1.0,
      pitch: prefs.getDouble(_speechPitchKey) ?? 1.0,
    );
  }

  Future<void> _configureTts() async {
    if (_flutterTts == null) return;

    try {
      await _flutterTts!.setLanguage('en-US');
      await _flutterTts!.setSpeechRate(state.rate);
      await _flutterTts!.setVolume(state.volume);
      await _flutterTts!.setPitch(state.pitch);

      if (!kIsWeb) {
        await _flutterTts!.setSharedInstance(true);
        await _flutterTts!.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
      }

      state = state.copyWith(isInitialized: true);
    } catch (e) {
      if (kDebugMode) {
        print('TTS configuration error: $e');
      }
    }
  }

  Future<void> speak(String text) async {
    if (!state.isEnabled || !state.isInitialized || _flutterTts == null) {
      return;
    }

    try {
      await _flutterTts!.speak(text);
    } catch (e) {
      if (kDebugMode) {
        print('TTS speak error: $e');
      }
    }
  }

  Future<void> stop() async {
    if (_flutterTts == null) return;

    try {
      await _flutterTts!.stop();
    } catch (e) {
      if (kDebugMode) {
        print('TTS stop error: $e');
      }
    }
  }

  Future<void> pause() async {
    if (_flutterTts == null) return;

    try {
      await _flutterTts!.pause();
    } catch (e) {
      if (kDebugMode) {
        print('TTS pause error: $e');
      }
    }
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ttsEnabledKey, enabled);
    state = state.copyWith(isEnabled: enabled);
  }

  Future<void> setRate(double rate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_speechRateKey, rate);
    state = state.copyWith(rate: rate);

    if (_flutterTts != null && state.isInitialized) {
      await _flutterTts!.setSpeechRate(rate);
    }
  }

  Future<void> setVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_speechVolumeKey, volume);
    state = state.copyWith(volume: volume);

    if (_flutterTts != null && state.isInitialized) {
      await _flutterTts!.setVolume(volume);
    }
  }

  Future<void> setPitch(double pitch) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_speechPitchKey, pitch);
    state = state.copyWith(pitch: pitch);

    if (_flutterTts != null && state.isInitialized) {
      await _flutterTts!.setPitch(pitch);
    }
  }

  Future<void> speakQuestion(String question) async {
    if (!state.isEnabled) return;

    // Format the question for better speech
    String formattedQuestion = question
        .replaceAll('+', ' plus ')
        .replaceAll('-', ' minus ')
        .replaceAll('*', ' times ')
        .replaceAll('×', ' times ')
        .replaceAll('/', ' divided by ')
        .replaceAll('÷', ' divided by ')
        .replaceAll('=', ' equals ')
        .replaceAll('?', '');

    await speak(formattedQuestion);
  }

  @override
  void dispose() {
    _flutterTts?.stop();
    super.dispose();
  }
}

class TtsState {
  final bool isEnabled;
  final bool isInitialized;
  final double rate;
  final double volume;
  final double pitch;

  const TtsState({
    this.isEnabled = true,
    this.isInitialized = false,
    this.rate = 0.5,
    this.volume = 1.0,
    this.pitch = 1.0,
  });

  TtsState copyWith({
    bool? isEnabled,
    bool? isInitialized,
    double? rate,
    double? volume,
    double? pitch,
  }) {
    return TtsState(
      isEnabled: isEnabled ?? this.isEnabled,
      isInitialized: isInitialized ?? this.isInitialized,
      rate: rate ?? this.rate,
      volume: volume ?? this.volume,
      pitch: pitch ?? this.pitch,
    );
  }
}

final ttsProvider = StateNotifierProvider<TtsNotifier, TtsState>((ref) {
  return TtsNotifier();
});