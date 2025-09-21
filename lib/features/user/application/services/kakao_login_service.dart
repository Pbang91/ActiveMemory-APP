import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginService {
  // 카카오 로그인 (카카오톡이 설치되어 있으면 카카오톡으로, 없으면 웹브라우저로)
  static Future<Map<String, dynamic>?> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
        } catch (error) {
          // 카카오톡 로그인 실패 시 웹브라우저로 재시도
          await UserApi.instance.loginWithKakaoAccount();
        }
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      // 사용자 정보 가져오기
      User user = await UserApi.instance.me();

      return {
        'id': user.id.toString(),
        'nickname': user.kakaoAccount?.profile?.nickname,
        'email': user.kakaoAccount?.email,
        'profileImageUrl': user.kakaoAccount?.profile?.profileImageUrl,
      };
    } catch (error) {
      // 에러는 조용히 처리
      return null;
    }
  }

  // 로그아웃
  static Future<bool> logout() async {
    try {
      await UserApi.instance.logout();
      return true;
    } catch (error) {
      return false;
    }
  }

  // 연결 끊기 (회원 탈퇴)
  static Future<bool> unlink() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      return false;
    }
  }

  // 현재 로그인 상태 확인
  static Future<bool> isLoggedIn() async {
    try {
      await UserApi.instance.accessTokenInfo();
      return true;
    } catch (error) {
      return false;
    }
  }

  // 현재 사용자 정보 가져오기
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      if (await isLoggedIn()) {
        User user = await UserApi.instance.me();
        return {
          'id': user.id.toString(),
          'nickname': user.kakaoAccount?.profile?.nickname,
          'email': user.kakaoAccount?.email,
          'profileImageUrl': user.kakaoAccount?.profile?.profileImageUrl,
        };
      }
      return null;
    } catch (error) {
      return null;
    }
  }
}
