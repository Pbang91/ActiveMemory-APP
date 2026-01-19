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

    // 2. 401 에러가 아니면 넘겨서 맡기기
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

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

  Future<void> _forceLogout() async {
    await _storage.deleteAll();

    _ref.read(authViewModelProvider.notifier).logout();
  }
}
