import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/accessibility_provider.dart';
import '../../data/providers/tts_provider.dart';
import '../../l10n/app_localizations.dart';

class AccessibilitySettingsScreen extends ConsumerWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilityState = ref.watch(accessibilityProvider);
    final accessibilityNotifier = ref.read(accessibilityProvider.notifier);
    final ttsState = ref.watch(ttsProvider);
    final ttsNotifier = ref.read(ttsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accessibilityFeatures),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            'Text-to-Speech',
            [
              SwitchListTile(
                title: const Text('Enable Text-to-Speech'),
                subtitle: const Text('Read questions and content aloud'),
                value: ttsState.isEnabled,
                onChanged: (value) => ttsNotifier.setEnabled(value),
                secondary: const Icon(Icons.record_voice_over),
              ),
              if (ttsState.isEnabled) ...[
                _buildSliderTile(
                  context,
                  'Speech Rate',
                  'How fast the voice speaks',
                  Icons.speed,
                  ttsState.rate,
                  0.1,
                  1.0,
                  (value) => ttsNotifier.setRate(value),
                ),
                _buildSliderTile(
                  context,
                  'Speech Volume',
                  'How loud the voice is',
                  Icons.volume_up,
                  ttsState.volume,
                  0.1,
                  1.0,
                  (value) => ttsNotifier.setVolume(value),
                ),
                _buildSliderTile(
                  context,
                  'Speech Pitch',
                  'How high or low the voice sounds',
                  Icons.tune,
                  ttsState.pitch,
                  0.5,
                  2.0,
                  (value) => ttsNotifier.setPitch(value),
                ),
                ListTile(
                  leading: const Icon(Icons.play_arrow),
                  title: const Text('Test Voice'),
                  subtitle: const Text('Tap to test current voice settings'),
                  onTap: () => ttsNotifier.speak('This is a test of the text to speech feature'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Vision Accessibility',
            [
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Color Blind Support'),
                subtitle: Text(accessibilityNotifier.getColorBlindTypeName(accessibilityState.colorBlindType)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showColorBlindDialog(context, ref),
              ),
              SwitchListTile(
                title: const Text('High Contrast Mode'),
                subtitle: const Text('Increase contrast for better visibility'),
                value: accessibilityState.highContrast,
                onChanged: (value) => accessibilityNotifier.setHighContrast(value),
                secondary: const Icon(Icons.contrast),
              ),
              SwitchListTile(
                title: const Text('Large Font Size'),
                subtitle: const Text('Increase text size for easier reading'),
                value: accessibilityState.largeFont,
                onChanged: (value) => accessibilityNotifier.setLargeFont(value),
                secondary: const Icon(Icons.format_size),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            'Motion & Interaction',
            [
              SwitchListTile(
                title: const Text('Reduced Motion'),
                subtitle: const Text('Minimize animations and transitions'),
                value: accessibilityState.reducedMotion,
                onChanged: (value) => accessibilityNotifier.setReducedMotion(value),
                secondary: const Icon(Icons.motion_photos_off),
              ),
              SwitchListTile(
                title: const Text('Haptic Feedback'),
                subtitle: const Text('Vibrate for button presses and actions'),
                value: accessibilityState.hapticFeedback,
                onChanged: (value) => accessibilityNotifier.setHapticFeedback(value),
                secondary: const Icon(Icons.vibration),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'About Accessibility',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'These features are designed to make MindMath more accessible to users with different needs. '
                    'Text-to-speech helps users who have difficulty reading, while color blind support and high contrast '
                    'mode assist users with visual impairments. All settings are saved and will persist between app sessions.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
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

  Widget _buildSliderTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: 20,
            label: value.toStringAsFixed(1),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _showColorBlindDialog(BuildContext context, WidgetRef ref) {
    final accessibilityState = ref.watch(accessibilityProvider);
    final accessibilityNotifier = ref.read(accessibilityProvider.notifier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Color Blind Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ColorBlindType.values.map((type) {
            return RadioListTile<ColorBlindType>(
              title: Text(accessibilityNotifier.getColorBlindTypeName(type)),
              value: type,
              groupValue: accessibilityState.colorBlindType,
              onChanged: (selectedType) {
                if (selectedType != null) {
                  accessibilityNotifier.setColorBlindType(selectedType);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }
}