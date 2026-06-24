import 'package:eduvest_output/core/services/crash_reporter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // In the test environment kDebugMode is true, so CrashReporter short-circuits
  // to debugPrint and never touches FirebaseCrashlytics. These tests assert it
  // is safe to call and never throws.
  test('1. record completes without throwing', () async {
    await expectLater(
      CrashReporter.record(Exception('boom'), StackTrace.current,
          reason: 'unit-test'),
      completes,
    );
  });

  test('2. record tolerates a null stack trace', () async {
    await expectLater(
      CrashReporter.record('string error', null),
      completes,
    );
  });

  test('3. log completes without throwing', () async {
    await expectLater(CrashReporter.log('breadcrumb'), completes);
  });
}
