import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

abstract class AuthRemoteSource {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> signup(String email, String password, String name);
  Future<void> logout();
  Future<void> resetPassword(String email);
  UserEntity? get currentUser;
  Stream<UserEntity?> get authStateChanges;
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final FlutterSecureStorage _secureStorage;

  static const _uidKey = 'eduvest_auth_uid';

  AuthRemoteSourceImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? db,
    FlutterSecureStorage? secureStorage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _db = db ?? FirebaseFirestore.instance,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  // ── Public interface ──────────────────────────────────────────────────────

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = cred.user!;

      // Fetch full profile from Firestore
      final doc = await _db.collection(FirestorePaths.users).doc(user.uid).get();
      final entity = doc.exists
          ? UserModel.fromFirestore(doc)
          : UserModel.fromFirebaseUser(user);

      await _secureStorage.write(key: _uidKey, value: user.uid);
      return entity;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthError(e.code));
    }
  }

  @override
  Future<UserEntity> signup(
      String email, String password, String name) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = cred.user!;

      await user.updateDisplayName(name);

      final now = DateTime.now();
      final entity = UserEntity(
        id: user.uid,
        email: email,
        name: name,
        memberSince: now,
      );

      // Create Firestore document
      final firestoreData = {
        ...UserModel.toFirestore(entity),
        'settings': {
          'theme': 'light',
          'notifications': true,
          'biometric': false,
        },
        'monthlyBudget': {
          'limit': 0.0,
          'month': now.month,
          'year': now.year,
        },
      };
      await _db.collection(FirestorePaths.users).doc(user.uid).set(firestoreData);

      await _secureStorage.write(key: _uidKey, value: user.uid);
      return entity;
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthError(e.code));
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(key: _uidKey);
    await _auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthError(e.code));
    }
  }

  @override
  UserEntity? get currentUser {
    final u = _auth.currentUser;
    if (u == null) return null;
    return UserModel.fromFirebaseUser(u);
  }

  @override
  Stream<UserEntity?> get authStateChanges => _auth.authStateChanges().map(
      (u) => u != null ? UserModel.fromFirebaseUser(u) : null);

  // ── Error mapping ─────────────────────────────────────────────────────────

  static String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password must be at least 8 characters.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'requires-recent-login':
        return 'Please sign in again to continue.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
