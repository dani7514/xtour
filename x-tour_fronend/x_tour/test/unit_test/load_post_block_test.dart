import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:x_tour/posts/bloc/load_posts_bloc.dart';
import 'package:x_tour/posts/models/post.dart' as post_model;
import 'package:x_tour/posts/repository/post_repository.dart';
import 'package:x_tour/user/bloc/user_bloc.dart';
import 'package:x_tour/user/models/user.dart';

class MockPostRepository extends Mock implements PostRepository {
  @override
  Future<List<post_model.Posts>> getHomepagePosts(
      Map<String, dynamic> query) async {
    return List.from(testPosts);
  }

  @override
  Future<List<post_model.Posts>> getSearchedPosts(
      Map<String, dynamic> query) async {
    return testPosts;
  }

  @override
  Future<post_model.Posts> getApprovedPost(String id) async {
    return testPosts[0];
  }

  @override
  Future<post_model.Posts> getPendingPost(String id) async {
    return testPosts[0];
  }

  @override
  Future<post_model.Posts> createPost(
      {required User user, required post_model.Posts post}) async {
    return testPosts[0];
  }

  @override
  Future<post_model.Posts> updatePost(
      {required String id, required post_model.Posts post}) async {
    return testPosts[0];
  }

  @override
  Future<post_model.Posts> likePost({required String id}) async {
    return testPosts[0];
  }

  @override
  Future<post_model.Posts> unlikePost({required String id}) async {
    return testPosts[0];
  }

  @override
  Future<User> bookmarkPost(String id) async {
    return testUser;
  }

  @override
  Future<User> unbookmarkPost(String id) async {
    return testUser;
  }
}

class MockUserBloc extends Mock implements UserBloc {}

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
  late LoadPostsBloc loadPostsBloc;
  late MockPostRepository mockPostRepository;
  late MockUserBloc mockUserBloc;

  setUp(() {
    mockPostRepository = MockPostRepository();
    mockUserBloc = MockUserBloc();
    loadPostsBloc = LoadPostsBloc(
      postRepository: mockPostRepository,
      userBloc: mockUserBloc,
    )..add(LoadPosts(limit: 1, page: 1));
  });

  // tearDown(() {
  //   loadPostsBloc.close();
  // });

  blocTest(
    'LoadPostsBloc emits PostsLoading and PostsLoaded states when LoadPosts event is added',
    build: () => loadPostsBloc,
    act: (bloc) => bloc.add(LoadPosts(limit: 1, page: 1)),
    expect: () => [
      PostsLoading(),
      PostsLoaded(posts: testPosts),
    ],
  );
  blocTest(
    'LoadPostsBloc emits PostsLoading and PostsLoadMoreFailed states when LoadMore event is added and an exception occurs',
    build: () => loadPostsBloc..add(LoadPosts(limit: 1, page: 2)),
    act: (bloc) => bloc.add(LoadMore(limit: 1, page: 2)),
    expect: () => [
      PostsLoading(),
      PostsLoaded(posts: testPosts + testPosts),
    ],
  );

  blocTest(
    'LoadPostsBloc emits PostsLoaded state with updated posts list when LikePost event is added',
    build: () => loadPostsBloc..add(LoadPosts(limit: 1, page: 2)),
    act: (bloc) => bloc.add(LikePost(id: '1')),
    expect: () => [
      PostsLoading(),
      PostsLoaded(posts: testPosts),
    ],
  );

  blocTest(
    'LoadPostsBloc emits PostsLoaded state with updated posts list when UnlikePost event is added',
    build: () => loadPostsBloc..add(LoadPosts(limit: 1, page: 2)),
    act: (bloc) => bloc.add(UnlikePost(id: '1')),
    expect: () => [
      PostsLoading(),
      PostsLoaded(posts: testPosts),
    ],
  );
}
