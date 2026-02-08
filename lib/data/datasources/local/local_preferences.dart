import '../../../config/app_config.dart';
import '../../models/index.dart';
import 'hive_service.dart';

class PreferencesLocalDataSource {
  static const String _settingsKey = 'settings';

  Future<AppSettingsModel?> getSettings() async {
    final box = HiveService.getBox<AppSettingsModel>(
      AppConfig.hivePreferencesBox,
    );
    return box.get(_settingsKey);
  }

  Future<void> saveSettings(AppSettingsModel settings) async {
    final box = HiveService.getBox<AppSettingsModel>(
      AppConfig.hivePreferencesBox,
    );
    await box.put(_settingsKey, settings);
  }
}
