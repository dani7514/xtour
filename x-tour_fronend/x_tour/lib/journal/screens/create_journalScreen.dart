import 'dart:io';
// import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_tour/journal/models/journal.dart';

import 'package:http/http.dart' show MultipartFile;

import '../../user/bloc/user_bloc.dart';

class CreateJournalScreen extends StatefulWidget {
  @override
  _CreateJournalScreenState createState() => _CreateJournalScreenState();
}

class _CreateJournalScreenState extends State<CreateJournalScreen> {
  late final UserBloc userBloc;

  String? _titleError;
  String? _descriptionError;
  late TextEditingController _linkController;
  late TextEditingController _titleController;
  String? _linkError;
  late TextEditingController _descriptionController;
  File? _selectedImages;
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();
    _titleController = TextEditingController();
    _linkController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    if (userBloc.state is UserOperationFailure) {
      userBloc.add(GetUser());
    }
    _titleController.dispose();
    _linkController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateLink(String? link) {
    if (link!.isEmpty) {
      return 'Please enter a link';
    } else if (!Uri.parse(link).isAbsolute) {
      return 'Invalid link format';
    }
    return null;
  }

  void clearLink() {
    setState(() {
      _linkController.clear();
      _linkError = null;
    });
  }

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your title';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description';
    }
    return null;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage == null) return;

    final path = File(pickedImage.path);

    setState(() {
      _selectedImages = path;
    });
  }

  Widget _buildImagePreview() {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 1,
        itemBuilder: (context, index) {
          final imageFile = _selectedImages;
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                width: 200, // Adjusted width for better visibility
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: FileImage(imageFile!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 15,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImages = null;
                    });
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _buildGetMode(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: const [
                          Expanded(
                            child: Icon(
                              Icons.photo_library,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Gallery',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.camera),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.blue),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: const [
                            Expanded(
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Camera',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handlePost() async {
    final link = _linkController.text;
    final title = _titleController.text;
    final description = _descriptionController.text;

    setState(() {
      _linkError = _validateLink(link);
      _titleError = _validateTitle(title);
      _descriptionError = _validateDescription(description);
    });

    if (_linkError == null &&
        _descriptionError == null &&
        _titleError == null &&
        _selectedImages != null) {
      setState(() {
        _isPosting = true;
      });

      final image =
          await MultipartFile.fromPath("image", _selectedImages!.path);
      if (_linkError == null && _descriptionError == null) {
        userBloc.add(CreatePendingJournal(
            journal:
                Journal(title: title, link: link, description: description),
            image: image));
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Validation Error'),
          content:
              Text('Please fill in all fields and select at least one image.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(listener: (context, state) {
      if (state is UserOperationSuccess) {
        GoRouter.of(context).pop();
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Create Journal')),
          actions: [
            state is UserLoading
                ? CircularProgressIndicator()
                : IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: _isPosting ? null : _handlePost,
                  ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _buildGetMode(context),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      width: 180,
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white70,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            const Divider(
              height: 16.0,
              thickness: 1.0,
            ),
            const SizedBox(height: 10.0),
            if (_selectedImages != null) Expanded(child: _buildImagePreview()),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                errorText: _titleError,
                prefixIcon: const Icon(
                  Icons.title,
                  color: Colors.blue,
                  size: 20,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    _titleController.clear();
                  },
                ),
                errorStyle: const TextStyle(
                  color: Colors.red,
                ),
                hintStyle: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a description...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                errorText: _descriptionError,
                prefixIcon: const Icon(
                  Icons.description,
                  color: Colors.blue,
                  size: 20,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    _descriptionController.clear();
                  },
                ),
                errorStyle: TextStyle(
                  color: Colors.red,
                ),
                hintStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _linkController,
              decoration: InputDecoration(
                labelText: 'Link',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                errorText: _linkError,
                prefixIcon: const Icon(
                  Icons.link,
                  color: Colors.blue,
                  size: 20,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ),
                  onPressed: clearLink,
                ),
                errorStyle: const TextStyle(
                  color: Colors.red,
                ),
                hintStyle: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onFieldSubmitted: (_) => _validateLink,
            ),
          ],
        ),
      );
    });
  }
}
