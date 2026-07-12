import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/themes/app_themes.dart';
import 'core/navigation/navigation_scaffold.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'ZodiacPluss',

      theme: AppThemes.light,
      darkTheme: AppThemes.dark,

      // We'll connect this to Riverpod later.
      themeMode: ThemeMode.light,

      home: const NavigationScaffold(),
    );
  }
}