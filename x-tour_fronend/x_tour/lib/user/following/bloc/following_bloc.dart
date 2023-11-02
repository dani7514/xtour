import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../bloc/user_bloc.dart';
import '../../models/user.dart';
import '../../repository/user_repository.dart';

part 'following_event.dart';
part 'following_state.dart';

class FollowingBloc extends Bloc<FollowingEvent, FollowingState> {
  final UserRepository userRepository;
  final UserBloc userBloc;

  FollowingBloc({required this.userRepository, required this.userBloc})
      : super(FollowingInitial()) {
    on<UnfollowUser>(unfollowUser);
    on<LoadFollowing>(loadFollowing);
  }

  FutureOr<void> unfollowUser(
      UnfollowUser event, Emitter<FollowingState> emit) async {
    try {
      final followers = (state as FollowingOperationSuccess).followings;
      await userRepository.unFollowUser(event.id);
      followers.removeWhere((element) => element.id == event.id);
      emit(FollowingLoading());
      emit(FollowingOperationSuccess(followings: followers));
      userBloc.add(GetUser());
    } on Exception catch (_) {}
  }

  FutureOr<void> loadFollowing(
      LoadFollowing event, Emitter<FollowingState> emit) async {
    emit(FollowingLoading());
    try {
      final followings = await userRepository.getFollowings();
      emit(FollowingOperationSuccess(followings: followings));
    } on Exception catch (e) {
      emit(FollowingOperationFailure(error: e));
    }
  }
}
