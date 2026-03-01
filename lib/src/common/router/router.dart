import 'package:active_memory/src/common/screen/main_screen.dart';
import 'package:active_memory/src/features/accounts/auth/presentation/screen/login_screen.dart';
import 'package:active_memory/src/features/accounts/auth/presentation/view_models/auth_view_model.dart';
import 'package:active_memory/src/features/accounts/user/presentation/screen/my_page_screen.dart';
import 'package:active_memory/src/features/accounts/user/presentation/screen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/home',
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
          builder: (context, state) => const MainScreen(),
        ),
        GoRoute(
          path: '/mypage',
          builder: (context, state) => const MyPageScreen(),
        )
      ],
      redirect: (context, state) {
        /**
         * NOTE
         * 에러가 발생했다면, 로그인이 실패한 것으로 "로그인 안 됨"으로 간주하고 로직 진행
         */

        // 현재 진입하려는 목적지
        final String location = state.uri.toString();

        // 로그인 여부 판단
        final bool isLoggedIn = ref.watch(
            authViewModelProvider.select((state) => state.valueOrNull != null));
        // 로그인이나 회원가입이라면
        final bool isLoggingIn = location == '/login' || location == '/signup';

        // 로그인 안했는데, 홈으로 가려고 한다면 로그인 화면으로
        if (!isLoggedIn) {
          // 로그인, 회원가입 페이지로 진입하려는 거라면 가만히 넘김
          if (isLoggingIn) return null;

          // 그 외는 로그인 페이지로 강제 이동
          return '/login';
        }

        // 로그인 했는데, 로그인 화면으로 가려고 한다면 홈으로
        if (isLoggedIn && isLoggingIn) {
          return '/home';
        }

        return null; // 통과(원래 가려던 곳)
      });
}
