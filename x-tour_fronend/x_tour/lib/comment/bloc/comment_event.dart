part of 'comment_bloc.dart';

@immutable
abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

class CreateComment extends CommentEvent {
  final Comment comment;

  const CreateComment({required this.comment});

  @override
  List<Object> get props => [comment];
}

class GetComments extends CommentEvent {
  final String id;
  final int limit;
  final int page;
  final bool isReply;

  const GetComments(
      {required this.id, this.limit = 5, this.page = 1, this.isReply = false});

  @override
  List<Object> get props => [limit, page];
}

class DeleteComment extends CommentEvent {
  final String id;

  const DeleteComment({required this.id});
  @override
  List<Object> get props => [id];
}

class UpdateComment extends CommentEvent {
  final String commentId;
  final Comment comment;

  const UpdateComment({required this.commentId, required this.comment});

  @override
  List<Object> get props => [commentId, comment];
}
