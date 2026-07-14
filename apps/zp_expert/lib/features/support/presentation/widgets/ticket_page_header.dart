import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../shared/constans/app_assets.dart';
import '../../../../themes/app_colors.dart';
import 'ticket_styles.dart';

class TicketPageHeader extends StatelessWidget {
  const TicketPageHeader({
    required this.onBack,
    required this.onNotification,
    required this.onChat,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onNotification;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
        child: Row(
          children: <Widget>[
            _HeaderCircleButton(icon: Icons.arrow_back_rounded, onTap: onBack),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Raise a Ticket', style: TicketStyles.pageTitle),
                  Text('We are here to help you',
                      style: TicketStyles.pageSubtitle),
                ],
              ),
            ),
            _HeaderCircleButton(
              assetPath: AppAssets.notificationIcon,
              onTap: onNotification,
            ),
            const SizedBox(width: 12),
            _HeaderCircleButton(assetPath: AppAssets.chatIcon, onTap: onChat),
          ],
        ),
      );
}

class _HeaderCircleButton extends StatelessWidget {
  const _HeaderCircleButton({this.icon, this.assetPath, required this.onTap});

  final IconData? icon;
  final String? assetPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.white,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 42,
            height: 42,
            child: Center(
              child: assetPath != null
                  ? SvgPicture.asset(assetPath!, width: 20, height: 20)
                  : Icon(icon, color: AppColors.primary, size: 25),
            ),
          ),
        ),
      );
}
