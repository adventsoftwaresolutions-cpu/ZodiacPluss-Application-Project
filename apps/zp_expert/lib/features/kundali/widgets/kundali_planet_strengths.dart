import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../themes/app_radius.dart';
import '../../../themes/app_spacing.dart';
import '../data/models/kundali_planet_model.dart';

class KundaliPlanetStrengths extends StatelessWidget {
  const KundaliPlanetStrengths({super.key, required this.strengths});

  final List<KundaliPlanetStrength> strengths;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.leaderboard_rounded, color: colors.primary, size: 20),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Planetary Strengths',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            'Strongest classical-planet placements in this chart',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.58),
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 246,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: strengths.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) => _StrengthCard(
                rank: index + 1,
                strength: strengths[index],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: colors.outlineVariant),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 16, color: colors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Self-calculated placement score using degree state, sign '
                  'dignity, house support and motion. This is not full Shadbala.',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        height: 1.35,
                        color: colors.onSurface.withValues(alpha: 0.58),
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StrengthCard extends StatelessWidget {
  const _StrengthCard({required this.rank, required this.strength});

  final int rank;
  final KundaliPlanetStrength strength;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final emphasis = switch (rank) { 1 => 0.15, 2 => 0.10, _ => 0.07 };

    return Container(
      width: 184,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: emphasis),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: colors.primary.withValues(alpha: rank == 1 ? 0.52 : 0.24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _RankBadge(rank: rank),
              const Spacer(),
              Text(
                '${strength.score}/100',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SvgPicture.asset(strength.asset, width: 48, height: 48),
          const SizedBox(height: 7),
          Text(
            strength.planet.label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: LinearProgressIndicator(
              value: strength.score / 100,
              minHeight: 5,
              color: colors.primary,
              backgroundColor: colors.surface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            strength.label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            strength.reasons.take(2).join(' • '),
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  height: 1.32,
                  color: colors.onSurface.withValues(alpha: 0.62),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: colors.primary.withValues(alpha: 0.38)),
      ),
      child: Text(
        '$rank',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}
