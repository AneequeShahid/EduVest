import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Centralised error logging to Crashlytics.
///
/// PII safety: callers must pass non-identifying [reason] strings. Never pass
/// emails, passwords, names or raw user content here.
class CrashReporter {
  CrashReporter._();

  static Future<void> record(
    Object error,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {
    if (kDebugMode) {
      // Surface in the console during development instead of Crashlytics.
      debugPrint('CrashReporter: ${reason ?? error}');
      return;
    }
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: reason,
        fatal: fatal,
      );
    } catch (_) {
      // Never let logging throw.
    }
  }

  /// Logs a non-PII breadcrumb message.
  static Future<void> log(String message) async {
    if (kDebugMode) return;
    try {
      await FirebaseCrashlytics.instance.log(message);
    } catch (_) {}
  }
}
