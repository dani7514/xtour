import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';
import 'package:x_tour/user/repository/user_repository.dart';

import '../../models/user.dart';

part 'other_followings_event.dart';
part 'other_followings_state.dart';

class OtherFollowingsBloc
    extends Bloc<OtherFollowingsEvent, OtherFollowingsState> {
  final UserRepository userRepository;
  final UserBloc userBloc;
  OtherFollowingsBloc({required this.userRepository, required this.userBloc})
      : super(OtherFollowingsInitial()) {
    on<OtherUnfollowUser>(unfollowUser);
    on<LoadFollowing>(loadFollowing);
  }

  FutureOr<void> unfollowUser(
      OtherUnfollowUser event, Emitter<OtherFollowingsState> emit) async {
    try {
      final followers = (state as OtherFollowingOperationSuccess).followings;
      await userRepository.unFollowUser(event.id);
      followers.removeWhere((element) => element.id == event.id);
      emit(OtherFollowingOperationSuccess(followings: followers));
      userBloc.add(GetUser());
    } on Exception catch (_) {}
  }

  FutureOr<void> loadFollowing(
      LoadFollowing event, Emitter<OtherFollowingsState> emit) async {
    emit(OtherFollowingLoading());
    try {
      final followings = await userRepository.getOtherUserFollowings(event.id);
      emit(OtherFollowingOperationSuccess(followings: followings));
    } on Exception catch (e) {
      emit(OtherFollowingOperationFailure(error: e));
    }
  }
}
