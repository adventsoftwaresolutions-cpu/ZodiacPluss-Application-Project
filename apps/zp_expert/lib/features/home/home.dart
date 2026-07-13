// home.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zp_expert/features/home/widgets/manage_pricing_card.dart';
import '../../shared/widgets/gradient_page.dart';
import 'widgets/profile_greeting_header.dart';
import 'widgets/wallet_balance_card.dart';
import 'widgets/availability_toggle_card.dart';
import 'data/availability_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(availabilityControllerProvider);

    return GradientPage(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileGreetingHeader(
              name: 'Shreya',
              role: 'Psychologist',
              avatarUrl: 'assets/images/dp.jpg',
              isVerified: true,
              status: status,
              onNotificationTap: () {},
              onChatTap: () {},
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  WalletBalanceCard(onCheckStatus: () {}),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Divider(height: 1),
                  ),
                  const AvailabilityToggleCard(),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ManagePricingCard(
              onTap: () {
                // TODO: wire to pricing/offers route once that screen exists
              },
            ),
          ],
        ),
      ),
    );
  }
}