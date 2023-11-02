import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:x_tour/screens/screens.dart';


void main() {
  testWidgets('EditProfileScreen test', (WidgetTester tester) async {
   
    await tester.pumpWidget(const MaterialApp(home: EditProfileScreen()));

    final closeIcon = find.byIcon(Icons.close);
    expect(closeIcon, findsOneWidget);

    final checkIcon = find.byIcon(Icons.check);
    expect(checkIcon, findsOneWidget);

  
    final editText = find.text('Edit Picture');
    expect(editText, findsOneWidget);


    final nameText = find.text('Name');
    expect(nameText, findsOneWidget);

    final  usernameText = find.text('Username');
    expect(usernameText, findsOneWidget);

    final passwordText = find.text('Password');
    expect(passwordText, findsOneWidget);

    
    expect(find.byKey(const Key('name_field')), findsOneWidget);
    await tester.enterText(find.byKey(Key('name_field')), 'John Doe');
    await tester.pump();
    expect(find.text('John Doe'), findsOneWidget);


    expect(find.byKey(const Key('username_field')), findsOneWidget);
    await tester.enterText(find.byKey(Key('username_field')), 'johndoe');
    await tester.pump();
    expect(find.text('johndoe'), findsOneWidget);


    expect(find.byKey(const Key('password_field')), findsOneWidget);
    await tester.enterText(find.byKey(const Key('password_field')), 'newpassword');
    await tester.pump();
    expect(find.text('newpassword'), findsOneWidget);
  });
}
