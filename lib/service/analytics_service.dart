import 'package:firebase_analytics/firebase_analytics.dart';
import '../config/app_config.dart';

class AnalyticsService {
  AnalyticsService._(this._analytics);

  final FirebaseAnalytics? _analytics;

  static Future<AnalyticsService> initialize() async {
    if (!AppConfig.enableAnalytics) {
      return AnalyticsService._(null);
    }
    try {
      final analytics = FirebaseAnalytics.instance;
      return AnalyticsService._(analytics);
    } catch (_) {
      return AnalyticsService._(null);
    }
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) async {
    if (_analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (_) {
      // ignore analytics errors
    }
  }
}
