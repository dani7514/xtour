import 'dart:io';
import 'package:http/http.dart' show MultipartFile;

import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../cache service/sqflite_service.dart';
import '../../journal/models/journal.dart';
import '../../posts/models/post.dart';
import '../auth/bloc/auth_bloc.dart';
import '../data/auth_service.dart';
import '../data/user_service.dart';
import '../models/user.dart';

class UserRepository {
  final UserService userService;
  final AuthService authService;
  final SqfliteService sqfliteService;
  final AuthBloc authBloc;
  final FlutterSecureStorage storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  UserRepository(
      {required this.userService,
      required this.authService,
      required this.sqfliteService,
      required this.authBloc});

  // With caching UserService

  Future<User> getInfo() async {
    final cachedUser = await sqfliteService.getUser();
    if (cachedUser != null) return cachedUser;

    final response = await userService.getUser(accesstoken: getAccessHeader());
    return returnValue<User>(response, sqfliteService.addUser);
  }

  Future<User> inserImage(MultipartFile image) async {
    final response = await userService.insertImage(
        image: image, accesstoken: getAccessHeader());
    return returnValue<User>(response, sqfliteService.updateUser);
  }

  Future<User> followUser(String id) async {
    final response =
        await userService.followUser(id: id, accesstoken: getAccessHeader());
    return returnValue<User>(response, sqfliteService.updateUser);
  }

  Future<User> unFollowUser(String id) async {
    final response =
        await userService.unfollowUser(id: id, accesstoken: getAccessHeader());
    return returnValue<User>(response, sqfliteService.updateUser);
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

  Future<User> updateProfile(User user) async {
    final response = await userService.updateProfile(
        user: user, accesstoken: getAccessHeader());
    return returnValue<User>(response, sqfliteService.updateUser);
  }

  Future<void> requestJournal(String id) async {
    await userService.requestJournal(id: id, accesstoken: getAccessHeader());
  }

  Future<List<Posts>> getApprovedPosts(User user) async {
    // final cachedPosts = await sqfliteService.getApprovedPosts();
    // if (cachedPosts.isNotEmpty && user.posts!.length == cachedPosts.length) {
    //   return cachedPosts;
    // }

    final response =
        await userService.getApprovedPosts(accesstoken: getAccessHeader());
    return returnValue<List<Posts>>(response);
  }

  Future<List<Posts>> getPendingPosts(User user) async {
    final cachedPosts = await sqfliteService.getPendingPosts();
    if (cachedPosts.isNotEmpty && user.posts!.length == cachedPosts.length) {
      return cachedPosts;
    }

    final response =
        await userService.getPendingPosts(accesstoken: getAccessHeader());
    final val =
        returnValue<List<Posts>>(response, sqfliteService.addPendingPosts);

    return val;
  }

  Future<List<Posts>> getBookmarkPosts(User user) async {
    final cachedPosts = await sqfliteService.getBookmarkedPosts();
    if (cachedPosts.isNotEmpty &&
        user.bookmarkPosts!.length == cachedPosts.length) {
      return cachedPosts;
    }

    final response =
        await userService.getBookmark(accesstoken: getAccessHeader());
    return returnValue<List<Posts>>(
        response, sqfliteService.addBookmarkedPosts);
  }

  Future<List<Journal>> getApprovedJournals(User user) async {
    final cachedJournals = await sqfliteService.getApprovedJournals();
    if (cachedJournals.isNotEmpty &&
        user.journals!.length == cachedJournals.length) {
      return cachedJournals;
    }

    final response =
        await userService.getApprovedJournals(accesstoken: getAccessHeader());
    return returnValue<List<Journal>>(response);
  }

  Future<List<Journal>> getPendingJournals(User user) async {
    final cachedJournals = await sqfliteService.getPendingJournals();
    if (cachedJournals.isNotEmpty &&
        user.journals!.length == cachedJournals.length) {
      return cachedJournals;
    }

    final response =
        await userService.getPendingJournals(accesstoken: getAccessHeader());
    return returnValue<List<Journal>>(
        response, sqfliteService.addPendingJournals);
  }

  // Without caching UserService

  Future<List<User>> getFollowings() async {
    final response =
        await userService.getFollowings(accesstoken: getAccessHeader());
    return returnValue<List<User>>(response);
  }

  Future<List<User>> getFollowers() async {
    final response =
        await userService.getFollowers(accesstoken: getAccessHeader());
    return returnValue<List<User>>(response);
  }

  Future<User> getOtherUser(String id) async {
    final response =
        await userService.getOtherUser(id: id, accesstoken: getAccessHeader());
    return returnValue<User>(response);
  }

  Future<List<User>> getOtherUserFollowers(String id) async {
    final response = await userService.getOtherUserFollowers(
        id: id, accesstoken: getAccessHeader());
    return returnValue<List<User>>(response);
  }

  Future<List<User>> getOtherUserFollowings(String id) async {
    final response = await userService.getOtherUserFollowings(
        id: id, accesstoken: getAccessHeader());
    return returnValue<List<User>>(response);
  }

  Future<List<Posts>> getOtherUserApprovedPosts(String id) async {
    final response = await userService.getOtherUserApprovedPosts(
        id: id, accesstoken: getAccessHeader());
    return returnValue<List<Posts>>(response);
  }

  Future<List<Journal>> getOtherUserApprovedJournals(String id) async {
    final response = await userService.getOtherUserApprovedJournals(
        id: id, accesstoken: getAccessHeader());
    return returnValue<List<Journal>>(response);
  }

  T returnValue<T>(Response response, [Function? cacheFunction]) {
    if (response.isSuccessful) {
      if (cacheFunction != null) {
        cacheFunction(response.body);
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
