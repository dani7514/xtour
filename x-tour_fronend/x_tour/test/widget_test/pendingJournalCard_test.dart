// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:x_tour/custom/pendingJournalCard.dart';


// void main() {
//   testWidgets('PendingJournalCard widget test', (WidgetTester tester) async {
//     // Build the PendingJournalCard widget
//     await tester.pumpWidget(MaterialApp(home: PendingJournalCard(journal: null, pendingJournalBloc: null, user: null, userBloc: null,)));

//     final circularAvator = find.byType(CircleAvatar);
//     expect(circularAvator, findsOneWidget);

//     final editIcon = find.byIcon(Icons.edit);
//     expect(editIcon, findsOneWidget);


//     final deleteIcon = find.byIcon(Icons.delete);
//     expect(deleteIcon, findsOneWidget);

//     await tester.tap(find.byIcon(Icons.delete));
//     await tester.pumpAndSettle();

//     final coniformText = find.text('Confirm Delete');
//     expect(coniformText, findsOneWidget);

//     final titleText = find.text('Are you sure you want to delete this journal?');
//     expect(titleText,findsOneWidget);

    
//     expect(find.text('Cancel'), findsOneWidget);
//     expect(find.text('Delete'), findsOneWidget);
//   });
// }
