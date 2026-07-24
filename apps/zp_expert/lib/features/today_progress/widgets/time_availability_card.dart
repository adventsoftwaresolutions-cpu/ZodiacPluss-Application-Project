import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../data/models/today_progress_model.dart';
import '../../../shared/widgets/progress_section_card.dart';
import '../../../shared/widgets/progress_stat_row.dart';

class TimeAvailabilityCard extends StatelessWidget {
  const TimeAvailabilityCard({required this.data, super.key});

  final TimeAvailabilityData data;

  @override
  Widget build(BuildContext context) {
    return ProgressSectionCard(
      title: 'Time & Availability',
      child: Column(
        children: <Widget>[
          ProgressStatRow(
            icon: Icons.wifi_rounded,
            accentColor: AppColors.success,
            title: 'Online Time',
            subtitle: 'Total time online today',
            trailing: StatValue(value: _formatDuration(data.onlineTime)),
          ),
          ProgressStatRow(
            icon: Icons.event_busy_rounded,
            accentColor: AppColors.callGlowRose,
            title: 'Busy in Sessions',
            subtitle: 'Time spent in active sessions',
            trailing: StatValue(value: _formatDuration(data.busyTime)),
          ),
          ProgressStatRow(
            icon: Icons.access_time_rounded,
            accentColor: AppColors.callGlowBlue,
            title: 'Available Time',
            subtitle: 'Time available for new sessions',
            trailing: StatValue(value: _formatDuration(data.availableTime)),
          ),
          ProgressStatRow(
            icon: Icons.speed_rounded,
            accentColor: AppColors.warning,
            title: 'Avg Response Time',
            subtitle: 'Average time to first response',
            trailing:
                StatValue(value: _formatShortDuration(data.avgResponseTime)),
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
