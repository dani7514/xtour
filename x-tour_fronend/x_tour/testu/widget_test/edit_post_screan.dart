import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:x_tour/posts/screens/createPostScreen.dart';

void main() {
  group('CreatePostPage', () {
    testWidgets('Widget initializes correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CreatePostPage()));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Create Post'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byType(TextField), findsWidgets);
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('Posting with empty fields shows validation errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CreatePostPage()));

      await tester.tap(find.byIcon(Icons.check));
      await tester.pump();

      expect(find.text('Please enter your story'), findsOneWidget);
      expect(find.text('Please enter a description'), findsOneWidget);
    });

    testWidgets('Posting with valid fields shows success message',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CreatePostPage()));

      await tester.enterText(find.byKey(ValueKey('story')), 'Test Story');
      await tester.enterText(
          find.byKey(ValueKey('description')), 'Test Description');
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.text('Post successful!'), findsOneWidget);
    });

    testWidgets('Adding and removing images', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CreatePostPage()));

      await tester.tap(find.byKey(ValueKey('image')));
      await tester.pumpAndSettle();

      expect(find.text('Gallery'), findsOneWidget);
      expect(find.text('Camera'), findsOneWidget);

      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();
    });
  });
}
