import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../cache service/sqflite_service.dart';
import '../data/auth_service.dart';

class AuthRepository {
  final SqfliteService sqfliteService;
  final AuthService authService;
  final FlutterSecureStorage storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  const AuthRepository(
      {required this.sqfliteService, required this.authService});

  Future<String?> getAccessToken() async {
    return await storage.read(key: "access_token");
  }

  Future<String?> refreshToken() async {
    return await storage.read(key: "refresh_token");
  }

  Future<Map<String, dynamic>> signup(Map<String, dynamic> user) async {
    final response = await authService.userSignup(user);
    if (!response.isSuccessful) throw Exception("${response.error}");
    return response.body!;
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> user) async {
    final response = await authService.userLogin(user);
    if (response.isSuccessful) {
      await storage.write(
          key: "access_token", value: response.body!["access_token"]);
      await storage.write(
          key: "refresh_token", value: response.body!["refresh_token"]);
      return response.body!;
    }
    throw Exception("${response.error}");
  }

  Future<void> logout() async {
    await authService.deleteUser();
    await storage.delete(key: "access_token");
    await sqfliteService.deleteAll();
  }
}
