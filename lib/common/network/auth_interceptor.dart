import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_interceptor.g.dart';

@riverpod
AuthInterceptor authInterceptor(Ref ref) {
  return AuthInterceptor(ref);
}

class AuthInterceptor extends Interceptor {
  final Ref _ref;

  AuthInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /**
     * TODO: flutter_secure_storage에서 토큰 꺼내는 코드
     * final token = await storage.read(...);
     * if (token != null) options.headers['Authorization'] = 'Bearer $toekn';
     */

    debugPrint("Request Auth Path: ${options.path}");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    // TODO: 나중에 뭔갈 하겠지
    debugPrint("Response Auth Status: ${response.statusCode}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Dio 5.0부터는 DioError가 아니라 'DioException'
    // TODO: 401 에러뜨면 토큰 재발급 로직 수행
    debugPrint("🚨 [AuthInterceptor] 에러 발생: ${err.message}");

    if (err.response?.statusCode == 401) {
      debugPrint("🔄 토큰 만료! 재발급 시도 예정...");
    }

    super.onError(err, handler);
  }
}
