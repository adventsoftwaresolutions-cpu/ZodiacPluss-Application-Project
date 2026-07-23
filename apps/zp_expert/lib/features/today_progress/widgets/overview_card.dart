import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../themes/app_colors.dart';
import '../data/models/today_progress_model.dart';
import 'progress_section_card.dart';
import 'progress_stat_row.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({required this.data, super.key});

  final OverviewData data;

  @override
  Widget build(BuildContext context) {
    final NumberFormat currency =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

    return ProgressSectionCard(
      title: 'Overview',
      child: Column(
        children: <Widget>[
          ProgressStatRow(
            icon: Icons.account_balance_wallet_rounded,
            accentColor: AppColors.callGlowBlue,
            title: "Today's Earning",
            subtitle: 'Total earnings for today',
            trailing: StatValue(value: currency.format(data.earningsToday)),
          ),
          ProgressStatRow(
            icon: Icons.check_circle_rounded,
            accentColor: AppColors.success,
            title: 'Sessions Completed',
            subtitle: 'Total sessions done today',
            trailing: StatValue(value: '${data.sessionsCompleted}'),
          ),
          ProgressStatRow(
            icon: Icons.timer_rounded,
            accentColor: AppColors.callGlowViolet,
            title: 'Consultation Time',
            subtitle: 'Total time in consultations',
            trailing: StatValue(value: _formatDuration(data.consultationTime)),
          ),
          ProgressStatRow(
            icon: Icons.people_rounded,
            accentColor: AppColors.primaryVariant,
            title: 'Clients Served',
            subtitle: 'Unique clients today',
            trailing: StatValue(value: '${data.clientsServed}'),
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
