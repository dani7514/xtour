part of 'posts_bloc.dart';

@immutable
abstract class ApprovedPostsEvent extends Equatable {
  const ApprovedPostsEvent();

  @override
  List<Object?> get props => [];
}

class GetApprovedPost extends ApprovedPostsEvent {
  // final int limit;
  // final int page;

  const GetApprovedPost();

  @override
  List<Object?> get props => [];
}

class DeleteApprovedPost extends ApprovedPostsEvent {
  final String id;

  const DeleteApprovedPost({required this.id});

  @override
  List<Object?> get props => [id];
}
