import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:x_tour/posts/screens/searchScreen.dart';

void main() {
  testWidgets('SearchScreen widget test', (WidgetTester tester) async {
    // Build the SearchScreen widget
    await tester.pumpWidget(MaterialApp(home: SearchScreen()));

    final searchTextField = find.byType(TextField);
    expect(searchTextField, findsOneWidget);

    await tester.enterText(searchTextField, 'Test');
    final searchedText = find.text('Test');
    expect(searchedText, findsOneWidget);

    final searchIcon = find.byIcon(Icons.search);
    expect(searchIcon, findsOneWidget);

    final clearIcon = find.byIcon(Icons.clear);
    expect(clearIcon, findsNothing);

    final more_vertIcon = find.byIcon(Icons.more_vert);
    expect(more_vertIcon, findsNothing);

    await tester.enterText(searchTextField, 'Example');
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.clear), findsOneWidget);
  });
}
