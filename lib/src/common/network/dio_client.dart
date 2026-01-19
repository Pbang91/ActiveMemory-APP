import 'dart:io';

import 'package:active_memory/src/common/network/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

// Riverpod으로 Dio 객체를 전역 관리
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  String baseUrl;

  if (kIsWeb) {
    baseUrl = 'http://localhost:8009/api/v1';
  } else if (Platform.isAndroid) {
    baseUrl = 'http://10.0.2.2:8009/api/v1';
  } else {
    baseUrl = 'http://127.0.0.1:8009/api/v1';
  }

  final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Contenty-Type': 'application/json',
        'Accept': 'application/json'
      }));

  dio.interceptors.add(ref.watch(authInterceptorProvider));

  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
    ));
  }

  return dio;
}
