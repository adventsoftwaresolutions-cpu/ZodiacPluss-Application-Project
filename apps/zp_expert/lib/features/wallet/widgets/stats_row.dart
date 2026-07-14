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
          child: _AnimatedStatCard(
            delay: const Duration(milliseconds: 0),
            child: StatCard(
              iconPath: AppAssets.trendUpIcon,
              label: 'Total Withdraw',
              value: formatCompactINR(totalWithdraw),
              caption: 'All time',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _AnimatedStatCard(
            delay: const Duration(milliseconds: 100),
            child: StatCard(
              iconPath: AppAssets.calendarIcon,
              label: 'Sessions Completed',
              value: sessionsCompleted.toString(),
              caption: 'Total sessions',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _AnimatedStatCard(
            delay: const Duration(milliseconds: 200),
            child: StatCard(
              iconPath: AppAssets.walletIcon,
              label: 'Avg./Session',
              value: formatCompactINR(avgEarningPerSession),
              caption: 'Per session',
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedStatCard extends StatefulWidget {
  const _AnimatedStatCard({
    required this.delay,
    required this.child,
  });

  final Duration delay;
  final Widget child;

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _visible ? 1.0 : 0.85,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: widget.child,
      ),
    );
  }
}