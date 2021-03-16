import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future setUserProperties(String userId, name, owner) async {
    await _analytics.setUserId(userId);
    await _analytics.setUserProperty(name: "username", value: name);
    await _analytics.setUserProperty(name: "owner", value: owner);
  }
}