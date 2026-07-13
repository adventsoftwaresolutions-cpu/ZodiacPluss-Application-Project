import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigation/router.dart';
import 'startup_timing.dart';
import 'themes/app_themes.dart';

void main() {
  stopwatch.start();

  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('Binding: ${stopwatch.elapsedMilliseconds} ms');

  runApp(const ProviderScope(child: ZpExpertApp()));
}

class ZpExpertApp extends StatelessWidget {
  const ZpExpertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: expertRouter,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: ThemeMode.light,
    );
  }
}