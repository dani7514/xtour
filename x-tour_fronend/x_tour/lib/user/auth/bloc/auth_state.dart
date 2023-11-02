part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

class AuthUninitialized extends AuthState {
  @override
  List<Object?> get props => []; //! Inorder to prevent rerender
}

class AuthInitializing extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthAuthenticated extends AuthState {
  final String accessToken;
  AuthAuthenticated({required this.accessToken});
  @override
  List<Object?> get props => [];
}

class AuthUnauthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthFailed extends AuthState {
  @override
  List<Object?> get props => [];
}
