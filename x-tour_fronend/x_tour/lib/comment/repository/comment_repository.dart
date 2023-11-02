import '../../user/auth/bloc/auth_bloc.dart';
import '../data/comment_service.dart';
import '../models/comment.dart';

class CommentRepository {
  final CommentService commentService;
  final AuthBloc authBloc;
  const CommentRepository(
      {required this.commentService, required this.authBloc});

  Future<Comment?> getComment(String id) async {
    final response =
        await commentService.getComment(id: id, accesstoken: getAccessHeader());
    if (response.isSuccessful) {
      return response.body;
    }
    throw Exception('${response.error}');
  }

  Future<List<Comment>?> getComments(
      {required String postId, required Map<String, dynamic> query}) async {
    final response = await commentService.getComments(
        id: postId, query: query, accesstoken: getAccessHeader());
    if (response.isSuccessful) {
      return response.body;
    }
    throw Exception('${response.error}');
  }

  Future<List<Comment>?> getReplies(
      {required String commentId, required Map<String, dynamic> query}) async {
    final response = await commentService.getComments(
        id: commentId, query: query, accesstoken: getAccessHeader());
    if (response.isSuccessful) {
      return response.body;
    }
    throw Exception('${response.error}');
  }

  Future<Comment> createComment(Comment comment) async {
    final response = await commentService.createComment(
        comment: comment, accesstoken: getAccessHeader());
    if (response.isSuccessful) {
      return response.body!;
    }
    throw Exception('${response.error}');
  }

  Future<Comment> updateComment(
      {required String id, required Comment comment}) async {
    final response = await commentService.updateComment(
        id: id, comment: comment, accesstoken: getAccessHeader());
    if (response.isSuccessful) {
      return response.body!;
    }
    throw Exception('${response.error}');
  }

  Future<void> deleteComment(String id) async {
    final response = await commentService.deletePost(
      id: id,
      accesstoken: getAccessHeader(),
    );
    if (!response.isSuccessful) {
      throw Exception('${response.error}');
    }
  }

  String getAccessHeader() {
    String at = (authBloc.state as AuthAuthenticated).accessToken;
    return "Bearer $at";
  }
}
