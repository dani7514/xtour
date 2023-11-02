import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:x_tour/user/repository/user_repository.dart';

import '../../bloc/user_bloc.dart';
import '../../models/user.dart';

part 'other_followers_event.dart';
part 'other_followers_state.dart';

class OtherFollowersBloc
    extends Bloc<OtherFollowersEvent, OtherFollowersState> {
  final UserRepository userRepository;
  final UserBloc userBloc;

  OtherFollowersBloc({required this.userBloc, required this.userRepository})
      : super(OtherFollowersInitial()) {
    on<LoadFollower>(loadFollower);
    on<OtherFollowUser>(followUser);
  }

  FutureOr<void> loadFollower(
      LoadFollower event, Emitter<OtherFollowersState> emit) async {
    emit(OtherFollowerLoading());
    try {
      final followers = await userRepository.getOtherUserFollowers(event.id);
      emit(OtherFollowerOperationSuccess(followers: followers));
    } on Exception catch (e) {
      emit(OtherFollowerOperationFailure(error: e));
    }
  }

  FutureOr<void> followUser(
      OtherFollowUser event, Emitter<OtherFollowersState> emit) async {
    try {
      await userRepository.followUser(event.id);
      userBloc.add(GetUser());
    } on Exception catch (_) {}
  }
}
