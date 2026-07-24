import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_routes.dart';
import '../../shared/widgets/glass_top_bar.dart';
import '../../shared/widgets/gradient_page.dart';
import '../../shared/widgets/top_scroll_fade.dart';
import 'widgets/session_history_header.dart';
import 'widgets/session_history_list.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientPage(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: GlassTopBar.rootPagePadding,
          child: Column(
            children: <Widget>[
              SessionHistoryHeader(
                onBackTap: () => Navigator.of(context).maybePop(),
                onNotificationTap: () {},
                onChatTap: () => context.push(ExpertRoutes.chats),
                showBackButton: false,
                showSubtitle: false,
              ),
              const SizedBox(height: 28),
              const Expanded(
                child: TopScrollFade(child: SessionHistoryList()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
