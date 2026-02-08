import '../datasources/local/local_preferences.dart';
import '../models/index.dart';

class PreferencesRepository {
  PreferencesRepository({PreferencesLocalDataSource? local})
      : _local = local ?? PreferencesLocalDataSource();

  final PreferencesLocalDataSource _local;

  Future<AppSettingsModel?> getSettings() => _local.getSettings();

  Future<void> saveSettings(AppSettingsModel settings) =>
      _local.saveSettings(settings);
}
