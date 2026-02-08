import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/extensions.dart';
import '../widgets/app_bottom_nav.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            context.l10n.language,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _buildLanguageOptions(context, settings),
          const SizedBox(height: 16),
          Text(
            context.l10n.theme,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          _buildThemeOptions(context, settings),
          const SizedBox(height: 16),
          Text(
            context.l10n.fontSize,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            value: settings.fontSizeMultiplier,
            min: 0.8,
            max: 1.5,
            divisions: 7,
            label: settings.fontSizeMultiplier.toStringAsFixed(1),
            onChanged: (value) => settings.setFontSize(value),
          ),
          SwitchListTile(
            title: Text(context.l10n.notifications),
            value: settings.enableNotifications,
            onChanged: settings.setNotificationsEnabled,
          ),
          SwitchListTile(
            title: Text(context.l10n.analytics),
            value: settings.enableAnalytics,
            onChanged: settings.setAnalyticsEnabled,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOptions(
    BuildContext context,
    SettingsProvider settings,
  ) {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('日本語'),
          value: 'ja',
          groupValue: settings.settings.languageCode,
          onChanged: (value) {
            if (value != null) settings.setLanguage(value);
          },
        ),
        RadioListTile<String>(
          title: const Text('English'),
          value: 'en',
          groupValue: settings.settings.languageCode,
          onChanged: (value) {
            if (value != null) settings.setLanguage(value);
          },
        ),
      ],
    );
  }

  Widget _buildThemeOptions(
    BuildContext context,
    SettingsProvider settings,
  ) {
    return Column(
      children: [
        RadioListTile<String>(
          title: Text(context.l10n.themeLight),
          value: 'light',
          groupValue: settings.settings.themeMode,
          onChanged: (value) {
            if (value != null) settings.setThemeMode(value);
          },
        ),
        RadioListTile<String>(
          title: Text(context.l10n.themeDark),
          value: 'dark',
          groupValue: settings.settings.themeMode,
          onChanged: (value) {
            if (value != null) settings.setThemeMode(value);
          },
        ),
        RadioListTile<String>(
          title: Text(context.l10n.themeSystem),
          value: 'system',
          groupValue: settings.settings.themeMode,
          onChanged: (value) {
            if (value != null) settings.setThemeMode(value);
          },
        ),
        RadioListTile<String>(
          title: Text(context.l10n.themeHighContrast),
          value: 'high_contrast',
          groupValue: settings.settings.themeMode,
          onChanged: (value) {
            if (value != null) settings.setThemeMode(value);
          },
        ),
      ],
    );
  }
}
