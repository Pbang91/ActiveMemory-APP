import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void initKakao() => KakaoSdk.init(
      nativeAppKey: dotenv.get('KAKAO_NATIVE_APP_KEY'),
      javaScriptAppKey: dotenv.get('KAKAO_JAVASCRIPT_KEY'),
    );
