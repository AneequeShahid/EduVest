// Shared Mockito mocks for the authentication feature tests.
//
// Run `dart run build_runner build` to (re)generate `test_mocks.mocks.dart`.
import 'package:eduvest_output/features/authentication/domain/repositories/auth_repository.dart';
import 'package:mockito/annotations.dart';

export 'test_mocks.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {}
