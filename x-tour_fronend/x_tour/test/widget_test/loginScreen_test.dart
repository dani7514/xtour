import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:x_tour/screens/screens.dart';
import 'package:x_tour/user/login/bloc/login_bloc.dart';

void main() {
  group('Login', () {
    testWidgets('should display the title and login button',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      expect(find.text('X-tour'), findsOneWidget);

      expect(find.text('login'), findsOneWidget);
    });

    testWidgets('should validate empty username field on login button tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      await tester.tap(find.text('login'));
      await tester.pump();

      expect(find.text('Please enter your username'), findsOneWidget);
    });

    testWidgets('should validate empty password field on login button tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      await tester.enterText(find.byKey(Key('usernameField')), 'testuser');
      await tester.pump();

      await tester.tap(find.text('login'));
      await tester.pump();

      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('should validate password length on login button tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      await tester.enterText(find.byKey(Key('usernameField')), 'testuser');
      await tester.enterText(find.byKey(Key('passwordField')), '12345');
      await tester.pump();

      await tester.tap(find.text('login'));
      await tester.pump();

      expect(find.text('Password must be at least 6 characters long'),
          findsOneWidget);
    });
  });
}
