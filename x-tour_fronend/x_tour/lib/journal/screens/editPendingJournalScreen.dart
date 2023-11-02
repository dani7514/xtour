import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_tour/custom/custom.dart';
import 'package:x_tour/journal/models/journal.dart';
import 'package:x_tour/journal/repository/journal_repository.dart';
import 'package:x_tour/screens/error_page.dart';
import 'package:x_tour/user/edit_journal/bloc/edit_journal_bloc.dart';
import 'package:x_tour/user/pending_journal/bloc/pending_journal_bloc.dart';
import 'package:http/http.dart' show MultipartFile;

class EditPendingJournalScreen extends StatefulWidget {
  EditPendingJournalScreen({super.key, required this.id});

  final String id;

  @override
  __EditPendingJournalScreenState createState() =>
      __EditPendingJournalScreenState();
}

class __EditPendingJournalScreenState extends State<EditPendingJournalScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _linkController;
  File? _selectedImage;
  bool _isPosting = false;
  String? _titleError;
  String? _descriptionError;
  String? _linkError;

  late final EditJournalBloc editJournalBloc;

  @override
  void initState() {
    super.initState();
    editJournalBloc =
        EditJournalBloc(journalRepository: context.read<JournalRepository>())
          ..add(LoadJournal(id: widget.id));
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _linkController = TextEditingController();
  }

  @override
  void dispose() {
    editJournalBloc.close();
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description';
    }
    return null;
  }

  String? _validateLink(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a link';
    }
    return null;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage == null) return;

    final path = File(pickedImage.path);

    setState(() {
      _selectedImage = path;
    });

    Navigator.of(context).pop(); // Dismiss the bottom sheet
  }

  Widget _buildImagePreview() {
    return Container(
      height: 150,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            width: 200, // Adjusted width for better visibility
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: FileImage(_selectedImage!),
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
                  _selectedImage = null;
                });
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _buildgetMode(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(
                  Icons.photo_library,
                  color: Colors.white,
                ),
                label: Text('Gallery'),
              ),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                label: Text('Camera'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handlePost() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final link = _linkController.text;

    setState(() {
      _titleError = _validateTitle(title);
      _descriptionError = _validateDescription(description);
      _linkError = _validateLink(link);

      if (_titleError == null &&
          _descriptionError == null &&
          _linkError == null) {
        _isPosting = true;
      }
    });

    final image = await MultipartFile.fromPath('image', _selectedImage!.path);
    if (_titleError == null &&
        _descriptionError == null &&
        _linkError == null) {
      editJournalBloc.add(UpdateJournal(
          id: widget.id,
          journal: Journal(title: title, link: link, description: description),
          images: image));

      await Future.delayed(Duration(seconds: 2));

      setState(() {
        _isPosting = false;
      });

      // Show a snackbar or navigate to a new page to indicate successful posting
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Post successful!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditJournalBloc, EditJournalState>(
      bloc: editJournalBloc,
      listener: (context, state) {
        if (state is EditJournalLoadFailure) {
          //TODO
          editJournalBloc.add(LoadJournal(id: widget.id));
        }
        if (state is EditJournalOperationFailure) {
          ErrorPage();
        }
        if (state is EditJournalOperationSuccess) {
          const snackBar = SnackBar(
            content: Text('Updated successfully!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          context.read<PendingJournalBloc>().add(GetPendingJournal());
          GoRouter.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: XTourAppBar(
            title: 'Create Journal',
            showActionIcon: IconButton(
              icon: Icon(Icons.check),
              onPressed: _isPosting ? null : _handlePost,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      errorText: _titleError,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      errorText: _descriptionError,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _linkController,
                    decoration: InputDecoration(
                      labelText: 'Link',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      errorText: _linkError,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: GestureDetector(
                      onTap: () => _buildgetMode(context),
                      child: Container(
                        child: Stack(
                          children: [
                            DottedBorder(
                              strokeWidth: 2,
                              color: Colors.blue,
                              dashPattern: [4, 4],
                              borderType: BorderType.Circle,
                              radius: Radius.circular(8),
                              child: Container(
                                width: 120,
                                height: 120,
                              ),
                            ),
                            Positioned(
                              top: 30,
                              left: 40,
                              child: Text(
                                'Image',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Positioned(
                              top: 60,
                              left: 40,
                              child: Icon(
                                Icons.add,
                                size: 48,
                                color: Colors.yellow,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (_selectedImage != null) _buildImagePreview(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
