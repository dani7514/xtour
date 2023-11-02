import 'package:chopper/chopper.dart';
import 'package:http/http.dart' show MultipartFile;

import '../models/post.dart';
part 'posts_service.chopper.dart';

@ChopperApi(baseUrl: "posts")
abstract class PostService extends ChopperService {
  @Get(path: "/pending")
  Future<Response<List<Posts>>> getPendingPosts(
      {@QueryMap() required Map<String, dynamic> query,
      @Header("Authorization") required String accesstoken});

  @Get(path: "/homepage")
  Future<Response<List<Posts>>> getHomepage(
      {@QueryMap() required Map<String, dynamic> query,
      @Header("Authorization") required String accesstoken});

  @Get(path: "/{id}")
  Future<Response<Posts>> getApprovedPost(
      {@Path("id") required String id,
      @Header("Authorization") required String accesstoken});

  @Get(path: "/pending/{id}")
  Future<Response<Posts>> getPendingPost(
      {@Path("id") required String id,
      @Header("Authorization") required String accesstoken});

  @Get()
  Future<Response<List<Posts>>> getApprovedPosts(
      {@QueryMap() required Map<String, dynamic> query,
      @Header("Authorization") required String accesstoken});

  @Post(path: "/pending")
  Future<Response<Posts>> createPost(
      {@Body() required Posts post,
      @Header("Authorization") required String accesstoken});

  @Post(path: "/pending/images/{id}", optionalBody: true)
  @Multipart()
  Future<Response<Posts>> insertImage(
      {@Path("id") required String id,
      @PartFile("images") required List<MultipartFile> images,
      @Header("Authorization") required String accesstoken});

  @Patch(path: 'pending/{id}')
  Future<Response<Posts>> updatePost(
      {@Path("id") required String id,
      @Body() required Posts post,
      @Header("Authorization") required String accesstoken});

  @Patch(path: 'like/{id}', optionalBody: true)
  Future<Response<Posts>> likePost(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  @Patch(path: 'unlike/{id}', optionalBody: true)
  Future<Response<Posts>> unlikePost(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  @Delete(path: '/{id}')
  Future<Response> deleteApprovedPost(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  @Delete(path: '/pending/{id}')
  Future<Response> deletePendingPost(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  static PostService create([ChopperClient? client]) => _$PostService(client);
}
