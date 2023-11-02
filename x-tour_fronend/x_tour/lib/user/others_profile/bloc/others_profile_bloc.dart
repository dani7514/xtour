import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:x_tour/user/repository/user_repository.dart';

import '../../models/user.dart';

part 'others_profile_event.dart';
part 'others_profile_state.dart';

class OthersProfileBloc extends Bloc<OthersProfileEvent, OthersProfileState> {
  final UserRepository userRepository;
  OthersProfileBloc({required this.userRepository})
      : super(OthersProfileInitial()) {
    on<LoadOtherUser>((event, emit) async {
      emit(OthersProfileLoading());

      try {
        final User user = await userRepository.getOtherUser(event.id);
        emit(OtherProfileOperationSuccess(user: user));
      } on Exception catch (e) {
        emit(OtherProfileOperationFailure(error: e));
      }
    });
  }
}
