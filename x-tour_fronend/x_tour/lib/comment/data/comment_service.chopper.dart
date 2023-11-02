// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$CommentService extends CommentService {
  _$CommentService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = CommentService;

  @override
  Future<Response<Comment>> getComment({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('comments/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<Comment, Comment>($request);
  }

  @override
  Future<Response<List<Comment>>> getComments({
    required String id,
    required Map<String, dynamic> query,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('comments/post/${id}');
    final Map<String, dynamic> $params = query;
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      headers: $headers,
    );
    return client.send<List<Comment>, Comment>($request);
  }

  @override
  Future<Response<List<Comment>>> getReplies({
    required String id,
    required Map<String, dynamic> query,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('comments/replies/${id}');
    final Map<String, dynamic> $params = query;
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      headers: $headers,
    );
    return client.send<List<Comment>, Comment>($request);
  }

  @override
  Future<Response<Comment>> createComment({
    required Comment comment,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('comments');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final $body = comment;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<Comment, Comment>($request);
  }

  @override
  Future<Response<Comment>> updateComment({
    required String id,
    required Comment comment,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('comments/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final $body = comment;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<Comment, Comment>($request);
  }

  @override
  Future<Response<dynamic>> deletePost({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('comments/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
