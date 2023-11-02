import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:x_tour/user/repository/auth_repository.dart';

import '../../login/bloc/login_bloc.dart';
import '../../repository/user_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;
  final LoginBloc loginBloc;

  SignupBloc({required this.authRepository, required this.loginBloc})
      : super(SignupInitial()) {
    on<SignUp>(signup);
  }

  FutureOr<void> signup(SignUp event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
    try {
      Map<String, dynamic> body = {
        "fullName": event.fullName,
        "username": event.username,
        "password": event.password,
      };
      final Map<String, dynamic> user = await authRepository.signup(body);
      loginBloc
          .add(Login(username: user['username'], password: body['password']));
    } on Exception catch (e) {
      emit(SignupOperationFailure(error: e));
    }
  }
}
