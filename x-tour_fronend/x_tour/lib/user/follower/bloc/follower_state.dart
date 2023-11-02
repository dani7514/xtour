part of 'follower_bloc.dart';

abstract class FollowerState extends Equatable {
  const FollowerState();

  @override
  List<Object> get props => [];
}

class FollowerInitial extends FollowerState {}

class FollowerLoading extends FollowerState {}

class FollowerOperationSuccess extends FollowerState {
  final List<User> followers;

  const FollowerOperationSuccess({required this.followers});

  @override
  List<Object> get props => [followers];
}

class FollowerOperationFailure extends FollowerState {
  final Exception error;

  const FollowerOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
