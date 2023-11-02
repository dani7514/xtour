import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:x_tour/user/repository/auth_repository.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../bloc/user_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authBloc;
  final AuthRepository authRepository;
  final UserBloc userBloc;
  LoginBloc(
      {required this.authBloc,
      required this.authRepository,
      required this.userBloc})
      : super(LoginInitial()) {
    on<Login>(login);
  }

  FutureOr<void> login(event, emit) async {
    emit(LoginLoading());
    try {
      final Map<String, dynamic> body = {
        "username": event.username,
        "password": event.password,
      };
      final Map<String, dynamic> response = await authRepository.login(body);
      emit(LoginInitial());
      authBloc.add(LoggedIn(token: response["access_token"]));
      userBloc.add(LoadUser());
    } on Exception catch (e) {
      emit(LoginOperationFailure(error: e));
    }
  }
}
