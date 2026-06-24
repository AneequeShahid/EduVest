import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

/// Data-layer conversion utilities for [UserEntity].
/// Not a subclass of UserEntity (Freezed seals its concrete class),
/// but provides the same named factories the spec requires.
class UserModel {
  UserModel._();

  static UserEntity fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final raw = data['memberSince'];
    final memberSince =
        raw is Timestamp ? raw.toDate() : DateTime.now();
    return UserEntity(
      id: doc.id,
      email: data['email'] as String? ?? '',
      name: data['name'] as String? ?? '',
      avatarUrl: data['avatarUrl'] as String?,
      memberSince: memberSince,
      isPremium: data['isPremium'] as bool? ?? false,
    );
  }

  static UserEntity fromFirebaseUser(User user) {
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      avatarUrl: user.photoURL,
      memberSince: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  static Map<String, dynamic> toFirestore(UserEntity user) {
    return {
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'avatarUrl': user.avatarUrl,
      'memberSince': Timestamp.fromDate(user.memberSince),
      'isPremium': user.isPremium,
    };
  }
}
