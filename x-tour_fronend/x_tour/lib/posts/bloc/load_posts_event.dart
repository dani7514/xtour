part of 'load_posts_bloc.dart';

abstract class LoadPostsEvent extends Equatable {
  const LoadPostsEvent();

  @override
  List<Object> get props => [];
}

class LoadPosts extends LoadPostsEvent {
  final int perPage;
  final int page;

  const LoadPosts({this.perPage = 20, this.page = 1});

  @override
  List<Object> get props => [perPage, page];
}

class LoadMore extends LoadPostsEvent {
  final int limit;
  final int page;

  const LoadMore({this.limit = 20, this.page = 1});

  @override
  List<Object> get props => [limit, page];
}

class LikePost extends LoadPostsEvent {
  final String id;
  const LikePost({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class UnlikePost extends LoadPostsEvent {
  final String id;
  const UnlikePost({required this.id});

  @override
  List<Object> get props => [id];
}

class BookmarkPost extends LoadPostsEvent {
  final String id;
  const BookmarkPost({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class UnbookmarkPost extends LoadPostsEvent {
  final String id;
  const UnbookmarkPost({required this.id});

  @override
  List<Object> get props => [id];
}
