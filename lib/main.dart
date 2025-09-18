import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/themes/app_theme.dart';
import 'presentation/navigation/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MindMathApp()));
}

class MindMathApp extends ConsumerWidget {
  const MindMathApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'MindMath',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('tr', 'TR'), // Turkish
        Locale('da', 'DK'), // Danish
      ],
      routerConfig: router,
    );
  }
}
