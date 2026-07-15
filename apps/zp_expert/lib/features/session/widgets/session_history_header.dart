import 'package:flutter/material.dart';

import '../../../shared/widgets/header_action_buttons.dart';
import '../../../themes/app_colors.dart';

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
  });

  final VoidCallback onBackTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onChatTap;
  final String title;
  final String subtitle;
  final bool showBackButton;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (showBackButton) ...<Widget>[
          Material(
            color: Theme.of(context).colorScheme.surface,
            elevation: 1,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onBackTap,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primary,
                  size: 19,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              if (showSubtitle) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.2,
                  ),
                ),
              ],
            ],
          ),
        ),
        HeaderActionButtons(
          diameter: showBackButton ? 44 : 35,
          iconSize: showBackButton ? 22 : 18,
          spacing: 10,
          onNotificationTap: onNotificationTap,
          onChatTap: onChatTap,
        ),
      ],
    );
  }
}
