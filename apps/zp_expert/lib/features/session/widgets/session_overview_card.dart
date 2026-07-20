import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../shared/constants/app_assets.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';
import '../data/models/session_history_model.dart';

class SessionOverviewCard extends StatelessWidget {
  const SessionOverviewCard({
    required this.detail,
    required this.onClientTap,
    super.key,
  });

  final SessionDetailModel detail;
  final VoidCallback onClientTap;

  @override
  Widget build(BuildContext context) {
    final session = detail.session;

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const _AssetIcon(asset: AppAssets.voiceCallIcon, size: 62),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${session.title} Session',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 7),
                    const Wrap(
                      spacing: 7,
                      children: <Widget>[
                        _StatusChip(label: 'Completed'),
                        _StatusChip(label: 'Paid'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 18,
            runSpacing: 14,
            children: <Widget>[
              _SessionFact(
                icon: Icons.badge_outlined,
                label: 'Session Id',
                value: 'VC-${session.id.toUpperCase()}',
              ),
              _SessionFact(
                icon: Icons.calendar_month_outlined,
                label: 'Date & Time',
                value: DateFormat('d MMM y, h:mm a').format(session.startedAt),
              ),
              _SessionFact(
                icon: Icons.timer_outlined,
                label: 'Duration',
                value: '${session.durationMinutes} min',
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _PersonDetail(
                  label: 'Client',
                  person: detail.client,
                  onNameTap: onClientTap,
                ),
              ),
              Expanded(
                  child: _PersonDetail(label: 'Expert', person: detail.expert)),
              _AmountDetail(amount: session.earnings),
            ],
          ),
        ],
      ),
    );
  }
}

class SessionReplayCard extends StatelessWidget {
  const SessionReplayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Session Replay',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.ticketText,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .11),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: <Widget>[
                const _AssetIcon(asset: AppAssets.playIcon, size: 42),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Watch Session Replay',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Replay available for 7 days from session date',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow_rounded, size: 16),
                  label: const Text('Watch'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
      side: BorderSide.none,
      backgroundColor: AppColors.success.withValues(alpha: .14),
      labelStyle: const TextStyle(color: AppColors.ticketResolved),
    );
  }
}

class _SessionFact extends StatelessWidget {
  const _SessionFact({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 148,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppColors.mutedText, size: 20),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 1),
                Text(
                  value,
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

class _PersonDetail extends StatelessWidget {
  const _PersonDetail({
    required this.label,
    required this.person,
    this.onNameTap,
  });

  final String label;
  final SessionPerson person;
  final VoidCallback? onNameTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
            radius: 18, backgroundImage: AssetImage(person.avatarAsset)),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Semantics(
                button: onNameTap != null,
                label: onNameTap == null
                    ? null
                    : 'Open ${person.name} client history',
                child: GestureDetector(
                  onTap: onNameTap,
                  child: Text(
                    person.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: onNameTap == null
                              ? null
                              : Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
              Text(person.role, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _AmountDetail extends StatelessWidget {
  const _AmountDetail({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text('Amount', style: Theme.of(context).textTheme.bodySmall),
        Text(
          '₹$amount',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.ticketResolved,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _AssetIcon extends StatelessWidget {
  const _AssetIcon({required this.asset, required this.size});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: SvgPicture.asset(
        asset,
        colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
      ),
    );
  }
}
