import 'package:bloc_test/bloc_test.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' show MultipartFile;
import 'package:mockito/mockito.dart';
import 'package:x_tour/journal/models/journal.dart';
import 'package:x_tour/journal/repository/journal_repository.dart';
import 'package:x_tour/posts/models/post.dart' as post_model;
import 'package:x_tour/posts/repository/post_repository.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';
import 'package:x_tour/user/models/user.dart';
import 'package:x_tour/user/repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {
  final User testUser;

  MockUserRepository(this.testUser);

  @override
  Future<User> getInfo() async {
    return testUser;
  }

  @override
  Future<User> inserImage(MultipartFile image) async {
    return testUser;
  }

  @override
  Future<User> followUser(String id) async {
    return testUser;
  }

  @override
  Future<User> unFollowUser(String id) async {
    return testUser;
  }

  @override
  Future<User> bookmarkPost(String id) async {
    return testUser;
  }

  @override
  Future<User> unbookmarkPost(String id) async {
    return testUser;
  }

  @override
  Future<User> updateProfile(User user) async {
    return testUser;
  }
}

class MockJournalRepository extends Mock implements JournalRepository {}

class MockPostRepository extends Mock implements PostRepository {}

final User testUser = User(
  id: '1',
  password: 'testPassword',
  username: 'testUser',
  fullName: 'Test User',
  following: [],
  follower: [],
  posts: [],
  penddingPosts: [],
  journals: [],
  pendingJournal: [],
  bookmarkPosts: [],
  profilePicture: null,
);

final Journal testJournal = Journal(
    id: '1',
    title: 'Test Journal',
    description: 'Lorem ipsum dolor sit amet.',
    creator: testUser,
    link: "rwer");

final List<post_model.Posts> testPosts = [
  post_model.Posts(
    id: '1',
    story: 'Test story',
    description: 'Test description',
    likes: [],
    creator: null,
    images: [],
    comments: [],
  ),
  post_model.Posts(
    id: '2',
    story: 'Test story',
    description: 'Test description',
    likes: [],
    creator: null,
    images: [],
    comments: [],
  ),
  post_model.Posts(
    id: '2',
    story: 'Test story',
    description: 'Test description',
    likes: [],
    creator: null,
    images: [],
    comments: [],
  ),
];

void main() {
  late UserBloc userBloc;
  late MockUserRepository mockUserRepository;
  late MockJournalRepository mockJournalRepository;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockUserRepository = MockUserRepository(testUser);
    mockJournalRepository = MockJournalRepository();
    mockPostRepository = MockPostRepository();
    userBloc = UserBloc(
      userRepository: mockUserRepository,
      journalRepository: mockJournalRepository,
      postRepository: mockPostRepository,
    );
  });

  blocTest(
    'UserBloc emits UserOperationSuccess state when GetUser event is added',
    build: () => userBloc..add(LoadUser()),
    act: (bloc) => bloc.add(GetUser()),
    expect: () => [
      UserLoading(),
      UserOperationSuccess(user: testUser),
    ],
  );

  blocTest(
    'UserBloc emits UserLoading and UserOperationSuccess states when LoadUser event is added',
    build: () => userBloc,
    act: (bloc) => bloc.add(LoadUser()),
    expect: () => [
      UserLoading(),
      UserOperationSuccess(user: testUser),
    ],
  );

  blocTest(
    'UserBloc emits UserOperationSuccess state when FollowUser event is added',
    build: () => userBloc..add(LoadUser()),
    act: (bloc) => bloc.add(FollowUser(id: '1')),
    expect: () => [
      UserLoading(),
      UserOperationSuccess(user: testUser),
    ],
  );

  blocTest(
    'UserBloc emits UserOperationSuccess state when UnfollowUser event is added',
    build: () => userBloc..add(LoadUser()),
    act: (bloc) => bloc.add(UnfollowUser(id: '1')),
    expect: () => [
      UserLoading(),
      UserOperationSuccess(user: testUser),
    ],
  );
}
