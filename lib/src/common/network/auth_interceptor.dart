import 'package:active_memory/src/common/network/base_response.dart';
import 'package:active_memory/src/common/network/custom_exception.dart';
import 'package:active_memory/src/features/accounts/auth/data/auth_api.dart';
import 'package:active_memory/src/features/accounts/auth/data/dto/re_issue_request.dart';
import 'package:active_memory/src/features/accounts/auth/presentation/view_models/auth_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_interceptor.g.dart';

@riverpod
AuthInterceptor authInterceptor(Ref ref) {
  final storage = ref.watch(storageProvider);
  return AuthInterceptor(storage, ref);
}

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Ref _ref;

  AuthInterceptor(this._storage, this._ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.headers['requiresToken'] == false) {
      options.headers.remove('requiresToken');

      return handler.next(options);
    }

    final accessToken = await _storage.read(key: 'accessToken');

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    // TODO: 나중에 뭔갈 하겠지
    debugPrint("Response Auth Status: ${response.statusCode}");
    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Dio 5.0부터는 DioError가 아니라 'DioException'

    // 1. 로그아웃 요청 자체가 401이 난거라면
    // 이미 만료된 내용이니깐 재시도하거나 또 강제 로그아웃을 부르면 안됨(무한 루프 방지)
    if (err.requestOptions.path.contains("/auth/logout")) {
      return handler.next(err);
    }

    // 2. 401 에러면
    if (err.response?.statusCode == 401) {
      final isRetry = err.requestOptions.extra.containsKey('isRetry');

      if (isRetry) {
        // 재시도한적 있으면 로그아웃 - 무한루프 방지
        await _forceLogout();
        return handler.next(err);
      }

      final refreshToken = await _storage.read(key: 'refreshToken');

      if (refreshToken == null) {
        // 리프레시 토큰 없으면 로그아웃
        await _forceLogout();
        return handler.next(err);
      }

      try {
        final refreshDio = Dio(BaseOptions(
            baseUrl: dotenv.env['API_URL'] ?? 'http://localhost:8080/api/v1',
            headers: {
              'Content-Type': 'application/json',
            }));

        final authApi = AuthApi(refreshDio);

        final response =
            await authApi.reIssue(ReIssueRequest(refreshToken: refreshToken));
        final newAccssToken = response.data.accessToken;
        final newRefreshToken = response.data.refreshToken;

        await _storage.write(key: 'accessToken', value: newAccssToken);
        await _storage.write(key: 'refreshToken', value: newRefreshToken);

        // 원래 요청 재시도
        final options = err.requestOptions;

        options.headers['Authorization'] = 'Bearer $newAccssToken';
        options.extra['isRetry'] = true;

        // 재용용 Dio는 그냥 Dio로 진행
        final retryResponse = await Dio().fetch(options);
        return handler.resolve(retryResponse);
      } catch (e) {
        await _forceLogout();
        return handler.next(err);
      }
    }

    // 3. 그 외 에러(타임아웃, 400, 500 등)를 CustomException으로 반환
    CustomException customException;

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionError) {
      customException = CustomException(
          message: "서버와 연결할 수 없습니다.\n네트워크를 확인해주세요.",
          code: "NETWORK_ERR",
          details: err.message ?? '');
    } else if (err.response?.data != null) {
      // 서버가 보낸 에러 응답이 있다면
      try {
        final data = err.response!.data;

        if (data is Map<String, dynamic>) {
          final errorResponse = ExceptionResponse.fromJson(data);

          customException = CustomException(
            message: errorResponse.description,
            code: errorResponse.code,
            details: errorResponse.details,
          );
        } else {
          customException = CustomException(
            message: "서버 오류가 발생했습니다",
            code: "UNKNOWN",
            details: data.toString(),
          );
        }
      } catch (e) {
        customException = CustomException(
          message: "알 수 없는 에러가 발생했습니다.",
          code: "UNKNOWN",
          details: err.message ?? '',
        );
      }
    } else {
      customException = CustomException(
        message: "알 수 없는 에러가 발생했습니다.",
        code: "UNKNOWN",
        details: err.message ?? '',
      );
    }

    final newError = err.copyWith(error: customException);

    return handler.next(newError);
  }

  Future<void> _forceLogout() async {
    await _storage.deleteAll();

    _ref.read(authViewModelProvider.notifier).logout();
  }
}
