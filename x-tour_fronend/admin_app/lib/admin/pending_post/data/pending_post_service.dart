import 'package:chopper/chopper.dart';
import 'package:x_tour/admin/pending_post/model/post.dart';

part 'pending_post_service.chopper.dart';

@ChopperApi(baseUrl: "posts")
abstract class PendingPostService extends ChopperService {
  @Get(path: "/pending")
  Future<Response<List<Posts>>> getPendingPosts(
      {@QueryMap() required Map<String, dynamic> query,
      @Header("Authorization") required String accesstoken});

  @Post(path: "/{id}")
  Future<Response<Posts>> approvePendingPost(
      {@Path("id") required String id,
      @Body() required Posts post,
      @Header("Authorization") required String accesstoken});

  @Delete(path: '/pending/{id}')
  Future<Response> deletePendingPost(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  static PendingPostService create([ChopperClient? client]) =>
      _$PendingPostService(client);
}
