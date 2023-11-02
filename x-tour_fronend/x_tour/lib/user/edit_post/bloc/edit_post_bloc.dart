import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:x_tour/posts/models/post.dart';
import 'package:http/http.dart' show MultipartFile;
import 'package:x_tour/posts/repository/post_repository.dart';

part 'edit_post_event.dart';
part 'edit_post_state.dart';

class EditPostBloc extends Bloc<EditPostEvent, EditPostState> {
  final PostRepository postRepository;
  EditPostBloc({required this.postRepository}) : super(EditPostInitial()) {
    on<LoadPost>(loadPost);
    on<UpdatePost>(updatePost);
  }

  FutureOr<void> loadPost(LoadPost event, Emitter<EditPostState> emit) async {
    emit(EditPostLoading());
    try {
      final post = await postRepository.getPendingPost(event.id);
      emit(EditPostLoaded(post: post));
    } catch (e) {
      emit(EditPostLoadFailure());
    }
  }

  FutureOr<void> updatePost(
      UpdatePost event, Emitter<EditPostState> emit) async {
    Posts post = (state as EditPostLoaded).post;
    emit(EditPostLoading());
    try {
      if (event.post != null) {
        post = await postRepository.updatePost(id: event.id, post: event.post!);
      }
      if (event.images != null) {
        post = await postRepository.insertImage(
            id: event.id, images: event.images!);
      }
      emit(EditPostOperationSuccess());
    } on Exception catch (_) {
      emit(EditPostLoadFailure());
    }
  }
}
