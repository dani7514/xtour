import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:x_tour/screens/createJournalScreen.dart';

void main() {
  group('CreateJournalScreen', () {
    testWidgets(
        'Validation error shown when posting without filling all fields and selecting an image',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CreateJournalScreen()));

      // Tap on the post button without filling any fields or selecting an image
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Check if the validation error dialog is shown
      expect(find.text('Validation Error'), findsOneWidget);
      expect(
          find.text('Please fill in all fields and select at least one image.'),
          findsOneWidget);
    });

    testWidgets('Validation error shown when posting with invalid link',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CreateJournalScreen()));

      // Enter invalid link
      await tester.enterText(find.byKey(Key('linkField')), 'invalid-link');
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Check if the validation error is shown for the link field
      expect(find.text('Invalid link format'), findsOneWidget);
    });

    testWidgets(
        'Posting successful when all fields are filled and image is selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CreateJournalScreen()));

      // Enter valid details
      await tester.enterText(find.byKey(Key('titleField')), 'Test Title');
      await tester.enterText(
          find.byKey(Key('descriptionField')), 'Test Description');
      await tester.enterText(
          find.byKey(Key('linkField')), 'https://www.youtube.com/watch?v=pxJGOJI6fik');
      await tester.tap(find.byIcon(Icons.photo_library));
      await tester.pumpAndSettle();

      // Check if the image preview is displayed
      expect(find.byType(Image), findsOneWidget);

      // Tap on the post button
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Check if the posting state is updated
      expect(find.text('Posting...'), findsOneWidget);
      await tester.pump(Duration(seconds: 2));

      // Check if the posting state is updated after delay
      expect(find.text('Posting...'), findsNothing);
    });
  });
}
