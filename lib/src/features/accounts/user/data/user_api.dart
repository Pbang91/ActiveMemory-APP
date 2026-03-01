import 'package:active_memory/src/common/network/base_response.dart';
import 'package:active_memory/src/features/accounts/user/data/dto/get_me_response.dart';
import 'package:active_memory/src/features/accounts/user/data/dto/register_user_request.dart';
import 'package:active_memory/src/features/accounts/user/data/dto/register_user_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio) = _UserApi;

  @POST('/users')
  Future<SuccessResponse<RegisterUserResponse>> register(
      @Body() RegisterUserRequest body);

  @GET('/users/me')
  Future<SuccessResponse<GetMeResponse>> getMe();
}
