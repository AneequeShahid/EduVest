import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

import 'package:eduvest_output/features/authentication/data/sources/auth_remote_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFirebaseFirestore firestore;
  late FlutterSecureStorage secureStorage;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    FlutterSecureStorage.setMockInitialValues({});
    secureStorage = const FlutterSecureStorage();
  });

  AuthRemoteSourceImpl buildSource(FirebaseAuth auth) => AuthRemoteSourceImpl(
        auth: auth,
        db: firestore,
        secureStorage: secureStorage,
      );

  group('AuthRemoteSourceImpl.signup', () {
    test('1. creates a FirebaseAuth user on signup', () async {
      final auth = MockFirebaseAuth();
      final source = buildSource(auth);

      final user = await source.signup(
          'new@university.edu', 'pass1234', 'New Student');

      expect(auth.currentUser, isNotNull);
      expect(auth.currentUser!.email, 'new@university.edu');
      expect(user.email, 'new@university.edu');
      expect(user.name, 'New Student');
    });

    test('2. creates a Firestore user document on signup', () async {
      final auth = MockFirebaseAuth();
      final source = buildSource(auth);

      final user = await source.signup(
          'new@university.edu', 'pass1234', 'New Student');

      final doc =
          await firestore.collection('users').doc(user.id).get();

      expect(doc.exists, isTrue);
      final data = doc.data()!;
      expect(data['email'], 'new@university.edu');
      expect(data['name'], 'New Student');
      expect(data['isPremium'], false);
      expect(data['avatarUrl'], isNull);
      expect(data['memberSince'], isA<Timestamp>());
      // Nested defaults required by the spec.
      expect(data['settings'], {
        'theme': 'light',
        'notifications': true,
        'biometric': false,
      });
      expect((data['monthlyBudget'] as Map)['limit'], 0.0);
      expect((data['monthlyBudget'] as Map).containsKey('month'), isTrue);
      expect((data['monthlyBudget'] as Map).containsKey('year'), isTrue);
    });
  });

  group('AuthRemoteSourceImpl.login', () {
    test('3. returns user data from Firestore on successful login', () async {
      // Seed an existing auth user + matching Firestore profile.
      final mockUser = MockUser(
        uid: 'uid-login',
        email: 'student@university.edu',
        displayName: 'Alex Sterling',
      );
      final auth = MockFirebaseAuth(mockUser: mockUser);
      await firestore.collection('users').doc('uid-login').set({
        'id': 'uid-login',
        'email': 'student@university.edu',
        'name': 'Alex Sterling',
        'avatarUrl': null,
        'memberSince': Timestamp.fromDate(DateTime(2024, 1, 1)),
        'isPremium': true,
      });

      final source = buildSource(auth);
      final user = await source.login('student@university.edu', 'pass1234');

      expect(user.id, 'uid-login');
      expect(user.email, 'student@university.edu');
      expect(user.name, 'Alex Sterling');
      expect(user.isPremium, isTrue);
    });
  });

  group('AuthRemoteSourceImpl error mapping', () {
    test('4. throws friendly message for wrong-password', () async {
      final auth = MockFirebaseAuth();
      whenCalling(Invocation.method(#signInWithEmailAndPassword, []))
          .on(auth)
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));

      final source = buildSource(auth);

      expect(
        () => source.login('student@university.edu', 'wrongpass'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('Incorrect password'))),
      );
    });

    test('5. throws friendly message for user-not-found', () async {
      final auth = MockFirebaseAuth();
      whenCalling(Invocation.method(#signInWithEmailAndPassword, []))
          .on(auth)
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));

      final source = buildSource(auth);

      expect(
        () => source.login('ghost@university.edu', 'pass1234'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('No account found with this email'))),
      );
    });
  });
}
