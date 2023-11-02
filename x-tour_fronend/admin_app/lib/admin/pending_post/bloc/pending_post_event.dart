part of 'pending_post_bloc.dart';

abstract class PendingPostEvent extends Equatable {
  const PendingPostEvent();

  @override
  List<Object> get props => [];
}

class LoadPendingPost extends PendingPostEvent {
  final int limit;
  final int page;

  const LoadPendingPost({this.limit = 20, this.page = 1});

  @override
  List<Object> get props => [limit, page];
}

class LoadMorePendingPost extends PendingPostEvent {
  final int limit;
  final int page;

  const LoadMorePendingPost({this.limit = 20, this.page = 1});

  @override
  List<Object> get props => [limit, page];
}

class ApprovePendingPost extends LoadPendingPost {
  final String id;
  final Posts post;

  const ApprovePendingPost({required this.id, required this.post});

  @override
  List<Object> get props => [id, post];
}

class DeletePendingPost extends PendingPostEvent {
  final String id;

  const DeletePendingPost({required this.id});

  @override
  List<Object> get props => [id];
}
