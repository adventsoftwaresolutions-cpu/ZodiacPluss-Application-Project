import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_routes.dart';
import '../../shared/widgets/glass_top_bar.dart';
import '../../shared/widgets/gradient_page.dart';
import '../../shared/widgets/top_scroll_fade.dart';
import 'widgets/client_history_content.dart';

class ClientHistoryPage extends StatelessWidget {
  const ClientHistoryPage({required this.clientId, super.key});

  final String clientId;

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
                title: 'Client History',
                subtitle: 'Detail about client',
                onBackTap: () => Navigator.of(context).maybePop(),
                onNotificationTap: () {},
                onChatTap: () => context.push(ExpertRoutes.chats),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TopScrollFade(
                  child: ClientHistoryContent(clientId: clientId),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
