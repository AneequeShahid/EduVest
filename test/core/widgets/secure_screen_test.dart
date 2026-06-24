import 'package:eduvest_output/core/widgets/secure_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('1. renders its child', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SecureScreen(child: Text('SECURE CONTENT')),
    ));
    expect(find.text('SECURE CONTENT'), findsOneWidget);
  });

  testWidgets('2. disposes cleanly when removed from the tree',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: SecureScreen(child: Text('A')),
    ));
    expect(find.text('A'), findsOneWidget);

    // Replace with a different tree → triggers dispose() / _setSecure(false).
    await tester.pumpWidget(const MaterialApp(
      home: Text('B', textDirection: TextDirection.ltr),
    ));
    expect(find.text('A'), findsNothing);
    expect(find.text('B'), findsOneWidget);
  });
}
