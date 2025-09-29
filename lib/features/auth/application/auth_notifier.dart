import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoggedIn;
  final String? userNickname;
  final String? userSlug;

  const AuthState({required this.isLoggedIn, this.userNickname, this.userSlug});

  AuthState copyWith({
    bool? isLoggedIn,
    String? userNickname,
    String? userSlug,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userNickname: userNickname ?? this.userNickname,
      userSlug: userSlug ?? this.userSlug,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState(isLoggedIn: false);
  }

  void login({required String nickname, required String slug}) {
    state = state.copyWith(
      isLoggedIn: true,
      userNickname: nickname,
      userSlug: slug,
    );
  }

  void logout() {
    state = const AuthState(isLoggedIn: false);
  }

  Future<void> checkAuthStatus() async {
    // TODO: 실제 토큰 확인 로직
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});

final currentUserProvider = Provider<String?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isLoggedIn ? authState.userNickname : null;
});
