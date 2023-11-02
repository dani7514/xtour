part of 'other_followers_bloc.dart';

@immutable
abstract class OtherFollowersEvent extends Equatable {
  const OtherFollowersEvent();

  @override
  List<Object?> get props => [];
}

class OtherFollowUser extends OtherFollowersEvent {
  final String id;

  const OtherFollowUser(this.id);

  @override
  List<Object> get props => [id];
}

class LoadFollower extends OtherFollowersEvent {
  final String id;

  const LoadFollower({required this.id});

  @override
  List<Object?> get props => [id];
}
