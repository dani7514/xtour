import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_tour/cache%20service/sqflite_service.dart';
import 'package:x_tour/chopper%20convertor/chopper_convertor.dart';
import 'package:x_tour/comment/data/comment_service.dart';
import 'package:x_tour/comment/repository/comment_repository.dart';
import 'package:x_tour/custom/xtour_appBar.dart';
import 'package:x_tour/journal/data/journal_service.dart';
import 'package:x_tour/journal/repository/journal_repository.dart';
import 'package:x_tour/posts/data/posts_service.dart';
import 'package:x_tour/posts/repository/post_repository.dart';
import 'package:x_tour/screens/screens.dart';
import 'package:x_tour/user/auth/bloc/auth_bloc.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';
import 'package:x_tour/user/data/auth_service.dart';
import 'package:x_tour/user/data/user_service.dart';
import 'package:x_tour/user/login/bloc/login_bloc.dart';
import 'package:x_tour/user/models/user.dart';
import 'package:x_tour/user/pending_journal/bloc/pending_journal_bloc.dart';
import 'package:x_tour/user/pending_posts/bloc/pending_posts_bloc.dart';
import 'package:x_tour/user/repository/auth_repository.dart';
import 'package:x_tour/user/repository/user_repository.dart';
import 'package:x_tour/user/screens/profileScreen.dart';
import 'package:x_tour/user/signup/bloc/signup_bloc.dart';

void main() {
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

  setUp(() {
    userBloc.add(LoadUser());
  });
  testWidgets('ProfileScreen Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(BlocProvider.value(
      value: userBloc,
      child: MaterialApp(home: ProfileScreen()),
    ));

    final xTourAppBarh = find.byType(XTourAppBar);
    expect(xTourAppBarh, findsOneWidget);

    final circularAvatar = find.byType(CircleAvatar);
    expect(circularAvatar, findsOneWidget);

    final followerText = find.text('Followers');
    expect(followerText, findsOneWidget);

    final followingText = find.text('Following');
    expect(followingText, findsOneWidget);

    final photoLibraryicon = find.byIcon(Icons.photo_library);
    expect(photoLibraryicon, findsOneWidget);

    final articleOutlinedicon = find.byIcon(Icons.article_outlined);
    expect(articleOutlinedicon, findsOneWidget);

    final bookmarkAddicon = find.byIcon(Icons.bookmark_add);
    expect(bookmarkAddicon, findsOneWidget);

    await tester.tap(find.byIcon(Icons.photo_library));
    await tester.pump();

    expect((tester.widget<Icon>(find.byIcon(Icons.photo_library)).color),
        Colors.blue);

    await tester.tap(find.byIcon(Icons.article_outlined));
    await tester.pump();

    final journalIcon = find.byIcon(Icons.article_outlined);
    expect((tester.widget<Icon>(journalIcon).color), Colors.blue);

    final bookmarkIcon = find.byIcon(Icons.bookmark_add);
    await tester.tap(bookmarkIcon);
    await tester.pump();

    expect((tester.widget<Icon>(bookmarkIcon).color), Colors.blue);

    expect(find.byType(GridView), findsOneWidget);

    final iconFinder = find.byIcon(Icons.menu);
    expect(iconFinder, findsOneWidget);

    await tester.tap(iconFinder);
    await tester.pumpAndSettle();

    final menuDialogFinder = find.byType(Dialog);

    expect(menuDialogFinder, findsOneWidget);

    final pendingJournalFinder =
        find.widgetWithText(ListTile, 'Pending Journal');
    final logoutFinder = find.widgetWithText(ListTile, 'Logout');

    expect(pendingJournalFinder, findsOneWidget);
    expect(logoutFinder, findsOneWidget);

    final followerGesture = find.byKey(const Key('followerGesture'));
    expect(followerGesture, findsOneWidget);
    await tester.tap(followerGesture);
    await tester.pumpAndSettle();

    final followerDialogFinder = find.byType(Dialog);
    expect(followerDialogFinder, findsOneWidget);

    final followerDialogTextFinder = find.text('Followers');
    expect(followerDialogTextFinder, findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(followerDialogFinder, findsNothing);

    final followingGesture = find.byKey(const Key('followingGesture'));
    expect(followingGesture, findsOneWidget);
    await tester.tap(followingGesture);
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
  });
}
