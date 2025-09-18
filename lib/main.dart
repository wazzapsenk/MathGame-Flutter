import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/themes/app_theme.dart';
import 'presentation/navigation/app_router.dart';
import 'data/services/offline_service.dart';
import 'data/providers/locale_provider.dart';
import 'data/providers/accessibility_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize offline service
  await OfflineService.initialize();

  runApp(const ProviderScope(child: MindMathApp()));
}

class MindMathApp extends ConsumerWidget {
  const MindMathApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final accessibilityState = ref.watch(accessibilityProvider);
    final accessibilityNotifier = ref.read(accessibilityProvider.notifier);

    // Get accessible themes
    final lightTheme = AppTheme.lightTheme.copyWith(
      colorScheme: accessibilityNotifier.getAccessibleColorScheme(
        AppTheme.lightTheme.colorScheme,
      ),
    );

    final darkTheme = AppTheme.darkTheme.copyWith(
      colorScheme: accessibilityNotifier.getAccessibleColorScheme(
        AppTheme.darkTheme.colorScheme,
      ),
    );

    return MaterialApp.router(
      title: 'MindMath',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LocaleNotifier.supportedLocales,
      routerConfig: router,
      builder: (context, child) {
        // Apply accessibility font scaling
        final mediaQuery = MediaQuery.of(context);
        final scaledTextScaleFactor = accessibilityState.largeFont
            ? mediaQuery.textScaler.scale(1.2)
            : mediaQuery.textScaler.scale(1.0);

        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(scaledTextScaleFactor),
          ),
          child: child!,
        );
      },
    );
  }
}
