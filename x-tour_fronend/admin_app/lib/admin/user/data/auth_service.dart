import 'package:chopper/chopper.dart';


part 'auth_service.chopper.dart';

@ChopperApi(baseUrl: "auth")
abstract class AuthService extends ChopperService {
  static AuthService create([ChopperClient? client]) => _$AuthService(client);

  @Post(path: '/login')
  Future<Response<Map<String, dynamic>>> userLogin(
      @Body() Map<String, dynamic> user);

  @Patch(path: '/signup')
  Future<Response<Map<String, dynamic>>> userSignup(
      @Body() Map<String, dynamic> user);

  @Delete(path: '/logout')
  Future<Response<Map<String, dynamic>>> deleteUser();
}
