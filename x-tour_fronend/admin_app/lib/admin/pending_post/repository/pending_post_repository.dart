import 'dart:io';

import 'package:x_tour/admin/pending_post/data/pending_post_service.dart';
import 'package:x_tour/admin/pending_post/model/post.dart';
import 'package:x_tour/admin/user/auth/bloc/auth_bloc.dart';

class PendingPostRepository {
  final PendingPostService pendingPostService;
  final AuthBloc authBloc;

  const PendingPostRepository(
      {required this.pendingPostService, required this.authBloc});

  Future<List<Posts>> getPendingPosts(Map<String, dynamic> query) async {
    final response = await pendingPostService.getPendingPosts(
        query: query, accesstoken: getAccessHeader());
    if (response.isSuccessful) {
      return response.body!;
    }
    if (response.statusCode == HttpStatus.unauthorized) {
      authBloc.add(LogOut());
    }
    throw Exception(response.error);
  }

  Future<Posts> approvePendingPosts(String id, Posts post) async {
    post.id = null;
    final response = await pendingPostService.approvePendingPost(
        id: id, post: post, accesstoken: getAccessHeader());
    if (response.isSuccessful) {
      return response.body!;
    }
    if (response.statusCode == HttpStatus.unauthorized) {
      authBloc.add(LogOut());
    }
    throw Exception(response.error);
  }

  Future<void> deletePendingPost({required String id}) async {
    final response = await pendingPostService.deletePendingPost(
        id: id, accesstoken: getAccessHeader());
    if (response.statusCode == HttpStatus.unauthorized) {
      authBloc.add(LogOut());
    }
    if (!response.isSuccessful) {
      throw Exception("Something went wrong");
    }
  }

  String getAccessHeader() {
    String at = (authBloc.state as AuthAuthenticated).accessToken;
    return "Bearer $at";
  }
}
