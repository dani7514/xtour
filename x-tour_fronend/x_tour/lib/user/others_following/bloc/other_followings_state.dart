part of 'other_followings_bloc.dart';

@immutable
abstract class OtherFollowingsState extends Equatable {
  const OtherFollowingsState();

  @override
  List<Object?> get props => [];
}

class OtherFollowingsInitial extends OtherFollowingsState {}

class OtherFollowingInitial extends OtherFollowingsState {}

class OtherFollowingLoading extends OtherFollowingsState {}

class OtherFollowingOperationSuccess extends OtherFollowingsState {
  final List<User> followings;

  const OtherFollowingOperationSuccess({required this.followings});

  @override
  List<Object> get props => [followings];
}

class OtherFollowingOperationFailure extends OtherFollowingsState {
  final Exception error;

  const OtherFollowingOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
