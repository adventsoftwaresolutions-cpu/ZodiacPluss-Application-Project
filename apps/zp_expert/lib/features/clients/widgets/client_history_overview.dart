import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../shared/constants/app_assets.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';
import '../data/models/client_history_model.dart';

class ClientHistoryOverview extends StatelessWidget {
  const ClientHistoryOverview({
    required this.history,
    required this.note,
    required this.onNoteTap,
    super.key,
  });

  final ClientHistoryModel history;
  final String? note;
  final VoidCallback onNoteTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(context),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage(history.client.avatarAsset),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          history.client.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 7),
                        Wrap(
                          spacing: 7,
                          children: <Widget>[
                            const _StatusChip(
                              label: 'Normal User',
                              color: AppColors.ticketResolved,
                            ),
                            if (history.isRisky)
                              const _StatusChip(
                                  label: 'Risky', color: AppColors.error),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  _ProfileFact(
                    icon: Icons.person_outline_rounded,
                    label: 'Age/Gender',
                    value: '${history.age}, ${history.gender}',
                  ),
                  Container(
                      width: 1, height: 32, color: AppColors.separatorLight),
                  const SizedBox(width: 14),
                  _ProfileFact(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: history.location,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: onNoteTap,
                icon: SvgPicture.asset(
                  AppAssets.notesIcon,
                  width: 17,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                label: Text(note == null || note!.trim().isEmpty
                    ? 'Add note'
                    : 'View note'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: _cardDecoration(context),
          child: SizedBox(
            height: 96,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                SizedBox(
                  width: 144,
                  child: _StatTile(
                    icon: Icons.forum_outlined,
                    label: 'Total Sessions',
                    value:
                        '${history.pastSessions.length + history.upcomingSessions.length}',
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 144,
                  child: _StatTile(
                    icon: Icons.timer_outlined,
                    label: 'Total Duration',
                    value: history.totalDurationLabel,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 144,
                  child: _StatTile(
                    icon: Icons.calendar_month_outlined,
                    label: 'First Session',
                    value:
                        DateFormat('d MMM y').format(history.firstSessionDate),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 144,
                  child: _StatTile(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Total Earned',
                    value: '₹${history.totalEarned}',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 16,
          offset: Offset(0, 7),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
      side: BorderSide.none,
      backgroundColor: color.withValues(alpha: .13),
      labelStyle: TextStyle(color: color),
    );
  }
}

class _ProfileFact extends StatelessWidget {
  const _ProfileFact({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Icon(icon, color: AppColors.mutedText, size: 21),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppColors.primary, size: 23),
          const SizedBox(height: 7),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
