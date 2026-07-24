import 'package:flutter/material.dart';
import 'package:zp_expert/shared/widgets/glass_top_bar.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({
    required this.onNotificationTap,
    required this.onChatTap,
    super.key,
  });

  final VoidCallback onNotificationTap;
  final VoidCallback onChatTap;

  @override
  Widget build(BuildContext context) => GlassTopBar(
        title: 'Wallet',
        onNotificationTap: onNotificationTap,
        onChatTap: onChatTap,
      );
}
