// Shared Mockito mocks for the insights feature tests.
//
// Run `dart run build_runner build` to (re)generate the `.mocks.dart`.
import 'package:eduvest_output/features/insights/domain/repositories/insights_repository.dart';
import 'package:mockito/annotations.dart';

export 'insights_test_mocks.mocks.dart';

@GenerateMocks([InsightsRepository])
void main() {}
