import 'package:flutter/material.dart';
import 'package:zp_expert/features/wallet/widgets/stat_card.dart';
import 'package:zp_expert/shared/constants/app_assets.dart';
import 'package:zp_expert/shared/utils/currency_formatter.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({
    required this.totalWithdraw,
    required this.sessionsCompleted,
    required this.avgEarningPerSession,
    super.key,
  });

  final double totalWithdraw;
  final int sessionsCompleted;
  final double avgEarningPerSession;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: StatCard(
            iconPath: AppAssets.trendUpIcon,
            label: 'Total Withdraw',
            value: formatCompactINR(totalWithdraw),
            caption: 'All time',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            iconPath: AppAssets.calendarIcon,
            label: 'Sessions Completed',
            value: sessionsCompleted.toString(),
            caption: 'Total sessions',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            iconPath: AppAssets.walletIcon,
            label: 'Avg./Session',
            value: formatCompactINR(avgEarningPerSession),
            caption: 'Per session',
          ),
        ),
      ],
    );
  }
}