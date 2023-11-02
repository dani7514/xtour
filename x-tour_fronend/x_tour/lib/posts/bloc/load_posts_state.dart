part of 'load_posts_bloc.dart';

abstract class LoadPostsState extends Equatable {
  const LoadPostsState();

  @override
  List<Object> get props => [];
}

class LoadPostsInitial extends LoadPostsState {}

class PostsLoading extends LoadPostsState {}

class PostsLoaded extends LoadPostsState {
  final List<post_model.Posts> posts;

  const PostsLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class PostsLoadMoreFailed extends LoadPostsState {
  final Exception error;

  const PostsLoadMoreFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class PostsFailed extends LoadPostsState {
  final Exception error;

  const PostsFailed({required this.error});

  @override
  List<Object> get props => [error];
}
