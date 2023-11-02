part of 'pending_posts_bloc.dart';

abstract class PendingPostsState extends Equatable {
  const PendingPostsState();

  @override
  List<Object> get props => [];
}

class PendingPostsInitial extends PendingPostsState {}

class PendingPostsLoading extends PendingPostsState {}

class PendingPostsOperationSuccess extends PendingPostsState {
  final List<post_model.Posts> posts;

  const PendingPostsOperationSuccess({required this.posts});

  @override
  List<Object> get props => [posts];
}

class PendingPostsOperationFailure extends PendingPostsState {
  final Exception error;

  const PendingPostsOperationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
