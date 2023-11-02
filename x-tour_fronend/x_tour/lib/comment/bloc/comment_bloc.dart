import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../user/repository/user_repository.dart';
import '../repository/comment_repository.dart';
import 'package:x_tour/comment/models/comment.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository commentRepository;
  final UserRepository userRepository;
  CommentBloc({required this.commentRepository, required this.userRepository})
      : super(CommentInitial()) {
    on<GetComments>(getComments);
    on<CreateComment>(createComment);
    on<DeleteComment>(deleteComment);
    on<UpdateComment>(updateComment);
  }

  FutureOr<void> updateComment(event, emit) async {
    CommentOperationSuccess currentState = state as CommentOperationSuccess;
    List<Comment>? comments = currentState.comments;
    emit(CommentLoading());
    try {
      final comment = await commentRepository.updateComment(
          comment: event.comment, id: event.commentId);
      List<Comment>? newComments =
          comments.map((e) => e.id == comment.id ? comment : e).toList();
      emit(CommentOperationSuccess(comments: newComments));
    } on Exception catch (e) {
      emit(CommentOperationFailure(error: e));
    }
  }

  FutureOr<void> deleteComment(event, emit) async {
    CommentOperationSuccess currentState = state as CommentOperationSuccess;
    List<Comment>? comments = currentState.comments;
    emit(CommentLoading());
    try {
      await commentRepository.deleteComment(event.id);
      comments.removeWhere((element) => element.id == event.id);
      emit(CommentOperationSuccess(comments: comments));
    } on Exception catch (e) {
      emit(CommentOperationFailure(error: e));
    }
  }

  FutureOr<void> createComment(event, emit) async {
    CommentOperationSuccess currentState = state as CommentOperationSuccess;
    List<Comment>? comments = currentState.comments;
    emit(CommentLoading());
    try {
      Comment newComment = await commentRepository.createComment(event.comment);
      comments.insert(0, newComment);
      emit(CommentOperationSuccess(comments: comments));
    } on Exception catch (e) {
      emit(CommentOperationFailure(error: e));
    }
  }

  FutureOr<void> getComments(event, emit) async {
    emit(CommentLoading());
    Map<String, dynamic> query = {
      "perPage": event.limit,
      "page": event.page,
    };

    try {
      if (event.isReply) {
        final response = await commentRepository.getReplies(
            commentId: event.id, query: query);

        emit(CommentOperationSuccess(comments: response ?? []));
      } else {
        final response =
            await commentRepository.getComments(postId: event.id, query: query);
        emit(CommentOperationSuccess(comments: response ?? []));
      }
    } catch (e) {
      emit(CommentOperationFailure(error: e as Exception));
    }
  }
}
