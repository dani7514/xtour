import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../bloc/user_bloc.dart';
import '../../models/user.dart';
import '../../repository/user_repository.dart';

part 'follower_event.dart';
part 'follower_state.dart';

class FollowerBloc extends Bloc<FollowerEvent, FollowerState> {
  final UserRepository userRepository;
  final UserBloc userBloc;

  FollowerBloc({required this.userRepository, required this.userBloc})
      : super(FollowerInitial()) {
    on<FollowUser>(followUser);
    on<LoadFollower>(loadFollower);
  }

  FutureOr<void> followUser(
      FollowUser event, Emitter<FollowerState> emit) async {
    try {
      await userRepository.followUser(event.id);
      userBloc.add(GetUser());
    } on Exception catch (_) {}
  }

  FutureOr<void> loadFollower(
      LoadFollower event, Emitter<FollowerState> emit) async {
    emit(FollowerLoading());
    try {
      final followers = await userRepository.getFollowers();
      emit(FollowerOperationSuccess(followers: followers));
    } on Exception catch (e) {
      emit(FollowerOperationFailure(error: e));
    }
  }
}
