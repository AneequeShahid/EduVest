import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

/// Wraps a screen that displays sensitive financial data and applies
/// `FLAG_SECURE` (blocks screenshots / screen recording on Android) while the
/// screen is mounted, clearing it on dispose.
///
/// All platform calls are guarded so non-Android platforms and the test
/// environment (no plugin) are no-ops.
class SecureScreen extends StatefulWidget {
  final Widget child;

  const SecureScreen({super.key, required this.child});

  @override
  State<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
  @override
  void initState() {
    super.initState();
    _setSecure(true);
  }

  @override
  void dispose() {
    _setSecure(false);
    super.dispose();
  }

  Future<void> _setSecure(bool enable) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      if (enable) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
      } else {
        await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      }
    } catch (_) {
      // Plugin unavailable (tests / unsupported platform) — ignore.
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
