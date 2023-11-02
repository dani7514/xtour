part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserOperationSuccess extends UserState {
  final User user;

  const UserOperationSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class UserOperationFailure extends UserState {
  final Exception error;

  const UserOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
