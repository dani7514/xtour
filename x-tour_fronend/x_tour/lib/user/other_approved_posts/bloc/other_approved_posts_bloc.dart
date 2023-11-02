import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:x_tour/posts/repository/post_repository.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';
import 'package:x_tour/user/repository/user_repository.dart';

import '../../../posts/models/post.dart';

part 'other_approved_posts_event.dart';
part 'other_approved_posts_state.dart';

class OtherApprovedPostsBloc
    extends Bloc<OtherApprovedPostsEvent, OtherApprovedPostsState> {
  final UserRepository userRepository;
  final PostRepository postRepository;
  final UserBloc userBloc;

  OtherApprovedPostsBloc(
      {required this.userRepository,
      required this.userBloc,
      required this.postRepository})
      : super(OtherApprovedPostsInitial()) {
    on<LoadPosts>(getPosts);
    on<LikePost>(likePost);
    on<UnlikePost>(unlikePost);
    on<BookmarkPost>(bookmarkPost);
    on<UnbookmarkPost>(unbookmarkPost);
  }

  FutureOr<void> getPosts(
      LoadPosts event, Emitter<OtherApprovedPostsState> emit) async {
    emit(PostsLoading());
    try {
      final response = await userRepository.getOtherUserApprovedPosts(event.id);
      emit(PostsLoaded(posts: response));
    } on Exception catch (e) {
      emit(PostsFailed(error: e));
    }
  }

  FutureOr<void> likePost(
      LikePost event, Emitter<OtherApprovedPostsState> emit) async {
    List<Posts> posts = (state as PostsLoaded).posts;
    try {
      final post = await postRepository.likePost(id: event.id);
      final newPosts = posts.map((e) => e.id == post.id ? post : e).toList();
      emit(PostsLoaded(posts: newPosts));
    } catch (_) {}
  }

  FutureOr<void> unlikePost(
      UnlikePost event, Emitter<OtherApprovedPostsState> emit) async {
    List<Posts> posts = (state as PostsLoaded).posts;
    try {
      final post = await postRepository.unlikePost(id: event.id);
      final newPosts = posts.map((e) => e.id == post.id ? post : e).toList();
      emit(PostsLoaded(posts: newPosts));
    } catch (_) {}
  }

  FutureOr<void> bookmarkPost(
      BookmarkPost event, Emitter<OtherApprovedPostsState> emit) async {
    try {
      userBloc.add(BookmarkPost(id: event.id) as UserEvent);
    } catch (_) {}
  }

  FutureOr<void> unbookmarkPost(
      UnbookmarkPost event, Emitter<OtherApprovedPostsState> emit) async {
    try {
      userBloc.add(UnbookmarkPost(id: event.id) as UserEvent);
    } catch (_) {}
  }
}
