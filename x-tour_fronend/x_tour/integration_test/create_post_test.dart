import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:x_tour/screens/createPostScreen.dart';
import 'package:x_tour/screens/homeScreen.dart';

void main() {
  testWidgets('Create Post integration test', (WidgetTester tester) async {
    // Build the create post screen
    await tester.pumpWidget(MaterialApp(
      home: CreatePostScreen(),
    ));

    // Insert text in title, description, and story fields
    final storyField = find.widgetWithText(TextFormField, 'Story');
    await tester.enterText(storyField, 'This is my story');

    final descriptionField =
        find.widgetWithText(TextField, 'Add a description...');
    await tester.enterText(descriptionField, 'This is a description');

    // Pick an image
    final getModeButton = find.widgetWithText(GestureDetector, 'Gallery');
    await tester.tap(getModeButton);
    await tester.pumpAndSettle();

    final imagePicker = find.byType(ImagePicker);
    expect(imagePicker, findsOneWidget);

    final imageFile = await createSampleImage();
    final imageFilePicker = find.byType(ImagePicker);
    expect(imageFilePicker, findsOneWidget);
    await tester.tap(imageFilePicker);
    await tester.pumpAndSettle();

    // Expect navigation to the home screen
    final postButton = find.widgetWithIcon(IconButton, Icons.check);
    await tester.tap(postButton);
    await tester.pumpAndSettle();

    final homeScreen =
        find.byType(HomeScreen); // Replace with your home screen widget
    expect(homeScreen, findsOneWidget);
  });
}

Future<File> createSampleImage() async {
  final directory = await getTemporaryDirectory();
  final path = join(directory.path, 'sample_image.jpg');
  final imageFile = File(path);

  // Write sample data to the file
  await imageFile
      .writeAsBytes(List.generate(1024 * 1024, (index) => index % 256));

  return imageFile;
}
