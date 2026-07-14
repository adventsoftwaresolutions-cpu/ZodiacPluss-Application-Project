import 'package:flutter/material.dart';

import '../../../shared/widgets/header_action_buttons.dart';
import '../../../themes/app_colors.dart';
import 'ticket_styles.dart';

class TicketHeader extends StatelessWidget {
  const TicketHeader({
    required this.onBackTap,
    required this.onNotificationTap,
    required this.onChatTap,
    this.title = 'Raise a Ticket',
    this.subtitle = 'We are here to help you',
    super.key,
  });

  final VoidCallback onBackTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onChatTap;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
        child: Row(
          children: <Widget>[
            Material(
              color: AppColors.white,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onBackTap,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 42,
                  height: 42,
                  child: Icon(Icons.arrow_back_rounded,
                      color: AppColors.primary, size: 25),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: TicketStyles.pageTitle),
                  Text(subtitle, style: TicketStyles.pageSubtitle),
                ],
              ),
            ),
            HeaderActionButtons(
              diameter: 42,
              iconSize: 20,
              spacing: 12,
              onNotificationTap: onNotificationTap,
              onChatTap: onChatTap,
            ),
          ],
        ),
      );
}
