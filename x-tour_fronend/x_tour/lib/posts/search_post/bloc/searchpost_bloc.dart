import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/post.dart' as post_model;
import '../../repository/post_repository.dart';

part 'searchpost_event.dart';
part 'searchpost_state.dart';

class SearchpostBloc extends Bloc<SearchpostEvent, SearchpostState> {
  final PostRepository postRepository;
  SearchpostBloc({required this.postRepository}) : super(SearchpostInitial()) {
    on<SearchPost>(searchPost);
    on<LikePost>(likePost);
    on<UnlikePost>(unlikePost);
  }

  Future<FutureOr<void>> unlikePost(event, emit) async {
    List<post_model.Posts> posts = (state as SearchpostLoaded).posts;
    try {
      final post = await postRepository.unlikePost(id: event.id);
      final newPosts = posts.map((e) => e.id == post.id ? post : e).toList();
      emit(SearchpostLoaded(posts: newPosts));
    } on Exception catch (e) {
      emit(SearchpostFailed(error: e));
    }
  }

  FutureOr<void> likePost(event, emit) async {
    List<post_model.Posts> posts = (state as SearchpostLoaded).posts;
    try {
      final post = await postRepository.likePost(id: event.id);
      final newPosts = posts.map((e) => e.id == post.id ? post : e).toList();
      emit(SearchpostLoaded(posts: newPosts));
    } on Exception catch (e) {
      emit(SearchpostFailed(error: e));
    }
  }

  Future<FutureOr<void>> searchPost(event, emit) async {
    emit(SearchpostLoading());
    try {
      Map<String, dynamic> query = {
        "perPage": event.perPage,
        "page": event.page,
        "search": event.search
      };
      final response = await postRepository.getSearchedPosts(query);
      emit(SearchpostLoaded(posts: response));
    } on Exception catch (e) {
      emit(SearchpostFailed(error: e));
    }
  }
}
