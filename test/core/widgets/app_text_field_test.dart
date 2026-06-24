import 'package:eduvest_output/core/theme/app_theme.dart';
import 'package:eduvest_output/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<void> pump(WidgetTester tester, Widget child,
      {Key? formKey}) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Form(
            key: formKey,
            child: child,
          ),
        ),
      ),
    );
  }

  testWidgets('1. renders label', (tester) async {
    final controller = TextEditingController();
    await pump(
        tester, AppTextField(label: 'Email address', controller: controller));
    expect(find.text('Email address'), findsOneWidget);
  });

  testWidgets('2. shows error text when validator fails', (tester) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    await pump(
      tester,
      AppTextField(
        label: 'Email',
        controller: controller,
        validator: (_) => 'Invalid email',
      ),
      formKey: formKey,
    );

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Invalid email'), findsOneWidget);
  });

  testWidgets('3. toggles password visibility on icon tap', (tester) async {
    final controller = TextEditingController(text: 'secret');
    await pump(
      tester,
      AppTextField(
        label: 'Password',
        controller: controller,
        obscureText: true,
      ),
    );

    // Initially obscured → "show" (off) icon visible.
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    expect(find.byIcon(Icons.visibility_outlined), findsNothing);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    // Now revealed → "hide" (on) icon visible.
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
  });
}
