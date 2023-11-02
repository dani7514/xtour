part of 'others_profile_bloc.dart';

@immutable
abstract class OthersProfileState extends Equatable {
  const OthersProfileState();

  @override
  List<Object?> get props => [];
}

class OthersProfileInitial extends OthersProfileState {}

class OthersProfileLoading extends OthersProfileState {}

class OtherProfileOperationSuccess extends OthersProfileState {
  final User user;

  const OtherProfileOperationSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class OtherProfileOperationFailure extends OthersProfileState {
  final Exception error;

  const OtherProfileOperationFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
