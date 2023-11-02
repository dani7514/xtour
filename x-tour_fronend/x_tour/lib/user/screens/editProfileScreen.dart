import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart' show MultipartFile;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../custom/custom.dart';
import '../bloc/user_bloc.dart';
import '../models/user.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _selectedImages;
  bool isImageSelected = false;

  late final UserBloc userBloc;

  @override
  void initState() {
    userBloc = context.read<UserBloc>();
    User user = (userBloc.state as UserOperationSuccess).user;
    _nameController.text = user.fullName!;
    _usernameController.text = user.username!;
    super.initState();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage == null) return;

    final path = File(pickedImage.path);

    setState(() {
      _selectedImages = path;
      isImageSelected = !isImageSelected;
    });
  }

  @override
  void dispose() {
    if (userBloc.state is UserOperationFailure) {
      userBloc.add(GetUser());
    }
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserOperationSuccess) {
          const snackBar = SnackBar(
            content: Text('Updated successfully!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          GoRouter.of(context).pop();
        }

        if (state is UserOperationFailure) {
          const snackBar = SnackBar(
            content: Text('Something went wrong, Try using another username'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: XTourAppBar(
            title: 'Edit Profile',
            leading: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    GoRouter.of(context).pop(context);
                  },
                ),
              ],
            ),
            showActionIcon: state is UserLoading
                ? CircularProgressIndicator()
                : IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      final String? fullName = _nameController.text == ""
                          ? null
                          : _nameController.text;
                      final String? username = _usernameController.text == ""
                          ? null
                          : _usernameController.text;
                      final String? password = _passwordController.text == ""
                          ? null
                          : _passwordController.text;

                      final MultipartFile? profilePicture =
                          _selectedImages != null
                              ? await MultipartFile.fromPath(
                                  "image", _selectedImages!.path)
                              : null;

                      userBloc.add(UpdateUser(
                          user: User(
                              username: username,
                              password: password,
                              fullName: fullName),
                          image: profilePicture));
                    },
                  ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: isImageSelected
                              ? FileImage(_selectedImages!)
                              : Image.network(
                                      "http://10.0.2.2:3000/${(userBloc.state as UserOperationSuccess).user.profilePicture!}")
                                  .image,
                        )),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: GestureDetector(
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: Text(
                        'Edit Picture',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your username',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
