import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../data/models/today_progress_model.dart';
import 'progress_section_card.dart';
import 'progress_stat_row.dart';

class SessionStatusCard extends StatelessWidget {
  const SessionStatusCard({required this.data, super.key});

  final SessionStatusData data;

  @override
  Widget build(BuildContext context) {
    return ProgressSectionCard(
      title: 'Session Status Breakdown',
      child: Column(
        children: <Widget>[
          ProgressStatRow(
            icon: Icons.check_circle_rounded,
            accentColor: AppColors.success,
            title: 'Completed',
            subtitle: 'Sessions finished successfully',
            trailing: StatValue(value: '${data.completed}'),
          ),
          ProgressStatRow(
            icon: Icons.schedule_rounded,
            accentColor: AppColors.callGlowBlue,
            title: 'Upcoming',
            subtitle: 'Sessions scheduled ahead',
            trailing: StatValue(value: '${data.upcoming}'),
          ),
          ProgressStatRow(
            icon: Icons.play_circle_rounded,
            accentColor: AppColors.primaryVariant,
            title: 'Currently Active',
            subtitle: 'Session in progress now',
            trailing: StatValue(value: '${data.active}'),
          ),
          ProgressStatRow(
            icon: Icons.person_off_rounded,
            accentColor: AppColors.warning,
            title: 'Cancelled by Client',
            subtitle: 'Client-initiated cancellations',
            trailing: StatValue(value: '${data.cancelledByClient}'),
          ),
          ProgressStatRow(
            icon: Icons.cancel_outlined,
            accentColor: AppColors.error,
            title: 'Cancelled by Expert',
            subtitle: 'Expert-initiated cancellations',
            trailing: StatValue(value: '${data.cancelledByExpert}'),
          ),
          ProgressStatRow(
            icon: Icons.call_missed_rounded,
            accentColor: AppColors.callGlowRose,
            title: 'Missed',
            subtitle: 'Sessions missed today',
            trailing: StatValue(value: '${data.missed}'),
            isLast: true,
          ),
        ],
      ),
    );
  }
}
