import 'package:flutter/material.dart';

import '../../shared/widgets/gradient_page.dart';
import '../../shared/widgets/top_scroll_fade.dart';
import 'widgets/auth_body.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientPage(
      child: SafeArea(
        child: TopScrollFade(child: AuthBody()),
      ),
    );
  }
}
