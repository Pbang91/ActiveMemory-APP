import 'package:active_memory/src/common/network/base_response.dart';
import 'package:active_memory/src/features/accounts/auth/data/dto/login_request.dart';
import 'package:active_memory/src/features/accounts/auth/data/dto/login_response.dart';
import 'package:active_memory/src/features/accounts/auth/data/dto/re_issue_request.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/auth/login')
  Future<BaseResponse<LoginResponse>> login(@Body() LoginRequest request);

  @POST('/auth/logout')
  Future<void> logout();

  @POST('/auth/re-issue')
  Future<BaseResponse<LoginResponse>> reIssue(@Body() ReIssueRequest request);
}
