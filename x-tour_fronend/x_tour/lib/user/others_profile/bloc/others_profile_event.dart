part of 'others_profile_bloc.dart';

@immutable
abstract class OthersProfileEvent extends Equatable {
  const OthersProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadOtherUser extends OthersProfileEvent {
  final String id;

  const LoadOtherUser({required this.id});

  @override
  List<Object?> get props => [id];
}
