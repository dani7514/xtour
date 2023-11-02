part of 'searchpost_bloc.dart';

abstract class SearchpostState extends Equatable {
  const SearchpostState();

  @override
  List<Object> get props => [];
}

class SearchpostInitial extends SearchpostState {}

class SearchpostLoading extends SearchpostState {}

class SearchpostLoaded extends SearchpostState {
  final List<post_model.Posts> posts;
  const SearchpostLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class SearchpostFailed extends SearchpostState {
  final Exception error;
  const SearchpostFailed({required this.error});

  @override
  List<Object> get props => [error];
}
