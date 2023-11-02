part of 'follower_bloc.dart';

abstract class FollowerEvent extends Equatable {
  const FollowerEvent();

  @override
  List<Object> get props => [];
}

class FollowUser extends FollowerEvent {
  final String id;

  const FollowUser(this.id);

  @override
  List<Object> get props => [id];
}

class LoadFollower extends FollowerEvent {}
