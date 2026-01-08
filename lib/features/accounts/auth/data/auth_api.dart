import 'package:active_memory/common/network/base_response.dart';
import 'package:active_memory/features/accounts/auth/data/dto/login_request.dart';
import 'package:active_memory/features/accounts/auth/data/dto/login_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/auth/login')
  Future<BaseResponse<LoginResponse>> login(@Body() LoginRequest request);
}
