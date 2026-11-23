import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chan_navigation_app/main.dart';
import 'package:chan_navigation_app/firebase_options.dart';
import 'package:chan_navigation_app/demo_auth.dart';

void main() {
  group('Laboratory Activity 8 - Firebase & App Use Case Tests', () {
    test('Use Case 1: Firebase Options Configuration Check', () {
      final options = DefaultFirebaseOptions.web;
      expect(options.projectId, 'chan-student-app');
      expect(options.appId, startsWith('1:374122341196:web:'));
      expect(options.authDomain, 'chan-student-app.firebaseapp.com');
    });

    testWidgets('Use Case 2: Login Screen Renders Successfully',
        (WidgetTester tester) async {
      await tester.pumpWidget(const StudentApp());

      // Confirm header & input fields
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    });

    testWidgets('Use Case 3: DemoAuth Successful Login Navigates to Dashboard',
        (WidgetTester tester) async {
      await tester.pumpWidget(const StudentApp());

      // Enter admin credentials
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'admin');
      await tester.enterText(textFields.at(1), 'admin123');

      // Tap Login button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Verify navigation to MainScreen (Dashboard)
      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('Welcome, admin!'), findsOneWidget);
    });

    testWidgets('Use Case 4: Navigation through Calculator, Social, and Profile',
        (WidgetTester tester) async {
      DemoAuth.login('admin', 'admin123');
      await tester.pumpWidget(const StudentApp());

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'admin');
      await tester.enterText(textFields.at(1), 'admin123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Navigate to Calculator
      await tester.tap(find.byIcon(Icons.calculate_outlined));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.calculate), findsWidgets);

      // Navigate to Social
      await tester.tap(find.byIcon(Icons.people_outline));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.people), findsWidgets);

      // Navigate to Profile
      await tester.tap(find.byIcon(Icons.person_outline));
      await tester.pumpAndSettle();
      expect(find.text('Profile'), findsWidgets);
    });
  });
}
