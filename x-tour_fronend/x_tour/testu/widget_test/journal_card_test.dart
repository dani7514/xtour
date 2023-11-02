import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:x_tour/custom/journal_card.dart';
import 'package:x_tour/custom/avator_custom.dart';
import 'package:x_tour/journal/models/journal.dart';
import 'package:x_tour/user/models/user.dart';

void main() {
  group('journalCard', () {
    testWidgets('Widget initializes correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: journalCard(
                journal: Journal(description: "", link: "", title: ""),
                user: User()),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(profile_avatar), findsOneWidget);
    });
  });
}
