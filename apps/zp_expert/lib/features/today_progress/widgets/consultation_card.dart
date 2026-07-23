import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../data/models/today_progress_model.dart';
import 'progress_section_card.dart';
import 'progress_stat_row.dart';

class ConsultationCard extends StatelessWidget {
  const ConsultationCard({required this.data, super.key});

  final ConsultationData data;

  @override
  Widget build(BuildContext context) {
    return ProgressSectionCard(
      title: 'Consultation Breakdown',
      child: Column(
        children: <Widget>[
          ProgressStatRow(
            icon: Icons.chat_bubble_rounded,
            accentColor: AppColors.callGlowBlue,
            title: 'Chat Consultation',
            subtitle: 'Text-based sessions',
            trailing: StatValue(value: '${data.chat}'),
          ),
          ProgressStatRow(
            icon: Icons.phone_rounded,
            accentColor: AppColors.callGlowViolet,
            title: 'Voice Consultation',
            subtitle: 'Audio call sessions',
            trailing: StatValue(value: '${data.voice}'),
          ),
          ProgressStatRow(
            icon: Icons.videocam_rounded,
            accentColor: AppColors.callGlowRose,
            title: 'Video Consultation',
            subtitle: 'Video call sessions',
            trailing: StatValue(value: '${data.video}'),
            isLast: true,
          ),
        ],
      ),
    );
  }
}
