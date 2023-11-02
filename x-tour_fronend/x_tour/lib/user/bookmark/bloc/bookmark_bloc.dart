import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chopper/chopper.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../posts/models/post.dart';
import '../../bloc/user_bloc.dart';
import '../../repository/user_repository.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final UserRepository userRepository;
  final UserBloc userBloc;
  BookmarkBloc({required this.userRepository, required this.userBloc})
      : super(BookmarkInitial()) {
    on<UnbookmarkPost>(unbookmarkPost);
    on<LoadBookmarkPosts>(loadBookmarkPosts);
  }

  FutureOr<void> unbookmarkPost(
      UnbookmarkPost event, Emitter<BookmarkState> emit) async {
    try {
      final bookmarkedPosts = (state as BookmarkOperationSuccess).bookmarkPosts;
      final user = await userRepository.unbookmarkPost(event.postId);
      bookmarkedPosts.removeWhere((element) => element.id == event.postId);
      emit(BookmarkOperationSuccess(bookmarkPosts: bookmarkedPosts));
      userBloc.add(GetUser());
    } on Exception catch (e) {
      emit(BookmarkOperationFailure(error: e));
    }
  }

  FutureOr<void> loadBookmarkPosts(
      LoadBookmarkPosts event, Emitter<BookmarkState> emit) async {
    emit(BookmarkLoading());
    try {
      final bookmarkedPosts = await userRepository
          .getBookmarkPosts((userBloc.state as UserOperationSuccess).user);
      emit(BookmarkOperationSuccess(bookmarkPosts: bookmarkedPosts));
    } on Exception catch (e) {
      emit(BookmarkOperationFailure(error: e));
    }
  }
}
