part of 'bookmark_bloc.dart';

@immutable
abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object?> get props => [];
}

class UnbookmarkPost extends BookmarkEvent {
  final String postId;
  const UnbookmarkPost(this.postId);

  @override
  List<Object?> get props => [postId];
}

class LoadBookmarkPosts extends BookmarkEvent {}
