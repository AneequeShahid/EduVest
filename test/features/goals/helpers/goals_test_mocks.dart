// Shared Mockito mocks for the goals feature tests.
//
// Run `dart run build_runner build` to (re)generate the `.mocks.dart`.
import 'package:eduvest_output/features/goals/domain/repositories/goals_repository.dart';
import 'package:mockito/annotations.dart';

export 'goals_test_mocks.mocks.dart';

@GenerateMocks([GoalsRepository])
void main() {}
