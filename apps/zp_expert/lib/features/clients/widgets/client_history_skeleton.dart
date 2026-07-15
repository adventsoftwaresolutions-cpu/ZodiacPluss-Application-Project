import 'package:flutter/material.dart';

import '../../../shared/widgets/shimmer_box.dart';
import '../../../themes/app_radius.dart';
import '../../session/widgets/session_history_card_skeleton.dart';

class ClientHistorySkeleton extends StatelessWidget {
  const ClientHistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      children: const <Widget>[
        _ProfileSkeleton(),
        SizedBox(height: 16),
        _StatsSkeleton(),
        SizedBox(height: 22),
        ShimmerBox(width: 140, height: 24, borderRadius: 8),
        SizedBox(height: 12),
        _SessionPanelSkeleton(),
      ],
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _skeletonDecoration(context),
      child: const Row(
        children: <Widget>[
          ShimmerBox(width: 96, height: 96, borderRadius: 48),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ShimmerBox(width: 150, height: 24),
                SizedBox(height: 10),
                ShimmerBox(width: 110, height: 22, borderRadius: 11),
                SizedBox(height: 18),
                ShimmerBox(width: 190, height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: _skeletonDecoration(context),
      child: const Row(
        children: <Widget>[
          Expanded(
            child: ShimmerBox(
              width: double.infinity,
              height: 96,
              borderRadius: 12,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ShimmerBox(
              width: double.infinity,
              height: 96,
              borderRadius: 12,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ShimmerBox(
              width: double.infinity,
              height: 96,
              borderRadius: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionPanelSkeleton extends StatelessWidget {
  const _SessionPanelSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _skeletonDecoration(context),
      child: const Column(
        children: <Widget>[
          SessionHistoryCardSkeleton(),
          SizedBox(height: 14),
          SessionHistoryCardSkeleton(),
          SizedBox(height: 14),
          SessionHistoryCardSkeleton(),
        ],
      ),
    );
  }
}

BoxDecoration _skeletonDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context)
        .colorScheme
        .surfaceContainerHighest
        .withValues(alpha: .78),
    borderRadius: BorderRadius.circular(AppRadius.xl),
  );
}
