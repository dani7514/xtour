import 'dart:io';
import 'package:http/http.dart' show MultipartFile;

import 'package:chopper/chopper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:x_tour/user/data/user_service.dart';

import '../../cache service/sqflite_service.dart';
import '../../user/auth/bloc/auth_bloc.dart';
import '../../user/models/user.dart';
import '../data/posts_service.dart';
import '../models/post.dart';

class PostRepository {
  final UserService userService;
  final PostService postService;
  final SqfliteService sqfliteService;
  final AuthBloc authBloc;
  final Connectivity connectivity = Connectivity();

  PostRepository(
      {required this.userService,
      required this.postService,
      required this.sqfliteService,
      required this.authBloc});

  Future<List<Posts>> getHomepagePosts(Map<String, dynamic> query) async {
    final hasConnection = await checkConnectivity();
    if (hasConnection) {
      final response = await postService.getHomepage(
          query: query, accesstoken: getAccessHeader());

      bool erase = false;
      if (query['page'] == 1) erase = true;
      return returnValue<List<Posts>>(
          response, sqfliteService.addFeedPosts, erase);
    }
    final cachedPosts = await sqfliteService.getFeedPosts();
    if (cachedPosts.isNotEmpty) return cachedPosts;
    throw Exception("No data available");
  }

  Future<List<Posts>> getSearchedPosts(Map<String, dynamic> query) async {
    final hasConnection = await checkConnectivity();

    if (hasConnection) {
      final response = await postService.getApprovedPosts(
          query: query, accesstoken: getAccessHeader());
      // bool erase = false;
      // if (query['page'] == 1) erase = true;
      return returnValue<List<Posts>>(response);
    }
    final cachedPosts = await sqfliteService.getSearchedPosts();
    if (cachedPosts.isNotEmpty) return cachedPosts;
    throw Exception("No data available");
  }

  Future<Posts> getApprovedPost(String id) async {
    final response = await postService.getApprovedPost(
        id: id, accesstoken: getAccessHeader());
    return returnValue<Posts>(response);
  }

  Future<Posts> getPendingPost(String id) async {
    final cachedPost = await sqfliteService.getPendingPost(id);
    if (cachedPost != null) {
      return cachedPost;
    }
    final response = await postService.getPendingPost(
        id: id, accesstoken: getAccessHeader());
    return returnValue<Posts>(response);
  }

  Future<Posts> createPost({required User user, required Posts post}) async {
    final response = await postService.createPost(
        post: post, accesstoken: getAccessHeader());
    final body = returnValue<Posts>(response, sqfliteService.addPendingPost);
    List<String> posts = user.penddingPosts!;
    posts.add(body.id!);
    User newUser = user.copyWith(penddingPosts: posts);
    sqfliteService.updateUser(newUser);
    return body;
  }

  Future<Posts> updatePost({required String id, required Posts post}) async {
    final response = await postService.updatePost(
        id: id, post: post, accesstoken: getAccessHeader());
    return returnValue<Posts>(response, sqfliteService.updatePendingPost);
  }

  Future<Posts> insertImage(
      {required String id, required List<MultipartFile> images}) async {
    final response = await postService.insertImage(
        id: id, images: images, accesstoken: getAccessHeader());
    return returnValue<Posts>(response, sqfliteService.updatePendingPost);
  }

  Future<Posts> likePost({
    required String id,
  }) async {
    final response =
        await postService.likePost(id: id, accesstoken: getAccessHeader());
    return returnValue<Posts>(response);
  }

  Future<Posts> unlikePost({
    required String id,
  }) async {
    final response =
        await postService.unlikePost(id: id, accesstoken: getAccessHeader());
    return returnValue<Posts>(response);
  }

  Future<User> bookmarkPost(String id) async {
    final response =
        await userService.bookmarkPost(id: id, accesstoken: getAccessHeader());
    return returnValue<User>(response, sqfliteService.updateUser);
  }

  Future<User> unbookmarkPost(String id) async {
    final response = await userService.unbookmarkPost(
        id: id, accesstoken: getAccessHeader());
    return returnValue<User>(response, sqfliteService.updateUser);
  }

  Future<void> deletePendingPost(
      {required String id, required User user}) async {
    final response = await postService.deletePendingPost(
        id: id, accesstoken: getAccessHeader());
    if (response.isSuccessful) {
      List<String> posts = user.penddingPosts!;
      posts.remove(id);
      User newUser = user.copyWith(penddingPosts: posts);
      sqfliteService.updateUser(newUser);
    }
  }

  Future<void> deleteApprovedPost(
      {required String id, required User user}) async {
    final response = await postService.deleteApprovedPost(
        id: id, accesstoken: getAccessHeader());
    if (response.isSuccessful) {
      List<String> posts = user.posts!;
      posts.remove(id);
      User newUser = user.copyWith(posts: posts);
      sqfliteService.updateUser(newUser);
    }
  }

  Future<bool> checkConnectivity() async {
    var result = await connectivity.checkConnectivity();
    if (result != ConnectivityResult.none &&
        result != ConnectivityResult.bluetooth &&
        result != ConnectivityResult.other) {
      return true;
    }
    return false;
  }

  T returnValue<T>(Response response,
      [Function? cacheFunction, erase = false]) {
    if (response.isSuccessful) {
      if (cacheFunction != null) {
        if (erase == false) {
          cacheFunction(response.body);
        } else {
          cacheFunction(response.body, erase);
        }
      }
      return response.body!;
    }
    if (response.statusCode == HttpStatus.unauthorized) {
      authBloc.add(LogOut());
    }
    throw Exception("${response.error}");
  }

  String getAccessHeader() {
    String at = (authBloc.state as AuthAuthenticated).accessToken;
    return "Bearer $at";
  }
}
