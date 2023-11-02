// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$PostService extends PostService {
  _$PostService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = PostService;

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
  Future<Response<List<Posts>>> getHomepage({
    required Map<String, dynamic> query,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('posts/homepage');
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
  Future<Response<Posts>> getApprovedPost({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('posts/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<Posts, Posts>($request);
  }

  @override
  Future<Response<Posts>> getPendingPost({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('posts/pending/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<Posts, Posts>($request);
  }

  @override
  Future<Response<List<Posts>>> getApprovedPosts({
    required Map<String, dynamic> query,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('posts');
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
  Future<Response<Posts>> createPost({
    required Posts post,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('posts/pending');
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
  Future<Response<Posts>> insertImage({
    required String id,
    required List<MultipartFile> images,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('posts/pending/images/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<List<MultipartFile>>(
        'images',
        images,
      )
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
      headers: $headers,
    );
    return client.send<Posts, Posts>($request);
  }

  @override
  Future<Response<Posts>> updatePost({
    required String id,
    required Posts post,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('posts/pending/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final $body = post;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<Posts, Posts>($request);
  }

  @override
  Future<Response<Posts>> likePost({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('posts/like/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<Posts, Posts>($request);
  }

  @override
  Future<Response<Posts>> unlikePost({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('posts/unlike/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<Posts, Posts>($request);
  }

  @override
  Future<Response<dynamic>> deleteApprovedPost({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('posts/${id}');
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
