part of 'edit_post_bloc.dart';

@immutable
abstract class EditPostState extends Equatable {
  const EditPostState();

  @override
  List<Object?> get props => [];
}

class EditPostInitial extends EditPostState {}

class EditPostLoading extends EditPostState {}

class EditPostOperating extends EditPostState {}

class EditPostLoaded extends EditPostState {
  final Posts post;

  const EditPostLoaded({required this.post});
}

class EditPostLoadFailure extends EditPostState {}

class EditPostOperationSuccess extends EditPostState {}

class EditPostOperationFailure extends EditPostState {}
