/// Abstract contract for authentication operations.
/// Zero Flutter/Firebase imports — pure Dart.
abstract class AuthRepository {
  Future<String> signInAnonymously();
  String getCurrentUid();
}
