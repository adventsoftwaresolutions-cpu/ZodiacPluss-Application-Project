import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zp_expert/shared/constants/app_assets.dart';
import 'package:zp_expert/shared/widgets/header_action_buttons.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({
    required this.onNotificationTap,
    required this.onChatTap,
    super.key,
  });

  final VoidCallback onNotificationTap;
  final VoidCallback onChatTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(AppAssets.walletIcon, width: 28, height: 28),
        const SizedBox(width: 8),
        Text(
          'Wallet',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
        const Spacer(),
        HeaderActionButtons(
          onNotificationTap: onNotificationTap,
          onChatTap: onChatTap,
        ),
      ],
    );
  }
}
