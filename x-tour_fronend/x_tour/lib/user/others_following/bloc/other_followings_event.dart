part of 'other_followings_bloc.dart';

@immutable
abstract class OtherFollowingsEvent extends Equatable {
  const OtherFollowingsEvent();

  @override
  List<Object?> get props => [];
}

class OtherUnfollowUser extends OtherFollowingsEvent {
  final String id;

  const OtherUnfollowUser(this.id);

  @override
  List<Object> get props => [id];
}

class LoadFollowing extends OtherFollowingsEvent {
  final String id;

  const LoadFollowing({required this.id});

  @override
  List<Object?> get props => [id];
}
