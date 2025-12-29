import 'dart:io';

import 'package:active_memory/common/network/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

// Riverpod으로 Dio 객체를 전역 관리
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8009/api/v1'
      : 'http://127.0.0.1:8009/api/v1';

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  dio.interceptors.add(ref.watch(authInterceptorProvider));

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  return dio;
}
