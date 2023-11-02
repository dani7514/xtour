import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:x_tour/user/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({
    required this.authRepository,
  }) : super(AuthUninitialized()) {
    on<InitApp>(initApp);
    on<LoggedIn>(loggedIn);
    on<LogOut>(logOut);
  }

  FutureOr<void> initApp(InitApp event, Emitter<AuthState> emit) async {
    emit(AuthInitializing());
    try {
      final String? accessToken = await authRepository.getAccessToken();
      if (accessToken == null) {
        emit(AuthUnauthenticated());
      } else {
        emit(AuthAuthenticated(accessToken: accessToken));
      }
    } on Exception catch (_) {
      emit(AuthUnauthenticated());
      // Can be replaced with AuthFailed
    }
  }

  FutureOr<void> loggedIn(LoggedIn event, Emitter<AuthState> emit) {
    emit(AuthInitializing());
    emit(AuthAuthenticated(accessToken: event.token));
  }

  FutureOr<void> logOut(LogOut event, Emitter<AuthState> emit) async {
    emit(AuthInitializing());
    try {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    } on Exception catch (_) {
      emit(AuthFailed());
    }
  }
}
