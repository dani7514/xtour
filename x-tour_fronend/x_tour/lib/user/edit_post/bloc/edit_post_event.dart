part of 'edit_post_bloc.dart';

@immutable
abstract class EditPostEvent extends Equatable {
  const EditPostEvent();

  @override
  List<Object?> get props => [];
}

class LoadPost extends EditPostEvent {
  final String id;

  const LoadPost({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdatePost extends EditPostEvent {
  final String id;
  final Posts? post;
  final List<MultipartFile>? images;

  const UpdatePost({required this.id, this.post, this.images});
  @override
  List<Object?> get props => [id];
}
