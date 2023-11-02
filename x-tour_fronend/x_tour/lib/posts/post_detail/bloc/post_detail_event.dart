part of 'post_detail_bloc.dart';

@immutable
abstract class PostDetailEvent extends Equatable {
  const PostDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadPostDetail extends PostDetailEvent {
  final String id;

  const LoadPostDetail({required this.id});

  @override
  List<Object?> get props => [id];
}
