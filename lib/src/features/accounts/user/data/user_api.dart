import 'package:active_memory/src/common/network/base_response.dart';
import 'package:active_memory/src/features/accounts/user/data/dto/get_me_response.dart';
import 'package:active_memory/src/features/accounts/user/data/dto/register_request.dart';
import 'package:active_memory/src/features/accounts/user/data/dto/register_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio) = _UserApi;

  @POST('/users')
  Future<BaseResponse<RegisterResponse>> register(@Body() RegisterRequest body);

  @GET('/users/me')
  Future<BaseResponse<GetMeResponse>> getMe();
}
