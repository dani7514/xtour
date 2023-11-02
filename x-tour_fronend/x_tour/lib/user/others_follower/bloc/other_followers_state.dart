part of 'other_followers_bloc.dart';

@immutable
abstract class OtherFollowersState extends Equatable {
  const OtherFollowersState();

  @override
  List<Object?> get props => [];
}

class OtherFollowersInitial extends OtherFollowersState {}

class OtherFollowerInitial extends OtherFollowersState {}

class OtherFollowerLoading extends OtherFollowersState {}

class OtherFollowerOperationSuccess extends OtherFollowersState {
  final List<User> followers;

  const OtherFollowerOperationSuccess({required this.followers});

  @override
  List<Object> get props => [followers];
}

class OtherFollowerOperationFailure extends OtherFollowersState {
  final Exception error;

  const OtherFollowerOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
