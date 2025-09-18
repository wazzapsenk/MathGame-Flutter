import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';

class LanguageSelectionDialog extends ConsumerWidget {
  const LanguageSelectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.language),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // System default option
          RadioListTile<Locale?>(
            title: Text(AppLocalizations.of(context)!.themeOptionSystem),
            subtitle: const Text('Use device language'),
            value: null,
            groupValue: currentLocale,
            onChanged: (locale) {
              localeNotifier.setLocale(locale);
              Navigator.of(context).pop();
            },
          ),
          const Divider(),
          // Supported locales
          ...LocaleNotifier.supportedLocales.map((locale) {
            return RadioListTile<Locale?>(
              title: Text(localeNotifier.getLocaleName(locale)),
              value: locale,
              groupValue: currentLocale,
              onChanged: (selectedLocale) {
                localeNotifier.setLocale(selectedLocale);
                Navigator.of(context).pop();
              },
            );
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
      ],
    );
  }
}