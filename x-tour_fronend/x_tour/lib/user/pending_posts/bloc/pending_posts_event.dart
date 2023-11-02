part of 'pending_posts_bloc.dart';

abstract class PendingPostsEvent extends Equatable {
  const PendingPostsEvent();

  @override
  List<Object> get props => [];
}

class GetPendingPost extends PendingPostsEvent {
  // final int limit;
  // final int page;

  // const GetPendingPost({this.limit = 20, this.page = 1});
  const GetPendingPost();

  @override
  List<Object> get props => [];
}

class DeletePendingPost extends PendingPostsEvent {
  final String id;

  const DeletePendingPost({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdatePendingPost extends PendingPostsEvent {
  final String postId;
  final post_model.Posts? post;
  final List<MultipartFile>? images;

  const UpdatePendingPost({required this.postId, this.post, this.images});

  @override
  List<Object> get props => [postId];
}
