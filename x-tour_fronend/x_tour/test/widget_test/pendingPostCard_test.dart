// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:x_tour/custom/pendingPostCard.dart';


// void main() {
//   testWidgets('PendingPostCard widget test', (WidgetTester tester) async {

//     await tester.pumpWidget(MaterialApp(home: PendingPostCard(pendingPostsBloc: null, post: null, user: null, userBloc: null,)));

//     final circularAvator = find.byType(CircleAvatar);
//     expect(circularAvator, findsOneWidget);


//     final viewText = find.text('View description');
//     expect(viewText, findsOneWidget);

//     final editIcon = find.byIcon(Icons.edit);
//     expect(editIcon, findsOneWidget);
 

//     // Test delete icon
//     final deleteIcon = find.byIcon(Icons.delete);
//     expect(deleteIcon, findsOneWidget);
//     await tester.tap(find.byIcon(Icons.delete));
//     await tester.pumpAndSettle();

//     final confirmText = find.text('Confirm Delete');
//     expect(confirmText, findsOneWidget);

//     final titleText = find.text('Are you sure you want to delete this post?');
//     expect(titleText,findsOneWidget);

//     expect(find.text('Cancel'), findsOneWidget);
//     expect(find.text('Delete'), findsOneWidget);
//   });
// }
