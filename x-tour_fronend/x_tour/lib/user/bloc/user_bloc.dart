import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:http/http.dart' show MultipartFile;
import '../../journal/models/journal.dart';
import '../../journal/repository/journal_repository.dart';
import '../../posts/models/post.dart';
import '../../posts/repository/post_repository.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final JournalRepository journalRepository;
  final PostRepository postRepository;

  UserBloc(
      {required this.journalRepository,
      required this.postRepository,
      required this.userRepository})
      : super(UserInitial()) {
    on<UpdateUser>(updateUser);
    on<GetUser>(getUser);
    on<LoadUser>(loadUser);
    on<BookmarkPost>(boomarkPost);
    on<UnbookmarkPost>(unbookmarkPost);
    on<FollowUser>(followUser);
    on<UnfollowUser>(unfollowUser);
    on<CreatePendingPost>(createPendingPost);
    on<CreatePendingJournal>(createPendingJournal);
  }
  FutureOr<void> updateUser(UpdateUser event, Emitter<UserState> emit) async {
    try {
      User user = (state as UserOperationSuccess).user;
      if (event.user != null) {
        user = await userRepository.updateProfile(event.user!);
      }
      if (event.image != null) {
        user = await userRepository.inserImage(event.image!);
      }
      emit(UserLoading());
      emit(UserOperationSuccess(user: user));
    } on Exception catch (e) {
      emit(UserOperationFailure(error: e));
    }
  }

  FutureOr<void> getUser(GetUser event, Emitter<UserState> emit) async {
    try {
      final User user = await userRepository.getInfo();
      emit(UserOperationSuccess(user: user));
    } on Exception catch (_) {}
  }

  FutureOr<void> loadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final User user = await userRepository.getInfo();
      emit(UserOperationSuccess(user: user));
    } on Exception catch (_) {}
  }

  FutureOr<void> boomarkPost(
      BookmarkPost event, Emitter<UserState> emit) async {
    try {
      final User user = await userRepository.bookmarkPost(event.postId);
      emit(UserOperationSuccess(user: user));
    } on Exception catch (_) {}
  }

  FutureOr<void> unbookmarkPost(
      UnbookmarkPost event, Emitter<UserState> emit) async {
    try {
      final User user = await userRepository.unbookmarkPost(event.postId);
      emit(UserOperationSuccess(user: user));
    } on Exception catch (_) {}
  }

  FutureOr<void> followUser(FollowUser event, Emitter<UserState> emit) async {
    try {
      final User user = await userRepository.followUser(event.id);
      emit(UserLoading());
      emit(UserOperationSuccess(user: user));
    } on Exception catch (_) {}
  }

  FutureOr<void> unfollowUser(
      UnfollowUser event, Emitter<UserState> emit) async {
    try {
      final User user = await userRepository.unFollowUser(event.id);
      emit(UserLoading());
      emit(UserOperationSuccess(user: user));
    } on Exception catch (_) {}
  }

  FutureOr<void> createPendingPost(
      CreatePendingPost event, Emitter<UserState> emit) async {
    final User user = (state as UserOperationSuccess).user;
    emit(UserLoading());
    try {
      final Posts post =
          await postRepository.createPost(post: event.post, user: user);

      await postRepository.insertImage(id: post.id!, images: event.images);

      final List<String> userPendingPosts = user.penddingPosts ?? [];
      userPendingPosts.add(post.id!);
      final newUser = user.copyWith(penddingPosts: userPendingPosts);
      emit(UserOperationSuccess(user: newUser));
    } on Exception catch (e) {
      emit(UserOperationFailure(error: e));
    }
  }

  FutureOr<void> createPendingJournal(
      CreatePendingJournal event, Emitter<UserState> emit) async {
    final User user = (state as UserOperationSuccess).user;
    emit(UserLoading());
    try {
      final Journal journal = await journalRepository.createJournal(
          journal: event.journal, user: user);
      await journalRepository.insertImage(id: journal.id!, image: event.image);
      final List<String> userPendingJournal = user.journals ?? [];
      userPendingJournal.add(journal.id!);
      final newUser = user.copyWith(pendingJournal: userPendingJournal);
      emit(UserOperationSuccess(user: newUser));
    } on Exception catch (e) {
      emit(UserOperationFailure(error: e));
    }
  }
}
