import 'package:active_memory/core/config/env_loader.dart';
import 'package:active_memory/core/config/kakao_init.dart';
import 'package:active_memory/features/feed/presentation/screens/feed_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // env
  final envName = const String.fromEnvironment('ENV', defaultValue: 'dev');
  await loadEnv(envName);

  initKakao();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Active Memory',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const FeedListScreen(),
    );
  }
}
