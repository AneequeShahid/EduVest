import 'package:dartz/dartz.dart';
import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/features/authentication/domain/entities/user_entity.dart';
import 'package:eduvest_output/features/authentication/domain/usecases/signup_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_mocks.dart';

void main() {
  late MockAuthRepository repository;
  late SignupUseCase useCase;

  final tUser = UserEntity(
    id: 'uid-123',
    email: 'student@university.edu',
    name: 'Alex Sterling',
    memberSince: DateTime(2024, 1, 1),
  );

  setUp(() {
    repository = MockAuthRepository();
    useCase = SignupUseCase(repository);
  });

  group('SignupUseCase.execute', () {
    test('1. returns Right(UserEntity) on successful signup', () async {
      when(repository.signup(
              'student@university.edu', 'pass1234', 'Alex Sterling'))
          .thenAnswer((_) async => Right(tUser));

      final result = await useCase.execute(
          'student@university.edu', 'pass1234', 'Alex Sterling');

      expect(result, Right<Failure, UserEntity>(tUser));
      verify(repository.signup(
              'student@university.edu', 'pass1234', 'Alex Sterling'))
          .called(1);
    });

    test('2. returns Left(Failure) when email already exists', () async {
      when(repository.signup(any, any, any)).thenAnswer(
        (_) async =>
            const Left(AuthFailure('This email is already registered.')),
      );

      final result = await useCase.execute(
          'taken@university.edu', 'pass1234', 'Alex Sterling');

      expect(
        result,
        const Left<Failure, UserEntity>(
            AuthFailure('This email is already registered.')),
      );
    });

    test('3. returns Left(Failure) when password is too weak', () async {
      // Too short (< 8 chars) → rejected locally, repository never called.
      final result =
          await useCase.execute('student@university.edu', 'ab1', 'Alex');

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected a Left(ValidationFailure)'),
      );
      verifyNever(repository.signup(any, any, any));
    });

    test('4. returns Left(Failure) when name is empty', () async {
      final result =
          await useCase.execute('student@university.edu', 'pass1234', '');

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected a Left(ValidationFailure)'),
      );
      verifyNever(repository.signup(any, any, any));
    });

    test(
        '5. delegates to repository.signup on success '
        '(which creates the Firestore user document)', () async {
      when(repository.signup(any, any, any))
          .thenAnswer((_) async => Right(tUser));

      final result = await useCase.execute(
          'student@university.edu', 'pass1234', 'Alex Sterling');

      // The repository → remote source is responsible for writing the
      // users/{uid} document; verifying the delegation guarantees that path
      // is exercised. The document contents themselves are asserted in
      // auth_remote_source_test.dart.
      expect(result.isRight(), isTrue);
      verify(repository.signup(
              'student@university.edu', 'pass1234', 'Alex Sterling'))
          .called(1);
    });
  });
}
