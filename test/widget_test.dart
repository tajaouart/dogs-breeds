// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dogs_breeds/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Go to login tab', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // IMPORTANT
      await tester.pumpWidget(MyApp());

      SharedPreferences.setMockInitialValues({'is_logged_in': false});

      // Tap the 'login' tab and trigger a frame.
      await tester.tap(find.byIcon(Icons.account_circle));
      await tester.pump();

      // Verify that we moved to login tab
      expect(find.text('Connecting...'), findsOneWidget);
      await tester.pump();
      // Authentification is the head title of the screen
      expect(find.text('Authentification'), findsOneWidget);
      // login button
      expect(find.byIcon(Icons.login), findsOneWidget);
    });
  });
}
