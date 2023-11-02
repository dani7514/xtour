part of 'posts_bloc.dart';

@immutable
abstract class ApprovedPostsState extends Equatable {
  const ApprovedPostsState();

  @override
  List<Object?> get props => [];
}

class ApprovedPostsInitial extends ApprovedPostsState {}

class ApprovedPostsLoading extends ApprovedPostsState {}

class ApprovedPostsOperationSuccess extends ApprovedPostsState {
  final List<Posts> posts;

  const ApprovedPostsOperationSuccess({required this.posts});

  @override
  List<Object?> get props => [posts];
}

class ApprovedPostsOperationFailure extends ApprovedPostsState {
  final Exception error;

  const ApprovedPostsOperationFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
