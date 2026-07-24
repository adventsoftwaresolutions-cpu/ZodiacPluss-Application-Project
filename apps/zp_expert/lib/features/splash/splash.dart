import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_routes.dart';
import 'widgets/splash_scene.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => SplashScene(
        onCompleted: () => context.go(ExpertRoutes.auth),
      );
}
