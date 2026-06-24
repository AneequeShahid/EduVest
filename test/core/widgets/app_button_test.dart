import 'package:eduvest_output/core/theme/app_theme.dart';
import 'package:eduvest_output/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    // Avoid network font fetches during tests.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pump(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  testWidgets('1. renders label text', (tester) async {
    await pump(tester, AppButton(label: 'Continue', onPressed: () {}));
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('2. calls onPressed when tapped', (tester) async {
    var tapped = 0;
    await pump(tester, AppButton(label: 'Tap', onPressed: () => tapped++));
    await tester.tap(find.byType(AppButton));
    expect(tapped, 1);
  });

  testWidgets('3. shows CircularProgressIndicator when isLoading is true',
      (tester) async {
    await pump(
      tester,
      AppButton(label: 'Loading', onPressed: () {}, isLoading: true),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading'), findsNothing);
  });

  testWidgets('4. does not call onPressed when isLoading is true',
      (tester) async {
    var tapped = 0;
    await pump(
      tester,
      AppButton(label: 'Loading', onPressed: () => tapped++, isLoading: true),
    );
    await tester.tap(find.byType(AppButton), warnIfMissed: false);
    expect(tapped, 0);
  });

  testWidgets('5. renders outlined style when isOutlined is true',
      (tester) async {
    await pump(
      tester,
      AppButton(label: 'Outlined', onPressed: () {}, isOutlined: true),
    );
    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNothing);
  });
}
