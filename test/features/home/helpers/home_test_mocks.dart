// Shared Mockito mocks for the home feature tests.
//
// Run `dart run build_runner build` to (re)generate `home_test_mocks.mocks.dart`.
import 'package:eduvest_output/features/home/domain/repositories/home_repository.dart';
import 'package:mockito/annotations.dart';

export 'home_test_mocks.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {}
