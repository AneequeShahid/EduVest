import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../providers/auth_provider.dart';

/// Wraps the app and enforces a session timeout:
///
/// * On background/pause it records a "last active" timestamp in secure
///   storage.
/// * On resume, if more than [timeout] has elapsed, the user is signed out
///   (clearing secure storage), and the router guard redirects to /login.
/// * It also re-validates the Firebase session on every resume.
///
/// Security note: only timestamps and auth state are touched — never
/// credentials or PII.
class AuthSessionObserver extends ConsumerStatefulWidget {
  final Widget child;
  final Duration timeout;

  const AuthSessionObserver({
    super.key,
    required this.child,
    this.timeout = const Duration(minutes: 5),
  });

  @override
  ConsumerState<AuthSessionObserver> createState() =>
      _AuthSessionObserverState();
}

class _AuthSessionObserverState extends ConsumerState<AuthSessionObserver> {
  static const _lastActiveKey = 'eduvest_last_active';

  late final AppLifecycleListener _listener;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onResume: _onResume,
      onInactive: _recordTimestamp,
      onPause: _recordTimestamp,
    );
  }

  Future<void> _recordTimestamp() async {
    try {
      await _storage.write(
        key: _lastActiveKey,
        value: DateTime.now().toIso8601String(),
      );
    } catch (_) {
      // Secure storage unavailable (tests) — ignore.
    }
  }

  Future<void> _onResume() async {
    var timedOut = false;
    try {
      final raw = await _storage.read(key: _lastActiveKey);
      final last = raw == null ? null : DateTime.tryParse(raw);
      if (last != null &&
          DateTime.now().difference(last) > widget.timeout) {
        timedOut = true;
      }
    } catch (_) {
      // ignore storage errors
    }

    if (timedOut) {
      // Sign out → router guard redirects to /login.
      await ref.read(authNotifierProvider.notifier).logout();
    } else {
      // Re-validate the cached session against Firebase.
      ref.invalidate(authNotifierProvider);
    }
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
