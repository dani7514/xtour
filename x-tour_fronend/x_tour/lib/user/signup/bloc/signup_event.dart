part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignUp extends SignupEvent {
  final String fullName;
  final String username;
  final String password;

  const SignUp(
      {required this.fullName, required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
