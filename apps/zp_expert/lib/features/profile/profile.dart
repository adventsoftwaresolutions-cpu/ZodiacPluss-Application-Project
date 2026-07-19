import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_routes.dart';
import '../../shared/widgets/glass_top_bar.dart';
import '../../shared/widgets/gradient_page.dart';
import '../../shared/widgets/top_scroll_fade.dart';
import 'widgets/profile_content.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientPage(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: GlassTopBar.rootPagePadding,
              child: GlassTopBar(
                title: 'Expert Profile',
                onNotificationTap: () {},
                onChatTap: () => context.push(ExpertRoutes.chats),
              ),
            ),
            const SizedBox(height: 8),
            const Expanded(
              child: TopScrollFade(child: ProfileContent()),
            ),
          ],
        ),
      ),
    );
  }
}
