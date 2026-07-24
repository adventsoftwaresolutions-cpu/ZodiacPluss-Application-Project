import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zp_expert/themes/app_colors.dart';
import 'performance_card_skeleton.dart';
import '../data/performance_repository.dart';
import '../data/performance_stats.dart';

class PerformanceCard extends ConsumerWidget {
  const PerformanceCard({
    required this.onSessionHistoryTap,
    required this.onTransactionHistoryTap,
    required this.onReviewsTap,
    required this.onTodayProgressTap,
    required this.onOverallPerformanceTap,
    super.key,
  });

  final VoidCallback onSessionHistoryTap;
  final VoidCallback onTransactionHistoryTap;
  final VoidCallback onReviewsTap;
  final VoidCallback onTodayProgressTap;
  final VoidCallback onOverallPerformanceTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PerformanceStats> stats =
        ref.watch(performanceStatsProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
          const Text(
            'Performance Card',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D3B3E),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTodayProgressTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Today's Stats",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          stats.when(
            data: (PerformanceStats data) => _StatsRows(
              data: data,
              onSessionHistoryTap: onSessionHistoryTap,
              onTransactionHistoryTap: onTransactionHistoryTap,
              onReviewsTap: onReviewsTap,
              onOverallPerformanceTap: onOverallPerformanceTap,
            ),
            loading: () => const PerformanceCardSkeleton(),
            error: (Object error, StackTrace stackTrace) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Unable to load performance data',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRows extends StatelessWidget {
  const _StatsRows({
    required this.data,
    required this.onSessionHistoryTap,
    required this.onTransactionHistoryTap,
    required this.onReviewsTap,
    required this.onOverallPerformanceTap,
  });

  final PerformanceStats data;
  final VoidCallback onSessionHistoryTap;
  final VoidCallback onTransactionHistoryTap;
  final VoidCallback onReviewsTap;
  final VoidCallback onOverallPerformanceTap;

  @override
  Widget build(BuildContext context) {
    final NumberFormat currency =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    return Column(
      children: <Widget>[
        _PerformanceRow(
          icon: Icons.history_rounded,
          accentColor: AppColors.callGlowViolet,
          title: 'Session History',
          subtitle: 'Total sessions completed',
          trailing: _ArrowButton(
            accentColor: AppColors.callGlowViolet,
            onTap: onSessionHistoryTap,
          ),
        ),
        _PerformanceRow(
          icon: Icons.swap_horiz_rounded,
          accentColor: AppColors.callGlowRose,
          title: 'Transaction History',
          subtitle: 'All transaction history and invoice',
          trailing: _ArrowButton(
            accentColor: AppColors.callGlowRose,
            onTap: onTransactionHistoryTap,
          ),
        ),
        _PerformanceRow(
          icon: Icons.chat_bubble_outline_rounded,
          accentColor: AppColors.info,
          title: 'Reviews',
          subtitle: 'All your session reviews',
          trailing: _ArrowButton(
            accentColor: AppColors.info,
            onTap: onReviewsTap,
          ),
        ),
        _PerformanceRow(
          icon: Icons.insights_rounded,
          accentColor: AppColors.primaryVariant,
          title: 'Overall Performance',
          subtitle: 'Day & month wise detailed stats',
          trailing: _ArrowButton(
            accentColor: AppColors.primaryVariant,
            onTap: onOverallPerformanceTap,
          ),
        ),
      ],
    );
  }
}

String _formatDuration(Duration duration) {
  final int minutes = duration.inMinutes;
  final int seconds = duration.inSeconds % 60;
  return '${minutes}m ${seconds}s';
}

class _PerformanceRow extends StatelessWidget {
  const _PerformanceRow({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.isLast = false,
  });

  final IconData icon;
  final Color accentColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget details = _PerformanceDetails(
                icon: icon,
                accentColor: accentColor,
                title: title,
                subtitle: subtitle,
              );

              if (constraints.maxWidth < 280) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    details,
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerRight, child: trailing),
                  ],
                );
              }

              return Row(
                children: <Widget>[
                  Expanded(child: details),
                  const SizedBox(width: 8),
                  trailing,
                ],
              );
            },
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}

class _PerformanceDetails extends StatelessWidget {
  const _PerformanceDetails({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color accentColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                accentColor.withValues(alpha: 0.14),
                Colors.white,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D3B3E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.accentColor, required this.onTap});

  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.alphaBlend(
        accentColor.withValues(alpha: 0.14),
        Colors.white,
      ),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 18,
            color: accentColor,
          ),
        ),
      ),
    );
  }
}
