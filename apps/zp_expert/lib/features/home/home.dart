// home.dart
import 'package:flutter/material.dart';
import '../../shared/widgets/gradient_page.dart';
import 'widgets/profile_greeting_header.dart';
import 'widgets/wallet_balance_card.dart';
import 'widgets/availability_toggle_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              isAvailable: true,
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
          ],
        ),
      ),
    );
  }
}