import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/constants/app_assets.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_radius.dart';
import '../data/models/session_history_model.dart';

class SessionSummaryCard extends StatelessWidget {
  const SessionSummaryCard({required this.detail, super.key});

  final SessionDetailModel detail;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionTitle(title: 'Session Summary'),
          const SizedBox(height: 12),
          _SummaryRow(
            icon: Icons.person_outline_rounded,
            title: 'User Concern',
            value: detail.userConcern,
          ),
          const Divider(height: 22),
          _SummaryRow(
            asset: AppAssets.brainIcon,
            title: 'Presenting Concern',
            value: detail.presentingConcern,
            canEdit: true,
          ),
          const Divider(height: 22),
          _SummaryRow(
            asset: AppAssets.notesIcon,
            title: 'Homework Given',
            value: detail.homework,
            canEdit: true,
          ),
          const Divider(height: 22),
          _SummaryRow(
            asset: AppAssets.yogaIcon,
            title: 'Exercise Assigned',
            value: detail.exercise,
            canEdit: true,
          ),
          const Divider(height: 28),
          const _SectionTitle(title: 'Attachments'),
          const SizedBox(height: 10),
          _OutlineItem(
            asset: AppAssets.notesIcon,
            title: detail.attachmentName,
            subtitle: detail.attachmentSize,
            actionLabel: 'Edit',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          const _SectionTitle(title: 'Recordings'),
          const SizedBox(height: 10),
          _OutlineItem(
            asset: AppAssets.voiceCallIcon,
            title: 'Voice Call Recording',
            subtitle: detail.recordingDuration,
            actionLabel: '',
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.ticketText,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.title,
    required this.value,
    this.icon,
    this.asset,
    this.canEdit = false,
  });

  final String title;
  final String value;
  final IconData? icon;
  final String? asset;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _SummaryIcon(icon: icon, asset: asset),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        if (canEdit)
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              backgroundColor: AppColors.primary.withValues(alpha: .11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            child: const Text('Edit'),
          ),
      ],
    );
  }
}

class _OutlineItem extends StatelessWidget {
  const _OutlineItem({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
  });

  final String asset;
  final String title;
  final String subtitle;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: .72)),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: <Widget>[
          _SummaryIcon(asset: asset),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          if (actionLabel.isEmpty)
            const Icon(Icons.chevron_right_rounded, color: AppColors.primary)
          else
            TextButton(
              onPressed: () {},
              child: Text(actionLabel),
            ),
        ],
      ),
    );
  }
}

class _SummaryIcon extends StatelessWidget {
  const _SummaryIcon({this.icon, this.asset});

  final IconData? icon;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: asset == null
          ? Icon(icon, color: AppColors.primary)
          : SvgPicture.asset(
              asset!,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
    );
  }
}
