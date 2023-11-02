part of 'following_bloc.dart';

abstract class FollowingEvent extends Equatable {
  const FollowingEvent();

  @override
  List<Object> get props => [];
}

class UnfollowUser extends FollowingEvent {
  final String id;

  const UnfollowUser(this.id);

  @override
  List<Object> get props => [id];
}

class LoadFollowing extends FollowingEvent {}
