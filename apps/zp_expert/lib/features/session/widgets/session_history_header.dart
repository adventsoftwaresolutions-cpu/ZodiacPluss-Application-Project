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
  });

  final VoidCallback onBackTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onChatTap;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          color: colors.surface,
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
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
            ),
          ),
        ),
        HeaderActionButtons(
          diameter: 44,
          iconSize: 22,
          spacing: 10,
          onNotificationTap: onNotificationTap,
          onChatTap: onChatTap,
        ),
      ],
    );
  }
}
