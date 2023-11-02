part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

//! Login success is redirected to AuthBLoc
class LoginOperationFailure extends LoginState {
  final Exception error;

  const LoginOperationFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
