import 'package:flutter/material.dart';
import 'package:zp_expert/features/wallet/widgets/balance_info.dart';
import 'package:zp_expert/features/wallet/widgets/background_logo.dart';
import 'package:zp_expert/features/wallet/widgets/wallet_animation.dart';
import 'package:zp_expert/shared/utils/currency_formatter.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    required this.totalBalance,
    required this.availableBalance,
    required this.monthlyEarnings,
    super.key,
  });

  final double totalBalance;
  final double availableBalance;
  final double monthlyEarnings;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(150),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: <Widget>[
            const Positioned(
              left: -20,
              top: -10,
              child: BackgroundLogo(),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Total Earnings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                formatCompactINR(totalBalance),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 125,
                        height: 170,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: <Widget>[
                            Positioned(
                              right: -10,
                              top: -10,
                              child: WalletAnimation(width: 150, height: 150),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: BalanceInfo(
                          label: 'Available Balance',
                          amount: availableBalance,
                          caption: 'ready for payout',
                          dotColor: null,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white38,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      Expanded(
                        child: BalanceInfo(
                          label: 'Monthly Earnings',
                          amount: monthlyEarnings,
                          caption: 'this month',
                          dotColor: null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
