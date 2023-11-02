// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_post_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$PendingPostService extends PendingPostService {
  _$PendingPostService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = PendingPostService;

  @override
  Future<Response<List<Posts>>> getPendingPosts({
    required Map<String, dynamic> query,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('posts/pending');
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
    return client.send<List<Posts>, Posts>($request);
  }

  @override
  Future<Response<Posts>> approvePendingPost({
    required String id,
    required Posts post,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('posts/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final $body = post;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<Posts, Posts>($request);
  }

  @override
  Future<Response<dynamic>> deletePendingPost({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('posts/pending/${id}');
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
