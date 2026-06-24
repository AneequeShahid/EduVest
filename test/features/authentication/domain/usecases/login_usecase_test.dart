import 'package:dartz/dartz.dart';
import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/features/authentication/domain/entities/user_entity.dart';
import 'package:eduvest_output/features/authentication/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_mocks.dart';

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  final tUser = UserEntity(
    id: 'uid-123',
    email: 'student@university.edu',
    name: 'Alex Sterling',
    memberSince: DateTime(2024, 1, 1),
  );

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  group('LoginUseCase.execute', () {
    test('1. returns Right(UserEntity) when credentials are valid', () async {
      when(repository.login('student@university.edu', 'pass1234'))
          .thenAnswer((_) async => Right(tUser));

      final result =
          await useCase.execute('student@university.edu', 'pass1234');

      expect(result, Right<Failure, UserEntity>(tUser));
      verify(repository.login('student@university.edu', 'pass1234')).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('2. returns Left(Failure) when email is empty', () async {
      final result = await useCase.execute('', 'pass1234');

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected a Left(ValidationFailure)'),
      );
      verifyNever(repository.login(any, any));
    });

    test('3. returns Left(Failure) when password is empty', () async {
      final result = await useCase.execute('student@university.edu', '');

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected a Left(ValidationFailure)'),
      );
      verifyNever(repository.login(any, any));
    });

    test('4. returns Left(Failure) when Firebase returns user-not-found',
        () async {
      when(repository.login(any, any)).thenAnswer(
        (_) async =>
            const Left(AuthFailure('No account found with this email.')),
      );

      final result = await useCase.execute('ghost@university.edu', 'pass1234');

      expect(
        result,
        const Left<Failure, UserEntity>(
            AuthFailure('No account found with this email.')),
      );
    });

    test('5. returns Left(Failure) when Firebase returns wrong-password',
        () async {
      when(repository.login(any, any)).thenAnswer(
        (_) async =>
            const Left(AuthFailure('Incorrect password. Please try again.')),
      );

      final result =
          await useCase.execute('student@university.edu', 'wrongpass1');

      expect(
        result,
        const Left<Failure, UserEntity>(
            AuthFailure('Incorrect password. Please try again.')),
      );
    });

    test('6. returns Left(Failure) when network is unavailable', () async {
      when(repository.login(any, any)).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );

      final result =
          await useCase.execute('student@university.edu', 'pass1234');

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('Expected a Left(NetworkFailure)'),
      );
    });
  });
}
