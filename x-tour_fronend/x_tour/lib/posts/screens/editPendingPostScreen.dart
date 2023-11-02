import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_tour/posts/models/post.dart';
import 'package:x_tour/posts/repository/post_repository.dart';
import 'package:x_tour/screens/error_page.dart';
import "package:x_tour/user/edit_post/bloc/edit_post_bloc.dart";
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_tour/custom/custom.dart';
import 'package:http/http.dart' show MultipartFile;

import '../../user/pending_posts/bloc/pending_posts_bloc.dart';

class EditPendingPostScreen extends StatefulWidget {
  EditPendingPostScreen({super.key, required this.id});
  final String id;
  @override
  _EditPendingPostScreenState createState() => _EditPendingPostScreenState();
}

class _EditPendingPostScreenState extends State<EditPendingPostScreen> {
  late final EditPostBloc editPPostBloc;

  String? _storyError;
  String? _descriptionError;
  late TextEditingController _storyController;
  late TextEditingController _descriptionController;
  List<File> _selectedImages = [];
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    editPPostBloc = EditPostBloc(postRepository: context.read<PostRepository>())
      ..add(LoadPost(id: widget.id));
    _storyController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    editPPostBloc.close();
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
    final story = _storyController.text;
    final description = _descriptionController.text;

    setState(() {
      _storyError = _validateStory(story);
      _descriptionError = _validateDescription(description);
      if (_storyError == null && _descriptionError == null) {
        _isPosting = true;
      }
    });

    final List<MultipartFile>? images = null;
    _selectedImages.forEach((element) async {
      var image = await MultipartFile.fromPath("images", element.path);
      images!.add(image);
    });
    if (_storyError == null && _descriptionError == null) {
      editPPostBloc.add(UpdatePost(
          id: widget.id,
          post: Posts(story: story, description: description),
          images: images));

      setState(() {
        _isPosting = false;
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Post successful!')),
      // );
    }
    ;

    // Show a snackbar or navigate to a new page to indicate successful posting
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditPostBloc, EditPostState>(
      bloc: editPPostBloc,
      listener: (context, state) {
        if (state is EditPostLoadFailure) {
          //TODO
          // editPPostBloc.add(LoadPost(id: widget.id));
        }
        if (state is EditPostOperationFailure) {
          // TODO
          ErrorPage();
        }
        if (state is EditPostOperationSuccess) {
          const snackBar = SnackBar(
            content: Text('Updated successfully!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          context.read<PendingPostsBloc>().add(const GetPendingPost());
          GoRouter.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: XTourAppBar(
            title: 'Edit Post',
            showActionIcon: IconButton(
              icon: Icon(Icons.check),
              onPressed: _isPosting ? null : _handlePost,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _storyController,
                  decoration: InputDecoration(
                      labelText: 'Story',
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
                      errorText: _storyError),
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
                          horizontal: 16.0, vertical: 12.0),
                      errorText: _descriptionError),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: Column(children: [
                    SizedBox(
                      height: 100,
                    ),
                    GestureDetector(
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
                            const Positioned(
                              top: 30,
                              left: 40,
                              child: Text(
                                'Image',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            const Positioned(
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
                  ]),
                ),
                const SizedBox(height: 16.0),
                if (_selectedImages.isNotEmpty)
                  Expanded(
                    child: _buildImagePreview(),
                  )
                // else
                //   const Text('No images selected'),
              ],
            ),
          ),
        );
      },
    );
  }
}
