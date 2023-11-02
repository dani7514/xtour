part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class InitApp extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class LoggedIn extends AuthEvent {
  final String token;
  const LoggedIn({required this.token});

  @override
  List<Object?> get props => [token];
}

class LogOut extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class RefreshToken extends AuthEvent {
  const RefreshToken();

  @override
  List<Object?> get props => [];
}
