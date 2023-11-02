import 'package:chopper/chopper.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/cache%20service/sqflite_service.dart';
import 'package:x_tour/chopper%20convertor/chopper_convertor.dart';
import 'package:x_tour/comment/data/comment_service.dart';
import 'package:x_tour/comment/repository/comment_repository.dart';
import 'package:x_tour/journal/data/journal_service.dart';
import 'package:x_tour/journal/repository/journal_repository.dart';
import 'package:x_tour/posts/data/posts_service.dart';
import 'package:x_tour/posts/repository/post_repository.dart';
import 'package:x_tour/user/auth/bloc/auth_bloc.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';
import 'package:x_tour/user/data/auth_service.dart';
import 'package:x_tour/user/data/user_service.dart';
import 'package:x_tour/user/login/bloc/login_bloc.dart';
import 'package:x_tour/user/pending_journal/bloc/pending_journal_bloc.dart';
import 'package:x_tour/user/pending_posts/bloc/pending_posts_bloc.dart';
import 'package:x_tour/user/repository/auth_repository.dart';
import 'package:x_tour/user/repository/user_repository.dart';
import 'package:x_tour/user/signup/bloc/signup_bloc.dart';
import 'routes/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final chopperClient = ChopperClient(
      baseUrl: Uri.parse("http://10.0.2.2:3000"),
      services: [
        JournalService.create(),
        PostService.create(),
        CommentService.create(),
        UserService.create()
      ],
      converter: ChopperConvetor());
  final chopperClient2 = ChopperClient(
      baseUrl: Uri.parse("http://10.0.2.2:3000"),
      services: [AuthService.create()],
      converter: const JsonConverter());

  // Defining Services
  UserService userService = UserService.create(chopperClient);
  JournalService journalService = JournalService.create(chopperClient);
  CommentService commentService = CommentService.create(chopperClient);
  PostService postService = PostService.create(chopperClient);
  AuthService authService = AuthService.create(chopperClient2);

  SqfliteService sqfliteService = SqfliteService();
  sqfliteService.initSqflite();

  // Defining Repository and bloc
  AuthRepository authRepository =
      AuthRepository(sqfliteService: sqfliteService, authService: authService);
  AuthBloc authBloc = AuthBloc(authRepository: authRepository)..add(InitApp());
  UserRepository userRepository = UserRepository(
      userService: userService,
      authService: authService,
      sqfliteService: sqfliteService,
      authBloc: authBloc);
  JournalRepository journalRepository = JournalRepository(
      journalService: journalService,
      sqfliteService: sqfliteService,
      authBloc: authBloc);
  PostRepository postRepository = PostRepository(
      userService: userService,
      postService: postService,
      sqfliteService: sqfliteService,
      authBloc: authBloc);
  UserBloc userBloc = UserBloc(
      journalRepository: journalRepository,
      postRepository: postRepository,
      userRepository: userRepository);

  PendingPostsBloc pendingPostsBloc = PendingPostsBloc(
      userRepository: userRepository,
      postRepository: postRepository,
      userBloc: userBloc);

  PendingJournalBloc pendingJournalBloc = PendingJournalBloc(
      userRepository: userRepository,
      journalRepository: journalRepository,
      userBloc: userBloc);

  LoginBloc loginBloc = LoginBloc(
      authBloc: authBloc, authRepository: authRepository, userBloc: userBloc);
  SignupBloc signupBloc =
      SignupBloc(authRepository: authRepository, loginBloc: loginBloc);
  CommentRepository commentRepository =
      CommentRepository(commentService: commentService, authBloc: authBloc);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider.value(
        value: authBloc,
      ),
      BlocProvider.value(
        value: userBloc,
      ),
      BlocProvider.value(
        value: loginBloc,
      ),
      BlocProvider.value(
        value: signupBloc,
      ),
      BlocProvider.value(
        value: pendingPostsBloc,
      ),
      BlocProvider.value(
        value: pendingJournalBloc,
      )
    ],
    child: MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: userRepository,
        ),
        RepositoryProvider.value(
          value: postRepository,
        ),
        RepositoryProvider.value(
          value: journalRepository,
        ),
        RepositoryProvider.value(
          value: commentRepository,
        ),
      ],
      child: EasyDynamicThemeWidget(child: AppRoute(authBloc: authBloc)),
    ),
  ));
}
