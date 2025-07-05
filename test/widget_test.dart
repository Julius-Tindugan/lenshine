// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lenshine/main.dart';

void main() {
  testWidgets('Shows loading screen on startup', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Check for CircularProgressIndicator (the loading spinner)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Check for your logo image (if you want)
    expect(find.byType(Image), findsOneWidget);
  });
}