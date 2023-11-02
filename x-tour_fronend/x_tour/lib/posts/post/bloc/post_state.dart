part of 'post_bloc.dart';

@immutable
abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final Posts post;

  const PostLoaded({required this.post});

  @override
  List<Object> get props => [post];
}

class PostFailed extends PostState {
  final Exception error;

  const PostFailed({required this.error});

  @override
  List<Object> get props => [error];
}
