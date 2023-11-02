import 'package:chopper/chopper.dart';
import 'package:x_tour/comment/models/comment.dart';

part 'comment_service.chopper.dart';

@ChopperApi(baseUrl: "comments")
abstract class CommentService extends ChopperService {
  @Get(path: '/{id}')
  Future<Response<Comment>> getComment(
      {@Path('id') required String id,
      @Header("Authorization") required String accesstoken});

  @Get(path: 'post/{id}')
  Future<Response<List<Comment>>> getComments({
    @Path('id') required String id,
    @QueryMap() required Map<String, dynamic> query,
    @Header("Authorization") required String accesstoken,
  });

  @Get(path: 'replies/{id}')
  Future<Response<List<Comment>>> getReplies({
    @Path('id') required String id,
    @QueryMap() required Map<String, dynamic> query,
    @Header("Authorization") required String accesstoken,
  });

  @Post()
  Future<Response<Comment>> createComment({
    @Body() required Comment comment,
    @Header("Authorization") required String accesstoken,
  });

  @Patch(path: '/{id}')
  Future<Response<Comment>> updateComment({
    @Path('id') required String id,
    @Body() required Comment comment,
    @Header("Authorization") required String accesstoken,
  });

  @Delete(path: '/{id}')
  Future<Response> deletePost({
    @Path('id') required String id,
    @Header("Authorization") required String accesstoken,
  });

  static CommentService create([ChopperClient? client]) =>
      _$CommentService(client);
}
