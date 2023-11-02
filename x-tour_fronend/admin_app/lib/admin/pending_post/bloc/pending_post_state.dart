part of 'pending_post_bloc.dart';

abstract class PendingPostState extends Equatable {
  const PendingPostState();
  
  @override
  List<Object> get props => [];
}

class PendingPostInitial extends PendingPostState {}

class PendingPostLoading extends PendingPostState {}

class PendingPostLoaded extends PendingPostState{
  final List<Posts> posts;

  const PendingPostLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class PendingPostFailure extends PendingPostState{
  final Exception error;

  const PendingPostFailure({required this.error});

  @override
  List<Object> get props => [error];
}