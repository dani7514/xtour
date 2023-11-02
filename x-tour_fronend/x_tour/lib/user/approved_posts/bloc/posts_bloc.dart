import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../posts/models/post.dart';
import '../../../posts/repository/post_repository.dart';
import '../../bloc/user_bloc.dart';
import '../../repository/user_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class ApprovedPostsBloc extends Bloc<ApprovedPostsEvent, ApprovedPostsState> {
  final UserRepository userRepository;
  final PostRepository postRepository;
  final UserBloc userBloc;

  ApprovedPostsBloc(
      {required this.userRepository,
      required this.postRepository,
      required this.userBloc})
      : super(ApprovedPostsInitial()) {
    on<GetApprovedPost>(getApprovedPost);
    on<DeleteApprovedPost>(deleteApprovedPost);
  }

  Future<FutureOr<void>> getApprovedPost(
      GetApprovedPost event, Emitter<ApprovedPostsState> emit) async {
    emit(ApprovedPostsLoading());
    try {
      final response = await userRepository
          .getApprovedPosts((userBloc.state as UserOperationSuccess).user);
      emit(ApprovedPostsOperationSuccess(posts: response));
    } on Exception catch (e) {
      emit(ApprovedPostsOperationFailure(error: e));
    }
  }

  Future<FutureOr<void>> deleteApprovedPost(
      DeleteApprovedPost event, Emitter<ApprovedPostsState> emit) async {
    try {
      final List<Posts> posts = (state as ApprovedPostsOperationSuccess).posts;
      await postRepository.deleteApprovedPost(
          id: event.id, user: (userBloc.state as UserOperationSuccess).user);
      posts.removeWhere((element) => element.id == event.id);
      emit(ApprovedPostsOperationSuccess(posts: posts));
      userBloc.add(GetUser());
    } on Exception catch (e) {
      emit(ApprovedPostsOperationFailure(error: e));
    }
  }
}
