// Shared Mockito mocks for the expense feature tests.
//
// Run `dart run build_runner build` to (re)generate the `.mocks.dart`.
import 'package:eduvest_output/features/expense/domain/repositories/expense_repository.dart';
import 'package:mockito/annotations.dart';

export 'expense_test_mocks.mocks.dart';

@GenerateMocks([ExpenseRepository])
void main() {}
