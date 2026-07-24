import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zp_core/zp_core.dart';
import 'features/call_room/data/provider/call_room_provider.dart';
import 'navigation/router.dart';
import 'startup_timing.dart';
import 'themes/app_themes.dart';

void main() {
  stopwatch.start();

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  debugPrint('Binding: ${stopwatch.elapsedMilliseconds} ms');

  runApp(ProviderScope(
    overrides: <Override>[
      callRoomRepositoryProvider.overrideWith(
          (Ref ref) => ref.watch(expertCallRoomRepositoryProvider)),
    ],
    child: const ZpExpertApp(),
  ));
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
