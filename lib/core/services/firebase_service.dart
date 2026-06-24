import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/firestore_paths.dart';

class FirebaseService {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static String? get currentUserId => auth.currentUser?.uid;

  static CollectionReference<Map<String, dynamic>> userCollection(
      String userId, String collection) {
    return firestore
        .collection(FirestorePaths.users)
        .doc(userId)
        .collection(collection);
  }

  static Future<void> enableOfflinePersistence() async {
    firestore.settings = const Settings(persistenceEnabled: true);
  }
}
