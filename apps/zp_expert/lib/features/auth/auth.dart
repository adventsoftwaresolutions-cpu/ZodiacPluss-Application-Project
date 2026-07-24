import 'package:flutter/material.dart';

import '../../shared/widgets/gradient_page.dart';
import '../../shared/widgets/top_scroll_fade.dart';
import 'widgets/auth_body.dart';
import 'widgets/auth_blob_background.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientPage(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AuthBlobBackground(),
          SafeArea(
            child: TopScrollFade(child: AuthBody()),
          ),
        ],
      ),
    );
  }
}
