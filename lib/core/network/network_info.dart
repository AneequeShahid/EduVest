import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  static Future<bool> get isConnected async {
    final result = await Connectivity().checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  static Stream<bool> get connectivityStream =>
      Connectivity().onConnectivityChanged.map(
        (result) => result.any((r) => r != ConnectivityResult.none),
      );
}
