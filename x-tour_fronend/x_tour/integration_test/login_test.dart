import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:x_tour/screens/homeScreen.dart';
import 'package:x_tour/screens/loginScreen.dart';


void main() {
  testWidgets('Authentication succed and navigation to home screen', (WidgetTester tester) async {
    // Build the login screen
    await tester.pumpWidget(Login());

    // Enter the username and password
    final usernameField = find.byKey(Key('usernameField'));
    final passwordField = find.byKey(Key('passwordField'));
    await tester.enterText(usernameField, 'zelalem');
    await tester.enterText(passwordField, '12345678');

    // Tap the login button
    final loginButton = find.text('login');
    await tester.tap(loginButton);
    await tester.pumpAndSettle(); // Wait for navigation transition to complete

    // Verify navigation to the home screen
    final homeScreenFinder = find.byType(HomeScreen); // Replace with your home screen widget
    expect(homeScreenFinder, findsOneWidget);
  });


  testWidgets('Authentication not succed test (username or password error)', (WidgetTester tester) async {
    // Build the login screen
    await tester.pumpWidget(Login());

    // Enter the username and password
    final usernameField = find.byKey(Key('usernameField'));
    final passwordField = find.byKey(Key('passwordField'));
    await tester.enterText(usernameField, 'abebe');
    await tester.enterText(passwordField, '23456789');

    // Tap the login button
    final loginButton = find.text('login');
    await tester.tap(loginButton);
    await tester.pumpAndSettle(); // Wait for navigation transition to complete

    // Verify no navigation to the home screen
    final homeScreenFinder =
        find.byType(HomeScreen); // Replace with your home screen widget
    expect(homeScreenFinder, findsNothing);
  });
}
