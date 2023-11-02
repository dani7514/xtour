part of 'other_approved_posts_bloc.dart';

@immutable
abstract class OtherApprovedPostsEvent extends Equatable {
  const OtherApprovedPostsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPosts extends OtherApprovedPostsEvent {
  final String id;

  const LoadPosts({required this.id});

  @override
  List<Object?> get props => [id];
}

class LikePost extends OtherApprovedPostsEvent {
  final String id;
  const LikePost({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class UnlikePost extends OtherApprovedPostsEvent {
  final String id;
  const UnlikePost({required this.id});

  @override
  List<Object> get props => [id];
}

class BookmarkPost extends OtherApprovedPostsEvent {
  final String id;
  const BookmarkPost({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class UnbookmarkPost extends OtherApprovedPostsEvent {
  final String id;
  const UnbookmarkPost({required this.id});

  @override
  List<Object> get props => [id];
}
