part of 'post_detail_bloc.dart';

@immutable
abstract class PostDetailState extends Equatable {
  const PostDetailState();

  @override
  List<Object?> get props => [];
}

class PostDetailInitial extends PostDetailState {}

class PostDetailLoading extends PostDetailState {}

class PostDetailLoaded extends PostDetailState {
  final Posts post;

  const PostDetailLoaded({required this.post});

  @override
  List<Object> get props => [post];
}

class PostDetailFailed extends PostDetailState {
  final Exception error;

  const PostDetailFailed({required this.error});

  @override
  List<Object> get props => [error];
}
