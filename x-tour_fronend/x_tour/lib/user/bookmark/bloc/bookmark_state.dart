part of 'bookmark_bloc.dart';

@immutable
abstract class BookmarkState extends Equatable {
  const BookmarkState();

  @override
  List<Object?> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkOperationSuccess extends BookmarkState {
  final List<Posts> bookmarkPosts;
  const BookmarkOperationSuccess({required this.bookmarkPosts});

  @override
  List<Object?> get props => [bookmarkPosts];
}

class BookmarkOperationFailure extends BookmarkState {
  final Exception error;

  const BookmarkOperationFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
