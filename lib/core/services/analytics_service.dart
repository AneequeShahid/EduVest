import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logEvent(
      String name, Map<String, Object>? params) async {
    await _analytics.logEvent(name: name, parameters: params);
  }

  static Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  static Future<void> logPageView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }
}
