import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';
import '../data/models/today_progress_model.dart';
import 'progress_section_card.dart';
import 'progress_stat_row.dart';

class ClientEngagementCard extends StatelessWidget {
  const ClientEngagementCard({required this.data, super.key});

  final ClientEngagementData data;

  @override
  Widget build(BuildContext context) {
    return ProgressSectionCard(
      title: 'Client Engagement',
      child: Column(
        children: <Widget>[
          ProgressStatRow(
            icon: Icons.person_add_rounded,
            accentColor: AppColors.callGlowBlue,
            title: 'New Clients',
            subtitle: 'First-time clients today',
            trailing: StatValue(value: '${data.newClients}'),
          ),
          ProgressStatRow(
            icon: Icons.replay_rounded,
            accentColor: AppColors.callGlowViolet,
            title: 'Returning Clients',
            subtitle: 'Clients who came back',
            trailing: StatValue(value: '${data.returningClients}'),
          ),
          ProgressStatRow(
            icon: Icons.favorite_rounded,
            accentColor: AppColors.callGlowRose,
            title: 'Loyal Clients',
            subtitle: 'Clients with 5+ sessions',
            trailing: StatValue(value: '${data.loyalClients}'),
          ),
          ProgressStatRow(
            icon: Icons.star_rounded,
            accentColor: AppColors.warning,
            title: 'Average Rating Today',
            subtitle: "Rating from today's sessions",
            trailing: StatValue(value: data.avgRatingToday.toStringAsFixed(1)),
            isLast: true,
          ),
        ],
      ),
    );
  }
}
