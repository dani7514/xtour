import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' show MultipartFile;

import '../../../posts/models/post.dart' as post_model;
import '../../../posts/models/post.dart';
import '../../../posts/repository/post_repository.dart';
import '../../bloc/user_bloc.dart';
import '../../repository/user_repository.dart';

part 'pending_posts_event.dart';
part 'pending_posts_state.dart';

class PendingPostsBloc extends Bloc<PendingPostsEvent, PendingPostsState> {
  final UserRepository userRepository;
  final PostRepository postRepository;
  final UserBloc userBloc;

  PendingPostsBloc(
      {required this.userRepository,
      required this.postRepository,
      required this.userBloc})
      : super(PendingPostsInitial()) {
    on<GetPendingPost>(getPendingPost);
    on<DeletePendingPost>(deletePendingPost);
    on<UpdatePendingPost>(updatePendingPost);
  }

  getPendingPost(GetPendingPost event, Emitter<PendingPostsState> emit) async {
    emit(PendingPostsLoading());
    try {
      final response = await userRepository
          .getPendingPosts((userBloc.state as UserOperationSuccess).user);
      emit(PendingPostsOperationSuccess(posts: response));
    } on Exception catch (e) {
      emit(PendingPostsOperationFailure(error: e));
    }
  }

  Future<FutureOr<void>> deletePendingPost(
      DeletePendingPost event, Emitter<PendingPostsState> emit) async {
    try {
      final List<Posts> posts = (state as PendingPostsOperationSuccess).posts;
      await postRepository.deletePendingPost(
          id: event.id, user: (userBloc.state as UserOperationSuccess).user);
      posts.removeWhere((element) => element.id == event.id);
      emit(PendingPostsLoading());
      emit(PendingPostsOperationSuccess(posts: posts));
      userBloc.add(GetUser());
    } on Exception catch (e) {
      emit(PendingPostsOperationFailure(error: e));
    }
  }

  Future<FutureOr<void>> updatePendingPost(
      UpdatePendingPost event, Emitter<PendingPostsState> emit) async {
    emit(PendingPostsLoading());
    try {
      final List<Posts> posts = (state as PendingPostsOperationSuccess).posts;
      Posts post = posts.firstWhere((element) => element.id == event.postId);
      if (event.post != null) {
        post = await postRepository.updatePost(
            id: event.postId, post: event.post!);
      }
      if (event.images != null) {
        post = await postRepository.insertImage(
            id: event.postId, images: event.images!);
      }
      final newPosts = posts.map((e) => e.id == post.id ? post : e).toList();
      emit(PendingPostsLoading());
      emit(PendingPostsOperationSuccess(posts: newPosts));
    } on Exception catch (e) {
      emit(PendingPostsOperationFailure(error: e));
    }
  }
}
