part of 'signup_bloc.dart';

@immutable
abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupOperationFailure extends SignupState {
  final Exception error;

  const SignupOperationFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
