// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$UserService extends UserService {
  _$UserService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = UserService;

  @override
  Future<Response<User>> getUser({required String accesstoken}) {
    final Uri $url = Uri.parse('users/info');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<List<User>>> getFollowers({required String accesstoken}) {
    final Uri $url = Uri.parse('users/followers');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<List<User>, User>($request);
  }

  @override
  Future<Response<List<User>>> getFollowings({required String accesstoken}) {
    final Uri $url = Uri.parse('users/followings');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<List<User>, User>($request);
  }

  @override
  Future<Response<List<Posts>>> getApprovedPosts(
      {required String accesstoken}) {
    final Uri $url = Uri.parse('users/posts');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<List<Posts>, Posts>($request);
  }

  @override
  Future<Response<List<User>>> getOtherUserFollowers({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('users/followers/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<List<User>, User>($request);
  }

  @override
  Future<Response<List<User>>> getOtherUserFollowings({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('users/followings/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<List<User>, User>($request);
  }

  @override
  Future<Response<List<Posts>>> getOtherUserApprovedPosts({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('users/posts/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<List<Posts>, Posts>($request);
  }

  @override
  Future<Response<List<Posts>>> getPendingPosts({required String accesstoken}) {
    final Uri $url = Uri.parse('users/pendingPosts');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<List<Posts>, Posts>($request);
  }

  @override
  Future<Response<List<Journal>>> getApprovedJournals(
      {required String accesstoken}) {
    final Uri $url = Uri.parse('users/journals');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<List<Journal>, Journal>($request);
  }

  @override
  Future<Response<List<Journal>>> getOtherUserApprovedJournals({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('users/journals/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<List<Journal>, Journal>($request);
  }

  @override
  Future<Response<List<Journal>>> getPendingJournals(
      {required String accesstoken}) {
    final Uri $url = Uri.parse('users/pendingJournals');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<List<Journal>, Journal>($request);
  }

  @override
  Future<Response<List<Posts>>> getBookmark({required String accesstoken}) {
    final Uri $url = Uri.parse('users/bookmark');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<List<Posts>, Posts>($request);
  }

  @override
  Future<Response<User>> getOtherUser({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('users/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<User>> insertImage({
    required MultipartFile image,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('users/image');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<MultipartFile>(
        'image',
        image,
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
    return client.send<User, User>($request);
  }

  @override
  Future<Response<User>> followUser({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('users/follow/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<User>> unfollowUser({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('users/unfollow/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<User>> bookmarkPost({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('users/bookmark/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<User>> unbookmarkPost({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('users/unbookmark/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<User>> requestJournal({
    required String id,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('users/approveJournal/${id}');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<User, User>($request);
  }

  @override
  Future<Response<User>> updateProfile({
    required User user,
    required String accesstoken,
  }) {
    final Uri $url = Uri.parse('users');
    final Map<String, String> $headers = {
      'Authorization': accesstoken,
    };
    final $body = user;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<User, User>($request);
  }
}
