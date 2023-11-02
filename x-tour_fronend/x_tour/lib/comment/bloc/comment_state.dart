part of 'comment_bloc.dart';

@immutable
abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentOperationSuccess extends CommentState {
  final List<Comment> comments;

  const CommentOperationSuccess({required this.comments});

  @override
  List<Object> get props => [comments];
}

class CommentCreationOperationFailure extends CommentState {
  final Exception error;

  const CommentCreationOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class CommentOperationFailure extends CommentState {
  final Exception error;

  const CommentOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
