import 'package:chopper/chopper.dart';
import 'package:http/http.dart' show MultipartFile;

import '../../journal/models/journal.dart';
import '../../posts/models/post.dart';
import '../models/user.dart';

part 'user_service.chopper.dart';

@ChopperApi(baseUrl: "users")
abstract class UserService extends ChopperService {
  @Get(path: "/info")
  Future<Response<User>> getUser(
      {@Header("Authorization") required String accesstoken});

  @Get(path: '/followers')
  Future<Response<List<User>>> getFollowers(
      {@Header("Authorization") required String accesstoken});

  @Get(path: '/followings')
  Future<Response<List<User>>> getFollowings(
      {@Header("Authorization") required String accesstoken});

  @Get(path: '/posts')
  Future<Response<List<Posts>>> getApprovedPosts(
      {@Header("Authorization") required String accesstoken});

  @Get(path: '/followers/{id}')
  Future<Response<List<User>>> getOtherUserFollowers(
      {@Path("id") required String id,
      @Header("Authorization") required String accesstoken});

  @Get(path: '/followings/{id}')
  Future<Response<List<User>>> getOtherUserFollowings(
      {@Path("id") required String id,
      @Header("Authorization") required String accesstoken});

  @Get(path: '/posts/{id}')
  Future<Response<List<Posts>>> getOtherUserApprovedPosts(
      {@Path("id") required String id,
      @Header("Authorization") required String accesstoken});

  @Get(path: '/pendingPosts')
  Future<Response<List<Posts>>> getPendingPosts(
      {@Header("Authorization") required String accesstoken});

  @Get(path: '/journals')
  Future<Response<List<Journal>>> getApprovedJournals(
      {@Header("Authorization") required String accesstoken});

  @Get(path: '/journals/{id}')
  Future<Response<List<Journal>>> getOtherUserApprovedJournals(
      {@Path("id") required String id,
      @Header("Authorization") required String accesstoken});

  @Get(path: '/pendingJournals')
  Future<Response<List<Journal>>> getPendingJournals(
      {@Header("Authorization") required String accesstoken});

  @Get(path: '/bookmark')
  Future<Response<List<Posts>>> getBookmark(
      {@Header("Authorization") required String accesstoken});

  @Get(path: '/{id}')
  Future<Response<User>> getOtherUser(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  @Post(path: '/image')
  @Multipart()
  Future<Response<User>> insertImage(
      {@PartFile("image") required MultipartFile image,
      @Header("Authorization") required String accesstoken});

  @Patch(path: '/follow/{id}')
  Future<Response<User>> followUser(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  @Patch(path: '/unfollow/{id}')
  Future<Response<User>> unfollowUser(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  @Patch(path: '/bookmark/{id}')
  Future<Response<User>> bookmarkPost(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  @Patch(path: '/unbookmark/{id}')
  Future<Response<User>> unbookmarkPost(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  @Patch(path: "approveJournal/{id}")
  Future<Response<User>> requestJournal(
      {@Path("id") required String id,
      @Header("Authorization") required String accesstoken});

  @Patch()
  Future<Response<User>> updateProfile(
      {@Body() required User user,
      @Header("Authorization") required String accesstoken});

  static UserService create([ChopperClient? client]) => _$UserService(client);
}
