import 'package:flutter/material.dart';
import '../data/models/index.dart';
import '../data/repositories/preferences_repository.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({PreferencesRepository? repository})
      : _repository = repository ?? PreferencesRepository();

  final PreferencesRepository _repository;

  AppSettingsModel _settings = AppSettingsModel(
    languageCode: 'ja',
    themeMode: 'system',
    fontSizeMultiplier: 1.0,
    enableNotifications: true,
    enableAnalytics: true,
    lastUpdatedAt: DateTime.now(),
  );

  bool _initialized = false;

  bool get initialized => _initialized;
  AppSettingsModel get settings => _settings;
  Locale get locale => Locale(_settings.languageCode);
  double get fontSizeMultiplier => _settings.fontSizeMultiplier;
  bool get enableNotifications => _settings.enableNotifications;
  bool get enableAnalytics => _settings.enableAnalytics;

  ThemeMode get themeMode {
    switch (_settings.themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'high_contrast':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  bool get isHighContrast => _settings.themeMode == 'high_contrast';

  Future<void> load() async {
    final saved = await _repository.getSettings();
    if (saved != null) {
      _settings = saved;
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _settings = _settings.copyWith(
      languageCode: code,
      lastUpdatedAt: DateTime.now(),
    );
    await _repository.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _settings = _settings.copyWith(
      themeMode: mode,
      lastUpdatedAt: DateTime.now(),
    );
    await _repository.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setFontSize(double multiplier) async {
    _settings = _settings.copyWith(
      fontSizeMultiplier: multiplier.clamp(0.8, 1.5),
      lastUpdatedAt: DateTime.now(),
    );
    await _repository.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _settings = _settings.copyWith(
      enableNotifications: enabled,
      lastUpdatedAt: DateTime.now(),
    );
    await _repository.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setAnalyticsEnabled(bool enabled) async {
    _settings = _settings.copyWith(
      enableAnalytics: enabled,
      lastUpdatedAt: DateTime.now(),
    );
    await _repository.saveSettings(_settings);
    notifyListeners();
  }
}
