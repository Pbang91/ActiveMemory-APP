import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> loadEnv(String name) async => dotenv.load(fileName: '.env.$name');

String env(String k, [String d = '']) => dotenv.env[k] ?? d;
