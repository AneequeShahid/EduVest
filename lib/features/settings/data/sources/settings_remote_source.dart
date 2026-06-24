import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../models/settings_model.dart';
import '../../domain/entities/settings_entity.dart';

class SettingsRemoteSource {
  final FirebaseFirestore _db;
  final String _uid;

  SettingsRemoteSource({required String uid, FirebaseFirestore? db})
      : _uid = uid,
        _db = db ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> get _doc => _db
      .collection(FirestorePaths.users)
      .doc(_uid)
      .collection(FirestorePaths.settings)
      .doc(FirestorePaths.settingsPrefsDoc);

  Future<SettingsModel> getSettings() async {
    final snap = await _doc.get();
    if (!snap.exists) {
      return const SettingsModel(
          budgetAlerts: true,
          goalAchievements: true,
          marketingEmails: false,
          selectedTheme: 0);
    }
    return SettingsModel.fromJson(snap.data()!);
  }

  Future<void> saveSettings(SettingsEntity settings) async {
    await _doc.set(SettingsModel.fromEntity(settings).toJson());
  }

  Future<void> updateProfile(
      {String? displayName, String? photoUrl}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (displayName != null) await user.updateDisplayName(displayName);
      if (photoUrl != null) await user.updatePhotoURL(photoUrl);
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
          code: 'no-current-user', message: 'No authenticated user');
    }
    final email = user.email;
    if (email != null) {
      // Reauthenticate before changing the password.
      final cred = EmailAuthProvider.credential(
          email: email, password: currentPassword);
      await user.reauthenticateWithCredential(cred);
    }
    await user.updatePassword(newPassword);
  }
}
