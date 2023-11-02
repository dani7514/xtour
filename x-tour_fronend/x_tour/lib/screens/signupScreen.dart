import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../custom/custom_button.dart';
import '../custom/custom.dart';
import '../theme/xTour_theme.dart';
import '../user/signup/bloc/signup_bloc.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late SignupBloc signupBloc;
  @override
  void initState() {
    signupBloc = context.read<SignupBloc>();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Please enter both your first and last name';
    }
    return null;
  }

  String? _validateusername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateRePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please re-enter your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      // Perform signup logic
      final fullName = _fullNameController.text;
      final username = _usernameController.text;
      final password = _passwordController.text;
      final rePassword = _rePasswordController.text;

      signupBloc.add(SignUp(
        fullName: fullName,
        username: username,
        password: password,
      ));
    }
  }

  @override
  void dispose() {
    signupBloc.close();
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: XTourTheme().dark(),
      title: 'X-tour',
      home: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          if (state is SignupLoading) {
            Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            body: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: Text(
                              'Get started with us',
                              style: TextStyle(
                                fontSize: 43,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [
                                      Color.fromRGBO(85, 233, 242, 1),
                                      Color.fromRGBO(95, 56, 249, 1),
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                  ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                const SizedBox(width: 30),
                                Expanded(
                                  child: CustomTextField(
                                    labelText: 'Your full name',
                                    prefixIcon: Icons.person,
                                    controller: _fullNameController,
                                    borderRadius: 30,
                                    onChanged: (value) {
                                      // Handle the full name input value
                                    },
                                    validator: _validateFullName,
                                  ),
                                ),
                                const SizedBox(width: 30),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                const SizedBox(width: 30),
                                Expanded(
                                  child: CustomTextField(
                                    labelText: 'username',
                                    prefixIcon: Icons.person,
                                    controller: _usernameController,
                                    borderRadius: 30,
                                    onChanged: (value) {
                                      // Handle the username input value
                                    },
                                    validator: _validateusername,
                                  ),
                                ),
                                const SizedBox(width: 30),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                const SizedBox(width: 30),
                                Expanded(
                                  child: CustomTextField(
                                    labelText: 'Password',
                                    prefixIcon: Icons.lock,
                                    controller: _passwordController,
                                    borderRadius: 30,
                                    onChanged: (value) {
                                      // Handle the password input value
                                    },
                                    validator: _validatePassword,
                                    obscureText: true,
                                  ),
                                ),
                                const SizedBox(width: 30),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                const SizedBox(width: 30),
                                Expanded(
                                  child: CustomTextField(
                                    labelText: 'Re-Password',
                                    prefixIcon: Icons.lock,
                                    controller: _rePasswordController,
                                    borderRadius: 30,
                                    onChanged: (value) {
                                      // Handle the re-password input value
                                    },
                                    validator: _validateRePassword,
                                    obscureText: true,
                                  ),
                                ),
                                const SizedBox(width: 30),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          ElevatedButton(
                            onPressed: _signup,
                            child: const Text('Signup'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: const Size(250, 40),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                              onTap: () {
                                GoRouter.of(context).go("/login");
                              },
                              child: Text(
                                'Already have an account',
                                style: TextStyle(fontSize: 13),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
