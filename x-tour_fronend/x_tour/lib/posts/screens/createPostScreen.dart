import 'dart:io';
// import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_tour/posts/models/post.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';
import 'package:http/http.dart' show MultipartFile;

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late final UserBloc userBloc;

  String? _storyError;
  String? _descriptionError;
  late TextEditingController _storyController;
  late TextEditingController _descriptionController;
  List<File> _selectedImages = [];
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();
    _storyController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    if (userBloc.state is UserOperationFailure) {
      userBloc.add(GetUser());
    }
    _storyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateStory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your story';
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
      _selectedImages.add(path);
    });
  }

  Widget _buildImagePreview() {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          final imageFile = _selectedImages[index];
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                width: 200, // Adjusted width for better visibility
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: FileImage(imageFile),
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
                      _selectedImages.removeAt(index);
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
            color: Colors.white,
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
                          color: Colors.blue),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
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
                      )),
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
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
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
                        )),
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
    final story = _storyController.text;
    final description = _descriptionController.text;

    setState(() {
      _storyError = _validateStory(story);
      if (_selectedImages.isEmpty) {
        _descriptionError = 'Please select an image';
      } else {
        _descriptionError = _validateDescription(description);
      }
      if (_storyError == null && _descriptionError == null) {
        _isPosting = true;
      }
    });
    final List<MultipartFile> images = [];
    _selectedImages.forEach((element) async {
      var image = await MultipartFile.fromPath("images", element.path);
      images.add(image);
    });
    if (_storyError == null &&
        _descriptionError == null &&
        _selectedImages.isNotEmpty) {

      setState(() {
        _isPosting = false;
      });

      

      userBloc.add(CreatePendingPost(post: Posts(story: story, description: description), images: images));

      
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserOperationSuccess) {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post successful!'),
            ),
          );
          GoRouter.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is UserOperationFailure) {
          //TODO
        }
        return Scaffold(
          appBar: AppBar(
            title: Center(child: const Text('Create Post')),
            actions: [
              state is UserLoading
                  ? CircularProgressIndicator()
                  : IconButton(
                      icon: Icon(Icons.check),
                      onPressed: _isPosting ? null : _handlePost,
                    ),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Center(
                child: Column(children: [
                  GestureDetector(
                    onTap: () => _buildGetMode(context),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      width: 180,
                      height: 350, // Adjusted width for better visibility
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white70),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 10.0),
              const Divider(
                height: 16.0,
                thickness: 1.0,
                color: Colors.grey,
              ),
              const SizedBox(height: 10.0),

              if (_selectedImages.isNotEmpty)
                Expanded(
                  child: _buildImagePreview(),
                ),

              const SizedBox(height: 16.0),

              TextFormField(
                controller: _storyController,
                decoration: InputDecoration(
                  labelText: 'Story',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  errorText: _storyError,
                  prefixIcon: const Icon(
                    Icons.edit_note,
                    color: Colors.blue,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      _storyController.clear();
                    },
                  ),
                  errorStyle: const TextStyle(
                    color: Colors.red,
                  ),
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[500],
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
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  errorText: _descriptionError,
                  prefixIcon: const Icon(
                    Icons.description, // Add an icon before the input field
                    color: Colors.blue,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons
                          .clear, // Add a clear button at the end of the input field
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _descriptionController.clear(); // Clear the input field
                    },
                  ),
                  errorStyle: TextStyle(
                    color: Colors.red, // Customize the error text color
                  ),
                  hintStyle: TextStyle(
                    fontStyle:
                        FontStyle.italic, // Customize the hint text style
                    color: Colors.grey[500],
                  ),
                ),
              ),

              // else
              //   const Text('No images selected'),
            ],
          ),
        );
      },
    );
  }
}
