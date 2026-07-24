import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/progress_section_card.dart';
import '../../../shared/widgets/progress_stat_row.dart';
import '../../../themes/app_colors.dart';
import '../data/models/overall_performance_model.dart';

class PerformanceMetricsCard extends StatelessWidget {
  const PerformanceMetricsCard({
    required this.title,
    required this.metrics,
    super.key,
  });

  final String title;
  final PerformanceMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final NumberFormat currency =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    return ProgressSectionCard(
      title: title,
      child: Column(
        children: <Widget>[
          ProgressStatRow(
            icon: Icons.account_balance_wallet_rounded,
            accentColor: AppColors.callGlowBlue,
            title: 'Total Earning',
            subtitle: 'Cumulative earnings',
            trailing: StatValue(value: currency.format(metrics.totalEarning)),
          ),
          ProgressStatRow(
            icon: Icons.check_circle_rounded,
            accentColor: AppColors.success,
            title: 'Sessions Completed',
            subtitle: 'Total sessions done',
            trailing:
                StatValue(value: '${metrics.totalSessionsCompleted}'),
          ),
          ProgressStatRow(
            icon: Icons.timer_rounded,
            accentColor: AppColors.callGlowViolet,
            title: 'Consultation Time',
            subtitle: 'Total consultation duration',
            trailing: StatValue(
                value: _formatDuration(metrics.totalConsultationTime)),
          ),
          ProgressStatRow(
            icon: Icons.people_rounded,
            accentColor: AppColors.primaryVariant,
            title: 'Clients Served',
            subtitle: 'Total unique clients',
            trailing: StatValue(value: '${metrics.totalClientsServed}'),
          ),
          ProgressStatRow(
            icon: Icons.person_off_rounded,
            accentColor: AppColors.warning,
            title: 'Cancelled by Client',
            subtitle: 'Client-initiated cancellations',
            trailing: StatValue(value: '${metrics.cancelledByClient}'),
          ),
          ProgressStatRow(
            icon: Icons.cancel_outlined,
            accentColor: AppColors.error,
            title: 'Cancelled by Expert',
            subtitle: 'Expert-initiated cancellations',
            trailing: StatValue(value: '${metrics.cancelledByExpert}'),
          ),
          ProgressStatRow(
            icon: Icons.call_missed_rounded,
            accentColor: AppColors.callGlowRose,
            title: 'Missed',
            subtitle: 'Total missed sessions',
            trailing: StatValue(value: '${metrics.missed}'),
          ),
          ProgressStatRow(
            icon: Icons.wifi_rounded,
            accentColor: AppColors.success,
            title: 'Total Online Time',
            subtitle: 'Cumulative online duration',
            trailing:
                StatValue(value: _formatDuration(metrics.totalOnlineTime)),
          ),
          ProgressStatRow(
            icon: Icons.event_busy_rounded,
            accentColor: AppColors.callGlowRose,
            title: 'Total Busy Time',
            subtitle: 'Time spent in sessions',
            trailing:
                StatValue(value: _formatDuration(metrics.totalBusyTime)),
          ),
          ProgressStatRow(
            icon: Icons.speed_rounded,
            accentColor: AppColors.info,
            title: 'Avg Response Time',
            subtitle: 'Average time to first response',
            trailing: StatValue(
                value: _formatShortDuration(metrics.avgResponseTime)),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  final int hours = duration.inHours;
  final int minutes = duration.inMinutes % 60;
  if (hours > 0) return '${hours}h ${minutes}m';
  return '${minutes}m';
}

String _formatShortDuration(Duration duration) {
  final int minutes = duration.inMinutes;
  final int seconds = duration.inSeconds % 60;
  return '${minutes}m ${seconds}s';
}
