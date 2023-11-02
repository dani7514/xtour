part of 'following_bloc.dart';

abstract class FollowingState extends Equatable {
  const FollowingState();

  @override
  List<Object> get props => [];
}

class FollowingInitial extends FollowingState {}

class FollowingLoading extends FollowingState {}

class FollowingOperationSuccess extends FollowingState {
  final List<User> followings;

  const FollowingOperationSuccess({required this.followings});

  @override
  List<Object> get props => [followings];
}

class FollowingOperationFailure extends FollowingState {
  final Exception error;

  const FollowingOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
