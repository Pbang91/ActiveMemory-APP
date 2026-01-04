import 'package:active_memory/common/network/base_response.dart';
import 'package:active_memory/features/accounts/user/data/dto/register_request.dart';
import 'package:active_memory/features/accounts/user/data/dto/register_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio) = _UserApi;

  @POST('/users')
  Future<BaseResponse<RegisterResponse>> register(@Body() RegisterRequest body);
}
