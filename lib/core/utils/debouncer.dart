import 'dart:async';

/// Delays execution of [action] until [duration] has passed without
/// another call. Useful for search fields and live-filter inputs to
/// avoid firing on every keystroke.
///
/// Usage:
/// ```dart
/// final _debouncer = Debouncer(duration: const Duration(milliseconds: 400));
///
/// void onSearchChanged(String query) {
///   _debouncer.run(() => _doSearch(query));
/// }
///
/// @override
/// void dispose() {
///   _debouncer.dispose();
///   super.dispose();
/// }
/// ```
class Debouncer {
  final Duration duration;

  Timer? _timer;

  Debouncer({this.duration = const Duration(milliseconds: 400)});

  /// Schedules [action] to run after [duration]. Cancels any pending call.
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// Cancels any pending call without running it.
  void cancel() => _timer?.cancel();

  /// Runs any pending call immediately, then cancels the timer.
  void flush(void Function() action) {
    _timer?.cancel();
    action();
  }

  /// Must be called when the owner is disposed to avoid memory leaks.
  void dispose() => _timer?.cancel();
}
