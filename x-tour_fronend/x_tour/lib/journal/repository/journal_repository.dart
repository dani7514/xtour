import 'dart:io';
import 'package:http/http.dart' show MultipartFile;

import 'package:chopper/chopper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../cache service/sqflite_service.dart';
import '../../user/auth/bloc/auth_bloc.dart';
import '../../user/models/user.dart';
import '../data/journal_service.dart';
import '../models/journal.dart';

class JournalRepository {
  final JournalService journalService;
  final SqfliteService sqfliteService;
  final AuthBloc authBloc;
  final Connectivity connectivity = Connectivity();

  JournalRepository(
      {required this.journalService,
      required this.sqfliteService,
      required this.authBloc});

  Future<List<Journal>> getJournals(
      {required Map<String, dynamic> query}) async {
    bool hasConnection = await checkConnectivity();
    if (hasConnection) {
      final response = await journalService.getApprovedJournals(
          query: query, accesstoken: getAccessHeader());
      bool erase = false;
      if (query["page"] == 1) erase = true;
      return returnValue<List<Journal>>(
          response, sqfliteService.addJournals, erase);
    }
    final cachedJournals = await sqfliteService.getJournals();
    if (cachedJournals.isNotEmpty) {
      return cachedJournals;
    }
    throw Exception("No data available");
  }

  Future<Journal> getPendingJournal(String id) async {
    final cachedJournals = await sqfliteService.getPendingJournal(id);
    if (cachedJournals != null) {
      return cachedJournals;
    }

    final response = await journalService.getPendingJournal(
        id: id, accesstoken: getAccessHeader());
    return returnValue<Journal>(response);
  }

  // Future<List<Journal>> getPendingJournals(
  //     {required Map<String, dynamic> query}) async {
  //   bool hasConnection = await checkConnectivity();
  //   if (hasConnection) {
  //     final response = await journalService.getPendingJournals(query: query);
  //     bool erase = false;
  //     if (query["page"] == 1) erase = true;
  //     return returnValue<List<Journal>>(
  //         response, hiveService.addJournals, erase);
  //   }
  //   return hiveService.getPendingJournals();
  // }

  Future<Journal> createJournal(
      {required Journal journal, required User user}) async {
    final response = await journalService.createJournal(
        journal: journal, accesstoken: getAccessHeader());
    final body = returnValue<Journal>(response);
    List<String> journals = user.pendingJournal!;
    journals.add(body.id!);
    User newUser = user.copyWith(pendingJournal: journals);
    sqfliteService.updateUser(newUser);
    return body;
  }

  Future<Journal> updateJournal(
      {required String id, required Journal journal}) async {
    final response = await journalService.updateJournal(
        id: id, journal: journal, accesstoken: getAccessHeader());
    return returnValue<Journal>(response);
  }

  Future<Journal> insertImage(
      {required String id, required MultipartFile image}) async {
    final response = await journalService.insertImage(
        id: id, image: image, accesstoken: getAccessHeader());
    return returnValue<Journal>(response);
  }

  Future<void> deletePendingJournal(
      {required String id, required User user}) async {
    final response = await journalService.deletePendingJournal(
        id: id, accesstoken: getAccessHeader());
    if (response.isSuccessful) {
      List<String> journals = user.pendingJournal!;
      journals.remove(id);
      User newUser = user.copyWith(pendingJournal: journals);
      sqfliteService.updateUser(newUser);
    }
  }

  Future<void> deleteApprovedJournal(
      {required String id, required User user}) async {
    final response = await journalService.deleteApprovedJournal(
        id: id, accesstoken: getAccessHeader());
    if (response.isSuccessful) {
      List<String> journals = user.journals!;
      journals.remove(id);
      User newUser = user.copyWith(journals: journals);
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
        cacheFunction(response.body, erase);
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
