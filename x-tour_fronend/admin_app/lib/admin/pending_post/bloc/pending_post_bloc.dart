import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:x_tour/admin/pending_post/model/post.dart';
import 'package:x_tour/admin/pending_post/repository/pending_post_repository.dart';

part 'pending_post_event.dart';
part 'pending_post_state.dart';

class PendingPostBloc extends Bloc<PendingPostEvent, PendingPostState> {
  final PendingPostRepository pendingPostRepository;
  PendingPostBloc({required this.pendingPostRepository})
      : super(PendingPostInitial()) {
    on<LoadPendingPost>(loadPost);
    on<LoadMorePendingPost>(loadMorePost);
    on<ApprovePendingPost>(approvePost);
    on<DeletePendingPost>(deletePost);
  }

  FutureOr<void> loadPost(
      LoadPendingPost event, Emitter<PendingPostState> emit) async {
    emit(PendingPostLoading());
    try {
      Map<String, dynamic> query = {"perPage": event.limit, "page": event.page};
      final List<Posts> posts =
          await pendingPostRepository.getPendingPosts(query);
      emit(PendingPostLoading());
      emit(PendingPostLoaded(posts: posts));
    } on Exception catch (e) {
      emit(PendingPostFailure(error: e));
    }
  }

  FutureOr<void> loadMorePost(
      LoadMorePendingPost event, Emitter<PendingPostState> emit) async {
    final List<Posts> posts = (state as PendingPostLoaded).posts;
    try {
      Map<String, dynamic> query = {"perPage": event.limit, "page": event.page};
      final response = await pendingPostRepository.getPendingPosts(query);
      posts.addAll(response);
      emit(PendingPostLoaded(posts: posts));
    } catch (_) {}
  }

  FutureOr<void> approvePost(
      ApprovePendingPost event, Emitter<PendingPostState> emit) async {
    try {
      await pendingPostRepository.approvePendingPosts(event.id, event.post);
      final posts = await pendingPostRepository.getPendingPosts({});
      emit(PendingPostLoading());
      emit(PendingPostLoaded(posts: posts));
    } catch (_) {}
  }

  FutureOr<void> deletePost(
      DeletePendingPost event, Emitter<PendingPostState> emit) async {
    final posts = (state as PendingPostLoaded).posts;
    try {
      await pendingPostRepository.deletePendingPost(id: event.id);
      posts.removeWhere((element) => element.id == event.id);
      emit(PendingPostLoading());
      emit(PendingPostLoaded(posts: posts));
    } catch (_) {}
  }
}
