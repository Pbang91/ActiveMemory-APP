import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'env_loader.dart';

// 카카오 초기화
void initKakao() => KakaoSdk.init(
  nativeAppKey: env('KAKAO_NATIVE_APP_KEY'),
  javaScriptAppKey: env('KAKAO_JAVASCRIPT_KEY'),
);
