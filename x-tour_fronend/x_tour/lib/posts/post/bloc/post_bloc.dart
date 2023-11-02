import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';

import '../../models/post.dart';
import '../../repository/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  final UserBloc userBloc;

  PostBloc({required this.postRepository, required this.userBloc})
      : super(PostInitial()) {
    on<LoadPost>(getPost);
    on<LikePost>(likePost);
    on<UnlikePost>(unlikePost);
    on<BookmarkPost>(bookmarkPost);
    on<UnbookmarkPost>(unbookmarkPost);
  }

  FutureOr<void> getPost(LoadPost event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final response = await postRepository.getApprovedPost(event.id);
      emit(PostLoaded(post: response));
    } on Exception catch (e) {
      emit(PostFailed(error: e));
    }
  }

  FutureOr<void> likePost(LikePost event, Emitter<PostState> emit) async {
    try {
      final post = await postRepository.likePost(id: event.id);
      emit(PostLoaded(post: post));
    } catch (_) {}
  }

  FutureOr<void> unlikePost(UnlikePost event, Emitter<PostState> emit) async {
    try {
      final post = await postRepository.unlikePost(id: event.id);
      emit(PostLoaded(post: post));
    } catch (_) {}
  }

  FutureOr<void> bookmarkPost(
      BookmarkPost event, Emitter<PostState> emit) async {
    try {
      userBloc.add(BookmarkPost(id: event.id) as UserEvent);
    } catch (_) {}
  }

  FutureOr<void> unbookmarkPost(
      UnbookmarkPost event, Emitter<PostState> emit) async {
    try {
      userBloc.add(BookmarkPost(id: event.id) as UserEvent);
    } catch (_) {}
  }
}
