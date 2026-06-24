import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';

/// The ONLY file in the auth feature that imports Firebase Auth SDK.
/// Handles anonymous sign-in and exposes the current user's uid.
class AuthFirebaseDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthFirebaseDataSource({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Signs in anonymously. Returns the uid on success.
  /// If a user is already signed in, returns their existing uid.
  Future<String> signInAnonymously() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        return currentUser.uid;
      }
      final credential = await _firebaseAuth.signInAnonymously();
      final uid = credential.user?.uid;
      if (uid == null) {
        throw const AuthException('Anonymous sign-in returned null uid');
      }
      return uid;
    } on FirebaseAuthException catch (e) {
      throw AuthException('Firebase Auth error during sign-in: ${e.message}');
    } catch (e) {
      throw AuthException('Failed to sign in anonymously: $e');
    }
  }

  /// Returns the current signed-in uid synchronously.
  /// Throws if no user is signed in yet.
  String getCurrentUid() {
    try {
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw const AuthException('No authenticated user found');
      }
      return uid;
    } catch (e) {
      throw AuthException('Failed to retrieve current user UID: $e');
    }
  }
}
