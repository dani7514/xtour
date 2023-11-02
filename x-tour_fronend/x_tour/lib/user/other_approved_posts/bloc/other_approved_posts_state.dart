part of 'other_approved_posts_bloc.dart';

@immutable
abstract class OtherApprovedPostsState extends Equatable {
  const OtherApprovedPostsState();

  @override
  List<Object?> get props => [];
}

class OtherApprovedPostsInitial extends OtherApprovedPostsState {}

class PostsLoading extends OtherApprovedPostsState {}

class PostsLoaded extends OtherApprovedPostsState {
  final List<Posts> posts;

  const PostsLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class PostsFailed extends OtherApprovedPostsState {
  final Exception error;

  const PostsFailed({required this.error});

  @override
  List<Object> get props => [error];
}
