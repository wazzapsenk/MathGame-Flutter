import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../navigation/app_router.dart';
import '../widgets/language_selection_dialog.dart';
import '../../data/providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Assessment', // TODO: Add to localizations
            [
              _SettingsTile(
                icon: Icons.quiz,
                title: AppLocalizations.of(context)!.skillAssessmentTest,
                subtitle: AppLocalizations.of(context)!.placementTestDescription,
                onTap: () => context.push(AppRouter.placementTest),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            AppLocalizations.of(context)!.preferencesSection,
            [
              _SettingsTile(
                icon: Icons.palette,
                title: AppLocalizations.of(context)!.theme,
                subtitle: 'Light, Dark, or System', // TODO: Add to localizations
                trailing: Text(AppLocalizations.of(context)!.themeOptionSystem),
                onTap: () {
                  // TODO: Implement theme selection
                },
              ),
              _SettingsTile(
                icon: Icons.language,
                title: AppLocalizations.of(context)!.language,
                subtitle: 'Change app language', // TODO: Add to localizations
                trailing: Consumer(builder: (context, ref, child) {
                  final localeNotifier = ref.read(localeProvider.notifier);
                  return Text(localeNotifier.getCurrentLocaleName());
                }),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const LanguageSelectionDialog(),
                  );
                },
              ),
              _SettingsTile(
                icon: Icons.accessibility,
                title: AppLocalizations.of(context)!.accessibilityFeatures,
                subtitle: 'Text-to-speech and more', // TODO: Add to localizations
                onTap: () => context.push(AppRouter.accessibilitySettings),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Progress', // TODO: Add to localizations
            [
              _SettingsTile(
                icon: Icons.refresh,
                title: 'Reset Progress', // TODO: Add to localizations
                subtitle: 'Clear all data and start over', // TODO: Add to localizations
                onTap: () => _showResetDialog(context),
                trailing: const Icon(Icons.warning, color: Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            AppLocalizations.of(context)!.aboutSection,
            [
              _SettingsTile(
                icon: Icons.info,
                title: AppLocalizations.of(context)!.aboutApp,
                subtitle: '${AppLocalizations.of(context)!.version} 1.0.0',
                onTap: () {
                  // TODO: Show about dialog
                },
              ),
              _SettingsTile(
                icon: Icons.privacy_tip,
                title: AppLocalizations.of(context)!.privacyPolicy,
                subtitle: 'How we protect your data', // TODO: Add to localizations
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Progress'), // TODO: Add to localizations
        content: Text(
          AppLocalizations.of(context)!.confirmResetProgress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement reset functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Progress reset feature coming soon!')), // TODO: Add to localizations
              );
            },
            child: Text('Reset', style: TextStyle(color: Colors.red)), // TODO: Add to localizations
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}