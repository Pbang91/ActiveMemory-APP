import 'package:active_memory/features/accounts/user/presentation/screen/login_screen.dart';
import 'package:active_memory/features/accounts/user/presentation/screen/sign_up_screen.dart';
import 'package:active_memory/features/reference/presentation/screen/reference_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  // TODO: 인증 상태 구독(Auth Provider)

  const isLoggedIn = false; // 임시

  return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const ReferenceScreen(),
        )
      ],
      redirect: (context, state) {
        final String location = state.uri.toString();
        final bool isLoggingIn = location == '/login' || location == '/signup';

        // 로그인 안했는데, 홈으로 가려고 한다면 로그인 화면으로
        if (!isLoggedIn && !isLoggingIn) {
          return '/login';
        }

        // 로그인 했는데, 로그인 화면으로 가려고 한다면 홈으로
        if (isLoggedIn && isLoggingIn) {
          return '/home';
        }

        return null; // 통과(원래 가려던 곳)
      });
}
