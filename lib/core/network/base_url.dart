import 'dart:io';

import 'package:active_memory/core/config/env_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String resolveBaseUrl() {
  final override = dotenv.env['API_BASE'];

  if (override != null && override.isNotEmpty) return override;

  final port = env('PORT', '8009');

  if (kIsWeb) return 'http://localhost:$port/api/v1';
  if (Platform.isIOS) return 'http://127.0.0.1:$port/api/v1';
  if (Platform.isAndroid) return 'http://10.0.2.2:$port/api/v1';

  return 'http://127.0.0.1:$port/api/v1';
}
