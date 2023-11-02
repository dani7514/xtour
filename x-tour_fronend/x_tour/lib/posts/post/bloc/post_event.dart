part of 'post_bloc.dart';

@immutable
abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class LoadPost extends PostEvent {
  final String id;

  const LoadPost({required this.id});

  @override
  List<Object?> get props => [id];
}

class LikePost extends PostEvent {
  final String id;
  const LikePost({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class UnlikePost extends PostEvent {
  final String id;
  const UnlikePost({required this.id});

  @override
  List<Object> get props => [id];
}

class BookmarkPost extends PostEvent {
  final String id;
  const BookmarkPost({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class UnbookmarkPost extends PostEvent {
  final String id;
  const UnbookmarkPost({required this.id});

  @override
  List<Object> get props => [id];
}
