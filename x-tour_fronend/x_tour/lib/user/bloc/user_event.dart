part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UpdateUser extends UserEvent {
  final User? user;
  final MultipartFile? image;
  const UpdateUser({this.user, this.image});

  @override
  List<Object> get props => [];
}

class GetUser extends UserEvent {}

class LoadUser extends UserEvent {}

class BookmarkPost extends UserEvent {
  final String postId;

  const BookmarkPost(this.postId);

  @override
  List<Object> get props => [postId];
}

class UnbookmarkPost extends UserEvent {
  final String postId;

  const UnbookmarkPost(this.postId);

  @override
  List<Object> get props => [postId];
}

class FollowUser extends UserEvent {
  final String id;
  const FollowUser({required this.id});
  @override
  List<Object> get props => [id];
}

class UnfollowUser extends UserEvent {
  final String id;
  const UnfollowUser({required this.id});
  @override
  List<Object> get props => [id];
}

class CreatePendingPost extends UserEvent {
  final Posts post;
  final List<MultipartFile> images;

  const CreatePendingPost({required this.post, required this.images});

  @override
  List<Object> get props => [post];
}

class CreatePendingJournal extends UserEvent {
  final Journal journal;
  final MultipartFile image;

  const CreatePendingJournal({required this.journal, required this.image});

  @override
  List<Object> get props => [journal];
}
