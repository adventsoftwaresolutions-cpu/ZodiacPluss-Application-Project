import 'package:flutter/material.dart';

import '../../../shared/widgets/header_action_buttons.dart';
import '../../../themes/app_colors.dart';

class ClientsHeader extends StatelessWidget {
  const ClientsHeader({
    required this.onBackTap,
    required this.onNotificationTap,
    required this.onChatTap,
    super.key,
  });

  final VoidCallback onBackTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onChatTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _BackButton(onTap: onBackTap),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Clients',
                style: TextStyle(
                  color: AppColors.ticketText,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  height: 1.08,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manage your clients',
                style: TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 13,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        HeaderActionButtons(
          diameter: 36,
          iconSize: 17,
          onNotificationTap: onNotificationTap,
          onChatTap: onChatTap,
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 1,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          height: 36,
          width: 36,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
