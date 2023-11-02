import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:x_tour/user/bloc/user_bloc.dart' as UserBloc;

import '../models/post.dart' as post_model;
import '../models/post.dart';
import '../repository/post_repository.dart';

part 'load_posts_event.dart';
part 'load_posts_state.dart';

class LoadPostsBloc extends Bloc<LoadPostsEvent, LoadPostsState> {
  final PostRepository postRepository;
  final UserBloc.UserBloc userBloc;
  LoadPostsBloc({required this.postRepository, required this.userBloc})
      : super(LoadPostsInitial()) {
    on<LoadPosts>(getPosts);
    on<LoadMore>(loadMore);
    on<LikePost>(likePost);
    on<UnlikePost>(unlikePost);
    on<BookmarkPost>(bookmarkPost);
    on<UnbookmarkPost>(unbookmarkPost);
  }

  FutureOr<void> getPosts(LoadPosts event, Emitter<LoadPostsState> emit) async {
    emit(PostsLoading());
    try {
      Map<String, dynamic> query = {
        "perPage": event.perPage,
        "page": event.page
      };
      final response = await postRepository.getHomepagePosts(query);
      emit(PostsLoaded(posts: response));
    } on Exception catch (e) {
      emit(PostsFailed(error: e));
    }
  }

  FutureOr<void> likePost(LikePost event, Emitter<LoadPostsState> emit) async {
    List<Posts> posts = (state as PostsLoaded).posts;
    try {
      final post = await postRepository.likePost(id: event.id);
      final newPosts = posts.map((e) => e.id == post.id ? post : e).toList();
      emit(PostsLoaded(posts: newPosts));
    } on Exception catch (_) {}
  }

  FutureOr<void> unlikePost(
      UnlikePost event, Emitter<LoadPostsState> emit) async {
    List<Posts> posts = (state as PostsLoaded).posts;
    try {
      final post = await postRepository.unlikePost(id: event.id);
      final newPosts = posts.map((e) => e.id == post.id ? post : e).toList();
      emit(PostsLoaded(posts: newPosts));
    } on Exception catch (_) {}
  }

  FutureOr<void> bookmarkPost(
      BookmarkPost event, Emitter<LoadPostsState> emit) async {
    try {
      userBloc.add(UserBloc.BookmarkPost(event.id));
    } on Exception catch (_) {}
  }

  FutureOr<void> unbookmarkPost(
      UnbookmarkPost event, Emitter<LoadPostsState> emit) async {
    try {
      userBloc.add(UserBloc.UnbookmarkPost(event.id));
    } on Exception catch (_) {}
  }

  FutureOr<void> loadMore(LoadMore event, Emitter<LoadPostsState> emit) async {
    try {
      List<Posts> posts = (state as PostsLoaded).posts;

      Map<String, dynamic> query = {"perPage": event.limit, "page": event.page};
      final response = await postRepository.getHomepagePosts(query);
      posts.addAll(response);
      emit(PostsLoaded(posts: posts));
    } on Exception catch (e) {
      emit(PostsLoadMoreFailed(error: e));
    }
  }
}
