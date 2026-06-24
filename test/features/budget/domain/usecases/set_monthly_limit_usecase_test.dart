import 'package:eduvest_output/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:eduvest_output/features/budget/data/sources/budget_remote_source.dart';
import 'package:eduvest_output/features/budget/domain/usecases/set_monthly_limit_usecase.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const uid = 'uid-1';
  const month = 3;
  const year = 2024;
  const docId = '2024-03';

  late FakeFirebaseFirestore firestore;
  late SetMonthlyLimitUseCase useCase;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    useCase = SetMonthlyLimitUseCase(
        BudgetRepositoryImpl(BudgetRemoteSource(db: firestore)));
  });

  Future<Map<String, dynamic>?> budgetData() async =>
      (await firestore
              .collection('users')
              .doc(uid)
              .collection('budget')
              .doc(docId)
              .get())
          .data();

  test('1. creates a new budget doc if none exists', () async {
    final result = await useCase(uid, month, year, 1500);

    expect(result.isRight(), isTrue);
    final data = await budgetData();
    expect(data, isNotNull);
    expect(data!['totalLimit'], 1500);
    expect(data['month'], month);
    expect(data['year'], year);
  });

  test('2. updates an existing document', () async {
    await useCase(uid, month, year, 1000);
    await useCase(uid, month, year, 2000);

    final data = await budgetData();
    expect(data!['totalLimit'], 2000);
  });

  test('3. returns Left(Failure) when limit <= 0', () async {
    final zero = await useCase(uid, month, year, 0);
    final negative = await useCase(uid, month, year, -5);

    expect(zero.isLeft(), isTrue);
    expect(negative.isLeft(), isTrue);
    expect(await budgetData(), isNull); // nothing written
  });

  test('4. preserves existing categories when updating', () async {
    await useCase(uid, month, year, 1000);
    // Seed a category subdoc.
    await firestore
        .collection('users')
        .doc(uid)
        .collection('budget')
        .doc(docId)
        .collection('categories')
        .doc('rent')
        .set({'name': 'Rent', 'limit': 1200.0});

    await useCase(uid, month, year, 2000); // update limit

    final cat = await firestore
        .collection('users')
        .doc(uid)
        .collection('budget')
        .doc(docId)
        .collection('categories')
        .doc('rent')
        .get();
    expect(cat.exists, isTrue);
    expect(cat.data()!['limit'], 1200.0);
  });
}
