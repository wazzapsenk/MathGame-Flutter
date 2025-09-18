import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ColorBlindType {
  none,
  protanopia,    // Red blind
  deuteranopia,  // Green blind
  tritanopia,    // Blue blind
  monochromacy,  // Complete color blindness
}

class AccessibilityNotifier extends StateNotifier<AccessibilityState> {
  AccessibilityNotifier() : super(const AccessibilityState()) {
    _loadSettings();
  }

  static const String _colorBlindModeKey = 'color_blind_mode';
  static const String _highContrastKey = 'high_contrast';
  static const String _largeFontKey = 'large_font';
  static const String _reducedMotionKey = 'reduced_motion';
  static const String _hapticFeedbackKey = 'haptic_feedback';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final colorBlindIndex = prefs.getInt(_colorBlindModeKey) ?? 0;

    state = state.copyWith(
      colorBlindType: ColorBlindType.values[colorBlindIndex],
      highContrast: prefs.getBool(_highContrastKey) ?? false,
      largeFont: prefs.getBool(_largeFontKey) ?? false,
      reducedMotion: prefs.getBool(_reducedMotionKey) ?? false,
      hapticFeedback: prefs.getBool(_hapticFeedbackKey) ?? true,
    );
  }

  Future<void> setColorBlindType(ColorBlindType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorBlindModeKey, type.index);
    state = state.copyWith(colorBlindType: type);
  }

  Future<void> setHighContrast(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_highContrastKey, enabled);
    state = state.copyWith(highContrast: enabled);
  }

  Future<void> setLargeFont(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_largeFontKey, enabled);
    state = state.copyWith(largeFont: enabled);
  }

  Future<void> setReducedMotion(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reducedMotionKey, enabled);
    state = state.copyWith(reducedMotion: enabled);
  }

  Future<void> setHapticFeedback(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticFeedbackKey, enabled);
    state = state.copyWith(hapticFeedback: enabled);
  }

  // Color adaptation methods
  Color adaptColor(Color originalColor) {
    switch (state.colorBlindType) {
      case ColorBlindType.none:
        return originalColor;
      case ColorBlindType.protanopia:
        return _protanopiaAdaptation(originalColor);
      case ColorBlindType.deuteranopia:
        return _deuteranopiaAdaptation(originalColor);
      case ColorBlindType.tritanopia:
        return _tritanopiaAdaptation(originalColor);
      case ColorBlindType.monochromacy:
        return _monochromacyAdaptation(originalColor);
    }
  }

  Color _protanopiaAdaptation(Color color) {
    // Simulate protanopia (red blindness) by reducing red component
    final hsl = HSLColor.fromColor(color);
    if (hsl.hue >= 0 && hsl.hue <= 60) {
      // Red-orange range, shift to yellow
      return HSLColor.fromAHSL(
        hsl.alpha,
        60,
        hsl.saturation * 0.8,
        hsl.lightness,
      ).toColor();
    } else if (hsl.hue >= 300 && hsl.hue <= 360) {
      // Red-purple range, shift to blue
      return HSLColor.fromAHSL(
        hsl.alpha,
        240,
        hsl.saturation * 0.8,
        hsl.lightness,
      ).toColor();
    }
    return color;
  }

  Color _deuteranopiaAdaptation(Color color) {
    // Simulate deuteranopia (green blindness) by adjusting green component
    final hsl = HSLColor.fromColor(color);
    if (hsl.hue >= 60 && hsl.hue <= 180) {
      // Green range, shift to blue or yellow
      final newHue = hsl.hue < 120 ? 60.0 : 240.0; // Yellow or blue
      return HSLColor.fromAHSL(
        hsl.alpha,
        newHue,
        hsl.saturation * 0.8,
        hsl.lightness,
      ).toColor();
    }
    return color;
  }

  Color _tritanopiaAdaptation(Color color) {
    // Simulate tritanopia (blue blindness) by adjusting blue component
    final hsl = HSLColor.fromColor(color);
    if (hsl.hue >= 180 && hsl.hue <= 300) {
      // Blue-purple range, shift to green or red
      final newHue = hsl.hue < 240 ? 120.0 : 0.0; // Green or red
      return HSLColor.fromAHSL(
        hsl.alpha,
        newHue,
        hsl.saturation * 0.8,
        hsl.lightness,
      ).toColor();
    }
    return color;
  }

  Color _monochromacyAdaptation(Color color) {
    // Convert to grayscale using newer Color API
    final colorValue = color.value;
    final red = (colorValue >> 16) & 0xFF;
    final green = (colorValue >> 8) & 0xFF;
    final blue = colorValue & 0xFF;
    final alpha = (colorValue >> 24) & 0xFF;

    final gray = (red * 0.299 + green * 0.587 + blue * 0.114).round();
    return Color.fromARGB(alpha, gray, gray, gray);
  }

  // High contrast color adjustments
  Color getContrastColor(Color backgroundColor) {
    if (!state.highContrast) return backgroundColor;

    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  // Font size adjustments
  double getFontSize(double baseSize) {
    return state.largeFont ? baseSize * 1.2 : baseSize;
  }

  // Animation duration adjustments
  Duration getAnimationDuration(Duration baseDuration) {
    return state.reducedMotion ? Duration.zero : baseDuration;
  }

  // Get accessible color scheme
  ColorScheme getAccessibleColorScheme(ColorScheme baseScheme) {
    if (state.colorBlindType == ColorBlindType.none && !state.highContrast) {
      return baseScheme;
    }

    return ColorScheme(
      brightness: baseScheme.brightness,
      primary: adaptColor(baseScheme.primary),
      onPrimary: state.highContrast
          ? getContrastColor(adaptColor(baseScheme.primary))
          : adaptColor(baseScheme.onPrimary),
      secondary: adaptColor(baseScheme.secondary),
      onSecondary: state.highContrast
          ? getContrastColor(adaptColor(baseScheme.secondary))
          : adaptColor(baseScheme.onSecondary),
      error: adaptColor(baseScheme.error),
      onError: state.highContrast
          ? getContrastColor(adaptColor(baseScheme.error))
          : adaptColor(baseScheme.onError),
      surface: state.highContrast
          ? (baseScheme.brightness == Brightness.light ? Colors.white : Colors.black)
          : adaptColor(baseScheme.surface),
      onSurface: state.highContrast
          ? (baseScheme.brightness == Brightness.light ? Colors.black : Colors.white)
          : adaptColor(baseScheme.onSurface),
      surfaceContainerHighest: state.highContrast
          ? (baseScheme.brightness == Brightness.light ? Colors.grey[100]! : Colors.grey[900]!)
          : adaptColor(baseScheme.surfaceContainerHighest),
      outline: state.highContrast
          ? (baseScheme.brightness == Brightness.light ? Colors.black : Colors.white)
          : adaptColor(baseScheme.outline),
    );
  }

  String getColorBlindTypeName(ColorBlindType type) {
    switch (type) {
      case ColorBlindType.none:
        return 'Normal Vision';
      case ColorBlindType.protanopia:
        return 'Protanopia (Red Blind)';
      case ColorBlindType.deuteranopia:
        return 'Deuteranopia (Green Blind)';
      case ColorBlindType.tritanopia:
        return 'Tritanopia (Blue Blind)';
      case ColorBlindType.monochromacy:
        return 'Monochromacy (Complete Color Blindness)';
    }
  }
}

class AccessibilityState {
  final ColorBlindType colorBlindType;
  final bool highContrast;
  final bool largeFont;
  final bool reducedMotion;
  final bool hapticFeedback;

  const AccessibilityState({
    this.colorBlindType = ColorBlindType.none,
    this.highContrast = false,
    this.largeFont = false,
    this.reducedMotion = false,
    this.hapticFeedback = true,
  });

  AccessibilityState copyWith({
    ColorBlindType? colorBlindType,
    bool? highContrast,
    bool? largeFont,
    bool? reducedMotion,
    bool? hapticFeedback,
  }) {
    return AccessibilityState(
      colorBlindType: colorBlindType ?? this.colorBlindType,
      highContrast: highContrast ?? this.highContrast,
      largeFont: largeFont ?? this.largeFont,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
    );
  }
}

final accessibilityProvider = StateNotifierProvider<AccessibilityNotifier, AccessibilityState>((ref) {
  return AccessibilityNotifier();
});