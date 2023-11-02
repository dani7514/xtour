import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:x_tour/user/screens/othersProfileScreen.dart';

void main() {
  testWidgets('OtherProfileScreen Widget Test', (WidgetTester tester) async {
    // Build the OtherProfileScreen widget
    await tester.pumpWidget(MaterialApp(
        home: OtherProfileScreen(
      id: '',
    )));

    // Find the avatar
    final avatarFinder = find.byKey(Key("circularAvator"));
    expect(avatarFinder, findsOneWidget);

    // Find the username text
    final usernameTextFinder = find.text('Username');
    expect(usernameTextFinder, findsOneWidget);

    // Find the post text
    final postTextFinder = find.text('Posts');
    expect(postTextFinder, findsOneWidget);

    // Find the follower text
    final followerTextFinder = find.text('Followers');
    expect(followerTextFinder, findsOneWidget);

    // Tap on the follower text to open the follower dialog
    await tester.tap(followerTextFinder);
    await tester.pumpAndSettle();

    // Find the follower dialog
    final followerDialogFinder = find.byType(Dialog);
    expect(followerDialogFinder, findsOneWidget);

    // Find the following text
    final followingTextFinder = find.text('Following');
    expect(followingTextFinder, findsOneWidget);

    // Tap on the following text to open the following dialog
    await tester.tap(followingTextFinder);
    await tester.pumpAndSettle();

    // Find the following dialog
    final followingDialogFinder = find.byType(Dialog);
    expect(followingDialogFinder, findsOneWidget);

    // Find the post icon
    final postIconFinder = find.byIcon(Icons.photo_library);
    expect(postIconFinder, findsOneWidget);

    // Tap on the post icon
    await tester.tap(postIconFinder);
    await tester.pumpAndSettle();

    final postJournalIconFinder = find.byIcon(Icons.playlist_add);
    expect(postJournalIconFinder, findsOneWidget);

    // Tap on the post journal icon
    await tester.tap(postJournalIconFinder);
    await tester.pumpAndSettle();
  });
}
