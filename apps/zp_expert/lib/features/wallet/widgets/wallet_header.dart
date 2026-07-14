import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zp_expert/shared/constants/app_assets.dart';
import 'package:zp_expert/shared/widgets/header_action_buttons.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({
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
      children: <Widget>[
        _CircleIconButton(icon: Icons.arrow_back, onTap: onBackTap),
        const SizedBox(width: 12),
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

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 35,
          height: 35,
          child: Icon(icon, size: 18, color: Colors.black87),
        ),
      ),
    );
  }
}