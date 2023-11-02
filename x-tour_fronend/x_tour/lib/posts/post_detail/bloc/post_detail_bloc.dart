import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:x_tour/posts/models/post.dart';

import '../../../user/bloc/user_bloc.dart';
import '../../repository/post_repository.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final PostRepository postRepository;
  final UserBloc userBloc;
  PostDetailBloc({required this.postRepository, required this.userBloc})
      : super(PostDetailInitial()) {
    on<PostDetailEvent>((event, emit) {});
    on<LoadPostDetail>(getPostDetail);
  }

  FutureOr<void> getPostDetail(
      LoadPostDetail event, Emitter<PostDetailState> emit) async {
    emit(PostDetailLoading());
    try {
      final response = await postRepository.getApprovedPost(event.id);
      emit(PostDetailLoaded(post: response));
    } on Exception catch (e) {
      emit(PostDetailFailed(error: e));
    }
  }
}
