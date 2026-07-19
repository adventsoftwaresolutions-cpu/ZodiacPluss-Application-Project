import 'package:flutter/material.dart';

import '../../../shared/widgets/glass_top_bar.dart';

class SessionHistoryHeader extends StatelessWidget {
  const SessionHistoryHeader({
    required this.onBackTap,
    required this.onNotificationTap,
    required this.onChatTap,
    super.key,
    this.title = 'Session History',
    this.subtitle = 'All session details',
    this.showBackButton = true,
    this.showSubtitle = true,
    this.showActionButtons = true,
  });

  final VoidCallback onBackTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onChatTap;
  final String title;
  final String subtitle;
  final bool showBackButton;
  final bool showSubtitle;
  final bool showActionButtons;

  @override
  Widget build(BuildContext context) => GlassTopBar(
        title: title,
        subtitle: showSubtitle ? subtitle : null,
        onBackTap: showBackButton ? onBackTap : null,
        onNotificationTap: onNotificationTap,
        onChatTap: onChatTap,
        showActionButtons: showActionButtons,
      );
}
